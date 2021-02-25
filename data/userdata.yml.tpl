files:

- path: /run/config/xds/cds.yaml
  text: |
    resources:
  %{ for cluster in clusters ~}
  - "@type": type.googleapis.com/envoy.config.cluster.v3.Cluster
      name: ${cluster.name}-${cluster.bport}
      connect_timeout: 1s
      type: STRICT_DNS
      load_assignment:
        cluster_name: ${cluster.name}-${cluster.bport}
  %{ endfor ~}

- path: /run/config/xds/cds.yaml.tpl
  text: |
    resources:
  %{ for cluster in clusters ~}
  - "@type": type.googleapis.com/envoy.config.cluster.v3.Cluster
      name: ${cluster.name}-${cluster.bport}
      connect_timeout: 1s
      type: STRICT_DNS
      health_checks:
      - timeout: ${cluster.healthcheck.timeout}s
        interval: ${cluster.healthcheck.interval}s
        healthy_threshold: ${cluster.healthcheck.healthy_threshold}
        unhealthy_threshold: ${cluster.healthcheck.unhealthy_threshold}
        tcp_health_check:
          send:
            text: "000000FF"
      load_assignment:
        cluster_name: ${cluster.name}-${cluster.bport}
        endpoints:
        - lb_endpoints:
        {{- range $host := .${cluster.name}}}
          - endpoint:
              address:
                socket_address:
                  address: {{ $host }}
                  port_value: ${cluster.bport}
        {{- end }}
  %{ endfor ~}

- path: /run/config/xds/lds.yaml
  text: |
    resources:
  %{ for cluster in clusters ~}
  - "@type": "type.googleapis.com/envoy.config.listener.v3.Listener"
      name: ${cluster.name}-${cluster.fport}
      address:
        socket_address:
          address: 0.0.0.0
          port_value: ${cluster.fport}
      filter_chains:
      - filters:
          name: "envoy.http_connection_manager"
          typed_config:
            "@type": "type.googleapis.com/envoy.extensions.filters.network.tcp_proxy.v3.TcpProxy"
            stat_prefix: ${cluster.name}-${cluster.bport}
            cluster: ${cluster.name}-${cluster.bport}
            max_connect_attempts: 4
  %{ endfor ~}

- path: /run/config/igdns/env
  text: |
    AWS_REGION=${aws_region}
    AWS_ACCESS_KEY=${aws_access_key}
    AWS_SECRET_KEY=${aws_secret_key}
    AWS_ROLE=${aws_role_arn}
    IGDNS_GROUP=${group_name}
    IGDNS_ZONE=${aws_zone_id}
    IGDNS_NAME=${domain_name}
    IGDNS_FOLDER=${folder_id}

- path: /run/config/xds/groups
  text: |
%{ for c in clusters ~}
    ${c.name}:${c.id}
%{ endfor ~}

templates:

- path: /run/config/envoy/envoy.yaml
  text: |
    node:
      id: {{ .hostname }}
      cluster: ${envoy_name}
    dynamic_resources:
      cds_config:
        path: /etc/xds/cds.yaml
      lds_config:
        path: /etc/xds/lds.yaml
    admin:
      access_log_path: "/var/log/envoy/admin.log"
      address:
        socket_address:
          address: 0.0.0.0
          port_value: 2000
  vars:
    hostname: /run/config/local_hostname
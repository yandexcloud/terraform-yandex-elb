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
        http_health_check:
          path: ${cluster.healthcheck.path}
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

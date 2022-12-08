resource "kubectl_manifest" "vmrule_deadman_switches" {
  count = var.deadman_enabled ? 1 : 0
  yaml_body = yamlencode({
    apiVersion = "operator.victoriametrics.com/v1beta1"
    kind       = "VMRule"
    metadata = {
      name      = "vmrule-deadman"
      namespace = var.namespace
    }
    spec = {
      groups = [
        {
          name = "DeadMan"
          rules = [
            {
              alert = "DeadMan"
              expr  = "vector(1)"
              labels = {
                severity = "warning"
              }
              annotations = {
                summary     = "Alerting DeadMan"
                description = "The DeadMan ensures the Alerting pipeline is functional (warning = slack, critical = pd)"
                value       = "{{ $value }}"
              }
            },
          ]
        },
      ]
    }
    }
  )
}
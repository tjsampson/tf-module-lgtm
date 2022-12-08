

resource "kubectl_manifest" "node_scrape_crd" {
  count      = var.agent_enabled ? 1 : 0
  depends_on = [helm_release.victoria_operator]
  yaml_body = yamlencode(
    {
      apiVersion = "operator.victoriametrics.com/v1beta1"
      kind       = "VMNodeScrape"
      metadata = {
        name      = "cadvisor-metrics"
        namespace = var.namespace
      }
      spec = {
        scheme        = "http"
        tlsConfig = {
          insecureSkipVerify = true
          caFile             = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"          
        }        
        bearerTokenFile = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        interval        = "30s"
        path            = "/metrics"
        port            = "9100"
        scrapeTimeout   = "5s"
        relabelConfigs = [
          {
            action = "labelmap"
            regex  = "__meta_kubernetes_node_label_(.+)"
          }
        ]        
      }
    }
  )
}
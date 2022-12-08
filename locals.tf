locals {
  loki_resource_label = "${var.cluster_name}-loki"
  grafana_resource_label = "${var.cluster_name}-grafana"
  tempo_resource_label = "${var.cluster_name}-tempo"
  mimir_resource_label = "${var.cluster_name}-mimir"
  victoria_resource_label = "${var.cluster_name}-victoria"
}

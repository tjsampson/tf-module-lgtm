resource "kubernetes_namespace" "loki" {
  metadata {
    name = "loki"
  }
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

resource "kubernetes_namespace" "tempo" {
  metadata {
    name = "tempo"
  }
}

resource "kubernetes_namespace" "mimir" {
  metadata {
    name = "mimir"
  }
}


resource "kubernetes_namespace" "victoria" {
  metadata {
    name = "victoria"
  }
}


resource "google_storage_bucket" "loki" {
  count         = var.loki_enabled ? 1 : 0
  name          = local.loki_resource_label
  location      = var.bucket_location
  force_destroy = true
}

resource "google_storage_bucket" "mimir" {
  count         = var.loki_enabled ? 1 : 0
  name          = local.mimir_resource_label
  location      = var.bucket_location
  force_destroy = true
}


resource "helm_release" "loki" {
  count      = var.loki_enabled ? 1 : 0
  version    = var.loki_helm_chart_version
  name       = "loki-distributed"  
  chart      = "loki-distributed"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.loki.metadata[0].name
  values     = [data.template_file.loki_values[0].rendered]
  depends_on = [module.loki-identity]
}


resource "helm_release" "grafana" {
  depends_on = [kubernetes_namespace.grafana, module.docker_creds]
  version    = var.grafan_helm_chart_version
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.grafana.metadata[0].name
  values     = [data.template_file.grafana_values[0].rendered]

  set_sensitive {
    name  = "grafana\\.ini.database.url"
    value = format("postgres://%s:%s@cloud-sql-proxy.cloud-sql-proxy:5432/%s", var.db_username, var.db_password, var.db_name)
  }  

  set_sensitive {
    name  = "adminPassword"
    value = var.admin_password
  }  
}

resource "helm_release" "tempo" {
  depends_on = [
      module.tempo-identity,
      data.template_file.tempo_values
  ]
  version    = var.temp_helm_chart_version
  name       = "tempo-distributed"
  chart      = "tempo-distributed"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.tempo.metadata[0].name
  values     = [data.template_file.tempo_values[0].rendered]
  force_update = true
}


# https://artifacthub.io/packages/helm/prometheus-community/kube-state-metrics
resource "helm_release" "kube-state-metrics" {
  count      = var.kube_state_metrics_enabled ? 1 : 0
  name       = "kube-state-metrics"
  chart      = "kube-state-metrics"  
  namespace  = "default"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.kube_state_metrics_chart_version
}


resource "helm_release" "victoria_operator" {
  version       = var.victoria_operator_version
  name          = "vm-operator"  
  chart         = "victoria-metrics-operator"
  repository    = "https://victoriametrics.github.io/helm-charts"
  namespace     = kubernetes_namespace.victoria.metadata[0].name
  recreate_pods = true
  values     = [data.template_file.victoria_values[0].rendered]
}
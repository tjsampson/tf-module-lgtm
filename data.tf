data "template_file" "loki_values" {
  count    = var.loki_enabled ? 1 : 0
  template = file("${path.module}/config/loki_config.yaml")
  vars = {
    gcs_bucket                  = google_storage_bucket.loki.name
    host_name                   = var.host_name
    cert_manager_cluster_issuer = var.cert_manager_cluster_issuer
    service_account             = module.loki-identity.k8s_service_account_name  
  }
  depends_on = [
    google_storage_bucket.loki
  ]
}



data "template_file" "grafana_values" {
  count    = var.grafana_enabled ? 1 : 0
  template = file("${path.module}/config/grafana_config.yaml")
  vars = {
    cluster_issuer = var.cert_manager_cluster_issuer
    relay_addr = var.relay_addr # TODO: Setup PostFix Relay with SMTP (Postmark, SendGrid, etc.)
  }
}


data "template_file" "tempo_values" {
  count    = var.tempo_enabled ? 1 : 0
  template = file("${path.module}/config/tempo_config.yaml")
  vars = {
    gcs_bucket=var.storage_bucket
    service_account = module.tempo-identity.k8s_service_account_name
  }
}


data "template_file" "victoria_values" {
  count    = var.victoria_enabled ? 1 : 0
  template = file("${path.module}/config/victoria_config.yaml")
  vars = {
    
  }
}
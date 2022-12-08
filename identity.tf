module "loki-identity" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                            = local.loki_resource_label
  namespace                       = kubernetes_namespace.loki.metadata[0].name
  project_id                      = var.project_id
  roles                           = ["roles/storage.admin", "roles/storage.objectAdmin"]
  automount_service_account_token = true
}


module "tempo-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = local.tempo_resource_label
  namespace  = kubernetes_namespace.tempo.metadata[0].name
  project_id = var.project_id
  roles      = ["roles/storage.admin","roles/storage.objectAdmin"]
  automount_service_account_token = true
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }    
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    helm = {
      source  = "hashicorp/helm"
    }
    vault = {
      source  = "hashicorp/vault"
    }
  }
}
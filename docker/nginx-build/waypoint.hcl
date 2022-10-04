project = "docker-nginx-build"

variable "registry_username" {
  sensitive = true
  env       = ["REGISTRY_USERNAME"]
  type      = string
  default   = ""
}

variable "registry_token" {
  sensitive = true
  env       = ["REGISTRY_TOKEN"]
  type      = string
  default   = ""
}

variable "registry_image" {
  env     = ["REGISTRY_IMAGE"]
  type    = string
  default = "docker.io/kdsda/tester"
}

variable "registry_image_tag" {
  env     = ["REGISTRY_IMAGE_TAG"]
  type    = string
  default = "latest"
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/kred-no/waypoint-demo.git"
    ref  = "HEAD"
    path = "docker/nginx-build"
  }
}

app "nginx" {
  
  // See https://developer.hashicorp.com/waypoint/docs/lifecycle/build
  build {
    use "docker" {
      disable_entrypoint = false
    }
    
    registry {
      // See https://developer.hashicorp.com/waypoint/docs/kubernetes/container-build#container-registry
      use "docker" {
        local    = false
        image    = var.registry_image
        tag      = var.registry_image_tag
        username = var.registry_username
        password = var.registry_token
      }
    }
  }

  // See https://developer.hashicorp.com/waypoint/docs/lifecycle/deploy
  deploy {
    use "kubernetes" {
      replicas = 1
      
      probe_path   = "/"
      service_port = 80
      
      cpu {
        request = "50m"
        limit   = "100m"
      }
      
      memory {
        request = "25Mi"
        limit   = "75Mi"
      }
    }
  }
  
  // See https://developer.hashicorp.com/waypoint/docs/lifecycle/release
  release {
    use "kubernetes" {
      node_port = 30000 // NodePort between 30000-32767
    }
  }
}

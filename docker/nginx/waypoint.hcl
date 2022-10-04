project = "waypoint-demo"

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
    path = "docker/nginx"
  }
}

app "webserver" {
  build {
    use "docker" {
      disable_entrypoint = true
    }
    
    registry {
      
      # https://developer.hashicorp.com/waypoint/docs/kubernetes/container-build#container-registry
      use "docker" {
        local    = false
        image    = var.registry_image
        tag      = var.registry_image_tag
        username = var.registry_username
        password = var.registry_token
      }
    }
  }

  deploy {
    use "kubernetes" {}
  }
}

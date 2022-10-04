project = "docker-nginx-ref"

variable "registry_image" {
  type    = string
  default = "registry.hub.docker.com/library/nginx"
  env     = ["REGISTRY_IMAGE"]
}

variable "registry_image_tag" {
  type    = string
  default = "alpine"
  env     = ["REGISTRY_IMAGE_TAG"]
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/kred-no/waypoint-demo.git"
    path = "docker/nginx-ref"
    ref  = "HEAD"
  }
}

app "nginx" {
  
  // See https://developer.hashicorp.com/waypoint/docs/lifecycle/build
  build {
    
    // See https://developer.hashicorp.com/waypoint/plugins/docker#docker-ref-builder
    use "docker-ref" {
      image = var.registry_image
      tag   = var.registry_image_tag
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

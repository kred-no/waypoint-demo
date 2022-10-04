project = "waypoint-demo"

variable "registry_image" {
  env     = ["REGISTRY_IMAGE"]
  type    = string
  default = "docker.io/nginx"
}

variable "registry_image_tag" {
  env     = ["REGISTRY_IMAGE_TAG"]
  type    = string
  default = "alpine"
}

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/kred-no/waypoint-demo.git"
    ref  = "HEAD"
    path = "docker/nginx-pull"
  }
}

app "nginx-pull" {
  
  // See https://developer.hashicorp.com/waypoint/docs/lifecycle/build
  build {
    
    // See https://developer.hashicorp.com/waypoint/plugins/docker#docker-pull-builder
    use "docker-pull" {
      // Not building the image.
      disable_entrypoint = true
      
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

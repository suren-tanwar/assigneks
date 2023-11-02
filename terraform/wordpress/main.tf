#CREATE WORDPRESS deployment

module "rds" {
  source = "../rds"
}

resource "kubernetes_deployment" "wordpress_dep" {
 metadata {
     name = "wordpress"
     labels = {    
      app = "wordpress"
    }
  }
  
   spec {
    replicas = 1
    selector {
      match_labels = {
        app = "wordpress"
     }
  }
  template {
     metadata {
       labels = {
         app   ="wordpress"
       }
}
  
   spec {
     container {
          image = "wordpress:latest"
          name  = "wordpress"
   env{
     name = "WORDPRESS_DB_HOST"
     value = module.rds.rds_db_host
 }
   env{
     name = "WORDPRESS_DB_PASSWORD"
     value = module.rds.rds_db_pass
     }
     env{
      name = "WORDPRESS_DB_USER"
      value = module.rds.rds_db_user
      }
       env{
       name = "WORDPRESS_DB_NAME"
        value = module.rds.rds_db_name
       }
  port{
     container_port = 80
     name = "wordpress"
  }
}
}
}
}
 }


 resource "kubernetes_service" "wordpress_service" {
  metadata {
    name = "wordpress"
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}


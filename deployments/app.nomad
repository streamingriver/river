job "app" {
  type = "service"
  group "frontend" {
    network {
      mode = "bridge"

    }
    service {
      name         = "frontend-service"
      provider     = "consul"
      address_mode = "auto"
      port         = "80"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.${NOMAD_ALLOC_ID}.entrypoints=web",
        "traefik.http.routers.${NOMAD_ALLOC_ID}.rule=HasPrefix(`/app`)"
      ]
      connect {
        sidecar_service {}
      }
    }
    task "service" {
      driver = "docker"
      config {
        image = "nginx:latest"
        ports = ["80:80"]
      }

    }
  }
}
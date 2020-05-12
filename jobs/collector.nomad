job "collector" {
  datacenters = ["dc1"]
  type        = "service"

  group "api" {
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }
    task "collector_api" {
      driver = "docker"
      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "!="
        value     = "windows"
      }
      config {
        image = "whatsaranjit/collector:0.1.0"
        port_map {
          http = 4567
        }
      }
      resources {
        network {
          mbits = 10
          port "http" {
            static = 4567
          }
        }
      }
      service {
        name = "collector"
        tags = ["demo"]
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "1m"
          timeout  = "2s"
        }
      }
    }
  }
}

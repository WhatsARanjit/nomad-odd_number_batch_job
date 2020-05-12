job "odd" {
  parameterized {
    payload       = "optional"
    meta_optional = ["batch_size", "sleep"]
  }

  meta {
    batch_size = 100
    sleep      = 1
  }

  reschedule {
    attempts       = 5
    interval       = "3m30s"
    delay          = "30s"
    delay_function = "constant"
    max_delay      = "15m"
    unlimited      = false
  }

  datacenters = ["dc1"]
  type        = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }
  
  group "batch_group" {
    count = 800

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
        options {
          checksum = "sha256:2e2aac5ecd533e5cc87c9ab797dc415373685f8e7985edb5fa93598ce57c7ddb"
        }
      }

      config {
        command = "batch_splitter.sh"
        args    = ["${NOMAD_ALLOC_INDEX}", "${NOMAD_META_batch_size}", "${NOMAD_META_sleep}"]
      }

      logs {
        max_files     = 10
        max_file_size = 10
      }
    }
  }
}

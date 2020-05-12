job "odd" {
  parameterized {
  payload       = "optional"
  meta_optional = ["batch_size"]
  }

  meta {
    batch_size = 100
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
  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }
  
  group "batch_group" {
    count = 800

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
        options {
          checksum = "sha256:fe385b108e93cc31f51cdb0143b66e627c15cf729cff4de967bff9b23fb86e69"
        }
      }

      config {
        command = "batch_splitter.sh"
        args    = ["${NOMAD_ALLOC_INDEX}", "${NOMAD_META_batch_size}"]
      }

      logs {
        max_files     = 10
        max_file_size = 10
      }
    }
  }
}

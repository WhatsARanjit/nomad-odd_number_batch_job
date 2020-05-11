job "test" {
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
    count = 600

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
        options {
          checksum = "sha256:9f9016e20a0c9ea3b02ac9369e97897ecb03f76e501b602a882050f4c691595f"
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

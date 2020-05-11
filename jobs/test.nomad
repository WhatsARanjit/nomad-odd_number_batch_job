job "test" {
  meta {
    batch_size = 10
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
    count = 5

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
        options {
          checksum = "sha256:9970d0e61d232c1f7cbf13f91759b357c9a5250de3d89de6d04c34018a09a9d0"
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

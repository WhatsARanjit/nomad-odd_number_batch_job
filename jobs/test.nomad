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
    count = 10

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
        options {
          checksum = "sha256:cc1d52284bf2df69c29f662235fb00f9995c2f92fd736ff46e5911904271f544"
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

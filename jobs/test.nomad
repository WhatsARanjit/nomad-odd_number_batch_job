job "test" {
  meta {
    batch_size = 20
  }

  reschedule {
    attempts       = 1000
    interval       = "1h23m20s"
    delay          = "5s"
    delay_function = "constant"
    max_delay      = "30s"
    unlimited      = false
  }

  datacenters = ["dc1"]
  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value = "darwin"
  }
  
  group "batch_group" {
    count = 60

    task "test_task" {
      driver = "raw_exec"

      restart {
        interval = "15s"
        attempts = 60
        delay    = "15s"
        mode     = "fail"
      }

      artifact {
        source = "https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh"
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

job "test" {
  meta {
    batch_size = 10
  }

  reschedule {
    attempts       = 0
    delay          = "15s"
    delay_function = "constant"
    max_delay      = "1h"
    unlimited      = true
  }

  datacenters = ["dc1"]
  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value = "darwin"
  }
  
  group "batch_group" {
    count = 75

    task "test_task" {
      driver = "raw_exec"

      artifact {
        source = "https://gist.githubusercontent.com/WhatsARanjit/ed1bea889e816adbfae770f68d2e20a6/raw/7cbe994adc806bb19e2510e2668fefa1f4ddd1d1/batch_splitter.sh"
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

# Nomad Odd Job

#### Table of Contents

1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Workflow](#workflow)
    * [Collector Service](#collector-service)
    * [Odd Job](#odd-job)
    * [Show the initial state](#show-the-initial-state)
    * [Run the batch job](#run-the-batch-job)
1. [Things to Know](#things-to-know)

## Overview

An example Nomad batch job which reads in a list of numbers and farms out jobs to filter that list down to odd numbers only.  Lastly, each batch job then submits that data to a "collector" service job to record.

## Requirements

* Nomad server- cluster or dev
* Linux Nomad clients with `raw_exec` and `docker` drivers
* Consul running behind Nomad for service discovery
* Collector service runs on port `4567`, in case you need to adjust security rules


## Workflow

### Collector Service

* First, start the collector service:

```shell
nomad run jobs/collector.nomad
```

* Wait for that to come up in Nomad and successfully get registered in Consul.

### Odd Job

* Next register the Odd parameterized job

```shell
nomad run jobs/odd.nomad
```

The odd job takes 2 parameters:

1. `batch_size`: The quantity of numbers in each batch to be process by each allocation - default is 100
1. `sleep`: An arbitrary sleep in seconds in each allocation to slow it down for demo purposes - default is 1 second

* You can use the defaults or tune it for your demo in `jobs/params.json`
* You can also adjust the `count` in the odd job's `batch_group` group to something that makes sense for you
* The idea is to find the right `batch_size` and `count` combination to slightly over allocate, so you can show how Nomad will queue it up and process

### Show the initial state

* Show the dataset in `numbers/numbers.txt` with even and odd numbers
* Bring up the collector job
* Exec into the job to get shell
* In your CWD, show that `results.txt` is empty to start
* Bring up the odd job in the UI to watch

### Run the batch job

* Dispatch the odd job

```shell
nomad job dispatch odd jobs/params.json
```

* Click into the batch_group job dispatch that pops up
* You should see a warning that resources are exhausted
* Watch as the allocations queue up and Nomad processes all of them
* Check `results.txt` on the collector again to see odd numbers only

## Things to know

* The collector service is a Ruby Sinatra webapp
* The odd job contains a sha256 checksum of `scripts/batch_splitter.sh`, so if you update the script, you must grab the new : `shasum -a 256 <(curl https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/scripts/batch_splitter.sh)`
* The number list is 5000 but you don't have to process it all
* The bash script uses Consul DNS to find the collector service
* The bash script is intentionally very verbose for easy debugging




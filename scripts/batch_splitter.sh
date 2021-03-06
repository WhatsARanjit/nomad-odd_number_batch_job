#!/bin/bash

# Debug options - set $BATCH_DEMO_DEBUG to anything
if [ ! -z "$BATCH_DEMO_DEBUG" ]; then
  set -x
  set -e
  trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
  trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT
  CURL_VERBOSE="-v"
fi

# Set indexes
START_INDEX=$1
SIZE=$2
START=$(expr $START_INDEX "*" $SIZE + 1)
END=$(($START+$SIZE))

# Collect numbers
COLLECT=$(curl -s https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/numbers/numbers.txt | sed "$START,$END !d")

# If past index, exit to success
# In case more runners than batches
if [ -z "$COLLECT" ]; then
  exit 0
fi

# Filter for odd numbers
RESULT=""
for num in $COLLECT; do
  if (( $num % 2 )); then
    #echo $num
    RESULT="${RESULT}${num}\n"
  fi
done

# Slow for demo
sleep=${3:-1}
sleep $sleep

# Trim and fixup payload
RESULT=${RESULT%??}
RESULT=$(echo -e $RESULT)

# Lookup Collector address
# Use ENV or check Consul
if [ -z "$COLLECTOR_ADDR" ]; then
  COLLECTOR_ADDR=$(dig @localhost -p8600 +short collector.service.consul)
fi
echo "Collector address: ${COLLECTOR_ADDR}"

# Submit payload
curl $CURL_VERBOSE -d "$RESULT" "${COLLECTOR_ADDR}:4567/api"

# Report payload
echo $RESULT

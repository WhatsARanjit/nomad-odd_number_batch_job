#!/bin/bash

# Set indexes
START_INDEX=$(($1))
SIZE=$2
START=$(($START_INDEX*$SIZE+1))
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
sleep 1

# Trim and fixup payload
RESULT=${RESULT%??}
RESULT=$(echo -e $RESULT)

# Submit payload
curl -s -d "$RESULT" "${COLLECTOR_ADDR}/api"

#!/bin/bash

# Set indexes
START=$(($1+1))
SIZE=$2
END=$(($START+$SIZE-1))

# Collect numbers
COLLECT=$(curl -s https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/numbers/numbers.txt | sed "$START,$END !d")

# If past index, exit to success
# In case more runners than batches
if [ -z "$COLLECT" ]; then
  exit 0
fi

# Filter for odd numbers
for num in $COLLECT; do
  if (( $num % 2 )); then
    echo $num
  fi
done

# Slow for demo
sleep 10

#!/bin/bash

START=$(($1+1))
SIZE=$2
END=$(($START+$SIZE-1))

COLLECT=$(curl -s https://raw.githubusercontent.com/WhatsARanjit/nomad-odd_number_batch_job/master/numbers/numbers.txt | sed "$START,$END !d")
if [ -z "$COLLECT" ]; then
  exit 0
fi

for num in $COLLECT; do
  if (( $num % 2 )); then
    echo $num
  fi
done

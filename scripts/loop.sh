#!/bin/bash

for i in {0..624}; do
  ./scripts/batch_splitter.sh $i 8
done

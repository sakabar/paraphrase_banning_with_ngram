#!/bin/zsh

rm -rf result_baseform/*.txt
for f in result_old/*.txt; do
# for f in result/*.txt; do
  paste $f <(cat $f | ./shell/convert_to_baseform.sh) | awk '{print $1,$3}' | awk '{a[$2]+=$1} END{for(k in a) {print a[k]"\t"k}}' | sort -nr | grep -v "NONE" | head > ./result_baseform/$f:t
done


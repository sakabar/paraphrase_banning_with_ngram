#!/bin/zsh

for d in x*; do
  output_dir=$d"_baseform"
  rm -rf $output_dir/*.txt
  mkdir $output_dir

  for f in $d/*.txt; do 
    paste $f <(cat $f | ./shell/convert_to_baseform.sh) | awk '{print $1,$3}' | awk '{a[$2]+=$1} END{for(k in a) {print a[k]"\t"k}}' | sort -nr | grep -v "NONE" | head > $output_dir/$f:t
  done
done

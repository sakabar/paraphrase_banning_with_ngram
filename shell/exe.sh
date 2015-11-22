#!/bin/zsh

if [ $# -ne 1 ]; then
  echo "argument error"
  exit 1
fi

if [ `hostname` != 'biscuit' ]; then
  echo "run at biscuit"
  exit 1
fi

str=$1

cat <(./shell/search_4gram.sh $str | awk '{print $3" "$5}') <(./shell/search_5gram.sh $str | awk '{print $3" "$6}') <(./shell/search_kudasai_5gram.sh $str | awk '{print $3" "$6}') <(./shell/search_kudasai_6gram.sh $str | awk '{print $3" "$7}') | awk '{a[$1]+=$2} END{for(k in a) {print a[k]"\t"k}}' | sort -nr

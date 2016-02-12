#!/bin/zsh


cat -n  output_of_antonym.txt | 
while read line; do
  sid=`echo $line | awk '{print $1}'`
  ans=`echo $line | awk '{print $2}'`

  if [ $ans != "NONE" ]; then
    orig_str=`lv data/input_uniq.txt | head -n$sid | tail -n1`
    ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ans"`
    if [ $ans_num -ge 1 ]; then
	echo "$sid $ans [OK]"
    else
       	echo "$sid $ans [NG]"
    fi
  else
    echo "$sid NONE"
  fi

done

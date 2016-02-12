#!/bin/zsh

split_num=75

cat -n  output_of_antonym.txt | 
while read line; do
  sid=`echo $line | awk '{print $1}'`
  ans=`echo $line | awk '{print $2}'`

  orig_str=`lv data/input_uniq.txt | head -n$sid | tail -n1`

  if [ $ans != "NONE" ]; then
    ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ans"`
    if [ $ans_num -ge 1 ]; then
	echo "$sid $ans [OK][dic]"
    else
       	echo "$sid $ans [NG][dic]"
    fi
  else
    #反義語がなかったときには、ngramのtop1を出力する
    
    n="$[($sid - 1) / $split_num + 1]" 
    line_num=`echo $[($sid - 1) % $split_num + 1]`
    filename=`ls pred_and_case_converted_split/ | grep "^x" | awk -v n=$n 'NR == n {print $0}'`
    exe_loop_result=`lv exe_loop_result_$filename".txt" | head -n $line_num | tail -n1`
    cand_file=`echo $exe_loop_result | tr ' ' '\n' | grep "\.txt" | head -n1`

    if [ "$cand_file" = "" ]; then
      echo "$sid NONE no_cand_file"
    else
      if [ `cat $filename"_baseform"/$cand_file | grep -c .` -eq 0 ]; then
        echo "$sid NONE no_cand_ngram"
	continue
      fi

      ngram_ans=`cat $filename"_baseform"/$cand_file | head -n1 | awk '{print $2}'`
      ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ngram_ans"`

      if [ $ans_num -ge 1 ]; then
        echo "$sid $ngram_ans [OK][ngram]"
      else
        echo "$sid $ngram_ans [NG][ngram]"
      fi
    fi
  fi

done

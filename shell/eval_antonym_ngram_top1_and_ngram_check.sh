#!/bin/zsh

split_num=75

cat -n  output_of_antonym.txt | 
while read line; do
  sid=`echo $line | awk '{print $1}'`
  ans=`echo $line | awk '{print $2}'`

  orig_str=`lv data/input_uniq.txt | head -n$sid | tail -n1`

  if [ $ans != "NONE" ]; then #反義語があった場合
    #そういう言い方があるかどうか、ngramをチェック
     arg=`lv pred_and_case_converted.txt |head -n$sid| tail -n1 |awk '{for(i=1;i<NF-1;i++){printf $i" "}}' | sed -e 's/ \+$//'`
     case=`lv pred_and_case_converted.txt |head -n$sid | tail -n1 | awk '{printf $(NF-1)}'`
     # echo $arg>&2
     # echo $case>&2
     # echo $ans>&2

     if [ "$arg" = "NONE" ];then #項がない→反義語を信じよう
       ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ans"`
       if [ $ans_num -ge 1 ]; then
         echo "$sid $ans [OK][dic] no_arg"
         continue
       else
         echo "$sid $ans [NG][dic] no_arg"
         continue
       fi
     fi

     orig_pred=`lv pred.txt | head -n$sid | tail -n1 | awk -F'/' '{print $1}'`
     orig_freq=0
     if [ "$case" = 'は' ]; then
       orig_freq=`{
         ./shell/search_ngram.sh "$arg は $orig_pred" | head -n1 | awk -F'\t' '{print $2}'
         ./shell/search_ngram.sh "$arg が $orig_pred" | head -n1 | awk -F'\t' '{print $2}'
         ./shell/search_ngram.sh "$arg を $orig_pred" | head -n1 | awk -F'\t' '{print $2}'
        } | sort -nr | head -n1`
     else
       # echo "$arg $case $orig_pred">&2
       orig_freq=`./shell/search_ngram.sh "$arg $case $orig_pred" | head -n1 | awk -F'\t' '{print $2}'`
     fi

     antonym_freq=0
     if [ "$case" = 'は' ]; then
       antonym_freq=`{
         ./shell/search_ngram.sh "$arg が $ans" | head -n1 | awk -F'\t' '{print $2}'
         ./shell/search_ngram.sh "$arg を $ans" | head -n1 | awk -F'\t' '{print $2}'
        } | sort -nr | head -n1`
     else
       antonym_freq=`./shell/search_ngram.sh "$arg $case $ans" | head -n1 | awk -F'\t' '{print $2}'`
     fi
     if [ "$antonym_freq" -gt 0 ] && [ "$orig_freq" -gt 0 ] ;then
       threshold="0.1"
       rate="$[1.0 * $antonym_freq / $orig_freq ]"
       if [ `expr "$rate" \>= "$threshold"` -eq 1 ]; then #元のngramと反義語ngramの比が一定以上のときに出力する
         ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ans"`
         if [ $ans_num -ge 1 ]; then
           echo "$sid $ans [OK][dic] $antonym_freq / $orig_freq : $rate | $arg $case |$orig_pred → $ans "
	   continue
         else
     	   echo "$sid $ans [NG][dic] $antonym_freq / $orig_freq : $rate | $arg $case | $orig_pred → $ans"
	   continue
         fi
       else
	 echo "$sid NONE ngram-freq rate is low : $antonym_freq / $orig_freq : $rate |$arg $case | orig_pred → $ans"
	 continue
       fi
     else
	 echo "$sid NONE ngram-freq is low anto:$antonym_freq and orig:$orig_freq | $arg $case | $orig_pred → $ans"
	 continue
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

      orig_pred=`lv pred.txt | head -n$sid | tail -n1 | awk -F'/' '{print $1}'` #元の動詞は選ばない

      ngram_ans=`cat $filename"_baseform"/$cand_file | grep -v " $orig_pred"'$' | head -n1 | awk '{print $2}'`
      if [ "$ngram_ans" = "" ]; then
	  echo "$sid NONE no_cand_ngram 2"
	 continue
      fi

      if [ "$ngram_ans" = "やめる" ] || [ "$ngram_ans" = "避ける" ] || [ "$ngram_ans" = "さける" ] ;then
         echo "$sid NONE 'やめる' '避ける'" #やめる、避けるは選ばない(なぜなら、禁止と変わらないから)
	 continue
      fi

      ans_num=`grep $orig_str data/banned_result.csv | cut -d, -f6- | tr ',' '\n' | grep -c "$ngram_ans"`

      if [ $ans_num -ge 1 ]; then
        echo "$sid $ngram_ans [OK][ngram]"
      else
        echo "$sid $ngram_ans [NG][ngram]"
      fi
    fi
  fi

done

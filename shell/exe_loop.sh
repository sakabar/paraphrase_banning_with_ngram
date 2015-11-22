#!/bin/zsh

set -ue

output_dir=/home/lr/tsakaki/work/paraphrase_banning_with_ngram/result
cat /dev/null > exe_loop_result.txt
s_id=1
lv replace_verb_just_prev_case_uniq_gen_from_gold_std.txt |
while read line; do
  arg=`echo $line | awk '{print $1}'`
  cas=`echo $line | awk '{print $2}'`
  banned_pred=`echo $line | awk '{print $3}' | awk -F'/' '{print $1}'`
  output_file=$output_dir/$s_id.txt
  shell/exe.sh "$arg $cas" > $output_file
  echo "$arg $cas $banned_pred $output_file" >> exe_loop_result.txt
  s_id=$[$s_id + 1]
done

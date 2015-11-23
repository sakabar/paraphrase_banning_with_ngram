#!/bin/zsh

if [ `hostname` != 'biscuit' ]; then
  echo "run at biscuit"
  exit 1
fi

output_dir=/home/lr/tsakaki/work/paraphrase_banning_with_ngram/result
rm -rf $output_dir/*.txt
set -ue

cat /dev/null > exe_loop_result.txt


s_id=1
# lv replace_verb_just_prev_case_uniq_gen_from_gold_std.txt |
cat - | 
while read line; do
  nf=`echo $line | awk '{print NF}'`
  arg=`echo $line | cut -d ' ' -f1-$[$nf-2]`
  cas=`echo $line | cut -d ' ' -f$[$nf-1]`
  banned_pred=`echo $line | awk '{print $NF}' | awk -F'/' '{print $1}'`
  # output_file=$output_dir/$s_id.txt

  if [ "`echo $line | awk '{print $1}'`" = "NONE" ]; then
      echo "NONE $banned_pred" >> exe_loop_result.txt
      continue
  fi

  case $cas in
   #  'を' ) shell/exe.sh "$arg を" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred を $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1]

   # 	   shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1]
   # 	   ;;

   #  'に' ) shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1]

   # 	   shell/exe.sh "$arg から" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred から $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1] ;;

   # 'から') shell/exe.sh "$arg から" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred から $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1] 

   # 	   shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> exe_loop_result.txt
   #         s_id=$[$s_id + 1]
   # 	   ;;

       * ) shell/exe.sh "$arg $cas" > $output_dir/$s_id.txt
	   echo "$arg $cas $banned_pred $s_id.txt" >> exe_loop_result.txt
           s_id=$[$s_id + 1] ;;
  esac
  # exit
done

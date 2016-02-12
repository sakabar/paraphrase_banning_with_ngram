#!/bin/zsh

if [ `hostname` != 'biscuit' ] && [ `hostname` != 'basil' ]; then
  echo "run at biscuit"
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "Argument error">&2
  exit 1
fi

splitted_file=$1


# output_dir=/home/lr/tsakaki/work/paraphrase_banning_with_ngram/result
output_dir=/home/lr/tsakaki/work/paraphrase_banning_with_ngram/$splitted_file:t:r
rm -rf $output_dir/*.txt
mkdir -p $output_dir

set -ue

result_file=exe_loop_result_$splitted_file:t:r".txt"
cat /dev/null > $result_file


s_id=1
# lv replace_verb_just_prev_case_uniq_gen_from_gold_std.txt |
cat $splitted_file |
while read line; do
  nf=`echo $line | awk '{print NF}'`

  if [ $nf -lt 3 ]; then
      #"ぇは  笑う/わらう:動"のように、mecabで単語が分かれない場合がある
      echo "NONE $banned_pred" >> $result_file
      continue
  fi

  arg=`echo $line | cut -d ' ' -f1-$[$nf-2]`
  cas=`echo $line | cut -d ' ' -f$[$nf-1]`
  banned_pred=`echo $line | awk '{print $NF}' | awk -F'/' '{print $1}'`
  # output_file=$output_dir/$s_id.txt

  if [ "`echo $line | awk '{print $1}'`" = "NONE" ]; then
      echo "NONE $banned_pred" >> $result_file
      continue
  fi

  case $cas in
   #  'を' ) shell/exe.sh "$arg を" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred を $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1]

   # 	   shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1]
   # 	   ;;

   #  'に' ) shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1]

   # 	   shell/exe.sh "$arg から" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred から $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1] ;;

   # 'から') shell/exe.sh "$arg から" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred から $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1] 

   # 	   shell/exe.sh "$arg に" > $output_dir/$s_id.txt
   #         echo "$arg $cas $banned_pred に $s_id.txt" >> $result_file
   #         s_id=$[$s_id + 1]
   # 	   ;;

       * ) shell/exe.sh "$arg $cas" > $output_dir/$s_id.txt
	   echo "$arg $cas $banned_pred $s_id.txt" >> $result_file
           s_id=$[$s_id + 1] ;;
  esac
  # exit
done

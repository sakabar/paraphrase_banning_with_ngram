#!/bin/zsh

set -ue
#banned_result.csvの中の言い換えられる文のうち、どの程度正解しているか

input=data/banned_result.csv
split_num=75 #75行ごとに分割

cat -n $input | tr '\t' ',' | awk -F, '$7 != "" {print $0}' | awk -F, '$4 == "place_1" {print $0}' | grep -E "word_1|word_2|word_3" \
  | while read line; do
  ban_str=`echo $line | awk -F, '{print $2}'`
  sid=`cat -n data/input_uniq.txt | grep "$ban_str" | head -n1 | awk '{print $1}'`

  n="$[($sid - 1) / $split_num + 1]" 
  line_num=`echo $[($sid - 1) % $split_num + 1]`
  filename=`ls pred_and_case_converted_split/ | grep "^x" | awk -v n=$n 'NR == n {print $0}'`


  exe_loop_result=`lv exe_loop_result_$filename".txt" | head -n $line_num | tail -n1`

  cand_file=`echo $exe_loop_result | tr ' ' '\n' | grep "\.txt" | head -n1`
  banned_pred=`echo $exe_loop_result | tr ' ' '\n' | grep -v "\.txt" | tail -n1`

  answers=`echo $line | cut -d ',' -f7- | sed -e 's/,\+$/,/' | sed -e 's/^/,/'`
  
set +e
  #反義語がない場合は、ここで、grepの返り値が0以外の値になってエラー
  antonyms_str=`echo $banned_pred | juman | head -n1 | grep -o "反義:[^\" ]\+"`
  antonyms=`echo $antonyms_str | sed -e 's/反義://' | tr ';' '\n' | sed -e 's|[^:]\+:\([^/]\+\)/.*|\1|' | tr '\n' ',' | sed -e 's/,$//'`
set -e

  antonym_is_ans_flag=0
  #辞書で引いた反義語は正解かどうか?
  for antonym in `echo $antonyms | tr ',' '\n'`; do
    set +e #ここも、grep -cの結果が0のとき(ヒットしないとき)に返り値が0以外になってエラー
    ans_num=`echo $answers | grep -c ",$antonym,"`
    set -e
    if [ $ans_num -ge 1 ]; then
	antonym_is_ans_flag=1
    fi
  done

  if [ $antonym_is_ans_flag -eq 1 ];then
    echo "[OK]sid:$sid $antonym is in dic\t$ban_str"
    continue #次の行へ
  fi



  #辞書で引いた単語には正解はなかった
  if [ "$cand_file" = "" ]; then
    #項を持たないファイルだった(辞書の反義語は調べ済なのでどうしようもない)
    echo "[NG]sid:$sid took no argument ...\t$ban_str"
    continue
  else
    result_cand_file=$filename"_baseform"/$cand_file

    pred_found_flag=0
    ans_OK=""
    for ans in `echo $answers | tr ',' '\n' | grep -v "^$"`; do
      set +e #ここも、grep -cの結果が0のとき(ヒットしないとき)に返り値が0以外になってエラー
      ans_in_cand_file_num=`cat $result_cand_file | tr '\t' ' ' | grep -c " $ans"'$' `
      set -e
      if [ "$ans_in_cand_file_num" -ge 1 ]; then
        # echo "[OK]sid:$sid $ans is in cand_file!"
	rank=`cat -n $result_cand_file | tr '\t' ' ' | grep " $ans"'$' | awk '{print $1}'`
	ans_OK=$ans_OK",$ans($rank)"
        pred_found_flag=1
      fi
    done

    if [ $pred_found_flag -eq 1 ];then
        echo "[OK]sid:$sid $ans_OK is in $result_cand_file\t$ban_str"
    else
       echo "[NG]sid:$sid all $answers are not in $result_cand_file\t$ban_str"
    fi
  fi

done

#!/bin/zsh

set -ue

if [ `hostname` != 'yokan' ]; then
  echo "run at yokan">&2
  exit
fi

model_path='/home/lr/tsakaki/work/word2vec/w2v_jawiki_latest_mecab_baseform_nai_withcase_s300_w5.bin'
if [ ! -e $model_path ]; then
  echo "there is no $model_path">&2
  exit
fi

lv exe_loop_result.txt | python src/check_word2vec_sim.py $model_path > result_jawiki.txt 


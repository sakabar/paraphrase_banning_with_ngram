#!/bin/zsh

set -ue

if [ `hostname` != 'basil' ]; then
  echo "run at basil">&2
  exit
fi

#model_path='/home/lr/tsakaki/work/word2vec/w2v_tsubame_kototoi_mecab_baseform_withcase_s300_w5.bin'
model_path='/local/tsakaki/w2v_tsubame_kototoi_mecab_baseform_ikemasen_mashou_s300_w5_cbow.bin'

if [ ! -e $model_path ]; then
  echo "there is no $model_path">&2
  exit 1
fi


python src/check_word2vec_sim2.py $model_path xaa xab xac xad xae xaf xag xah
exit 

for d in *_baseform; do
  split_tag=`echo $d | sed 's/_baseform//'` #xaaとか
  echo $split_tag>&2
  python src/check_word2vec_sim2.py $model_path $split_tag
done


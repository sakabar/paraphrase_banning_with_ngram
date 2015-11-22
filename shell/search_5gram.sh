#!/bin/zsh

set -ue

if [ $# -ne 1 ];then
  echo "argument error"
  exit 1
fi

n=5
str=$1

ngram_dir='/local/tsakaki/ngram/'$n'gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

ngram_file=`cat $ngram_dir/*.idx <(echo "target\t"$str" " )  | LC_ALL=C sort -t $'\t' -k2,2 | grep -B1 "^target"|head -n1 | awk '{print $1}'`
lv $ngram_dir/$ngram_file | LC_ALL=C grep "^"$str" " | awk '$5 == "ましょ" {print $0}' | awk '$4 == "し" {print $0}' 

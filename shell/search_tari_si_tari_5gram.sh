#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/5gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$2 == "たり" || $2 == "だり" {print $0}' | awk '$5 == "たり" {print $0}' | awk '$4 == "し" {print $0}'


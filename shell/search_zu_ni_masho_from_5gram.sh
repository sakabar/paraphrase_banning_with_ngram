#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/5gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$5 == "ましょ" {print $0}' | awk '$2 == "ず" {print $0}' | awk '$3 == "に" {print $0}'

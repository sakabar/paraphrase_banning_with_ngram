#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/7gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$7 == "ましょ" {print $0}' | awk '$2 == "せ" {print $0}' | awk '$3 == "ず" {print $0}' | awk '$4 == "に" {print $0}' | awk '$6 == "し" {print $0}'

#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/4gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$2 == "か" {print $0}' | awk '$4 == "か" {print $0}' 

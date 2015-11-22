#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/5gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$2 == "か" {print $0}' | awk '$4 == "する" {print $0}' | awk '$5 == "か" {print $0}' 

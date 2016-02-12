#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/6gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$2 == "する" {print $0}' | awk '$3 == "か" {print $0}' | awk '$5 == "する" {print $0}' | awk '$6 == "か" {print $0}' 

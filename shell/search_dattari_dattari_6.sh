#!/bin/zsh

ngram_dir='/local/tsakaki/ngram/6gms'
if [ ! -d $ngram_dir ];then
  echo "$ngram_dir is not existing directory"
  exit 1
fi

zcat $ngram_dir/*.gz | awk '$2 == "だっ" {print $0}' | awk '$3 == "たり" {print $0}' | awk '$5 == "だっ" {print $0}' | awk '$6 == "たり" {print $0}'


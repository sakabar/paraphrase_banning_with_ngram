#!/bin/zsh

if [ $# -ne 1 ]; then
  echo "argument error"
  exit 1
fi

if [ `hostname` != 'biscuit' ]; then
  echo "run at biscuit"
  exit 1
fi

str=$1
{
  ./shell/search_masho.sh $str
  ./shell/search_si_masho.sh $str
  ./shell/search_kudasai.sh $str
  ./shell/search_si_te_kudasai.sh $str
} | awk -F'\t' '{print $2"\t"$1}' > $$.txt

cat $$.txt | awk -F'\t' '{print $1}' > $$"_cnt.txt"
cat $$.txt | shell/convert_to_baseform.sh > $$"_bf.txt"
paste -d '\t' $$"_cnt.txt" $$"_bf.txt" | awk '{a[$2]+=$1} END{for(k in a) {print a[k]"\t"k}}' | sort -nr

rm -rf $$"_cnt.txt" $$"_bf.txt" $$.txt


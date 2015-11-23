#!/bin/zsh

cat - |
while read line; do
  num=`echo $line | awk -F'\t' '{print $1}'`
  str=`echo $line | awk -F'\t' '{print $2}'`

  ans=`echo $str | tr -d ' '| mecab | tr '\t' ',' | grep -E ",動詞,自立,|,名詞,サ変接続," | tail -n1 | awk -F, '{print $8}'`
  if [ "$ans" != "" ]; then
    echo "$ans"
  else
    echo "NONE"
  fi
done

exit

cat - | awk '{print $2}' | mecab -F '%f[6]:%f[0]-%f[1] ' -U '%f[6]:未知語 ' --nbest 10 --eos-format '\n' --eon-format 'EON\n' \
  | grep -v  " [^$]" | tr  '\n' ' ' | sed -e 's/ \+/ /g' | sed -e 's/ EON /\nEON\n/g' \
  |  awk '
{
  ans_sahen = ""
  ans_verb = ""
  for(i=1; i<=NF; i++){
    if((ans_sahen == "") && ($i ~ "^[^:]+:名詞-サ変接続$")){
      ans_sahen = $i #サ変の名詞を入れておく
    }
    if($i ~ "^[^:]+:動詞-自立$"){
      ans_verb = $i
      break
    }
  }

  #もし動詞-自立がヒットしていたら、その動詞を出力
  #もし動詞-自立がヒットせず、サ変名詞がヒットしていたら、サ変名詞を出力
  #サ変名詞もヒットしていなかったら、てきとうにNONEでも出しておく
  if(ans_verb != ""){
    print ans_verb
  }
  else{
    if($0 == "EON"){
      #EONは出力しない
      #print "EON"
    }
    else if(ans_sahen != ""){
      print ans_sahen
    }
    else{
      print "NONE"
    }
  }
}' | sed -e 's/:.*$//g'

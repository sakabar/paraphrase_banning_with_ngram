#!/bin/zsh

#並列でexe_loopを回す
#あらかじめ、pred_and_case_converted_splitに分割したファイル群を置いておく

if [ `hostname` != 'biscuit' ] && [ `hostname` != 'basil' ]; then
  echo "run at biscuit"
  exit 1
fi


for splitted_file in pred_and_case_converted_split/x*; do
  shell/exe_loop.sh $splitted_file &
done

wait

echo "Done."

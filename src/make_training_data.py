#coding:utf-8
import sys
import word2vec

#前までsample.pyだったから、それで検索すれば履歴が出てくるかも

#噂-ヲ-流すから(噂,流す)のみを切り出す
#格の情報は消す
def cut_arg_pred(s):
    l = s.split('-')
    return (l[0], l[2])

#標準入力から例のコーパスを読み込んで、項と述部のベクトルを出力、かな?
def main():
    # model = word2vec.load('/home/lr/sasano/corpus/word2vec/jawiki-mecab.bin')
    model = word2vec.load('/home/lr/tsakaki/work/word2vec/w2v_jawiki_latest_mecab_baseform_s300_w500.bin')

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split('\t')
        arg_pred0 = lst[0]
        arg_pred1 = lst[1]
        clas = lst[2]
        clas_detail = lst[3] if len(lst) >= 4 else ""

        arg = cut_arg_pred(arg_pred0)[0]
        pred0 = cut_arg_pred(arg_pred0)[1]
        pred1 = cut_arg_pred(arg_pred1)[1]
        ans_vector = []
        try:
            ans_vector.extend(model[arg])
            pred0_vec = model[pred0]
            pred1_vec = model[pred1]
            diff_vec = []
            for i in xrange(0, len(pred0_vec)):
                diff_vec.append(pred0_vec[i] - pred1_vec[i])

            ans_vector.extend(diff_vec)
        except:
            continue

        label = 1 if (clas == "反義" and clas_detail == "属性反義") else -1

        # print arg
        # print pred0
        # print pred1
        # print label
        # sys.exit(1)
        sys.stdout.write("%d " % label)
        for ind, val in enumerate(ans_vector):
            sys.stdout.write("%d:%f " % (ind+1, val))
        print

    return

if __name__ == '__main__':
    main()

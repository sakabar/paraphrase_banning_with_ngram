#coding:utf-8
import sys
import word2vec

def main():
    model = word2vec.load('/home/lr/tsakaki/work/word2vec/w2v_jawiki_latest_mecab_baseform_s300_w500.bin')
    # model = word2vec.load('/home/lr/sasano/corpus/word2vec/jawiki-mecab.bin')

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split()
        label = int(lst[0])
        arg = lst[1]
        pred0 = lst[2]
        pred1 = lst[3]

        vec = []
        try:
            arg_vec = model[arg]
            pred0_vec = model[pred0]
            pred1_vec = model[pred1]
        except:
            raise Exception("%s : CONTAINS UNKOWN WORD" % line)

        diff_vec = []
        for i in xrange(0, len(pred0_vec)):
            diff_vec.append(pred0_vec[i] - pred1_vec[i])
        vec.extend(arg_vec)
        # vec.extend(pred0_vec)
        # vec.extend(pred1_vec)
        vec.extend(diff_vec)
        sys.stdout.write("%d " % label)
        for ind, val in enumerate(vec):
            sys.stdout.write("%d:%f " % (ind,val))

        print 

    return

if __name__ == '__main__':
    main()

#coding:utf-8
import sys
import word2vec
import numpy as np

def main():
    model_path = ''
    if len(sys.argv) == 2:
        model_path = sys.argv[1]
    else:
        raise Exception("Argument error")

    sys.stderr.write("word2vec model loading...")
    sys.stderr.flush()    
    model = word2vec.load(model_path)
    sys.stderr.write("Done.\n")
    sys.stderr.flush()

    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split(' ')
        banned_arg = lst[0]
        banned_case = lst[1]
        banned_pred = lst[2]
        cand_case = lst[3]
        cand_file_name = lst[4]

        banned_arg_and_pred = "%s_%s_%s" % (banned_arg, banned_case, banned_pred)

        b0 = False
        try:
            banned_vec = model[banned_arg_and_pred]
            b0 = True
        except:
            pass

        if(not b0):
            print "banned_arg_and_pred(%s) is not found!" % banned_arg_and_pred
            print "----------*"
            continue

        similarity_lst = []
        with open('/home/lr/tsakaki/work/paraphrase_banning_with_ngram/result_baseform' + '/' + cand_file_name, 'r') as f:
            for cand_line in f:
                cand_line = cand_line.rstrip()
                cand_lst = cand_line.split()
                cand_cnt = int(cand_lst[0])
                # cand_pred_renyou = cand_lst[1] #出力しないようにした
                cand_pred_base = cand_lst[1]

                cand_arg_and_pred = "%s_%s_%s" % (banned_arg, cand_case, cand_pred_base)
                
           
                b1 = False
                try:
                    cand_vec = model[cand_arg_and_pred]
                    b1 = True
                except:
                    pass

                if(b1): #b0がFalseだったらもっと前で検知されている
                    sim = np.dot(banned_vec, cand_vec) / np.linalg.norm(banned_vec) / np.linalg.norm(cand_vec)
                    similarity_lst.append((cand_arg_and_pred, cand_cnt, sim))
                    
                    # print "%s %s both found" % (banned_arg_and_pred, cand_arg_and_pred)
                else:
                    # sys.stderr.write("cand_arg_and_pred(%s) is not found!\n" % cand_arg_and_pred)
                    similarity_lst.append((cand_arg_and_pred, cand_cnt, 0.0))

 
        if(len(similarity_lst)):
            for key, cnt, sim in sorted(similarity_lst, key=(lambda tpl: tpl[1]), reverse=True):
                print "%s %s %.2f %d" % (banned_arg_and_pred, key, sim, cnt)
        else:
            print "%s:similarity_lst_empty!(%s格→%s格)" % (banned_arg_and_pred, banned_case, cand_case)
        print "----------$"

    return

if __name__ == '__main__':
    main()

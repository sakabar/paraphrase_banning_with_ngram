#coding:utf-8
import sys
import word2vec
import numpy as np

def main():
    model_path = ''
    split_tag = ''
    if len(sys.argv) >= 3:
        model_path = sys.argv[1]
        # split_tag = sys.argv[2]
    else:
        raise Exception("Argument error")

    sys.stderr.write("word2vec model loading...")
    sys.stderr.flush()
    # model = word2vec.load('/home/lr/tsakaki/work/word2vec/w2v_jawiki_latest_mecab_baseform_s300_w5.bin')
    model = word2vec.load(model_path)
    sys.stderr.write("Done.\n")
    sys.stderr.flush()
    
    for i in xrange(2, len(sys.argv)):
        split_tag = sys.argv[i]
        with open('exe_loop_result_' + split_tag + '.txt', 'r') as result_f:
            for result_line in result_f:
                result_line = result_line.rstrip()
                result_lst = result_line.split(' ')

                if(result_lst[0] == 'NONE'):
                    #項がないパターン
                    print "%s:no-argument" % result_line
                    continue

                ngram_file = result_lst[-1]
                orig_pred = result_lst[-2]
                # print ngram_file
                # print orig_pred

                w1 = "%s_て_は_いける_ます_ん" % orig_pred
                # w1 = orig_pred
                v1 = []
                try:
                    v1 = model[w1]
                except:
                    sys.stderr.write("%s is not in vocab\n" % w1)
                    print "%s: not in vocab" % w1
                    continue
                    # raise Exception('vec error at 41')

                tmp_filename = split_tag + '_baseform/' + ngram_file
                # print tmp_filename
                with open(tmp_filename, 'r') as ngram_f:
                    for ngram_line in ngram_f:
                         ngram_line = ngram_line.rstrip()
                         ngram_lst = ngram_line.split()
                         ngram_cnt = ngram_lst[0]
                         cand_pred = ngram_lst[1]


                         w2 = "%s_ます_う" % cand_pred
                         # w2 = cand_pred
                         v2 = []
                         try:
                             v2 = model[w2]
                         except:
                             sys.stderr.write("%s is not in vocab\n" % w2)
                             continue

                         sim = np.dot(v1, v2) / np.linalg.norm(v1) / np.linalg.norm(v2)
                         print "%s:%s:%.2f" % (result_line, cand_pred, sim)
                    
        # lst = line.split(' ')


        # banned_arg = lst[0]
        # banned_case = lst[1]
        # banned_pred = lst[2]
        # cand_case = lst[3]
        # cand_file_name = lst[4]

        # banned_arg_and_pred = "%s_%s_%s" % (banned_arg, banned_case, banned_pred)

        # b0 = False
        # try:
        #     banned_vec = model[banned_arg_and_pred]
        #     b0 = True
        # except:
        #     pass

        # if(not b0):
        #     print "banned_arg_and_pred(%s) is not found!" % banned_arg_and_pred
        #     print "----------*"
        #     continue

        # similarity_lst = []
        # with open('/home/lr/tsakaki/work/paraphrase_banning_with_ngram/result_baseform' + '/' + cand_file_name, 'r') as f:
        #     for cand_line in f:
        #         cand_line = cand_line.rstrip()
        #         cand_lst = cand_line.split()
        #         cand_cnt = int(cand_lst[0])
        #         # cand_pred_renyou = cand_lst[1] #出力しないようにした
        #         cand_pred_base = cand_lst[1]

        #         cand_arg_and_pred = "%s_%s_%s" % (banned_arg, cand_case, cand_pred_base)
                
           
        #         b1 = False
        #         try:
        #             cand_vec = model[cand_arg_and_pred]
        #             b1 = True
        #         except:
        #             pass

        #         if(b1): #b0がFalseだったらもっと前で検知されている
        
        #             similarity_lst.append((cand_arg_and_pred, cand_cnt, sim))
                    
        #             # print "%s %s both found" % (banned_arg_and_pred, cand_arg_and_pred)
        #         else:
        #             # sys.stderr.write("cand_arg_and_pred(%s) is not found!\n" % cand_arg_and_pred)
        #             similarity_lst.append((cand_arg_and_pred, cand_cnt, 0.0))

 
        # if(len(similarity_lst)):
        #     for key, cnt, sim in sorted(similarity_lst, key=(lambda tpl: tpl[1]), reverse=True):
        #         print "%s %s %.2f %d" % (banned_arg_and_pred, key, sim, cnt)
        # else:
        #     print "%s:similarity_lst_empty!(%s格→%s格)" % (banned_arg_and_pred, banned_case, cand_case)
        # print "----------$"

    return

if __name__ == '__main__':
    main()

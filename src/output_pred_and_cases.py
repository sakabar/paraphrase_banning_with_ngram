#coding:utf-8
import sys
import re

mod_regex = re.compile('<係:([^>]+)>')
analysis_case_regex = re.compile('<解析格:([^>]+)>')
case_result_regex = re.compile('<格解析結果:([^:]+:[^:0-9]+)[0-9]*:([^>]+)>')
norm_form_regex = re.compile('<正規化代表表記:([^>]+)>')

def sentence_func(knp_lines):
    last_basic_phrase=[line for line in knp_lines if line[0] == '+'][-1]

    case_result_match = case_result_regex.search(last_basic_phrase)
    if case_result_match:
        pred = case_result_match.group(1)
        cases = case_result_match.group(2).split(';')
        cases = [case for case in cases if case.split('/')[0] in ['ガ', 'ヲ', 'ニ', 'カラ']] #使う格をガ/ヲ/ニ/カラに限定

        bp_nums = [int(case.split('/')[3]) for case in cases if case.split('/')[3] != '-']
        if len(bp_nums) != 0:
            bp_num = max(bp_nums)
            bp = [line for line in knp_lines if line.startswith("+ %d " % bp_num)][0]

            #bpの正規化代表表記を取って、格と足す
            #<係:マデ>とか
            #KNPの格解析結果をどこまで信じるか…?
            #解析格を利用しないことにした。
            
            case = ""
            norm_form = ""
            mod_regex_match = mod_regex.search(bp)
            norm_form_regex_match = norm_form_regex.search(bp)
            # analysis_case_regex_match = analysis_case_regex.search(bp)
            analysis_case_regex_match = False #使わない

            if norm_form_regex_match:
                if analysis_case_regex_match: #解析格がある場合
                    case = analysis_case_regex_match.group(1)
                    norm_form = norm_form_regex_match.group(1)
                    print "%s:%s格 %s" % (norm_form, case, pred)
                    return

                elif mod_regex_match: #解析格がない場合
                    case = mod_regex_match.group(1)
                    norm_form = norm_form_regex_match.group(1)
                    print "%s:%s %s" % (norm_form, case, pred)
                    return

                else:
                    print "NONE0 %s" % pred
                    return

            else:
                print "NONE1 %s" % pred
                return

        else:
            print "NONE2 %s" % pred
            return

    else:
        print "NONE3 %s" % pred
        return

    print "NONE 4"# % pred
    return

def main():
    knp_lines = []

    for line in sys.stdin:
        line = line.rstrip()

        if line == "EOS":
            sentence_func(knp_lines)
            knp_lines = []
        else:
            knp_lines.append(line)

    return

if __name__ == '__main__':
    main()

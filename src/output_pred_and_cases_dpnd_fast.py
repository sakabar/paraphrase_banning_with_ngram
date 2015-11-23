#coding:utf-8
import sys
import re

case_regex = re.compile('<係:([^>]+格)>')
# mod_regex = re.compile('<係:([^>]+)>')
# analysis_case_regex = re.compile('<解析格:([^>]+)>')
# case_result_regex = re.compile('<格解析結果:([^:]+:[^:0-9]+)[0-9]*:([^>]+)>')
norm_form_regex = re.compile('<正規化代表表記:([^>]+)>')
pred_norm_form_regex = re.compile('<用言代表表記:([^>]+)>')

def sentence_func(knp_lines):
    last_basic_phrase = [line for line in knp_lines if line[0] == '+'][-1]
    last_basic_phrase_num = -1
    try:
        last_basic_phrase_num = int(last_basic_phrase.split(' ')[1])
    except:
        raise Exception('Use -print-num option when use KNP')

    #文末の述語の正規化代表表記を出力
    m_norm = norm_form_regex.search(last_basic_phrase)
    if m_norm:
        sys.stdout.write(m_norm.group(1) + " ")
    else:
        sys.stdout.write("NONE ")

    #文末の述語の用言代表表記を出力
    m_pred_norm = pred_norm_form_regex.search(last_basic_phrase)
    if m_pred_norm:
        sys.stdout.write(m_pred_norm.group(1))
    else:
        sys.stdout.write("NONE")

    dpnd_basic_phrases = [line for line in knp_lines if line[0] == '+' and line.split(' ')[2] == str(last_basic_phrase_num) + "D"]

    for dpnd_basic_phrase in dpnd_basic_phrases[::-1]:
        m1 = case_regex.search(dpnd_basic_phrase)
        if m1:
            m2 = norm_form_regex.search(dpnd_basic_phrase)
            if m2:
                case = m1.group(1)
                if case == "未格" and "<ハ>" in dpnd_basic_phrase:
                    sys.stdout.write(" " + m2.group(1) + ":" + "未格_ハ")
                else:
                    sys.stdout.write(" " + m2.group(1) + ":" + case)
    print ""
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

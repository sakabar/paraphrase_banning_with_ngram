#coding:utf-8

import sys


def sentence_func(knp_lines):
    last_bp_ind, last_bp = [(ind, knp_line) for ind, knp_line in enumerate(knp_lines) if knp_line[0] == '+' and "-1D" in knp_line][0]
    
    for i in range(last_bp_ind, len(knp_lines)):
        if "反義" in knp_lines[i]:
            return knp_lines[i]

    return ""

def main():
    knp_lines = []

    for line in sys.stdin:
        line = line.rstrip()

        knp_lines.append(line)

        if line == "EOS":
            ans = sentence_func(knp_lines)
            if ans == "":
                print "NONE"
            else:
                print ans
            knp_lines = []

if __name__ == '__main__':
    main()

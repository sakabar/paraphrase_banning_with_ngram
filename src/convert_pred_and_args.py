#coding:utf-8
import sys
import jctconv
import re

def format_arg_noun(noun):
    ans = ""
    noun_tmp = noun.replace('v', '').replace('a', '') #扱いvの'v'を取る

    if '+' in noun_tmp:
        lst = noun_tmp.split('+')
        return "".join([format_arg_noun(noun_tmp) for noun_tmp in lst])
    else:
        if '?' in noun_tmp:
            lst = noun_tmp.split('?')
            if lst[0].split('/')[0] == lst[1].split('/')[0]: #表記は一意、読みが曖昧
                return lst[0].split('/')[0]
            else:
                return lst[0].split('/')[1]
        else:
            return noun_tmp.split('/')[0]

    raise Exception('Error') #到達しないはず
    # return ans

def format_arg_case(case):
    ans = ""

    #'hoge:同格未格'の場合がある
    #「人間以外の被造物に対してお辞儀などしてはならない。」
    if "未格" in case:
        ans = 'は'
    else:
        case_unicode = case.replace('格', '').decode('utf-8') #'格'の文字は取る
        ans = jctconv.kata2hira(case_unicode).encode('utf-8')

    return ans

def main():
    for line in sys.stdin:
        line = line.rstrip()
        lst = line.split()
        arg = lst[0]
        pred = lst[1]

        if arg[0:4] == "NONE":
            print arg
        else:
            ltmp = arg.split(':')
            noun = ltmp[0]
            case = ltmp[1]
            formatted_noun = format_arg_noun(noun)
            formatted_case = format_arg_case(case)
            # print "%s %s %s" % (formatted_noun, formatted_case, pred)
            print "%s %s" % (formatted_noun, formatted_case)

    return

if __name__ == '__main__':
    main()



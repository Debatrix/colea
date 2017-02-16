#!\usr\bin\env python
# _*_ coding: utf-8 _*_
import os
import sys


def changer(filename):
    data = ''
    with open(filename, 'rb') as file:
        data = file.read()
    if data:
        try:
            data = data.decode('gbk').encode('utf8')
            print '[gbk2utf] ' + filename
        except:
            data = data.decode('utf8').encode('gbk')
            print '[utf2gbk]' + filename
        finally:
            with open(filename, 'wb') as file:
                file.write(data)


def dirwalker(root):
    for (dirpath, dirnames, filenames) in os.walk(root):
        for filename in filenames:
            if cmp('.m', os.path.splitext(filename)[1]) == 0:
                changer(os.path.join(dirpath, filename))


if __name__ == '__main__':
    if len(sys.argv) > 1:
            dirwalker(sys.argv[1])
    else:
        dirwalker(os.getcwd())
    os.system("pause")

import re
from collections import defaultdict
import subprocess


def copy_file(input_file: str = '', tmp_file_name: str = '') -> str:
    try:
        command = 'cp ' + input_file + ' ' + tmp_file_name
        subprocess.run(command, shell=True, check=True)
        return './tmp.mlir'
    except subprocess.CalledProcessError as cpe:
        print('copy mlir file error!')
        return ''


def get_dialects(compiler: str, source_file: str, flag: str = '') -> defaultdict[str, dict]:
    try:
        dialects_res = print_op(compiler, source_file, flag)
        return find_dialects(dialects_res)
    except subprocess.CalledProcessError:
        print("get_dialects: CalledProcessError")
        raise


def find_dialects(src_str: str) -> defaultdict[str, dict]:
    # func.func
    re_dialect = re.compile(r'\b([A-Za-z]\w*)\.([.A-Za-z]+)\b\s*,\s(\d+)')

    # {arith: {addf: 1, constant:8, mulf: 1}, ... , }
    dialect = defaultdict(dict)

    a = re_dialect.finditer(src_str)
    for i in a:
        dialect[i.groups()[0]][i.groups()[1]] = i.groups()[2]
        # print(dialect[i.groups()[0]][i.groups()[1]])

    return dialect


def print_op(compiler: str, file_path: str, flag: str) -> str:
    command = compiler + ' ' + file_path + ' ' + flag + ' ' + '--print-op-stats'
    try:
        ret = subprocess.run(command, shell=True, check=True, capture_output=True)
        # print(ret.stderr.decode('utf-8'))
        return ret.stderr.decode('utf-8')

    except subprocess.CalledProcessError as cpe:
        print("print_op: CalledProcessError")
        raise


if __name__ == "__main__":
    file_path = '../test/a.mlir'
    # dialects = find_dialects(file_path)
    # print(dialects.keys())
    #
    res = get_dialects(file_path)
    print(res)

    # find_dialects("llvm.mlir.constant")

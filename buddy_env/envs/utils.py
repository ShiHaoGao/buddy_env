import re
from collections import defaultdict
from typing import DefaultDict, Dict, Any
import subprocess


def copy_file(input_file: str = '', tmp_file_name: str = '') -> str:
    """

    :param input_file: 要被复制的文件
    :param tmp_file_name: 新的文件名称
    :return: 复制出来的新的文件的路径
    """

    try:
        command = 'cp ' + input_file + ' ' + tmp_file_name
        subprocess.run(command, shell=True, check=True)
        return './' + tmp_file_name
    except subprocess.CalledProcessError as cpe:
        print('copy mlir file error!')
        return ''


def get_features(compiler: str, source_file: str, tmp_file: str, flag: str = '') -> Dict[str, Any]:
    """

    :param tmp_file: 临时文件路径
    :param compiler: 编译器路径
    :param source_file: 要被编译的文件
    :param flag: 编译参数
    :return: info信息，{features: {'dialect_name':{op1 : op1_num, op2: op2_num, ...}, ...}, state: False} \
            features：代码的特征，state：代码的状态（True表示正常，False表示发生异常）

    """

    info = {'features': {}, 'state': True, 'message': ''}
    try:
        apply_pass(compiler, source_file, tmp_file, flag)
        dialects_res = print_op(compiler, tmp_file)
        features = find_dialects(dialects_res)
        info['features'] = features
        return info
    except subprocess.CalledProcessError:
        print("get_dialects: CalledProcessError")
        info['state'] = False
        info['message'] = 'get_dialects: CalledProcessError'
        return info


def find_dialects(src_str: str) -> DefaultDict[str, Dict[str, int]]:
    """

    :param src_str: 将要被处理的字符串
    :return: {arith: {addf: 1, constant:8, mulf: 1}, ... , }
    """

    # func.func
    re_dialect = re.compile(r'\b([A-Za-z]\w*)\.([.A-Za-z_]+)\b\s*,\s(\d+)')

    # {arith: {addf: 1, constant:8, mulf: 1}, ... , }
    features = defaultdict(dict)

    a = re_dialect.finditer(src_str)
    for i in a:
        features[i.groups()[0]][i.groups()[1]] = i.groups()[2]
        # print(dialect[i.groups()[0]][i.groups()[1]])

    return features


def apply_pass(compiler: str, source_file_path: str, tmp_file_path: str, flag: str):
    command = compiler + ' ' + source_file_path + ' ' + flag + ' > ' + tmp_file_path
    try:
        ret = subprocess.run(command, shell=True, check=True, capture_output=True)
    except subprocess.CalledProcessError as cpe:
        print("apply_pass: CalledProcessError")
        raise


def print_op(compiler: str, file_path: str) -> str:
    """

    :param compiler: 编译器路径
    :param file_path: 被编译文件路径
    :param flag: 编译选项
    :return:
    """

    command = compiler + ' ' + file_path + ' --print-op-stats'
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
    res = get_features(file_path)
    print(res)

    # find_dialects("llvm.mlir.constant")

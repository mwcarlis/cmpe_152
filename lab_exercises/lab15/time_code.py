#!/usr/bin/python
import timeit
import os
import subprocess

def no_optimization():
    cmd = "./main.o"
    if not os.path.isfile('main.o'):
        raise Exception('main.o does not exist')
    subprocess.check_output([cmd])

def O1_optimization():
    cmd = "./main_O1.o"
    if not os.path.isfile('main_O1.o'):
        raise Exception('main_O1.o does not exist')
    subprocess.check_output([cmd])

def O2_optimization():
    cmd = "./main_O2.o"
    if not os.path.isfile('main_O2.o'):
        raise Exception('main_O2.o does not exist')
    subprocess.check_output([cmd])

def time_runs(func_setup=''):
    if not func_setup:
        raise Exception('func_setup invalid: {}'.format(func_setup))
    setit = "from __main__ import {}".format(func_setup)
    time = timeit.timeit("{}()".format(func_setup), setup=setit, number=1)
    print "Time {}: {}".format(func_setup, time)

def test_runs():
    time_runs('no_optimization')
    time_runs('O1_optimization')
    time_runs('O2_optimization')

if __name__ == "__main__":
    test_runs()


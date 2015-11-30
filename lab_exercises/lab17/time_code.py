#!/usr/bin/python
import timeit
import os
import subprocess

def binary_timer(program=''):
    if not os.path.isfile(program):
        raise Exception('{} does not exist'.format(program))
    cmd = "./{}".format(program)
    subprocess.check_output([cmd])

def time_runs(program='', func_setup=''):
    if not (program and func_setup):
        raise Exception('func_setup invalid: {}'.format(func_setup))
    setit = "from __main__ import {}".format(func_setup)
    secs = timeit.timeit(
        stmt="{}(program='{}')".format(func_setup, program.strip()),
        setup=setit,
        number=1
    )
    print "Time {}: {time}".format(program, time=secs)

def test_runs():
    time_runs('main.o          ', 'binary_timer')
    time_runs('inline_main.o   ', 'binary_timer')
    time_runs('O3_main.o       ', 'binary_timer')
    time_runs('O3_inline_main.o', 'binary_timer')

if __name__ == "__main__":
    test_runs()


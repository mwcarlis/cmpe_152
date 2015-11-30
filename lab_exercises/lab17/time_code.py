#!/usr/bin/python
import timeit
import os
import subprocess

BINARY_EXT = '.o'

def binary_timer(program=''):
    if not os.path.isfile(program):
        raise Exception('{} does not exist'.format(program))
    subprocess.check_output(["./{}".format(program)])

def time_runs(program='', func_setup=''):
    if not (program and func_setup):
        raise Exception('func_setup invalid: {}'.format(func_setup))
    secs = timeit.timeit(
        stmt="{}(program='{}')".format(func_setup, program.strip()),
        setup="from __main__ import {}".format(func_setup),
        number=1
    )
    print "Time {}: {time}".format(program, time=secs)

def test_runs():
    files = os.listdir(os.getcwd())
    binaries = [runnable for runnable in files if BINARY_EXT in runnable]
    if len(binaries) <= 0:
        msg = "We didn't find any executables to run. <>{}"
        raise Exception(msg.format(BINARY_EXT))
    width_fmat = '{}'.format(len(max(binaries, key=len)))
    row = '{:' + width_fmat + '}'
    for binary in binaries:
        time_runs(
            row.format(binary),
            'binary_timer'
        )


if __name__ == "__main__":
    test_runs()


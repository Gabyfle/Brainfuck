#--
#-  This file is used to benchmark Brainfuck generated programs
#-  @author Gabriel Santamaria
#-  File name: benchmarking.py
#-  Created on: May, 6 2020
#--

import subprocess
from resource import *
import argparse
import sys
import os.path

class benchmark:
    time: 0
    path: str

    def __init__(self, path: str):
        self.path = path

    def bench(self):
        """
        Process benchmarks on the given program
        """

        thread = subprocess.Popen([self.path], stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
        output = thread.communicate()

        resource = getrusage(RUSAGE_CHILDREN)

        cpu = resource.ru_utime + resource.ru_stime
        memory = resource.ru_maxrss  * getpagesize()

        return [
            getrusage(RUSAGE_CHILDREN),
            cpu,
            memory
        ]

parser = argparse.ArgumentParser(prog="Benchmarker", description="A little tool to get CPU time and MEMORY usage of a program")
parser.add_argument("-program", action="store", required=True, help="This is the program we're going to get the bench from")

args = parser.parse_args()

if not args.program:
    print ("Woups, we can't perform our benchmarks since we have no program to take the bench from")
    sys.exit(1)

if not (os.path.isfile(args.program)):
    print("It seems that the provided path (" + args.program + ") isn't a valid file.")
    sys.exit(2)

print("Starting benchmarks")
obj = benchmark(args.program)
benchmarks = obj.bench()
print("Process ended successfully.")
print("Benchmarks of this program:")
print("Time (seconds): " + str(benchmarks[1]))
print("Memory usage (Mb):" + str(benchmarks[2] / (10**6)))

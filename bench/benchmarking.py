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

parser.add_argument("-amount", action="store", required=True, help="Amount of times we should sample memory and CPU usage")

args = parser.parse_args()

if not (args.program and args.amount):
    print ("Woups, we can't perform our benchmarks since we have no program to take the bench from")
    sys.exit(1)

amount = 0
try:
    amount = int(args.amount)
except ValueError as e:
    print("An error occurred while trying to convert '-amount' to an integer")
    print("Error: " + e)
    sys.exit(2)
except:
    print("An uncaught exception happened. Please stop doing weird things with your computer and this program.")
    sys.exit(2)

if not (os.path.isfile(args.program)):
    print("It seems that the provided path (" + args.program + ") isn't a valid file.")
    sys.exit(3)

print("Starting benchmarks")

cpu = []
mem = []

cache = [
    [],  # CPU cache
    []   # memory cache
]

for i in range(0, amount + 1):
    obj = benchmark(args.program)
    benchmarks = obj.bench()
    if len(cpu) != 0:
        cpu.append(benchmarks[1] - (cache[len(cache) - 1]))
        cache.append(benchmarks[1])
    else:
        cpu.append(benchmarks[1])
        cache.append(benchmarks[1])
    mem.append(benchmarks[2])

print("Process ended successfully.")
print("Benchmarks of this program:")
print("Average time (seconds): " + str(sum(cpu) / (len(cpu)) ))
print("Average memory usage (Mb): " + str((sum(mem) / len(mem)) / 10**6))

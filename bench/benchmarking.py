#--
#-  This file is used to benchmark Brainfuck generated programs
#-  @author Gabriel Santamaria
#-  File name: benchmarking.py
#-  Created on: May, 6 2020
#--

import subprocess
import time
from resource import *

class benchmark:
    time: 0

    def __init__(self):
        self.time = time.perf_counter()
    

    def bench(self, path: str):
        """
        Process benchmarks on the given program
        """

        subprocess.Popen([path])

        return [
            self.time - time.perf_counter(),
            getrusage(RUSAGE_CHILDREN)
        ]

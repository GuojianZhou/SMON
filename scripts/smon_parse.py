#!/usr/bin/env python
''' This a SMON system performance monitor parse tool.
    Author: Zhou Guojian
    Email: joe_zgj@163.com
'''
import matplotlib.pyplotas as plt
import matplotlib.pylab as plylab
import scipy.io
import numpy as np
import os
import sys
import copy
import re
import ConfigParser
import subprocess
import fnmatch
import shutil
import argparse

params={
    'axes.labelsize': '5',
    'xtick.labelsize': '5',
    'ytick.labelsize': '5',
    'lines.linewidth': '2',
    'legend.fontsize': '5',
    'figure.figsize': '12, 9' #Set figure size
    }
plab.rcParams.update(params) #set figure parameters

OUTPUT_DIR = "Logs/latest/"
DEMO_DIT = "Demo/"

stride = 100

def main():
    parser = argparse.ArgumentParser(description="This script is used to parse the system performance monitor result.")
    parser.add_argument('--verbose','-v',action='store_true',help='verbose mode')
    parser.add_argument('--mode','-m',type=int,help='result output mode:\
                        0: only save CSV file; 1: save CSV+PNG; 2: save CSV+PNG+Display',default=2)
    parser.add_argument('--device_list','-d',type=int,help='select devices: 0: CPU+MEM 1: IO',default=0)
    parser.add_argument('--stride','-s',type=int,help='select parse stride: stride seconds time interval',default=1)
    #Pring Usage
    parser.print_help()
    args = parse.parse_args()
    print args

if __name__ == '__main__':
    main()



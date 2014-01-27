#! /usr/bin/python

import sys
import subprocess
import select
import re
import fcntl
import os

CYAN  ="\x1b[0;2;36m"
YELLOW="\x1b[1;35m"
RED   ="\x1b[1;31m"
GREEN ="\x1b[1;32m"
BLUE  ="\x1b[1;34m"
NO_COLOUR="\x1b[0m"


def printColored(line):
	m = re.search('([^:]*):([0-9]+)([:0-9]*)(: [a-zA-Z]*error:)(.*)', line)
	if m != None:
		sys.stderr.write(RED+m.group(1)+CYAN+':'+m.group(2)+m.group(3)+YELLOW+m.group(4)+RED+m.group(5)+NO_COLOUR+'\n')
		return

	m = re.search('([^:]*):([0-9]+)([:0-9]*)(: [a-zA-Z]*warning:)(.*)', line)
	if m != None:
		sys.stderr.write(RED+m.group(1)+CYAN+':'+m.group(2)+m.group(3)+GREEN+m.group(4)+NO_COLOUR+m.group(5)+NO_COLOUR+'\n')
		return

	sys.stdout.write(line)

def setnonblock(fd):
	fl = fcntl.fcntl(fd, fcntl.F_GETFL)
	fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)


if len(sys.argv)==1:
	r = [sys.stdin.fileno()]
	while True:
		ready = select.select(r,[],[],1)
		for fd in ready[0]:
			if fd == sys.stdin.fileno():
				lines = sys.stdin.readlines()
				for line in lines:
					printColored(line)
					sys.stdout.flush()
					sys.stderr.flush()
elif sys.stdin.isatty():
	p = subprocess.Popen(sys.argv[1:],
			bufsize=1,
			close_fds=True,
			stdout=subprocess.PIPE,
			stderr=subprocess.PIPE,
			stdin=subprocess.PIPE)
	p.stdin.close()
	r = [p.stdout.fileno(),p.stderr.fileno()]
	ready = select.select(r,[],[])

	for fd in ready[0]:
		if fd == p.stdout.fileno():
			for line in p.stdout:
				printColored(line)
		if fd == p.stderr.fileno():
			for line in p.stderr:
				printColored(line)

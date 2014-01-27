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


def printColored(lines):
	if not lines:
		return False
	for line in lines:
		m = re.search('([^:]*):([0-9]+)([:0-9]*)(: [a-zA-Z]*error:)(.*)', line)
		if m != None:
			sys.stderr.write(RED+m.group(1)+CYAN+':'+m.group(2)+m.group(3)+YELLOW+m.group(4)+RED+m.group(5)+NO_COLOUR+'\n')
			continue

		m = re.search('([^:]*):([0-9]+)([:0-9]*)(: [a-zA-Z]*warning:)(.*)', line)
		if m != None:
			sys.stderr.write(RED+m.group(1)+CYAN+':'+m.group(2)+m.group(3)+GREEN+m.group(4)+NO_COLOUR+m.group(5)+NO_COLOUR+'\n')
			continue

		sys.stdout.write(line)
	return True

def setnonblock(fd):
	fl = fcntl.fcntl(fd, fcntl.F_GETFL)
	fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)


if len(sys.argv)==1:
	while True:
		r = [sys.stdin.fileno()]
		ready = select.select(r,[],[])
		for fd in ready[0]:
			if fd == sys.stdin.fileno():
				lines = sys.stdin.readlines()
				if not printColored(lines): sys.exit(0)
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
			lines = p.stdout.readlines()
			printColored(lines)
		if fd == p.stderr.fileno():
			lines = p.stderr.readlines()
			printColored(lines)

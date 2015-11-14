import os
import re
import subprocess

class MacroExpand(gdb.Command):
    """Usage example:
        start           # breakpoint 1
        set confirm off
        source ~/.local/mexp.py
        mexp glINVOKE(p1, p2 ...)
    """
    def __init__(self):
        gdb.Command.__init__(self, "mexp", gdb.COMMAND_FILES, gdb.COMPLETE_FILENAME, True)

    def invoke(self, arg, from_tty):
        arg_list = gdb.string_to_argv(arg)
        if len(arg_list) == 0:
            print ("usage: mexp macro-expression")
            return
        m = re.match("([0-9_a-zA-Z]+)\(",arg)
        if not m:
            print ("wrong expression")
            return
        macro_name = m.group(1)
        gdb.execute("info macro %s" % (macro_name))
        expanded_macro= gdb.execute("macro expand %s" % (arg), False,True)
        p = subprocess.Popen("clang-format-3.8", shell=False,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                stdin=subprocess.PIPE)
        formated= p.communicate(input=expanded_macro.encode())[0]
        print(formated.decode())
MacroExpand()

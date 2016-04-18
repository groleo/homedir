import gdb
from gdb.FrameDecorator import FrameDecorator

from paramiko import SSHClient
from scp import SCPClient

#file_server = 'amnegrea-desk.rb.intel.com'
file_server = 'localhost'

def get_file(fname):
    ssh = SSHClient()
    ssh.load_system_host_keys()
    ssh.connect(file_server)
    scp = SCPClient(ssh.get_transport())
    scp.get(fname)
    scp.close()



class XInlinedFrameDecorator(FrameDecorator):
    def __init__(self, fobj):
        super(XInlinedFrameDecorator, self).__init__(fobj)
        self.fobj = fobj

    def filename(self):
        fname = self.fobj.filename()
        get_file(fname)
        return fname


class InlineFilter():
    def __init__(self):
        # Frame filter attribute creation.
        #
        # 'name' is the name of the filter that GDB will display.
        #
        # 'priority' is the priority of the filter relative to other
        # filters.
        #
        # 'enabled' is a boolean that indicates whether this filter is
        # enabled and should be executed.
        self.name = "InlinedFrameFilter"
        self.priority = 100
        self.enabled = True
        # Register this frame filter with the global frame_filters
        # dictionary.
        gdb.frame_filters[self.name] = self

    def filter(self, frame_iter):
        frame_iter = map(XInlinedFrameDecorator,
                frame_iter)
        return frame_iter
InlineFilter()

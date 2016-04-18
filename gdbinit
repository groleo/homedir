set  disassembly-flavor att
define hook-quit
    set confirm off
end
source ~/.local/gdb/mexp.py
source ~/.local/gdb/source-server-frame-filter.py

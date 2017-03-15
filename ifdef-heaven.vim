" ifdef-heaven.vim: A lifesaver that will save you from ifdef hell
" =============================================================================
" File:        ifdef-heaven.vim
" Description: Shows where you are in #if***(preprocessor directives) blocks
" Author:      Hanjoung Lee <waterets@gmail.com>
" Requirement: +python support of Vim
" URL:         https://github.com/wateret/ifdef-heaven.vim
" How To Install:
" Copy this file to your plugin directory and map IfdefHeaven_WhereAmI
" e.g.)
" $ cp ifdef-heaven.vim ~/.vim/plugin
" Then append below to .vimrc
" map f :call IfdefHeaven_WhereAmI() <CR>
" =============================================================================

function! IfdefHeaven_WhereAmI()
    if !has('python')
        finish
    endif

python << EOF

PLUGIN_NAME = "ifdef-heaven"
INDENT = 2

def end_with_error(msg):
    print PLUGIN_NAME + ": " + msg
    sys.exit(1)

def is_opener(tup):
    # Return false only for '#elif'
    return tup[1] in ["#if", "#ifdef", "#ifndef"]

def print_indent(s, i):
    print (" " * (i * INDENT)) + s

class IfStack:
    def __init__(self, sl, cl):
        self.stack = []
        self.source_lines = sl
        self.cursor_line = cl

    def push(self, o):
        self.stack.append(o)

    def pop(self):
        while True:
            top = self.stack.pop()
            if is_opener(top):
                break

    def print_stack(self):
        if not self.stack:
            print "<< There is no '#if***' wrapping around :D >>"
            return

        lineno_width = len(str(source_lines))
        lineno_format = "%" + str(lineno_width) + "d"

        i = -1
        for e in self.stack:
            i += 1 if is_opener(e) else 0
            no, typ, cond = e
            print lineno_format % no,
            print_indent("%s %s" % (typ, cond), i)
        print lineno_format % self.cursor_line,
        print_indent("<< YOU ARE HERE! >>", i+1)

try:
    import re
    import vim
    import string

    cursor_line = vim.current.window.cursor[0]
    buf = list(vim.current.buffer)
    source = buf[:cursor_line]
    source_lines = len(buf)
    if_stack = IfStack(source_lines, cursor_line)

    for no, line in enumerate(source, start=1):
        line = line.strip()

        matches_if = re.search("^(#if|#ifdef|#ifndef|#elif)\s(.+$)", line)
        if matches_if:
            typ, cond = matches_if.groups()
            if_stack.push((no, typ, cond))

        if re.search("^#else", line):
            if_stack.push((no, "#else", ""))

        if re.search("^#endif", line):
            if_stack.pop()

    if_stack.print_stack()

except ImportError, e:
    end_with_error("Some packages not installed")

except IndexError, e:
    end_with_error("'#if***' - '#endif' mismatches found")

EOF

endfunction

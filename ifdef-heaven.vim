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
    return tup[0] in ["#if", "#ifdef", "#ifndef"]

def print_indent(s, i):
    print (" " * (i * INDENT)) + s

class IfStack:
    def __init__(self):
        self.stack = []

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

        lineno_width = len(str(self.stack[-1][0]))
        print_format = "%" + str(lineno_width) + "d: %s %s"

        i = -1
        for e in self.stack:
            i += 1 if is_opener(e) else 0
            print_indent(print_format % (e[0], e[1], e[2]), i)
        print_indent("<< YOU ARE HERE! >>", i+1)

try:
    import re
    import vim
    import string

    if_stack = IfStack()
    cursor_line = vim.current.window.cursor[0]
    source = list(vim.current.buffer)[:cursor_line]

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

" ifdef-heaven.vim: A lifesaver that will save you from ifdef hell
" =============================================================================
" File:        ifdef-heaven.vim
" Description: Shows where you are in #if***(preprocessor directives) blocks
" Author:      Hanjoung Lee <waterets@gmail.com>
" Requirement: '+python' or '+python3' support from Vim
" URL:         https://github.com/wateret/ifdef-heaven.vim
" How To Install:
" Copy this file to your plugin directory and
" map function `IfdefHeaven_WhereAmI` to your preferred key
" e.g.)
" $ cp ifdef-heaven.vim ifdef-heaven.py ~/.vim/plugin
" Then append below to .vimrc
" map f :call IfdefHeaven_WhereAmI() <CR>
" =============================================================================

let g:ifdef_heaven_py_path = expand('<sfile>:p:h') . '/ifdef-heaven.py'

function! IfdefHeaven_WhereAmI()
    if has('python')
        let pyfile = 'pyfile'
    elseif has('python3')
        let pyfile = 'py3file'
    else
        finish
    endif

    let script_py = g:ifdef_heaven_py_path
    execute pyfile script_py
endfunction


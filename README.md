# ifdef-heaven.vim

A Vim plugin that shows where you are in `#if{def|ndef}`(preprocessor directives) blocks.

![](screenshot1.png)

Press the mapped key! (I use `f` for this)

![](screenshot2.png)

:D

## Requirement

Your vim must support `+python` or `+python3`. You may check that by `vim --version`.

## How to Install

Copy `ifdef-heaven.vim` and `ifdef-heaven.py` to plugin directory.

```
$ cp ifdef-heaven.vim ifdef-heaven.py ~/.vim/plugin
```

Append below to `.vimrc` (binding `f` key for this plugin)

```
map f :call IfdefHeaven_WhereAmI() <CR>
```

## How to Use

Press mapped key(`f` for above example).
It will show you the `#if***` context of current cursor position.


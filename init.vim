"                                           _
"       ___ _ __   __ _  ___ ___     __   _(_)_ __ ___
"      / __| -_ \ / _- |/ __/ _ \____\ \ / / | -_ - _ \
"      \__ \ |_) | (_| | (_|  __/_____\ V /| | | | | | |
"      |___/ .__/ \__._|\___\___|      \_/ |_|_| |_| |_|
"          |_|
"
"   Copyright (c) 2016 Liu-Cheng Xu & Contributors
"
"   You can customize space-vim with .spacevim
"   and don't have to take care of this file.
"
"   Author: Liu-Cheng Xu <xuliuchengxlc@gmail.com>
"   URL: https://github.com/liuchengxu/space-vim
"   License: MIT

scriptencoding utf-8

" Identify platform {
let g:MAC = has('macunix')
let g:LINUX = has('unix') && !has('macunix') && !has('win32unix')
let g:WINDOWS = has('win32') || has('win64')
" }

" Windows Compatible {
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if g:WINDOWS
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif
" }

let g:spacevim_dir = $VIM.'/cVim'
let g:spacevim_core_dir = '/core'
let g:spacevim_version = '0.5.0'

set runtimepath+=$VIM/cVim/core

call core_config#begin()

Layer 'spacevim'

call core_config#end()
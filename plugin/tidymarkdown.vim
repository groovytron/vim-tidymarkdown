"=========================================================
" File:        tidymarkdown.vim
" Author:      Julien M'Poy <julien.mpoy[at]googlemail.com>
" Last Change: Sat Sep 16 23:27:00 BST 2017
" Version:     0.0.1
" WebPage:     https://github.com/groovytron/vim-tidymarkdown
" License:     MIT Licence
"==========================================================
" see also README.rst

" Only do this when not done yet for this buffer
if exists('g:loaded_tidymarkdown')
    finish
endif

let g:loaded_tidymarkdown = 1

if !exists("TidyMd(...)")
    function TidyMd(...)

        let l:args = get(a:, 1, '')

        if exists("g:tidymd_cmd")
            let tidymd_cmd=g:tidymd_cmd
        else
            let tidymd_cmd="tidy-markdown"
        endif

        if !executable(tidymd_cmd)
            echoerr tidymd_cmd . " executable not found. Please install it first."
            return
        endif

        let execmdline=tidymd_cmd . " " . l:args
        let current_line = line('.')
        " save current cursor position
        let current_cursor = getpos(".")
        silent execute "0,$!" . execmdline
        " restore cursor
        call setpos('.', current_cursor)
        if v:shell_error != 0
            " Shell command failed, so open a new buffer with error text
            execute 'normal! gg"ayG'
            silent undo
            execute 'normal! ' . current_line . 'G'
            " restore cursor position
            call setpos('.', current_cursor)
            silent new
            silent put a
        end
    endfunction

    command! -nargs=? -bar TidyMd call TidyMd(<f-args>)
endif

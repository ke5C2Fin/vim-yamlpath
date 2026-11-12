" TODO > >- | |- logic
"
function! s:CheckLine(line)
        return a:line =~# '^ *\(#.*\)\?$' " comments and blank lines
endfunction

function! s:IsSequence(line)
        return a:line =~# '^ *- '
endfunction

function! s:GetIndent(lnum, is_seq)
        let l:indent = indent(a:lnum)
        if a:is_seq
                let l:indent += 2
        endif
        return l:indent
endfunction

function! s:GetYamlKey(line)
        let l:key = matchstr(a:line, '^ *-\? *\zs\S\{-}\ze:') " non-greedy
        if l:key =~# '\.'
                let l:key = '"' . l:key . '"'
        endif
        return l:key
endfunction

function! s:GetYamlPath(line)
        let l:line = getline(a:line)
        if s:CheckLine(l:line)
                return ''
        endif
        let l:is_seq = s:IsSequence(l:line)
        let l:curr_indent = s:GetIndent(a:line, l:is_seq)
        let l:trig_indent = l:curr_indent
        let l:yaml_path = s:GetYamlKey(l:line)

        let l:lnum = a:line
        while l:curr_indent > 0
                let l:lnum -= 1
                if l:lnum <= 0
                        break
                endif
                let l:line = getline(l:lnum)
                if s:CheckLine(l:line)
                        continue
                endif
                let l:is_seq = s:IsSequence(l:line)
                let l:curr_indent = s:GetIndent(l:lnum, l:is_seq)
                if l:curr_indent >= l:trig_indent
                        continue
                endif
                let l:trig_indent = l:curr_indent
                let l:seq_indicator = l:is_seq ? '[]' : ''
                let l:yaml_path = s:GetYamlKey(l:line) . l:seq_indicator . '.' . l:yaml_path
        endwhile
        return l:yaml_path
endfunction

augroup YamlPath
        autocmd! * <buffer>
        autocmd CursorMoved <buffer> redraw | echo(s:GetYamlPath(line('.')))
augroup END

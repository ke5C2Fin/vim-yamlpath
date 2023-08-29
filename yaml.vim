function! GetYamlPath(line)
	let lnum = a:line
	let islist = 0
	let curr_line = getline(lnum)
	if curr_line =~# '^\s*#'
		return ''
	endif
	let curr_indent = indent(lnum)
	if curr_line =~# '^\s*-\s'
		let islist = 1
		let curr_line = substitute(curr_line, '-', ' ', '')
		let curr_indent += 2
	endif
	let trig_indent = curr_indent
	let key = matchstr(curr_line, '^\s*\zs[^:]\+\ze:')
	let yaml_path = key

	while curr_indent > 0
		let lnum -= 1
		let list_indicator = ''
		if islist
			let list_indicator = '[]'
		endif
		let islist = 0
		let curr_line = getline(lnum)
		let curr_indent = indent(lnum)
		if curr_line =~# '^\s*-\s'
			let islist = 1
			let curr_line = substitute(curr_line, '-', ' ', '')
			let curr_indent += 2
		endif
		if curr_indent >= trig_indent
			continue
		endif
		let trig_indent = curr_indent
		let key = matchstr(curr_line, '^\s*\zs[^:]\+\ze:')
		let yaml_path = key .. list_indicator .. '.' .. yaml_path
	endwhile

	return yaml_path
endfunction

augroup YamlPath
	au!
	if &filetype =~# 'yaml'
		autocmd CursorMoved <buffer> redraw | echo GetYamlPath(line('.'))
	endif
aug END

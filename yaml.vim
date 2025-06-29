function! GetYamlPath(line)
	let lnum = a:line

	let curr_line = getline(lnum)
	if curr_line =~# '^ *\(#.*\)\?$' " comments and blank lines
		return ''
	endif

	let islist = 0
	let curr_indent = indent(lnum)
	if curr_line =~# '^ *- '
		let islist = 1
		let curr_indent += 2
	endif
	let trig_indent = curr_indent

	let yaml_key = matchstr(curr_line, '^ *-\? *\zs\S\{-}\ze:') " non-greedy
	if yaml_key =~# '\.'
		let yaml_key = '"' .. yaml_key .. '"'
	endif
	let yaml_path = yaml_key

	while curr_indent > 0
		let lnum -= 1
		if lnum == 0
			return ''
		endif

		let curr_line = getline(lnum)
		if curr_line =~# '^ *\(#.*\)\?$' " comments and blank lines
			continue
		endif

		let list_indicator = ''
		if islist
			let list_indicator = '[]'
		endif
		let islist = 0

		let curr_indent = indent(lnum)
		if curr_line =~# '^ *- '
			let islist = 1
			let curr_indent += 2
		endif
		if curr_indent >= trig_indent
			continue
		endif
		let trig_indent = curr_indent

		let yaml_key = matchstr(curr_line, '^ *-\? *\zs\S\{-}\ze:') " non-greedy
		if yaml_key =~# '\.'
			let yaml_key = '"' .. yaml_key .. '"'
		endif
		let yaml_path = yaml_key .. list_indicator .. '.' .. yaml_path
	endwhile

	return yaml_path
endfunction

augroup YamlPath
	au!
	if &filetype =~# 'yaml'
		autocmd CursorMoved <buffer> redraw | echo GetYamlPath(line('.'))
	endif
aug END

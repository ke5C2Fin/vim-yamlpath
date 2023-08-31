function! GetYamlPath(line)
	let lnum = a:line
	let curr_indent = indent(lnum)
	let trig_indent = curr_indent
	let yaml_path = ''
	let separator = ''
	let islist = 0

	if getline(a:line) =~# '^\s*#'
		return ''
	endif

	while curr_indent != 0 || islist || lnum == a:line
		let list_indicator = ''
		if islist
			let list_indicator = '[]'
		endif
		let islist = 0

		let curr_line = getline(lnum)
		let curr_indent = indent(lnum)
		let lnum -= 1

		if curr_line =~# '^\s*-\s'
			let islist = 1
			let curr_indent += 2 " assumes only '\s*- foo' and not '\s*- \+foo'
		endif
		if curr_indent >= trig_indent && lnum + 1 != a:line
			continue
		endif
		let trig_indent = curr_indent

		let yaml_key = matchstr(curr_line, '^\s*-\?\s*\zs\S\{-}\ze:')
		if yaml_key =~# '\.'
			let yaml_key = '"' .. yaml_key .. '"'
		endif
		let yaml_path = yaml_key .. list_indicator .. separator .. yaml_path
		let separator = '.'
	endwhile

	return yaml_path
endfunction

augroup YamlPath
	au!
	if &filetype =~# 'yaml'
		autocmd CursorMoved <buffer> redraw | echo GetYamlPath(line('.'))
	endif
aug END

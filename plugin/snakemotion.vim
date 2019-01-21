" snakemotion.vim
"
" Origin:		2014/05
" Last Change:	2019/01/21
" Version:		1.0
" Author:		Rick Howe <rdcxy754@ybb.ne.jp>
" Copyright:	(c) 2014-2019 by Rick Howe

if exists('g:loaded_snakemotion')
	finish
endif
let g:loaded_snakemotion = 1.0

let s:save_cpo = &cpoptions
set cpo&vim

command! SnakeMotion call snakemotion#SnakeMotion()

if !exists('g:SnakeHead')
	let g:SnakeHead = ['@', 'DiffText']		" head symbol and highlight
endif
if !exists('g:SnakeTail')
	let g:SnakeTail = ['#', 'StatusLine']	" tail symbol and highlight
endif
if !exists('g:SnakeBody')
	let g:SnakeBody = ['*', 'Search']		" body symbol and highlight
endif
if !exists('g:SnakeBlink')
	let g:SnakeBlink = ['.', 'LineNr']		" blank symbol and highlight
endif
if !exists('g:SnakeLength')
	let g:SnakeLength = 20					" head to tail length
endif
if !exists('g:SnakeSpeed')
	let g:SnakeSpeed = 50					" moving speed in ms
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: ts=4 sw=4

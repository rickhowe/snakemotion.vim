" snakemotion.vim
"
" Original:		2014/05
" Last Change:	2019/01/21
" Version:		1.0
" Author:		Rick Howe <rdcxy754@ybb.ne.jp>
" Copyright:	(c) 2014-2019 by Rick Howe

let s:save_cpo = &cpoptions
set cpo&vim

function! snakemotion#SnakeMotion()
	let head = g:SnakeHead
	let tail = g:SnakeTail
	let body = g:SnakeBody
	let blnk = g:SnakeBlink
	let lgth = g:SnakeLength
	let sped = g:SnakeSpeed
	let &cursorbind = 0
	let &cursorcolumn = 0
	let &cursorline = 0
	let &number = 0
	let &wrap = 0
	let &showmatch = 0
	let &hlsearch = 0
	let &buftype = "nowrite"
	let &swapfile = 0
	let &bufhidden = "wipe"
	call matchadd("Error", ".")
	call matchadd(head[1], '\V' . head[0])
	call matchadd(tail[1], '\V' . tail[0])
	call matchadd(body[1], '\V' . body[0])
	call matchadd(blnk[1], '\V' . blnk[0])
	highlight Cursor NONE
	let [lmin, cmin] = [1, 1]
	while 1
		echo "Now let's go!"
		let [lmax, cmax] = [winheight(0), winwidth(0)]
		let lnum = lmin
		while lnum <= lmax
			call setline(lnum, repeat(blnk[0], cmax))
			let lnum += 1
		endwhile
		let [lcent, ccent] = [(lmin + lmax) / 2, (cmin + cmax) / 2]
		let hist = repeat([[0, 0]], lgth)
		let hist[0] = [lcent, ccent]
		while 1
			let rcnt = [0, 0, 0, 0, 0, 0, 0, 0]
			let [l, c] = hist[0]
			while 1
				let rand = reltimestr(reltime())[-2 :] % 8
				let rcnt[rand] += 1
				if rcnt[rand] == 1
					" [Up or Down, Left or Right]
					let next = [(rand == 0 || rand == 1 || rand == 7) ?
										\((l == lmin) ? lmax : l - 1) :
								\(rand == 3 || rand == 4 || rand == 5) ?
										\((l == lmax) ? lmin : l + 1) : l,
								\(rand == 5 || rand == 6 || rand == 7) ?
										\((c == cmin) ? cmax : c - 1) :
								\(rand == 1 || rand == 2 || rand == 3) ?
										\((c == cmax) ? cmin : c + 1) : c]
				else
					let m = 1
					for r in rcnt | let m = m * r | endfor
					if m != 0
						" no option to the next, use initials
						echo "Stuck! Changing my head..."
						let [fs, ls] = [0x21, 0x7e]
						let hs = ''
						while hs != head[0]
							let hs = nr2char(reltimestr(reltime())[-2 :] % (fs - ls + 1) + fs)
							exec "normal r" . hs
							redraw
							exec "sleep " . sped . "m"
						endwhile
						exec "normal r" . blnk[0]
						echo "Got it! Let's go again!"
						let next = [lcent, ccent]
						break
					endif
					continue
				endif
				let hnum = 0
				while hnum < lgth && hist[hnum] != next
					let hnum += 1
				endwhile
				if hnum >= lgth | break | endif
			endwhile
			if hist[-1] != [0, 0]
				call cursor(hist[-1])
				exec "normal r" . blnk[0]
			endif
			if hist[-2] != [0, 0]
				call cursor(hist[-2])
				exec "normal r" . tail[0]
			endif
			call cursor(next)
			exec "normal r" . head[0]
			redraw
			exec "normal r" . body[0]
			if [lmax, cmax] != [winheight(0), winwidth(0)] | break | endif
			exec "sleep " . sped . "m"
			call remove(hist, lgth - 1)
			call insert(hist, next)
		endwhile
	endwhile
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: ts=4 sw=4


if !exists('g:zombies_vs_unicorns_delete_backup_vimrc')
  let g:zombies_vs_unicorns_delete_backup_vimrc = 0
endif

let s:tmpvimrc_variations = [$MYVIMRC . '.backup', $MYVIMRC . '.orig']
let s:tmpvimrc = ''

function! StampVimrc(slices, enabled)
  call writefile(a:slices[a:enabled[0] : a:enabled[1]], $MYVIMRC, 'b')
  silent! exe '!vim -c ' . shellescape('command! Unicorns q', 1) . ' -c ' . shellescape('command! Zombies cq', 1)
endfunction

function! BSFL(slices)
  let enabled = [0, (len(a:slices) / 2)]
  let disabled = [(len(a:slices) / 2) + 1, len(a:slices) - 1]
  call StampVimrc(a:slices, enabled)

  " TODO: might need a better loop termination condition
  while enabled[0] != enabled[1]
    " halve the enabled range depending on v:shell_error.
    " v:shell_error == 1 when exited with :cq (:Zombies), meaning the user
    " considers this session to possess the problem in question.
    if v:shell_error == 0
      let range = disabled
      " no fault found, so we need to keep looking in the previously disabled
      " half
    else
      let range = enabled
      " the currently enabled half has the fault, so we need to keep looking
      " within it
    endif
    let half = range[0] + (range[1] - range[0]) / 2
    let enabled = [range[0], half]
    let disabled = [half + 1, range[1]]
    call StampVimrc(a:slices, enabled)
  endwhile
  if v:shell_error == 0
    return disabled[0]
  else
    return enabled[0]
  endif
endfunction

function! SliceVimrc()
  let slices = [
        \ "set sts=4"
        \, "set tw=80"
        \, "set sw=2"
        \, "set laststatus=2"
        \, "set ts=2"
        \, "set et"
        \]
  return slices
endfunction

function! ReportFault(slice)
  echom "fault found with:" . a:slice
endfunction

function! BackupVimrc()
  let s:tmpvimrc = ''
  for tmpname in s:tmpvimrc_variations
    if filereadable(tmpname)
      continue
    else
      let s:tmpvimrc = tmpname
    endif
  endfor
  echo s:tmpvimrc
  if s:tmpvimrc == ''
    echoerr "Unable to backup vimrc - candidate names already exist."
    return 0
  else
    call writefile(readfile($MYVIMRC, 'b'), s:tmpvimrc, 'b')
    return 1
  endif
endfunction

function! RestoreVimrc()
  if s:tmpvimrc == '' || !filereadable(s:tmpvimrc)
    echoerr "Attempt to restore " . $MYVIMRC . " from non-existant backup!"
  else
    call writefile(readfile(s:tmpvimrc, 'b'), $MYVIMRC, 'b')
    if g:zombies_vs_unicorns_delete_backup_vimrc
      echom "Warning: Deleted backed up vimrc file, '" . s:tmpvimrc . "'"
      call delete(s:tmpvimrc)
    endif
  endif
endfunction

function! ZombiesVsUnicorns()
  if BackupVimrc()
    let slices = SliceVimrc()
    let faulty_slice = BSFL(slices)
    redraw!
    call RestoreVimrc()
    call ReportFault(slices[faulty_slice])
  endif
endfunction

command! ZombiesVsUnicorns call ZombiesVsUnicorns()

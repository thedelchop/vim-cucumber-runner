let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:cucumber_runner")
  let g:cucumber_runner = "os_x_terminal"
endif

if !exists("g:cucumber_command")
  let s:cmd = "cucumber {feature}"

  if has("gui_running") && has("gui_macvim")
    let g:cucumber_command = "silent !" . s:plugin_path . "/bin/" . g:cucumber_runner . " '" . s:cmd . "'"
  elseif has("win32") && fnamemodify(&shell, ':t') ==? "cmd.exe"
    let g:cucumber_command = "!cls && echo " . s:cmd . " && " . s:cmd
  else
    let g:cucumber_command = "!clear && echo " . s:cmd . " && " . s:cmd
  endif
endif

function! RunAllFeatures()
  let l:feature = "feature"
  call SetLastFeatureCommand(l:feature)
  call RunFeatures(l:feature)
endfunction

function! RunCurrentFeatureFile()
  if InFeatureFile()
    let l:feature = @%
    call SetLastFeatureCommand(l:feature)
    call RunFeatures(l:feature)
  else
    call RunLastFeature()
  endif
endfunction

function! RunNearestFeature()
  if InFeatureFile()
    let l:feature = @% . ":" . line(".")
    call SetLastFeatureCommand(l:feature)
    call RunFeatures(l:feature)
  else
    call RunLastFeature()
  endif
endfunction

function! RunLastFeature()
  if exists("s:last_feature_command")
    call RunFeatures(s:last_feature_command)
  endif
endfunction

function! InFeatureFile()
  return match(expand("%"), "_feature.rb$") != -1
endfunction

function! SetLastFeatureCommand(feature)
  let s:last_feature_command = a:feature
endfunction

function! RunFeatures(feature)
  execute substitute(g:cucumber_command, "{feature}", a:feature, "g")
endfunction

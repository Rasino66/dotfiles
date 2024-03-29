# Ctrl+r to historl peco
function peco_select_history_order
  if test (count $argv) = 0
    set peco_flags --layout=top-down
  else
    set peco_flags --layout=bottom-up --query "$argv"
  end

  history|peco $peco_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end

function fish_user_key_bindings
  bind \cr 'peco_select_history_order' # Ctrl + R
end

# GoLang
set PATH ~/bin $PATH
set -x  GOPATH ~/ $GOPATH


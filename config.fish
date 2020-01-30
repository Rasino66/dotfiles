# 生成物をおいておくところとpath
set PATH ~/bin $PATH
# alias 設定
alias doki='docker_ps_killer.sh'
alias dops='docker ps'
alias go='go.exe'
# fishにlogin時のwelcomメッセージを削除
set fish_greeting

## windows用力技設定共
# fishにてコマンド実行時tmuxのreload 
#function tmux_refresh --on-event fish_postexec
#  tmux refresh-client
#end

# 業務用
alias navi='navi.sh'
# windows糞設定(alias編
alias docker-compose='docker-compose.exe'
# windowsのXlancherに接続する設定
set -x DISPLAY localhost:0


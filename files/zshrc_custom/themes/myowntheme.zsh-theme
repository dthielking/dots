PROMPT='[%(!.%F{red}%n%f@%F{yellow}%m%f.%F{green}%n%f@%F{yellow}%m%f):%F{cyan}%~%f]$(git_prompt_info)%(?..(%F{red}%?%f%))%# '
RPS1='%(t.[Ding!].%(30t.[Dong!].[%T]))'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[magenta]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

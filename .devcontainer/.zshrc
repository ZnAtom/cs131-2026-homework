autoload -U colors && colors

precmd() {
   drawline=""
   for ((i = 0; i < COLUMNS; i++)); do
      drawline=" $drawline"
   done
   drawline="%U${drawline}%u"
   PS1="%F{252}${drawline}
%B%F{124}%n:%~>%b%f "
}

eval "$(opam env)"

alias ls="ls --color"

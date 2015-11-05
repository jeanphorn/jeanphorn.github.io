syntax on
set number
:set tabstop=4 
:set softtabstop=4 
:set shiftwidth=4
if &term=="xterm" 
    set t_Co=8 
    set t_Sb=^[[4%dm 
    set t_Sf=^[[3%dm 
endif

set mouse=a

# Set a Ctrl-b shortcut for reloading your tmux config
bind r source-file ~/.tmux.conf



# Rename your terminals 
set -g set-titles on 
set -g set-titles-string '#(whoami)::#h::#(curl ipecho.net/plain;echo)'


# Status bar customization 
set -g status-utf8 on 
set -g status-bg black 
set -g status-fg white 
set -g status-interval 5 
set -g status-left-length 90 
set -g status-right-length 60 
set -g status-left "#[fg=Green]#(whoami)#[fg=white]::#[fg=blue] \


(hostname - s)#[fg=white]::##[fg=yellow]#(curl ipecho.net/plain;echo)"


set -g status-justify left 
set -g status-right '#[fg=Cyan]#S #[fg=white]%a %d %b %R' 

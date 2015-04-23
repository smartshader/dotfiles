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

set -g default-terminal "screen-256color"
#set -g default-terminal "xterm"
set -g history-limit 10000

bind | split-window -h
bind - split-window -v




set -g status-justify left 
set -g status-right '#[fg=Cyan]#S #[fg=white]%a %d %b %R' 

# tmux vim plugin
is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?)(diff)?$"'
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
bind -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"


# bind tmux change pane keys
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R
bind-key h select-pane -L

bind-key L resize-pane -L 5
bind-key H resize-pane -R 5
bind-key J resize-pane -D 5
bind-key K resize-pane -U 5

# ============================================
# Tmux Smart Session Manager
# ============================================

# Main tmux session manager with fzf
tm() {
    # If already inside tmux, use switch-client instead of attach
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    
    # If session name provided, attach/create that specific session
    if [ $1 ]; then
        tmux $change -t "$1" 2>/dev/null || \
            (tmux new-session -d -s "$1" && tmux $change -t "$1")
        return
    fi
    
    # Interactive session picker with fzf
    if command -v fzf &> /dev/null; then
        session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
            fzf --height=40% --reverse --border --prompt="Select session: " \
                --preview="tmux list-windows -t {} -F '#{window_index}: #{window_name}'" \
                --exit-0) && \
            tmux $change -t "$session" || echo "No sessions found."
    else
        # Fallback if fzf not available
        echo "Available sessions:"
        tmux list-sessions 2>/dev/null || echo "No sessions found."
    fi
}

# Quick project-based session (based on current directory)
tms() {
    session_name=$(basename "$PWD" | tr '.' '_' | tr ' ' '_')
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        tmux new-session -s "$session_name" -c "$PWD" -d
    fi
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

# Kill session with fzf picker
tmk() {
    if [ $1 ]; then
        tmux kill-session -t "$1"
        return
    fi
    
    if command -v fzf &> /dev/null; then
        session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
            fzf --height=40% --reverse --border --prompt="Kill session: " --exit-0)
        [ -n "$session" ] && tmux kill-session -t "$session" && echo "Killed session: $session"
    else
        echo "Please specify session name: tmk <session-name>"
    fi
}

# Useful aliases
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias tn='tmux new -s'


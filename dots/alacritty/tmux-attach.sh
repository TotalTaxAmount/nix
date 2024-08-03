SESSION=$(tmux list-sessions 2>/dev/null | grep -v "(attached)" | head -n 1 | cut -d: -f1)

if [ -z "$SESSION" ]; then
    # If no detached session exists, create a new one
    tmux new-session
else
    # If a detached session exists, attach to it
    tmux attach-session -t "$SESSION"
fi
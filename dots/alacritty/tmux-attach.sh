SESSION=$(tmux list-sessions 2>/dev/null | grep -v "(attached)" | head -n 1 | cut -d: -f1)

if [ -z "$SESSION" ]; then
    tmux new-session
else
    tmux attach-session -t "$SESSION"
fi
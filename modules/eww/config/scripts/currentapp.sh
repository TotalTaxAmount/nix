#!/usr/bin/env bash

print_titles() {
  # Pass the clients JSON as a variable ($clients) into jq.
  # We find the highest monitor ID to determine the array size,
  # fill it with empty strings, and place the titles at their respective monitor IDs.
  hyprctl monitors -j | jq -c --argjson clients "$(hyprctl clients -j)" '
    # Find the highest monitor ID to size the array
    (map(.id) | if length > 0 then max else -1 end) as $max_id |

    if $max_id == -1 then
      []
    else
      # Initialize an array of empty strings: ["", "", "", ...]
      reduce .[] as $mon (
        [range(0; $max_id + 1) | ""];

        # Find the top window for this monitor"s active workspace using focusHistoryID
        (
          $clients
          | map(select(.workspace.id == $mon.activeWorkspace.id))
          | sort_by(.focusHistoryID)
          | first
          | .title
        ) as $title |

        # Insert the title at the index matching the monitor ID
        .[$mon.id] = ($title // "")
      )
    end
  '
}

# Print initial window titles on startup
print_titles

# Continuously stream window updates using the socket
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  case "$line" in
    activewindow*|focusedmon*|closewindow*|openwindow*)
      print_titles
      ;;
  esac
done

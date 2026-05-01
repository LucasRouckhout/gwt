#!/usr/bin/env bash

# gwt - Git Worktree Manager
# Requires: bash, git, fzf

gwt() {
  # 1. Pre-flight checks
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not in a git repository."
    return 1
  fi
  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed."
    return 1
  fi

  # 2. Run fzf with a header and expect keys
  # --header: Shows the inline legend
  # --expect: Tells fzf to print the key pressed (Enter produces an empty line)
  # --preview: Shows the git log for the selected worktree path
  local fzf_out
  fzf_out=$(git worktree list | fzf \
    --header="[ENTER] cd to worktree  |  [CTRL-X] remove worktree  |  [CTRL-N] create worktree" \
    --expect=ctrl-x,ctrl-n \
    --height=40% \
    --border \
    --preview="echo {} | awk '{print \$1}' | xargs -I % sh -c 'cd % && git log --oneline --graph --date=short --color --pretty=\"format:%C(auto)%cd %h%d %s\" -n 10'")

  # If user pressed ESC, fzf_out is empty
  if [ -z "$fzf_out" ]; then
    return 0
  fi

  # 3. Parse fzf output
  # First line is the key pressed
  local key=$(echo "$fzf_out" | head -n1)
  # Second line is the selected item
  local wt_line=$(echo "$fzf_out" | tail -n+2)
  
  # The path is the first column of the `git worktree list` output
  local wt_path=$(echo "$wt_line" | awk '{print $1}')

  # 4. Action Routing
  if [ "$key" = "ctrl-n" ]; then
    # Creation Flow
    printf "\nEnter new worktree name: "
    read -r wt_name < /dev/tty
    if [ -z "$wt_name" ]; then
      echo "Aborted."
      return 0
    fi
    printf "Enter location (default: .worktrees/%s): " "$wt_name"
    read -r wt_loc < /dev/tty
    if [ -z "$wt_loc" ]; then
      wt_loc=".worktrees/$wt_name"
    fi

    if git rev-parse --verify --quiet "refs/heads/$wt_name" >/dev/null; then
      git worktree add "$wt_loc" "$wt_name"
    else
      git worktree add -b "$wt_name" "$wt_loc"
    fi

    if [ $? -eq 0 ]; then
      cd "$wt_loc" || return 1
    fi
  else
    if [ -z "$wt_path" ]; then
      return 0
    fi

    if [ "$key" = "ctrl-x" ]; then
      # Removal Flow
      printf "\nRemove git worktree at: \033[1;31m%s\033[0m\nConfirm? [y/N]: " "$wt_path"
      read -r confirm < /dev/tty
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git worktree remove "$wt_path"
      else
        echo "Aborted."
      fi
    else
      # Change Directory Flow (Enter)
      cd "$wt_path" || return 1
    fi
  fi
}

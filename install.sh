#!/usr/bin/env bash

# Resolve the absolute path to the directory containing this script
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GWT_SCRIPT="$REPO_DIR/gwt.sh"
SOURCE_LINE="source \"$GWT_SCRIPT\""

echo "==============================="
echo "   gwt - Git Worktree Manager  "
echo "==============================="
echo "This will append the following line to your shell configuration:"
echo -e "\033[1;36m$SOURCE_LINE\033[0m\n"

installed=false

# Check common shell configuration files
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
    if [ -f "$rc" ]; then
        printf "Found \033[1;33m%s\033[0m. Install gwt here? [Y/n]: " "$rc"
        read -r confirm < /dev/tty
        
        # Default to Yes unless explicitly answered No
        if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
            if grep -Fq "$SOURCE_LINE" "$rc"; then
                echo " -> Already installed in $rc"
                installed=true
            else
                echo "" >> "$rc"
                echo "# gwt - Git Worktree Manager" >> "$rc"
                echo "$SOURCE_LINE" >> "$rc"
                echo " -> Successfully added to $rc"
                installed=true
            fi
        fi
    fi
done

# Fallback if no files were selected or found
if [ "$installed" = false ]; then
    echo "No standard shell configuration files were updated."
    printf "Enter a custom path to install to (or leave blank to abort): "
    read -r custom_path < /dev/tty
    
    # Expand tilde if provided in custom path
    custom_path="${custom_path/#\~/$HOME}"
    
    if [ -n "$custom_path" ] && [ -f "$custom_path" ]; then
        if grep -Fq "$SOURCE_LINE" "$custom_path"; then
            echo " -> Already installed in $custom_path"
        else
            echo "" >> "$custom_path"
            echo "# gwt - Git Worktree Manager" >> "$custom_path"
            echo "$SOURCE_LINE" >> "$custom_path"
            echo " -> Successfully added to $custom_path"
        fi
    elif [ -n "$custom_path" ]; then
        echo "File not found: $custom_path"
    fi
fi

echo -e "\nInstallation complete!"
echo -e "To start using \033[1;32mgwt\033[0m immediately, run:"
echo -e "  \033[1;36mexec \$SHELL\033[0m (or open a new terminal tab)"

# gwt 🌳

**`gwt`** is an extremely simple command-line utility to quickly and efficiently manage git worktrees. Powered by `fzf`.

Literally just a single bash function, `gwt` gives you an interactive, fuzzy-searchable list of your current git worktrees with inline git log previews, allowing you to instantly jump into them or clean them up.

---

## ⚡ Quick Start

Copy, paste, and run this in your terminal to clone and install:

```bash
git clone https://github.com/LucasRouckhout/gwt.git ~/.gwt && cd ~/.gwt && make install
```

Then, either restart your terminal, open a new tab, or run:
```bash
exec $SHELL
```

Now you're ready to go!

---

## 🚀 Usage

Whenever you are inside a git repository, simply run:

```bash
gwt
```

- **[ENTER]** `cd` into the selected worktree.
- **[CTRL-X]** safely remove the selected worktree.

*(Requires `bash`, `git`, and `fzf` to be installed on your system)*

---

## 🛠️ How it works (and why)

Why is `gwt` a bash function and not a compiled binary or standalone shell script? 

Because of the **`cd`** command! Standalone executables run in child processes and cannot change the current working directory of your active shell. By being a bash function that gets loaded directly into your environment, `gwt` can change your directory instantly and seamlessly.

### What exactly does the installation do?

The installation is incredibly lightweight and transparent. We don't hide anything. When you run `make install` (which executes `install.sh`), here is exactly what happens:

1. It scans for your standard shell configuration files (like `~/.zshrc` and `~/.bashrc`).
2. It prompts you to confirm if you want to install `gwt` into them.
3. If you say yes, it appends a **single line** to the end of that file, pointing to the script in the repository:
   ```bash
   source "/absolute/path/to/cloned/repo/gwt.sh"
   ```
4. It does **not** move files around, it does **not** put binaries in `/usr/local/bin`, and it does **not** clutter your system. It simply tells your shell where to find the `gwt` function.

**To uninstall:** Just delete that one `source` line from your `.zshrc` or `.bashrc` and delete the cloned folder. That's it!

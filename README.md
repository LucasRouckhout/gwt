# gwt 🌳

**`gwt`** is an extremely simple command-line utility to quickly and efficiently manage git worktrees. Powered by `fzf`.

Literally just a single bash function, `gwt` gives you an interactive, fuzzy-searchable list of your current git worktrees with inline git log previews, allowing you to instantly jump into them or clean them up.

---

## Quick Start

Run the following commands in your terminal to clone and install:

```bash
git clone https://github.com/LucasRouckhout/gwt.git ~/.gwt
cd ~/.gwt
make install
```

Then, either restart your terminal, open a new tab, or run:
```bash
exec $SHELL
```

Now you're ready to go!

---

## Usage

Whenever you are inside a git repository, simply run:

```bash
gwt
```

- **[ENTER]** `cd` into the selected worktree.
- **[CTRL-X]** safely remove the selected worktree.

*(Requires `bash`, `git`, and `fzf` to be installed on your system)*


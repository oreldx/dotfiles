# Dotfiles Repository

This repository contains my personal dotfiles for setting up a development environment. Below are the steps to replicate my environment.

## Getting Started

### Clone the Repository

First, clone the dotfiles repository and move it to the `.dotfiles` directory:

```
git clone git@github.com:oreldx/dotfiles.git
mv dotfiles .dotfiles
```

## Setting Up the Environment

### Fish Terminal

1. **Install Fish Terminal:** Follow the instructions on the [Fish website](https://fishshell.com) to install.
2. **Set Fish as Default Shell:**

```
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
```

### Tmux Setup

1. **Install Tmux:** Use your package manager to install tmux.
2. **Install TPM (Tmux Plugin Manager):** Clone TPM:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

3. **Configure Tmux:**

- Link the tmux configuration file:
  ```
  ln -s .dotfiles/.tmux.conf ~/.tmux.conf
  ```
- Run tmux and press `PREFIX + r` to reload the configuration, then `PREFIX + I` to install TPM plugins.

### Additional Tools

- **Install Peco:** Follow instructions from [Peco GitHub](https://github.com/peco/peco).
- **Install fzf:** Installation steps can be found on the [fzf GitHub page](https://github.com/junegunn/fzf).
- **Install exa:** Instructions at [exa website](https://the.exa.website/).
- **Install xclip:** Use your package manager to install xclip.

### Fish Configuration

- Link Fish configuration files:

```
ln -s .dotfiles/config.fish ~/.config/fish/config.fish
ln -s .dotfiles/fish_plugins ~/.config/fish/fish_plugins
ln -s .dotfiles/functions/gitmoji.fish ~/.config/fish/functions/gitmoji.fish
```

- **Install Fisher and Update Plugins:**

```
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

### Git and Editor Tools

- **Install Lazygit:** Follow the installation guide on [Lazygit GitHub](https://github.com/jesseduffield/lazygit).
- **Install Neovim:**
- Install dependencies: ripgrep and fd-find.
- Build Neovim from source following instructions on the [Neovim GitHub](https://github.com/neovim/neovim).
- **Install Lazyvim:** Lazyvim installation can be done through the [Lazyvim GitHub](https://github.com/LazyVim/LazyVim).

### Final Steps

- **Run Lazyvim:** Start Lazyvim to ensure all configurations are loaded properly.

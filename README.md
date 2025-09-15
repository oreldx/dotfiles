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

3. **Link Fish configuration file:**
    ```
    ln -sf ~/.dotfiles/fish/config.fish ~/.config/fish/config.fish
    ```
4. **Install fisher**
    ```
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    ln -sf ~/.dotfiles/fish/fish_plugins ~/.config/fish/fish_plugins
    fisher update
    ```

### Nerd fonts

1. Download a [Nerd Font](https://www.nerdfonts.com/font-downloads)

2. Unzip and copy to `~/.fonts`

3. Run the command `fc-cache -fv` to manually rebuild the font cache

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

### Neomvim Setup

1. Install prerequisites
    ```
    sudo apt-get install ninja-build gettext cmake curl build-essential
    ```

2. Clone Nvim repo in ~/Documents & Checkout to the desired release
    ```
    git clone https://github.com/neovim/neovim
    ```

3. Build
    ```
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    ```

4. Install
    ```
    sudo make install
    ```

### Lazyvim Setup

1. Clone & Remove .git
    ```
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    ```

### Git and Editor Tools

- **Install Lazygit:** Follow the installation guide on [Lazygit GitHub](https://github.com/jesseduffield/lazygit).

### Final Steps

- **Run Lazyvim:** Start Lazyvim to ensure all configurations are loaded properly.

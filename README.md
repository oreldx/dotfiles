# dotfiles

My personal dotfiles managed using [chezmoi](https://github.com/twpayne/chezmoi)

## 🚀 Usage

### Clone the Repository

First, clone the dotfiles repository and move it to the `.dotfiles` directory:
```
git clone git@github.com:oreldx/dotfiles.git
mv dotfiles .dotfiles
```

## Install Dependencies

### Ghostty

Use the one line installer to install [Ghostty](https://ghostty.org/docs/install/binary):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

### Fish

1. **Install Fish Terminal:** Follow the instructions on the [Fish website](https://fishshell.com) to install.
2. **Set Fish as Default Shell:**
    ```
    echo /usr/local/bin/fish | sudo tee -a /etc/shells
    chsh -s /usr/bin/fish
    ```
3. **Install fisher**
    ```
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    ln -sf ~/.dotfiles/fish/fish_plugins ~/.config/fish/fish_plugins
    fisher update
    ```

### Nerd fonts

1. Download a [Nerd Font](https://www.nerdfonts.com/font-downloads)

2. Unzip and copy to `~/.fonts`

3. Run the command `fc-cache -fv` to manually rebuild the font cache

### Zellij

Download latest release on [Zellij site](https://zellij.dev/documentation/installation.html) and install the package

Once downloaded, untar the file:

```bash
tar -xvf zellij*.tar.gz
```

check for the execution bit:

```bash
chmod +x zellij
```

move it in a directory included in $PATH then execute Zellij:
```bash
sudo mv ./zellij /usr/bin
zellij
```

### Git and Editor Tools

#### Neovim

1. Install prerequisites
    ```bash
    sudo apt-get install ninja-build gettext cmake curl build-essential
    ```

2. Clone Nvim repo in ~/Documents & Checkout to the desired release
    ```bash
    git clone https://github.com/neovim/neovim
    ```

3. Build
    ```bash
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    ```

4. Install
    ```bash
    sudo make install
    ```

#### Lazyvim Setup

1. Clone & Remove .git
    ```bash
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    ```

### Chezmoi (optional because applying the dotfiles will install it)

Install chezmoi according to the instructions on the [Chezmoi website](https://www.chezmoi.io/install).

One-line installer

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)"
```

## Apply the dotfiles

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply oreldx
```
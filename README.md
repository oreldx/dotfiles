# dotfiles

My macOS terminal setup: Zsh with Oh My Zsh, Ghostty and Herdr. Configs are
ordinary files in this repository, linked into place by `install.sh`.

## Prerequisites

Install these before linking the configs. The installer only manages links;
it does not download software or change the default shell.

| Dependency | Installation / notes |
| --- | --- |
| Git and Zsh | Use the macOS command line tools (`xcode-select --install`) and `/bin/zsh`. If needed, select Zsh with `chsh -s /bin/zsh`. |
| Ghostty | Follow the [official macOS installation instructions](https://ghostty.org/docs/install/binary). |
| Herdr | Follow the [official installation guide](https://herdr.dev). The current setup keeps the executable in `~/.local/bin`. |
| Oh My Zsh | Clone the [official repository](https://github.com/ohmyzsh/ohmyzsh#manual-installation) as shown below. |
| zsh-autosuggestions | Install the [Oh My Zsh plugin](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh) if it is not already present. |
| NVM | Follow the [official installation instructions](https://github.com/nvm-sh/nvm#installing-and-updating), using `~/.nvm`. Use `PROFILE=/dev/null` with its installer so the shell config stays managed here. Install the Node versions you need separately. |

On a fresh machine, install Oh My Zsh without generating a replacement `.zshrc`:

```sh
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
```

If `zsh-autosuggestions` is absent from both `~/.oh-my-zsh/plugins` and
`~/.oh-my-zsh/custom/plugins`, install it into the custom directory:

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
```

The `git` and `z` plugins ship with Oh My Zsh. The active prompt is `half-life`;
the optional `morelkai` prompt needs no special font. No font override is
configured in Ghostty.

## Install

Clone into a permanent location: the links point to this checkout, so keep it
there after installation.

```sh
git clone https://github.com/oreldx/dotfiles.git "$HOME/Work/random/dotfiles"
cd "$HOME/Work/random/dotfiles"
./install.sh --dry-run
./install.sh
```

The script also works when invoked by its absolute path from another directory.
Run `./install.sh --help` for its options. Review the diff before reinstalling
after a pull: edits to linked files take effect directly in this checkout.

The setup uses the default macOS paths below. It assumes no overrides such as
`XDG_CONFIG_HOME`, `HERDR_CONFIG_PATH`, `ZDOTDIR` or `ZSH_CUSTOM` pointing elsewhere.

| Repository file | Link destination |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/themes/morelkai.zsh-theme` | `~/.oh-my-zsh/custom/themes/morelkai.zsh-theme` |
| `ghostty/config.ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| `ghostty/themes/morelkai night` | `~/.config/ghostty/themes/morelkai night` |
| `ghostty/themes/morelkai day` | `~/.config/ghostty/themes/morelkai day` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |

Only those files are linked. Herdr sessions, snapshots, logs and sockets remain
in their existing directories. No application data, dependencies or binaries
belong in this repository.

`--dry-run` prints the planned backups and links without writing anything.
Installation skips correct links and moves existing files or incorrect links
into a unique directory under `~/.local/state/dotfiles/backups/`, preserving
their paths relative to the home directory. The script prints that directory.
It refuses directories at file destinations and blocked parent paths before
changing any configs. If an installation fails partway through, inspect the
printed output and backup directory before restoring or running it again.

## Reload and check

- Open a new Ghostty window to load the Zsh login profile and shell config.
- Reload Ghostty using **Reload Configuration** from its command palette.
- In Herdr, use the global menu's **reload config** action. For the local server,
  `herdr server reload-config` is also available.

Ghostty selects `morelkai day` or `morelkai night` from the system appearance.
Herdr has custom light/dark colors layered over its built-in Catppuccin themes;
those theme names do not require separate files. Its prefix is `Ctrl+G` and its
toast delivery is set to `system`.

Ghostty's named themes are looked up in `~/.config/ghostty/themes`, even though
the main config uses the macOS Application Support directory. If an old
`~/.config/ghostty/config` or `config.ghostty` exists, inspect it too: Ghostty
loads both locations, with the macOS config taking precedence for conflicting
settings. See the [configuration documentation](https://ghostty.org/docs/config)
and [theme reference](https://ghostty.org/docs/config/reference#theme).

From the checkout, validate the configs without installing links:

```sh
/bin/bash -n install.sh
/bin/zsh -n zsh/.zshrc
/bin/zsh -n zsh/.zprofile
/bin/zsh -n zsh/themes/morelkai.zsh-theme
HERDR_CONFIG_PATH="$PWD/herdr/config.toml" herdr config check
```

After installation, validate Ghostty including its named themes:

```sh
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```

Switch macOS between light and dark appearance with Ghostty and Herdr open to
check both palettes visually.

## Everyday changes

Edit a file in the checkout or through its usual path (for example `~/.zshrc`),
reload the relevant application, and review and commit the change:

```sh
git diff
git add <changed-files>
git commit -m "Update terminal configuration"
```

Inspect new settings before committing, especially if an application wrote them.
If an application replaces a symlink with a regular file, compare that file
with its repository counterpart, merge the changes you want, then rerun
`./install.sh` to back up the file and restore the link.

To enable the alternative Zsh prompt, change `ZSH_THEME` in `zsh/.zshrc` to
`morelkai`, then open a new shell. Keep `half-life` for the current setup.

### Update morelkai palettes

The palette source is [oreldx/morelkai](https://github.com/oreldx/morelkai).
This repository stores copies of its terminal exports, so cloning that project
is only necessary when updating the palettes.

In the theme project's checkout, edit the VS Code palettes and regenerate:

```sh
python3 scripts/export-terminal-themes.py
```

Copy the two generated files from its `terminal/ghostty/` directory into this
repository's `ghostty/themes/`. Replace the `[theme]` and `[theme.custom…]`
sections in `herdr/config.toml` with the generated `terminal/herdr/morelkai.toml`
content, keeping the other Herdr settings. Do not append duplicate TOML tables.
The optional Zsh prompt comes from `terminal/zsh/morelkai.zsh-theme` in that
project and can be copied into `zsh/themes/` when updated.

Review the diff, validate, and reload the applications. Theme generation stays
in the theme project; this repository does not run it during installation.

## Restore a previous config

Choose the backup directory printed by the installer. For example, restore
the old `.zshrc` (replace the placeholder with the real directory name):

```sh
backup="$HOME/.local/state/dotfiles/backups/<unique-date>"
mv -i "$backup/.zshrc" "$HOME/.zshrc"
```

This replaces the installed link with the saved file or link; it does not edit
the repository's config. Repeat for the other files using the destination
paths in the table, then reload the applications. For files that had no previous
version, remove only the installed symlink if you want to return to defaults.

## Installer tests

The tests use Python's standard library and temporary home directories. They
exercise installation, reruns, backups, conflicting paths and dry-run behavior
without changing the real home directory:

```sh
python3 -m unittest discover -s tests -v
```

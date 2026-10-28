#!/bin/bash
# Link individual config files; leave application data directories in place.
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./install.sh [--dry-run | --help]

Create macOS config symlinks to this checkout. Existing files and incorrect
symlinks are moved to ~/.local/state/dotfiles/backups/<unique-date>/ first.
Directories at file destinations are refused. Correct links are left alone.

  --dry-run  Print planned changes without writing anything.
  --help     Show this help.

Install application dependencies separately; see README.md.
EOF
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

dry_run=false
case "${1:-}" in
    --help) usage; exit 0 ;;
    --dry-run) dry_run=true ;;
    '') ;;
    *) usage >&2; fail "Unknown argument: $1" ;;
esac
[[ $# -le 1 ]] || fail 'Expected at most one argument.'
[[ $(uname -s) == Darwin ]] || fail 'This setup targets macOS.'
[[ ${HOME:-} == /* && $HOME != / ]] || fail 'HOME must be an absolute home directory.'

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

sources=(
    'zsh/.zshrc'
    'zsh/.zprofile'
    'zsh/themes/morelkai.zsh-theme'
    'ghostty/config.ghostty'
    'ghostty/themes/morelkai night'
    'ghostty/themes/morelkai day'
    'herdr/config.toml'
)
destinations=(
    '.zshrc'
    '.zprofile'
    '.oh-my-zsh/custom/themes/morelkai.zsh-theme'
    'Library/Application Support/com.mitchellh.ghostty/config.ghostty'
    '.config/ghostty/themes/morelkai night'
    '.config/ghostty/themes/morelkai day'
    '.config/herdr/config.toml'
)

# Reject blocked parent paths before changing any config files.
check_parent() {
    local parent
    parent=$(dirname -- "$1")
    while [[ $parent != / ]]; do
        if [[ -e $parent || -L $parent ]]; then
            [[ -d $parent ]] || fail "Parent is not a directory: $parent"
        fi
        parent=$(dirname -- "$parent")
    done
}

correct_link() {
    [[ -L $1 && $(readlink "$1") == "$2" ]]
}

backup_base="$HOME/.local/state/dotfiles/backups"
for ((i = 0; i < ${#sources[@]}; i++)); do
    source_file="$repo_dir/${sources[i]}"
    target="$HOME/${destinations[i]}"
    [[ -f $source_file ]] || fail "Missing source file: $source_file"
    [[ ! -d $target ]] || fail "Directory at file destination: $target"
    check_parent "$target"
done
check_parent "$backup_base/placeholder"

backup_dir=''
for ((i = 0; i < ${#sources[@]}; i++)); do
    source_file="$repo_dir/${sources[i]}"
    target="$HOME/${destinations[i]}"

    if correct_link "$target" "$source_file"; then
        printf 'Already linked: %s\n' "$target"
        continue
    fi

    if [[ -e $target || -L $target ]]; then
        if $dry_run; then
            printf 'Would back up: %s\n' "$target"
        else
            if [[ -z $backup_dir ]]; then
                mkdir -p -- "$backup_base"
                backup_dir=$(mktemp -d "$backup_base/$(date -u +%Y%m%dT%H%M%SZ).XXXXXX")
                printf 'Backup directory: %s\n' "$backup_dir"
            fi
            backup_file="$backup_dir/${destinations[i]}"
            mkdir -p -- "$(dirname -- "$backup_file")"
            mv -- "$target" "$backup_file"
            printf 'Backed up: %s -> %s\n' "$target" "$backup_file"
        fi
    fi

    if $dry_run; then
        printf 'Would link: %s -> %s\n' "$target" "$source_file"
    else
        mkdir -p -- "$(dirname -- "$target")"
        ln -s -- "$source_file" "$target"
        printf 'Linked: %s -> %s\n' "$target" "$source_file"
    fi
done

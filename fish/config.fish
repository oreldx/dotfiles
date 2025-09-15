if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting

end

function l
    set -l level
    set -l all
    set -l args

    for arg in $argv
        switch $arg
            case --lvl
                set level --level
            case --a
                set all --all
            case '*'
                if set -q level
                    set level $level $arg
                else
                    set -a args $arg
                end
        end
    end

    exa --icons --tree $level $all $args -I __pycache__ --sort=type
end

function c
    clear
end

set -U fish_user_paths $fish_user_paths ~/.local/bin

alias dcupd="docker compose up -d"
alias dcdn="docker compose down"
alias preset='set cur (git branch --show-current); and git checkout dev; and git pull origin dev; and git branch -d $cur'

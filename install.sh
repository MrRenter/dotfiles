#!/usr/bin/env bash

# Text formatting variables
text_bold="\e[1m"
text_red="\e[31m"
text_reset="\e[0m"
text_yellow="\e[33m"

# Output functions
function log {
    echo -ne "$1\n"
}

function warning {
    echo -ne "${text_bold}${text_yellow}WARNING${text_reset} $1\n"
}

function error {
    echo -ne "${text_bold}${text_red}ERROR${text_reset} $1\n"
    exit 1
}

function print_usage {
    cat <<EOF
Usage: dotlink [OPTIONS]

Link all files from hosts/\$HOSTNAME to \$HOME.

OPTIONS
  -h, --help    Show this help message
  -u, --unlink  Remove current links
EOF
    exit
}

# Set default values
unlink=false

# Parse arguments
while (( "$#" )); do
    case "$1" in
        -h|--help)
            print_usage
            ;;
        -u|--unlink)
            unlink=true
            shift
            ;;
        -*|--*=)
            error "Unsupported flag: $1"
            ;;
        *)
            error "Unsupported argument: $1"
            ;;
    esac
done

# Get current dotfile directory for later linking
dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if dotfiles for host exist
if [ ! -d "$dotfiles/$hostname" ]; then
    error "No dotfiles for host $text_bold$HOSTNAME$text_reset found, make sure the directory $text_bold$dotfiles/$hostname$text_reset exists"
fi

# Get dotfiles for current host
cd "$dotfiles/$hostname"
files=( $(find -L -type f -printf '%P\n'))

if [ "$unlink" == true ]; then
    log "Unlinking $text_bold${#files[@]}$text_reset files..\n"
else
    log "Linking $text_bold${#files[@]}$text_reset files..\n"
fi

for file in "${files[@]}"; do

    # Unlink files
    if [ "$unlink" == true ]; then

        if [ -L "$HOME/$file" ] && [ "$(readlink $HOME/$file)" == "$dotfiles/$hostname/$file" ]; then

            rm "$HOME/$file"
            log "Unlinked $text_bold$HOME/$file$text_reset"

            # Remove base directory if empty
            if ! [ "$(ls -A $(dirname $HOME/$file))" ]; then
                rmdir "$(dirname $HOME/$file)"
                log "Removed empty directory $text_bold$(dirname $HOME/$file)$text_reset"
            fi
        fi

    # Link files
    else

        # Check if target is a link
        if [ -L "$HOME/$file" ]; then

            if [ "$(readlink $HOME/$file)" != "$dotfiles/$hostname/$file" ]; then
                warning "$text_bold$HOME/$file$text_reset is a link but doesn't point to this repository, it will not be linked"
                continue
            fi

        # Check if target is a file or directory
        elif [ -f "$HOME/$file" ]; then

            warning "$text_bold$HOME/$file$text_reset exists and will not be linked"
            continue

        # Create link
        else

            # Create target directory if not existent
            mkdir -p "$(dirname $HOME/$file)"#

            # Link file
#            ln -s "$dotfiles/$hostname/$file" "$HOME/$file"
            log "Linked $text_bold$dotfiles/$file$text_reset to $text_bold$HOME/$file$text_reset"
        fi
    fi

done

log "\ndone"

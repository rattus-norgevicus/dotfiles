#!/bin/bash

set -e

source ./shellrc/zshrc.d/zshenv

info() {
	printf "\r [\033[00;34m..\033[0m] $1\n"	
}

success() {
	printf "\r [\033[2K[\033[0;32mOK\033[0m] $1\n"
}

fail() {
	printf "\r [\033[2K[\033[0;31mERROR\033[0m] $1\n"
	echo ''
	exit
}


link_file() {
	local src=$1 dest=$2

	local overwrite=
	local backup=
	local skip=
	local action=

	if [ -f "$dest" ] || [ -d "$dest" ] || [ -L "$dest" ]; then
		if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
			local current_src="$(readlink $dest)"

			if [ "$current_src" == "$src" ]; then
				skip=true;
			else
				user "File $dest already exists: ($(basename "$src")), what do you want to do?\n\
					[s] skip, [S] skip all, [o] overwrite, [O] overwrite all, [b] backup, [B] backup all?"
									read -n 1 action < /dev/tty

									case "$action" in
										o )
											overwrite=true;;
										O )
											overwrite_all=true;;
										s )
											skip=true;;
										S )
											skip_all=true;;
										b )
											backup=true;;
										B )
											backup_all=true;;
										* )
											;;
									esac
			fi
		fi

		overwrite=${overwrite:-$overwrite_all}
		backup=${backup:-$backup_all}
		skip=${skip:-$skip_all}

		if [ "$overwrite" == "true" ]; then
			rm -rf "$dest"
			success "removed $dest"
		fi

		if [ "$backup" == "true" ]; then
			mv "$dest" "${dest}.bak"
			success "moved $dest to ${dest}.bak"
		fi

		if [ "$skip" == "true" ]; then
			success "skipped $src"
		fi
	fi

	if [ "$skip" != "true" ]; then
		ln -s "$1" "$2"
		success "linked $1 to $2"
	fi
}

install_dotfiles() {
	info 'installing dotfiles'

	local overwrite_all=false backup_all=false skip_all=false

	find -H "$HOME/.dotfiles" -maxdepth 3 -name '*.slink' -not -path "*.git*" | while read linkfile; do
	cat "$linkfile" | while read line; do
	local src dest dir
	src=$(eval echo "$line" | cut -d '=' -f 1)
	dest=$(eval echo "$line" | cut -d '=' -f 2)
	dir=$(dirname $dest)

	mkdir -p "$dir"
	link_file "$src" "$dest"
done
done
}

install_dotfiles

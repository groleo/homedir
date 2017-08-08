#! /bin/sh

set -e

###########################################
# Packages
###########################################
install_packages()
{
	_basic="rxvt-unicode-256color vim vim-gtk vim-doc vim-scripts ctags mc indent unzip tmux autojump htop wdiff openssh-server xclip"
	_dev="python-pip cmake make gdb ccache strace cdecl flex bison libsqlite3-dev sqlite3-doc python-pysqlite2"
	_mesa="g++ xsltproc libexpat1 libexpat1-dev libudev-dev gettext libffi-dev libffi6 libmtdev-dev libjpeg-dev libpam0g-dev"
	_wayland="autoconf libtool sudo autopoint intltool"
	_scm_basic="tig git git-doc"
	_scm_extra="git-cvs git-svn git-email subversion vim-editorconfig libstdc++6-4.7-doc"
	sudo -E apt-get install \
		$_basic \
		$_dev \
		$_mesa \
		$_wayland \
		$_scm_basic
		#cpulimit \
		#libsqlite3-0-dbg linux-tools-3.2 libc6-dbg \
		#ia32-libs lib32ncurses5 lib32stdc++6 \
		#devscripts \

#	sudo apt-get remove unity-webapps-common
}

###########################################
# Git config
###########################################
setup_git()
{
	git config --global user.name "Adrian Negreanu"
	git config --global user.email "groleo@gmail.com"
	git config --global color.ui true
	git config --global sendemail.signedoffbycc no

	git config --global sendemail.waffle.to "waffle@lists.freedesktop.org"
	git config --global sendemail.waffle.from "Adrian Negreanu <groleo@gmail.com>"

	git config --global sendemail.mesa.to "mesa-dev@lists.freedesktop.org"
	git config --global sendemail.mesa.from "Adrian Negreanu <groleo@gmail.com>"

	git config --global sendemail.piglit.to "piglit@lists.freedesktop.org"
	git config --global sendemail.piglit.from "Adrian Negreanu <groleo@gmail.com>"

	git config --global sendemail.systemtap.to "systemtap@sourceware.org"
	git config --global sendemail.systemtap.from "Adrian Negreanu <groleo@gmail.com>"

	# Aliases
	git config --global alias.ll "log --oneline --graph --all --decorate"
	#git config --global alias.l1 "log --oneline"
	git config --global alias.bs "for-each-ref --sort='-committerdate:iso8601' --format=' %(committerdate:relative)%09%(refname:short)' refs/heads"
	git config --global alias.l1 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
}
###############################
install_packages
setup_git

inside_homedir() {
	origin_url="$(git config remote.origin.url || true)"
	if [ "$origin_url" = "https://github.com/groleo/homedir.git" ]; then
		return 1
	fi
	return 0
}

if [ -d homedir ]; then
	cd homedir
	git pull
else
	# check if we're already cd-ed inside homedir
	if [ $(inside_homedir) -eq 1 ]; then
		git pull
	else
		git clone https://github.com/groleo/homedir.git
		cd homedir
	fi
fi

[ ! -d ${HOME}/.local/temp ] && mkdir -p ${HOME}/.local/temp
[ ! -d ${HOME}/.local/bin ] && mkdir -p ${HOME}/.local/bin

if [ "$(grep .bash_env ${HOME}/.bashrc)" = "" ]; then
	echo '. ${HOME}/.bash_env' >> ${HOME}/.bashrc
fi

for i in bin/*; do
	ln -sf $PWD/$i ${HOME}/.local/bin/
done

###########################################
# dotrc files
###########################################

rm -f ${HOME}/.bash_env
ln -sf $PWD/bash_env ${HOME}/.bash_env

rm -f ${HOME}/.vimrc
ln -sf $PWD/vimrc ${HOME}/.vimrc

rm -f ${HOME}/.tmux.conf
ln -sf $PWD/tmux.conf ${HOME}/.tmux.conf

rm -rf ${HOME}/.local/gdb
ln -sf $PWD/gdb ${HOME}/.local/gdb

rm -f ${HOME}/.gdbinit
ln -sf $PWD/gdbinit ${HOME}/.gdbinit

rm -f ${HOME}/.Xresources
ln -sf $PWD/Xresources ${HOME}/.Xresources

rm -f ${HOME}/.clang-format
ln -sf $PWD/clang-format ${HOME}/.clang-format

if [ -n "$DISPLAY" ]; then
	xrdb -load ~/.Xresources
fi

###########################################
# Vim Setup
###########################################
[ ! -d ${HOME}/.vim/colors ] && mkdir -p ${HOME}/.vim/colors/

cp groleo.vim ${HOME}/.vim/colors/

wget --content-disposition 'http://www.vim.org/scripts/download_script.php?src_id=7701'
unzip -o taglist_*.zip -d ${HOME}/.vim
rm taglist_*.zip*

git clone https://github.com/ciaranm/detectindent.git
rm -rf detectindent/.git
cp -r detectindent/* ${HOME}/.vim/
rm -rf detectindent


wget --content-disposition 'http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz'
gunzip manpageview.vba.gz
vim -c 'so % | q' manpageview.vba
rm -rf manpageview.vba

wget --content-disposition 'http://www.vim.org/scripts/download_script.php?src_id=14047'
unzip fswitch-*.zip
cp -r vim-fswitch/* ${HOME}/.vim/
rm -rf vim-fswitch fswitch-*.zip*

wget 'https://raw.github.com/ciaranm/detectindent/master/plugin/detectindent.vim' -O ${HOME}/.vim/plugin/detectindent.vim
wget 'http://www.vim.org/scripts/download_script.php?src_id=7645' -O ${HOME}/.vim/plugin/grep.vim
wget 'http://www.vim.org/scripts/download_script.php?src_id=7218' -O ${HOME}/.vim/plugin/a.vim

#wget https://github.com/vimwiki/vimwiki/archive/master.zip


gcc connect.c -o ${HOME}/.local/bin/connect

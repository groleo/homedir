#! /bin/sh -e

###########################################
# Packages
###########################################
install_packages()
{
_basic="vim vim-nox vim-doc vim-scripts ctags mc indent unzip tmux autojump htop wdiff openssh-server"
_dev="gdb ccache strace cdecl flex bison libsqlite3-dev sqlite3-doc python-pysqlite2"
_mesa="g++ xsltproc libexpat1 libexpat1-dev libudev-dev gettext libffi-dev libffi6 libmtdev-dev libjpeg-dev libpam0g-dev"
_wayland="autoconf libtool sudo autopoint intltool"
_scm_basic="git git-doc"
_scm_extra="git-cvs git-svn git-email subversion"
sudo -E apt-get install \
	$_basic \
	$_dev \
	$_mesa \
	$_wayland \
	$_scm_basic

	#xclip \
	#cpulimit \
	#libsqlite3-0-dbg linux-tools-3.2 libc6-dbg \
	#ia32-libs lib32ncurses5 lib32stdc++6 \
	#devscripts \
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

if [ ! -d homedir ]; then
	git clone https://github.com/groleo/homedir.git
else
	cd homedir
	git pull
	cd -
fi

cd homedir
}

install_packages
setup_git

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
xrdb -load ~/.Xresources

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

wget --content-disposition 'http://www.vim.org/scripts/download_script.php?src_id=7645'
mv grep.vim ${HOME}/.vim/plugin/

wget --content-disposition 'http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz'
gunzip manpageview.vba.gz
vim -c 'so % | q' manpageview.vba
rm -rf manpageview.vba

wget --content-disposition 'http://www.vim.org/scripts/download_script.php?src_id=14047'
unzip fswitch-*.zip
cp -r vim-fswitch/* ${HOME}/.vim/
rm -rf vim-fswitch fswitch-*.zip*

wget https://raw.github.com/ciaranm/detectindent/master/plugin/detectindent.vim
cp detectindent.vim ${HOME}/.vim/
rm -rf detectindent.vim

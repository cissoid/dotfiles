# /usr/bin/env bash

SRC_DIR=`dirname \`realpath ${0}\``
TAR_DIR=$HOME

linkto () {
    if [ -d $2 -o -f $2 ]
    then
        echo "$2 exist, ignore it..."
        return 1
    fi
    ln -s $1 $2
}

files=(
    $SRC_DIR/bash/bashrc                $TAR_DIR/.bashrc
    $SRC_DIR/bash/inputrc               $TAR_DIR/.inputrc
    $SRC_DIR/flake8/flake8              $TAR_DIR/.config/flake8
    $SRC_DIR/git/gitconfig              $TAR_DIR/.gitconfig
    $SRC_DIR/ipython/ipython_config.py  $TAR_DIR/.ipython/profile_default/ipython_config.py
    $SRC_DIR/powerline                  $TAR_DIR/.config/powerline
    $SRC_DIR/tern/tern-config           $TAR_DIR/.tern-config
    $SRC_DIR/tmux/tmux.conf             $TAR_DIR/.tmux.conf
    $SRC_DIR/vim/vimrc                  $TAR_DIR/.vimrc
    $SRC_DIR/vim                        $TAR_DIR/.vim
)

for (( i=0; i<${#files[@]}; i=i+2 ))
do
    src=${files[i]}
    dest=${files[i+1]}
    linkto $src $dest
done

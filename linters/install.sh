#!/bin/bash
SRC_DIR=`dirname \`realpath ${0}\``
TAR_DIR=$HOME

install_maps=(
    # c, cpp
    "yaourt"        "clang-check"       "clang"
    "yaourt"        "cppcheck"          "cppcheck"
    "yaourt"        "cpplint"           "cpplint"

    # python
    "pip"           "flake8"            "flake8"

    # javascript, html
    "npm"           "eslint"            "eslint"
    "npm"           "jshint"            "jshint"
    "npm"           "jslint"            "jslint"
    "npm"           "jsonlint"          "jsonlint"
    "npm"           "standard"          "standard"
    # css
    "npm"           "csslint"           "csslint"
    "npm"           "stylelint"         "stylelint"
    # less
    "npm"           "lessc"             "less"
    "npm"           "recess"            "recess"
    # markdown
    "npm"           "textlint"          "textlint"
    # yaml
    "npm"           "js-yaml"           "js-yaml"

    # php
    "composer"      "phpcs"             "squizlabs/php_codesniffer"
)

config_maps=(
    "$SRC_DIR/flake8/flake8"  "$TAR_DIR/.config/flake8"
    "$SRC_DIR/tern/tern-config" "$TAR_DIR/.tern-project"
)

for(( i=0; i<${#install_maps[@]}; i=i+3 ))
do
    installer=${install_maps[i]}
    linter=${install_maps[i+1]}
    linter_name=${install_maps[i+2]}
    echo "check $linter exist..."
    if [ -x "$(which "$installer")" ] && [ ! -x "$(which "$linter")" ]; then
        echo "install $linter_name with $installer"
        case $installer in 
            "yaourt")
                yaourt -S "$linter_name"
                ;;
            "pip")
                pip install "$linter_name"
                ;;
            "npm")
                npm install -g "$linter_name"
                ;;
            "composer")
                composer global require "$linter_name"
        esac
    fi
done

linkto () {
    if [ -d $2 -o -f $2 ]
    then
        echo "$2 exist, ignore it..."
        return 1
    fi
    ln -s $1 $2
}

for(( i=0; i<${#config_maps[@]}; i=i+2 ));
do
    src=${config_maps[i]}
    dest=${config_maps[i+1]}
    linkto $src $dest
done

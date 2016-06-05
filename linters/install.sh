#!/bin/bash
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
                sudo pip install "$linter_name"
                ;;
            "npm")
                sudo npm install -g "$linter_name"
                ;;
            "composer")
                composer global require "$linter_name"
        esac
    fi
done

#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${build_platform} == ${target_platform} ]]; then
    go build -buildmode=pie -trimpath -o=${PREFIX}/bin/repocutter -ldflags="-s -w" ./cutter
    go build -buildmode=pie -trimpath -o=${PREFIX}/bin/repomapper -ldflags="-s -w" ./mapper
    go build -buildmode=pie -trimpath -o=${PREFIX}/bin/reposurgeon -ldflags="-s -w" ./surgeon
    go build -buildmode=pie -trimpath -o=${PREFIX}/bin/repotool -ldflags="-s -w" ./tool
else
    make
    make install prefix=${PREFIX}
fi

go-licenses save ./cutter --save_path=license-files_repocutter --ignore github.com/termie/go-shutil
go-licenses save ./mapper --save_path=license-files_repomapper --ignore github.com/termie/go-shutil
go-licenses save ./surgeon --save_path=license-files_reposurgeon --ignore github.com/termie/go-shutil
go-licenses save ./tool --save_path=license-files_repotool --ignore github.com/termie/go-shutil

mkdir -p ${PREFIX}/share/emacs/site-lisp
install -m 644 reposurgeon-mode.el ${PREFIX}/share/emacs/site-lisp/reposurgeon-mode.el

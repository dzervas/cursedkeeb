#!/usr/bin/env bash

set -ex
get_pkg () {
    nix --extra-experimental-features nix-command --extra-experimental-features flakes eval -f '<nixpkgs>' --raw "$1"
}
CC_LIB=$(get_pkg 'stdenv.cc.cc.lib')
ZLIB=$(get_pkg 'zlib')
LIBXML2=$(get_pkg 'libxml2')
GLIBC=$(get_pkg 'glibc')
ALL_LIBS="${CC_LIB}/lib:${ZLIB}/lib:${LIBXML2}/lib:${GLIBC}/lib"

#export LD_LIBRARY_PATH="${ALL_LIBS}:${LD_LIBRARY_PATH}"
NIX_CC=${NIX_CC:-$(nix-shell -p hello --run 'echo $NIX_CC')}
export NIX_CC

fix_paths () {
    file=$1
    if [ -z "$(ldd ${file} 2>/dev/null|grep '=> not found')" ]; then
        set +e
        patchelf --debug \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            ${file}
        set -e
        return
    fi

    toolchain="$(echo ${file}|cut -d '/' -f 6)"
    OLD_PATH="$(patchelf \
        --print-rpath \
        ${file} 2>/dev/null)"
    set +e
    patchelf --debug \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --force-rpath \
        --set-rpath "${HOME}/.rustup/toolchains/${toolchain}/lib:${ALL_LIBS}" \
        ${file} 2>/dev/null
        #--set-rpath "${OLD_PATH}:${HOME}/.rustup/toolchains/${toolchain}/lib:${ALL_LIBS}" \
    set -e
}

for toolchain in esp nightly-x86_64-unknown-linux-gnu; do
    echo "running ${toolchain}"
    #find ${HOME}/.rustup/toolchains/${toolchain} -type f -exec file {} \; | grep -P 'ELF 64-bit LSB( pie)?' | cut -d ':' -f 1 | while read file; do
    while read file; do
        echo ${file}
        INFO=$(file "${file}")
        set +e
        IS_ELF=$(echo ${INFO} | grep 'ELF 64-bit LSB')
        set -e
        if [ -n "${IS_ELF}" ]; then
            echo ${file} ======
            fix_paths "${file}"
        fi
    done < <(find ${HOME}/.rustup/toolchains/${toolchain} -type f)
    echo "done ${toolchain}"
done

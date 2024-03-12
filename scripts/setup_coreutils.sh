#!/bin/bash

bootstrap_coreutils () {
    rm -rf $1
    git clone git://git.sv.gnu.org/coreutils $1
    (
        cd $1
        bash ./bootstrap
    )
}

build_llvm() {
    llvm_dir="${1}/obj-llvm"
    rm -rf $llvm_dir
    mkdir $llvm_dir
    (
        cd $llvm_dir
        export LLVM_COMPILER=clang
        CC=wllvm ../configure --disable-nls CFLAGS="-g -O1 -Xclang -disable-llvm-passes -D__NO_STRING_INLINES  -D_FORTIFY_SOURCE=0 -U__OPTIMIZE__"
        make
        find . -executable -type f | xargs -I '{}' extract-bc '{}'
    )
}

cu_dir="../coreutils"

bootstrap_coreutils $cu_dir
build_llvm $cu_dir

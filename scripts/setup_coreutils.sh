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

    cc_name=clang
    linker_name=llvm-link

    if [ "$2" ]; then
        cc_name+="-${2}"
        linker_name+="-${2}"
    fi

    mkdir $llvm_dir
    (
        cd $llvm_dir
        export LLVM_CC_NAME=$cc_name
        export LLVM_COMPILER=clang
        CC=wllvm ../configure --disable-nls CFLAGS="-g -O1 -Xclang -disable-llvm-passes -D__NO_STRING_INLINES  -D_FORTIFY_SOURCE=0 -U__OPTIMIZE__"
        make
        find . -executable -type f ! -name 'config.status' | xargs -I '{}' extract-bc -l $linker_name '{}'
    )
}

cu_dir="../coreutils"

bootstrap_coreutils $cu_dir
build_llvm $cu_dir 13

echo 'All done!'

#!/usr/bin/env bash

# dynamically determine the path to this package
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

# dynamically take name of package from directory
MASON_NAME=$(basename $(dirname $HERE))
# dynamically take the version of the package from directory
MASON_VERSION=$(basename $HERE)
MASON_LIB_FILE=bin/${MASON_NAME}

. ${MASON_DIR}/mason.sh

function mason_build {
    ${MASON_DIR}/mason install llvm ${MASON_VERSION}
    CLANG_PREFIX=$(${MASON_DIR}/mason prefix llvm ${MASON_VERSION})

    # copy bin
    mkdir -p "${MASON_PREFIX}/bin"
    cp "${CLANG_PREFIX}/bin/${MASON_NAME}" "${MASON_PREFIX}/bin/"
    cp "${CLANG_PREFIX}/bin/clang" "${MASON_PREFIX}/bin/"
    # copy share
    mkdir -p "${MASON_PREFIX}/share"
    cp -r "${CLANG_PREFIX}/share/clang" "${MASON_PREFIX}/share/"
    # copy include/c++
    mkdir -p "${MASON_PREFIX}/include"
    cp -r "${CLANG_PREFIX}/include/c++" "${MASON_PREFIX}/include/"
    # copy libs
    mkdir -p "${MASON_PREFIX}/lib"
    cp -r ${CLANG_PREFIX}/lib/libc++* "${MASON_PREFIX}/lib/"
    cp -r ${CLANG_PREFIX}/lib/libLTO.* "${MASON_PREFIX}/lib/"
    mkdir -p "${MASON_PREFIX}/lib/clang"
    cp -R ${CLANG_PREFIX}/lib/clang/${MASON_VERSION} "${MASON_PREFIX}/lib/clang/"

    # fixup symlinks
    cd "${MASON_PREFIX}/bin/"
    MAJOR_MINOR=$(echo $MASON_VERSION | cut -d '.' -f1-2)
    rm -f "clang++-${MAJOR_MINOR}"
    ln -s "clang++" "clang++-${MAJOR_MINOR}"
    rm -f "clang-${MAJOR_MINOR}"
    ln -s "clang" "clang-${MAJOR_MINOR}"
}

function mason_cflags {
    :
}

function mason_ldflags {
    :
}

function mason_static_libs {
    :
}

mason_run "$@"

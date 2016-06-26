#!/bin/bash
# Set to exit on error
set -e

CWD=$(pwd)
INSTALLATION_DIR="$CWD/deps/libcouchbase/inst/"
UNAME=$(uname)
if [[ $UNAME != "Linux" ]]; then
    echo "Only install Couchbase with SSL support on Linux"
    echo "Default to using regular version of couchbase"
    exit 0
fi

# Test existance of needed utils
REQUIRED=( "git" "cmake" )
for cmd in "${REQUIRED[@]}"; do
    command -v $cmd >/dev/null 2>&1 || { echo >&2 "panoply-couchbase requires $cmd to build but it's not installed. Aborting."; exit 1; }
done

if [[ ! -d "$CWD/deps/libcouchbase" ]]; then
    mkdir -p "$CWD/deps"
    echo "Cloning libcouchbase from github"
    git clone --depth 1 git://github.com/couchbase/libcouchbase.git ./deps/libcouchbase >/dev/null 2>&1
else
    echo "libcouchbase directory already exists. Skipping git clone"
fi

if [[ ! -d "$CWD/deps/libcouchbase/build" ]]; then

    if [[ ! -d "$INSTALLATION_DIR" ]]; then
        echo "Creating installation directory"
        mkdir -p $INSTALLATION_DIR
    fi

    echo "Running configure script"
    cd ./deps/libcouchbase && ./configure.pl --prefix=$INSTALLATION_DIR >/dev/null 2>&1
    echo "Running build"
    (make && make install) >/dev/null 2>&1

else
    echo "Installaton directory already exists. Skipping build"
fi

# Return to root directory
cd $CWD
echo "Using couchbase root: $INSTALLATION_DIR"
echo "Executing: 'npm install --build-from-source --couchbase-root=$INSTALLATION_DIR couchbase@2.1.3'"
npm install --build-from-source --couchbase-root=$INSTALLATION_DIR couchbase@2.1.3

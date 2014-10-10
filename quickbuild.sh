#!/bin/sh
# Build Birdie quickly.

# We need to make our build directory for all of our temp files.
rm -r build
mkdir build

# Enter the build Directory
cd build

# Now we initiate cmake in this dir
cmake ..

# Next we build the source files!
make
./src/gistit

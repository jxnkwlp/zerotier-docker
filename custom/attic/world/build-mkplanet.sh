#!/bin/sh

c++ -std=c++11 -I../.. -I../../ext -I.. -g -o mkplanet ../../node/C25519.cpp ../../node/Salsa20.cpp ../../node/SHA512.cpp ../../node/Identity.cpp ../../node/Utils.cpp ../../node/InetAddress.cpp ../../osdep/OSUtils.cpp mkplanet.cpp -lm
if [ $? -ne 0 ]; then
    echo "Error: Failed to build mkplanet"
    exit 1
fi

echo "Build mkplanet completed."

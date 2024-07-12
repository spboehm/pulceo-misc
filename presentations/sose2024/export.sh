#!/bin/sh
PORT=$1
docker run --rm -t --network host -v `pwd`:/slides astefanutti/decktape reveal -s 1280x800 http://localhost:$PORT/sose2024.html#/title-slide sose2024-full.pdf
docker run --rm -t --network host -v `pwd`:/slides astefanutti/decktape reveal -s 1280x800 --slides 1-28 http://localhost:$PORT/sose2024.html#/title-slide sose2024.pdf
mv sose2024-full.pdf ../../docs/presentations/sose2024/sose2024-full.pdf
mv sose2024.pdf ../../docs/presentations/sose2024/sose2024.pdf
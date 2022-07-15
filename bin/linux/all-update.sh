#!/bin/sh

cd "$(dirname "$0")" || exit 1
pwd=$(pwd)

"$pwd"/apt-update.sh
"$pwd"/brew-update.sh
zprezto-update

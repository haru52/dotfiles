#!/bin/sh

case $(uname) in
  "Darwin") os="mac" ;;
  "Linux") os="linux" ;;
  *) exit 1 ;;
esac

echo $os

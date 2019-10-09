#!/usr/bin/env bash

set -e

ACTION=$1
ENV=$2

set -o allexport
[[ -f .env.local ]] && source .env.local
set +o allexport

echo "Verifying VirtualBox installed"
if ! [ -x "$(command -v VBoxManage)" ]; then
  echo 'Error: VirtualBox is not installed.'
  exit 1
fi

echo "Verifying VirtualBox supported version"
if [ "$(virtualbox --help | head -n 1 | awk '{print $NF}')" != "v6.0.12" ]; then
  echo 'Error: Unsupported VirtualBox version'
  exit 1
fi

echo "Verifying vagrant installed"
if ! [ -x "$(command -v vagrant)" ]; then
  echo 'Error: vagrant is not installed.'
  exit 1
fi

./build.sh

if [ "$ACTION" == "up" ]; then

  vagrant box update
  vagrant box prune
  vagrant destroy -f $ENV
  vagrant up $ENV
  # ./test/test.py

elif [ "$ACTION" == "destroy" ]; then

  vagrant destroy -f $ENV

fi
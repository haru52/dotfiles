#!/bin/bash

cd "$(dirname "$0")" || exit 1

repo_root_path=$(pwd)

# dotfiles
dotfiles_path=${repo_root_path}/dotfiles

os=$("${repo_root_path}"/get-os.sh)

# https://www.shellcheck.net/wiki/SC2207
ls_dotfiles=()
while IFS='' read -r line; do ls_dotfiles+=("${line}"); done < <(ls -A "${dotfiles_path}")

for file_name in "${ls_dotfiles[@]}"; do
  file_path=${dotfiles_path}/${file_name}
  if [[ -f "${file_path}" ]]; then
    ln -sfv "${file_path}" ~
  fi
done

# Zsh
cp -fv "${dotfiles_path}"/zprezto/* ~/.zprezto/runcoms
# TODO: etcというディレクトリ名など色々と適当なのでもう少し整理する
cp -fv "${dotfiles_path}"/etc/alias.zsh ~/.zprezto/modules/git

# OS specific installation

# WSL2 Linux
wsl_dotfiles_path=${dotfiles_path}/wsl

# WSL specific config
# TODO: Add some conditions to determine that the environment is WSL2
if [[ "${os}" = linux ]]; then
  sudo ln -sfv "${wsl_dotfiles_path}"/wsl.conf /etc/wsl.conf
  sudo ln -sfv "${wsl_dotfiles_path}"/resolv_template.conf /etc/resolv_template.conf
fi

# Custom commands
mkdir -p ~/bin

# Install scripts from bin directory (excluding linux subdirectory)
bin_path=${repo_root_path}/bin
if [[ -d "${bin_path}" ]]; then
  for script in "${bin_path}"/*.sh; do
    if [[ -f "${script}" ]]; then
      script_name=$(basename "${script}" .sh)
      ln -sfv "${script}" ~/bin/"${script_name}"
    fi
  done
fi

# Install scripts from private_bin directory
private_bin_path=${repo_root_path}/private_bin
if [[ -d "${private_bin_path}" ]]; then
  for script in "${private_bin_path}"/*.sh; do
    if [[ -f "${script}" ]]; then
      script_name=$(basename "${script}" .sh)
      ln -sfv "${script}" ~/bin/"${script_name}"
    fi
  done
fi

if [[ "${os}" = linux ]]; then
  ln -sfv "${bin_path}"/linux/apt-update.sh ~/bin/apt-update
fi

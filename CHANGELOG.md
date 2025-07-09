## 0.1.4

* chore: update installers
* chore(nvim): update lazy-lock
* feat(nvim): spellcheck <https://waylonwalker.com/my-nvim-spellcheck-setup/>
* feat(nvim): wayland clipboard support
* feat(container): wayland clipboard support
* feat(container): add podman-compose
* feat(container): add neofetch
* feat(container): add /usr/local/bin/aws for aws cli v2
* feat(zsh): add gi git ignore tool
* feat(templates): add daily and glossary templates

## 0.1.3

* fix npm install directory
* versioned distrobox.ini
* converted from python3.11 image to ubuntu:24.04
* updated nvim to v0.11.0
* update installers
* add date keymap for nvim

## 0.1.2

* update installers
* add minio client `mc`
* setup `slim_install.sh`
* add nvim-manager starship prompt
* use uv for `venv` alias
* enable nvidia on devtainer distrobox for use with ollama
* add ghostty distrobox
* fix Dockerfile
* add syntax highlighting for `Containerfile` in nvim
* add just testnvim to run quick local tests of a fresh nvim install

## 0.1.1

* update installers
* add gh extension gh-dash
* add NVIM_APPNAME to starship
* update venv alias to not echo error if venv doesn't exist
* add s3-cleanup one-shot-app
* add clock one-shot-app
* install one-shot-apps in container

## 0.1.0

* add tailscale and fuser host commands to devtainer distrobox
* update installers
* installer is done in justfile, not in alias
* fix missing batcat
* configure nvim-manager in zshrc
* devtainer builds now have a semver version defined in `version` file

## 0.0.0

After years of not tagging, versioning or logging, let's start doing things right.

#!/usr/bin/env bash
set -e
set -o pipefail
set -u
/installer/BurntSushi_ripgrep.sh
/installer/MordechaiHadad_bob.sh
/installer/Slackadays_Clipboard.sh
/installer/atuinsh_atuin.sh
/installer/bitnami-labs_sealed-secrets.sh
/installer/bootandy_dust.sh
/installer/casey_just.sh
/installer/cli_cli.sh
/installer/dalance_procs.sh
/installer/dbrgn_tealdeer.sh
/installer/derailed_k9s.sh
/installer/ducaale_xh.sh
/installer/extrawurst_gitui.sh
/installer/eza-community_eza.sh
/installer/gokcehan_lf.sh
/installer/jesseduffield_lazydocker.sh
/installer/jesseduffield_lazygit.sh
/installer/johanhaleby_kubetail.sh
/installer/jqlang_jq.sh
/installer/mgdm_htmlq.sh
/installer/starship_starship.sh
/installer/svenstaro_miniserve.sh
/installer/sxyazi_yazi.sh
/installer/argoproj_argo-cd.sh
/installer/waylonwalker_nvim-manager.sh
/installer/install_kubectl.sh
/installer/install_helm.sh

curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o /home/waylon/minio-binaries/mc

chmod +x /home/waylon/minio-binaries/mc
export PATH=/home/waylon/.local/share/bob/nvim-bin:/home/waylon/.fly/bin:/home/waylon/.cargo/bin:/home/waylon/go/bin:/home/waylon/.local/bin:/home/waylon/.local/.npm-global/bin/:/home/waylon/.npm/node_modules/bin/:/home/waylon/.atuin/bin:/home/waylon/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/waylon/minio-binaries:/root/.local/share/nvim/plugged/fzf/bin}:/home/waylon/minio-binaries/

mc --help

mv cli gh
mv tealdeer tldr
tldr --update
mv sealed-secrets kubeseal

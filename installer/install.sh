#!/usr/bin/env bash
set -e
/installer/BurntSushi_ripgrep.sh
/installer/MordechaiHadad_bob.sh
/installer/Slackadays_Clipboard.sh
/installer/atuinsh_atuin.sh
/installer/avencera_rustywind.sh
/installer/bcicen_ctop.sh
/installer/benbjohnson_litestream.sh
/installer/bitnami-labs_sealed-secrets.sh
/installer/bootandy_dust.sh
/installer/casey_just.sh
/installer/charmbracelet_vhs.sh
/installer/chmln_sd.sh
/installer/cjbassi_ytop.sh
/installer/cli_cli.sh
/installer/dalance_procs.sh
/installer/dbrgn_tealdeer.sh
/installer/derailed_k9s.sh
/installer/ducaale_xh.sh
/installer/extrawurst_gitui.sh
/installer/eza-community_eza.sh
/installer/go-task_task.sh
/installer/gokcehan_lf.sh
/installer/homeport_termshot.sh
/installer/imsnif_bandwhich.sh
/installer/imsnif_diskonaut.sh
/installer/jesseduffield_lazydocker.sh
/installer/jesseduffield_lazygit.sh
/installer/jmorganca_ollama.sh
/installer/johanhaleby_kubetail.sh
/installer/jqlang_jq.sh
/installer/mgdm_htmlq.sh
/installer/nats-io_nats-server.sh
/installer/nats-io_natscli.sh
/installer/neovim_neovim.sh
/installer/ogham_dog.sh
/installer/packwiz_packwiz.sh
/installer/pemistahl_grex.sh
/installer/sharkdp_pastel.sh
/installer/sirwart_ripsecrets.sh
/installer/starship_starship.sh
/installer/svenstaro_miniserve.sh
/installer/sxyazi_yazi.sh
/installer/topgrade-rs_topgrade.sh
/installer/twpayne_chezmoi.sh
/installer/zellij-org_zellij.sh
/installer/argoproj_argo-cd.sh
/installer/waylonwalker_nvim-manager.sh
/installer/install_terraform.sh
/installer/install_kubectl.sh
/installer/install_helm.sh
mv cli gh
mv tealdeer tldr
mv natscli nats
tldr --update
mv sealed-secrets kubeseal

if [[ -f /usr/bin/batcat ]]; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi
if [[ -f /usr/bin/fdfind ]]; then
    ln -s /usr/bin/fdfind ~/.local/bin/fd
fi


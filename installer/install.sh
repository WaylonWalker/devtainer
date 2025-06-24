#!/usr/bin/env bash
set -e
set -o pipefail
set -u
safe_mv() {
	src=$1 dest=$2
	[ -e "$src" ] || return 0
	if mv "$src" "$dest" 2>/dev/null; then
		return 0
	fi

	# plain mv failed → try with sudo if it exists
	if command -v sudo >/dev/null 2>&1; then
		sudo mv "$src" "$dest"
	else
		echo "Error: mv $src → $dest failed (permission denied), and sudo not found." >&2
		exit 1
	fi
}
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
/installer/install_kubectl.sh
/installer/install_helm.sh
/installer/install_ollama.sh

# https://min.io/docs/minio/linux/reference/minio-mc.html
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
--create-dirs \
-o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc --help

/installer/install_windsurf.sh
mv cli gh
mv tealdeer tldr
mv natscli nats
tldr --update
mv sealed-secrets kubeseal

if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi
if [[ -f /usr/bin/batcat ]]; then
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi
if [[ -f /usr/bin/fdfind ]]; then
    ln -s /usr/bin/fdfind ~/.local/bin/fd
fi


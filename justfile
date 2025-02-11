export registry := "docker.io"
export repository := "waylonwalker"
export ntfy_url := "https://ntfy.wayl.one"
export ntfy_channel := "deployments"
export docker := "podman"
export DATE_TAG := `date +%Y%m%d%H%M%S`
export version := `cat version`

default:
  @just --choose

build-deploy: build deploy

build: build-latest build-alpine build-slim
deploy: deploy-latest deploy-alpine deploy-slim

login:
    podman login {{ registry }}/{{ repository }}/devtainer

latest: build-latest deploy-latest
alpine: build-alpine deploy-alpine
slim: build-slim deploy-slim


build-latest:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo building latest
    echo building ${DATE_TAG}
    echo building ${version}


    {{ docker }} build -f docker/Dockerfile -t {{ registry }}/{{ repository }}/devtainer:latest -t {{ registry }}/{{ repository }}/devtainer:${DATE_TAG} -t {{ registry }}/{{ repository }}/devtainer:${version} .

deploy-latest: build-latest
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing ${DATE_TAG}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:${DATE_TAG}
    echo pushing ${version}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:${version}
    echo pushing latest
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:latest
    curl -d "released devtainer:latest and devtainer:${DATE_TAG}" {{ ntfy_url }}/{{ ntfy_channel }}
    
build-alpine:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} build -f docker/Dockerfile.alpine -t {{ registry }}/{{ repository }}/devtainer:alpine .

deploy-alpine:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:alpine
    curl -d "released devtainer:alpine" {{ ntfy_url }}/{{ ntfy_channel }}

build-kdenlive:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} build -f docker/Dockerfile.kdenlive -t {{ registry }}/{{ repository }}/kdenlive .

deploy-kdenlive:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} push {{ registry }}/{{ repository }}/kdenlive
    curl -d "released devtainer:kdenlive" {{ ntfy_url }}/{{ ntfy_channel }}

build-nautilus:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} build -f docker/Dockerfile.nautilus -t {{ registry }}/{{ repository }}/nautilus .
    {{ docker }} push {{ registry }}/{{ repository }}/nautilus
    curl -d "released devtainer:nautilus" {{ ntfy_url }}/{{ ntfy_channel }}

build-thunar:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} build -f docker/Dockerfile.thunar -t {{ registry }}/{{ repository }}/thunar .
    {{ docker }} push {{ registry }}/{{ repository }}/thunar
    curl -d "released devtainer:thunar" {{ ntfy_url }}/{{ ntfy_channel }}


deploy-fokais:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} tag {{ registry }}/{{ repository }}/devtainer:alpine registry.fokais.com/devtainer:alpine
    {{ docker }} tag {{ registry }}/{{ repository }}/devtainer:slim registry.fokais.com/devtainer:slim
    {{ docker }} push registry.fokais.com/devtainer:alpine
    {{ docker }} push registry.fokais.com/devtainer:slim

build-slim:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} build -f docker/Dockerfile.slim -t {{ registry }}/{{ repository }}/devtainer:slim .
deploy-slim:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:slim
    curl -d "released devtainer:slim to https://registry-ui.wayl.one/#!/taglist/devtainer" {{ ntfy_url }}/{{ ntfy_channel }}


update-installers:
    #!/usr/bin/env bash
    set -euxo pipefail

    slim_progs="
    BurntSushi/ripgrep
    MordechaiHadad/bob
    Slackadays/Clipboard
    atuinsh/atuin
    bitnami-labs/sealed-secrets 
    bootandy/dust
    casey/just
    cli/cli
    dalance/procs
    dbrgn/tealdeer
    derailed/k9s
    ducaale/xh
    extrawurst/gitui
    eza-community/eza
    gokcehan/lf
    jesseduffield/lazydocker
    jesseduffield/lazygit
    johanhaleby/kubetail
    jqlang/jq
    mgdm/htmlq
    starship/starship
    svenstaro/miniserve
    sxyazi/yazi
    argoproj/argo-cd
    waylonwalker/nvim-manager
    "

    i_progs="
    BurntSushi/ripgrep
    MordechaiHadad/bob
    Slackadays/Clipboard
    atuinsh/atuin
    avencera/rustywind
    bcicen/ctop
    benbjohnson/litestream
    bitnami-labs/sealed-secrets 
    bootandy/dust
    casey/just
    charmbracelet/vhs
    chmln/sd
    cjbassi/ytop
    cli/cli
    dalance/procs
    dbrgn/tealdeer
    derailed/k9s
    ducaale/xh
    extrawurst/gitui
    eza-community/eza
    go-task/task
    gokcehan/lf
    homeport/termshot
    imsnif/bandwhich
    imsnif/diskonaut
    jesseduffield/lazydocker
    jesseduffield/lazygit
    johanhaleby/kubetail
    jqlang/jq
    mgdm/htmlq
    nats-io/nats-server
    nats-io/natscli
    neovim/neovim
    ogham/dog
    packwiz/packwiz
    pemistahl/grex
    sharkdp/pastel
    sirwart/ripsecrets
    starship/starship
    svenstaro/miniserve
    sxyazi/yazi
    topgrade-rs/topgrade
    twpayne/chezmoi
    zellij-org/zellij
    argoproj/argo-cd
    waylonwalker/nvim-manager
    "

    rm -rf installer
    mkdir installer
    touch installer/install.sh
    # setup install.sh
    echo "#!/usr/bin/env bash" >> installer/install.sh
    echo "set -e" >> installer/install.sh
    echo "set -o pipefail" >> installer/install.sh
    echo "set -u" >> installer/install.sh
    echo ""
    echo "#install installers"

    # setup install_slim.sh
    echo "#!/usr/bin/env bash" >> installer/install_slim.sh
    echo "set -e" >> installer/install_slim.sh
    echo "set -o pipefail" >> installer/install_slim.sh
    echo "set -u" >> installer/install_slim.sh
    echo ""
    echo "#install installers"

    chmod +x installer/install.sh
    chmod +x installer/install_slim.sh

    for i_prog in $i_progs; do
        file=`echo $i_prog | sed 's/\//_/g'`
        curl https://i.wayl.one/$i_prog > installer/$file.sh
        chmod +x installer/$file.sh
        echo "/installer/$file.sh" >> installer/install.sh
        # if its in the slim list then add it to install_slim.sh
        if [[ $slim_progs =~ $i_prog ]]; then
            echo "/installer/$file.sh" >> installer/install_slim.sh
        fi
    done

    echo "

    # install terraform
    curl https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o terraform.zip
    unzip terraform.zip
    chmod +x terraform
    if [ "$PWD" != "/usr/local/bin" ]; then
        mv terraform /usr/local/bin
    fi
    " > installer/install_terraform.sh
    chmod +x installer/install_terraform.sh

    # disable terraform
    # echo "/installer/install_terraform.sh" >> installer/install.sh

    # install kubectl
    echo 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"' > installer/install_kubectl.sh
    chmod 700 installer/install_kubectl.sh

    echo "/installer/install_kubectl.sh" >> installer/install.sh
    echo "/installer/install_kubectl.sh" >> installer/install_slim.sh

    curl -fsSL -o installer/install_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 installer/install_helm.sh
    echo "/installer/install_helm.sh" >> installer/install.sh
    echo "/installer/install_helm.sh" >> installer/install_slim.sh

    curl -fsSL -o installer/install_ollama.sh https://ollama.com/install.sh
    chmod 700 installer/install_ollama.sh
    echo "/installer/install_ollama.sh" >> installer/install.sh


    echo '
    # https://min.io/docs/minio/linux/reference/minio-mc.html
    curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc

    chmod +x $HOME/minio-binaries/mc
    export PATH=$PATH:$HOME/minio-binaries/

    mc --help
    ' >> installer/install.sh

    echo "
    curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc

    chmod +x $HOME/minio-binaries/mc
    export PATH=$PATH:$HOME/minio-binaries/

    mc --help
    " >> installer/install_slim.sh


    # install windsurf
    curl -fsSL -o installer/windsurf.gpg "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg"
    echo '
    sudo gpg --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg /installer/windsurf.gpg
    echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
    ' >> installer/install_windsurf.sh
    chmod 700 installer/install_windsurf.sh
    echo "/installer/install_windsurf.sh" >> installer/install.sh

    echo "mv cli gh" >> installer/install.sh
    echo "mv cli gh" >> installer/install_slim.sh
    echo "mv tealdeer tldr" >> installer/install.sh
    echo "mv tealdeer tldr" >> installer/install_slim.sh
    echo "mv natscli nats" >> installer/install.sh
    echo "tldr --update" >> installer/install.sh
    echo "tldr --update" >> installer/install_slim.sh
    echo "mv sealed-secrets kubeseal" >> installer/install.sh
    echo "mv sealed-secrets kubeseal" >> installer/install_slim.sh
    # echo "gh extension install dlvhdr/gh-dash" >> installer/install.sh






    echo "
    if [[ ! -d ~/.local/bin ]]; then
        mkdir -p ~/.local/bin
    fi
    if [[ -f /usr/bin/batcat ]]; then
        ln -s /usr/bin/batcat ~/.local/bin/bat
    fi
    if [[ -f /usr/bin/fdfind ]]; then
        ln -s /usr/bin/fdfind ~/.local/bin/fd
    fi
    " >> installer/install.sh




    curl -L https://bit.ly/n-install > installer/n.sh
    chmod +x installer/n.sh

distrobox-assemble:
    #!/usr/bin/env bash
    set -euxo pipefail
    distrobox-assemble create --file distrobox/distrobox.ini

delete-tag:
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Get the version
    VERSION=$(cat version)
    
    # Delete the tag
    git tag -d "v$VERSION"
    git push origin ":refs/tags/v$VERSION"

create-tag:
    #!/usr/bin/env bash
    VERSION=$(cat version)
    git tag -a "v$VERSION" -m "Release v$VERSION"
    git push origin "v$VERSION"

testnvim:
    rm ~/.cache/wwtest -rf
    rm ~/.local/share/wwtest -rf
    rm ~/.config/wwtest -rf
    cp -r nvim/.config/nvim/ ~/.config/wwtest
    NVIM_APPNAME=wwtest nvim --headless "+Lazy sync" +qa
    NVIM_APPNAME=wwtest nvim --headless "+TSUpdateSync" "+sleep 5000m" +qa
    NVIM_APPNAME=wwtest nvim --headless "+MasonUpdate" +qa
    NVIM_APPNAME=wwtest nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue just" +qa
    NVIM_APPNAME=wwtest nvim --headless "+MasonInstall lua-language-server rustywind ruff ruff-lsp html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa
    NVIM_APPNAME=wwtest nvim

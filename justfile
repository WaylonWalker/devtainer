export registry := "ghcr.io"
export repository := "waylonwalker"
export ntfy_url := "https://ntfy.wayl.one"
export ntfy_channel := "deployments"
export docker := "podman"
export DATE_TAG := `date +%Y%m%d%H%M%S`
export version := `cat version`

default:
  @just --choose

setup-cursors:
    #!/usr/bin/env bash
    set -euxo pipefail
    ./scripts/setup-user-cursor.sh
    sudo ./scripts/setup-system-cursor.sh

build-deploy: build deploy

build: build-latest build-alpine build-alpine-slim build-slim build-arch-base build-arch build-arch-slim
deploy: deploy-latest deploy-alpine deploy-alpine-slim deploy-slim deploy-arch deploy-arch-slim

login:
    podman login {{ registry }}

login-ghcr:
    gh auth token | podman login ghcr.io -u waylonwalker --password-stdin

latest: build-latest deploy-latest
alpine: build-alpine deploy-alpine
alpine-slim: build-alpine-slim deploy-alpine-slim
slim: build-slim deploy-slim
arch: build-arch deploy-arch
arch-slim: build-arch-slim deploy-arch-slim

build-arch-base:
    #!/usr/bin/env bash
    set -euxo pipefail
    {{ docker }} build -f docker/Dockerfile.arch-base -t {{ registry }}/{{ repository }}/devtainer:arch-base .

build-arch: build-arch-base
    #!/usr/bin/env bash
    set -euxo pipefail
    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile.arch-mise \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:arch \
        -t {{ registry }}/{{ repository }}/devtainer:arch-{{ DATE_TAG }} \
        -t {{ registry }}/{{ repository }}/devtainer:arch-{{ version }} \
        .

build-arch-slim: build-arch-base
    #!/usr/bin/env bash
    set -euxo pipefail
    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile.arch-slim \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:arch-slim \
        -t {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ DATE_TAG }} \
        -t {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ version }} \
        .

deploy-arch: build-arch
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing {{ registry }}/{{ repository }}/devtainer:arch-{{ DATE_TAG }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-{{ DATE_TAG }}
    echo pushing {{ registry }}/{{ repository }}/devtainer:arch-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-{{ version }}
    echo pushing {{ registry }}/{{ repository }}/devtainer:arch
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch
    curl -d "released devtainer:arch ({{ DATE_TAG }})" {{ ntfy_url }}/{{ ntfy_channel }}

deploy-arch-slim: build-arch-slim
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ DATE_TAG }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ DATE_TAG }}
    echo pushing {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-slim-{{ version }}
    echo pushing {{ registry }}/{{ repository }}/devtainer:arch-slim
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-slim
    curl -d "released devtainer:arch-slim ({{ DATE_TAG }})" {{ ntfy_url }}/{{ ntfy_channel }}

build-bambu: build-arch-base
    #!/usr/bin/env bash
    set -euxo pipefail
    DATE_TAG=`date +%Y%m%d%H%M%S`
    VERSION_TAG=`cat version`
    {{ docker }} build \
        -f docker/Dockerfile.arch-bambu \
        -t {{ registry }}/{{ repository }}/devtainer:arch-bambu \
        -t {{ registry }}/{{ repository }}/devtainer:arch-bambu-${DATE_TAG} \
        -t {{ registry }}/{{ repository }}/devtainer:arch-bambu-${VERSION_TAG} \
        .
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-bambu
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-bambu-${DATE_TAG}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:arch-bambu-${VERSION_TAG}

build-latest:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo building latest
    echo building ${DATE_TAG}
    echo building ${version}


    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:latest \
        -t {{ registry }}/{{ repository }}/devtainer:${DATE_TAG} \
        -t {{ registry }}/{{ repository }}/devtainer:${version} \
        .

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

    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile.alpine \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:alpine \
        -t {{ registry }}/{{ repository }}/devtainer:alpine-{{ version }} \
        .

build-alpine-slim:
    #!/usr/bin/env bash
    set -euxo pipefail

    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile.alpine-slim \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:alpine-slim \
        -t {{ registry }}/{{ repository }}/devtainer:alpine-slim-{{ version }} \
        .

deploy-alpine: build-alpine
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing {{ registry }}/{{ repository }}/devtainer:alpine-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:alpine-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:alpine
    curl -d "released devtainer:alpine" {{ ntfy_url }}/{{ ntfy_channel }}

deploy-alpine-slim: build-alpine-slim
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing {{ registry }}/{{ repository }}/devtainer:alpine-slim-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:alpine-slim-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:alpine-slim
    curl -d "released devtainer:alpine-slim" {{ ntfy_url }}/{{ ntfy_channel }}

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
    {{ docker }} tag {{ registry }}/{{ repository }}/devtainer:alpine-slim registry.fokais.com/devtainer:alpine-slim
    {{ docker }} tag {{ registry }}/{{ repository }}/devtainer:slim registry.fokais.com/devtainer:slim
    {{ docker }} push registry.fokais.com/devtainer:alpine
    {{ docker }} push registry.fokais.com/devtainer:alpine-slim
    {{ docker }} push registry.fokais.com/devtainer:slim

build-slim:
    #!/usr/bin/env bash
    set -euxo pipefail

    GITHUB_TOKEN="$(gh auth token)" \
    {{ docker }} build \
        -f docker/Dockerfile.slim \
        --secret id=gh_token,env=GITHUB_TOKEN \
        -t {{ registry }}/{{ repository }}/devtainer:slim \
        -t {{ registry }}/{{ repository }}/devtainer:slim-{{ version }} \
        .
deploy-slim: build-slim
    #!/usr/bin/env bash
    set -euxo pipefail

    echo pushing {{ registry }}/{{ repository }}/devtainer:slim-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:slim-{{ version }}
    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:slim
    curl -d "released devtainer:slim to https://registry-ui.wayl.one/#!/taglist/devtainer" {{ ntfy_url }}/{{ ntfy_channel }}


update-installers:
    #!/usr/bin/env bash
    set -euxo pipefail

    slim_progs="
    BurntSushi/ripgrep
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
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer && \
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer-arch && \
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer-slim && \
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer-alpine && \
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer-arch-slim && \
    distrobox-assemble create --file distrobox/distrobox.ini --name devtainer-alpine-slim

distrobox-assemble-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    distrobox-assemble create --file distrobox/distrobox.ini

delete-tag:
    #!/usr/bin/env bash
    set -euo pipefail
    VERSION=$(cat version)
    git tag -d "v$VERSION"
    git push origin ":refs/tags/v$VERSION"

create-tag:
    #!/usr/bin/env bash
    set -euo pipefail
    VERSION=$(cat version)
    if git rev-parse "v$VERSION" >/dev/null 2>&1; then
        echo "Error: Tag v$VERSION already exists."
    else
        echo "Creating tag v$VERSION"
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
    fi

preview-release:
    #!/usr/bin/env bash
    VERSION=$(cat version)
    ./scripts/get_release_notes.py "$VERSION" > release_notes.tmp.md
    cat release_notes.tmp.md
    rm release_notes.tmp.md
    if ! git rev-parse "v$VERSION" >/dev/null 2>&1; then
        echo "Error: Tag v$VERSION does not exist."
        exit 1
    else
        echo "Tag v$VERSION exists. Ready for release"
    fi

create-release:
    #!/usr/bin/env bash
    VERSION=$(cat version)
    ./scripts/get_release_notes.py "$VERSION" > release_notes.tmp.md
    gh release create "v$VERSION" \
        --title "v$VERSION" \
        --notes-file release_notes.tmp.md
    rm release_notes.tmp.md

delete-release:
    #!/usr/bin/env bash
    set -euo pipefail
    VERSION=$(cat version)
    gh release delete "v$VERSION"


testnvim:
    rm ~/.cache/wwtest -rf
    rm ~/.local/share/wwtest -rf
    rm ~/.config/wwtest -rf
    cp -r nvim/.config/nvim/ ~/.config/wwtest
    # NVIM_APPNAME=wwtest nvim --headless "+Lazy sync" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+TSUpdateSync" "+sleep 5000m" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+MasonUpdate" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue just" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+MasonInstall lua-language-server rustywind ruff ruff-lsp html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa
    NVIM_APPNAME=wwtest nvim

extract-keymaps:
    # Extract keybindings from all environments
    ./scripts/extract_keymaps.py

gen-keybinding-pages:
    # Generate markdown pages from extracted keybindings
    ./scripts/gen_keybinding_pages.sh

update-keybindings:
    # Full refresh: extract and generate pages
    ./scripts/extract_nvimmappings.sh
    ./scripts/gen_keybinding_pages.sh
    rm ~/.cache/wwtest -rf
    rm ~/.local/share/wwtest -rf
    rm ~/.config/wwtest -rf
    cp -r nvim/.config/nvim/ ~/.config/wwtest
    # NVIM_APPNAME=wwtest nvim --headless "+Lazy sync" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+TSUpdateSync" "+sleep 5000m" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+MasonUpdate" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+TSInstallSync! c cpp go lua python rust tsx javascript typescript vimdoc vim bash yaml toml vue just" +qa
    # NVIM_APPNAME=wwtest nvim --headless "+MasonInstall lua-language-server rustywind ruff ruff-lsp html-lsp typescript-language-server beautysh fixjson isort markdownlint stylua yamlfmt python-lsp-server" +qa
    NVIM_APPNAME=wwtest nvim

# VHS recording commands
record-tapes:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo "Recording all VHS tapes..."
    for tape in static/tapes/*.tape; do
        if [ -f "$tape" ]; then
            echo "Recording: $tape"
            vhs < "$tape"
        fi
    done
    echo "All tapes recorded!"

record-tape TAPE:
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -f "static/tapes/{{ TAPE }}.tape" ]; then
        echo "Recording: static/tapes/{{ TAPE }}.tape"
        vhs < "static/tapes/{{ TAPE }}.tape"
    else
        echo "Tape not found: static/tapes/{{ TAPE }}.tape"
        exit 1
    fi

list-tapes:
    #!/usr/bin/env bash
    echo "Available VHS tapes:"
    for tape in static/tapes/*.tape; do
        if [ -f "$tape" ]; then
            basename "$tape" .tape
        fi
    done

build-site:
    markata-go build

build-devtainer-cli:
    #!/usr/bin/env bash
    set -euxo pipefail
    mkdir -p bin
    go build -ldflags "-X main.version={{ version }}" -o bin/devtainer ./cmd/devtainer

install-devtainer-cli:
    #!/usr/bin/env bash
    set -euxo pipefail
    mkdir -p "$HOME/.local/bin"
    go build -ldflags "-X main.version={{ version }}" -o "$HOME/.local/bin/devtainer" ./cmd/devtainer

build-devtainer-release:
    #!/usr/bin/env bash
    set -euxo pipefail
    out_dir="dist/devtainer/{{ version }}"
    rm -rf "$out_dir"
    mkdir -p "$out_dir"
    for target in linux/amd64 linux/arm64 darwin/amd64 darwin/arm64; do \
        GOOS="${target%/*}"; \
        GOARCH="${target#*/}"; \
        work_dir="$(mktemp -d)"; \
        GOOS="$GOOS" GOARCH="$GOARCH" CGO_ENABLED=0 go build -ldflags "-X main.version={{ version }}" -o "$work_dir/devtainer" ./cmd/devtainer; \
        tar -C "$work_dir" -czf "$out_dir/devtainer_${GOOS}_${GOARCH}.tar.gz" devtainer; \
        rm -rf "$work_dir"; \
    done
    cp scripts/install-devtainer-cli.sh "$out_dir/devtainer-install.sh"
    chmod +x "$out_dir/devtainer-install.sh"
    (cd "$out_dir" && sha256sum ./* > checksums.txt)

upload-devtainer-release-assets TAG="{{ version }}": build-devtainer-release
    #!/usr/bin/env bash
    set -euxo pipefail
    gh release upload "{{ TAG }}" dist/devtainer/{{ version }}/* --clobber

devtainer-config-init PROFILE="personal": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    "$HOME/.local/bin/devtainer" config init --profile "{{ PROFILE }}"

devtainer-profile-add PROFILE CLONE="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -n "{{ CLONE }}" ]; then
        "$HOME/.local/bin/devtainer" profile add "{{ PROFILE }}" --clone "{{ CLONE }}"
    else
        "$HOME/.local/bin/devtainer" profile add "{{ PROFILE }}"
    fi

devtainer-profile-use PROFILE: install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    "$HOME/.local/bin/devtainer" profile use "{{ PROFILE }}"

devtainer-profile-set-item PROFILE SLOT ITEM: install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    "$HOME/.local/bin/devtainer" profile set-item "{{ PROFILE }}" "{{ SLOT }}" "{{ ITEM }}"

devtainer-argocd-login SERVER PROFILE="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -n "{{ PROFILE }}" ]; then
        "$HOME/.local/bin/devtainer" setup --profile "{{ PROFILE }}" argocd
    else
        "$HOME/.local/bin/devtainer" setup argocd
    fi
    argocd login "{{ SERVER }}"

devtainer-bootstrap TOOL="all" PROFILE="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -n "{{ PROFILE }}" ]; then
        "$HOME/.local/bin/devtainer" bootstrap bitwarden --profile "{{ PROFILE }}" "{{ TOOL }}"
    else
        "$HOME/.local/bin/devtainer" bootstrap bitwarden "{{ TOOL }}"
    fi

devtainer-setup TOOL PROFILE="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ -n "{{ PROFILE }}" ]; then
        "$HOME/.local/bin/devtainer" setup --profile "{{ PROFILE }}" "{{ TOOL }}"
    else
        "$HOME/.local/bin/devtainer" setup "{{ TOOL }}"
    fi

devtainer-doctor TOOL="all" PROFILE="" FIX="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    extra_args=()
    if [ -n "{{ FIX }}" ]; then
        extra_args+=(--fix)
    fi
    if [ -n "{{ PROFILE }}" ]; then
        "$HOME/.local/bin/devtainer" doctor --profile "{{ PROFILE }}" "${extra_args[@]}" "{{ TOOL }}"
    else
        "$HOME/.local/bin/devtainer" doctor "${extra_args[@]}" "{{ TOOL }}"
    fi

devtainer-update TOOL ARTIFACT="" PROFILE="": install-devtainer-cli
    #!/usr/bin/env bash
    set -euxo pipefail
    cmd=("$HOME/.local/bin/devtainer" update)
    if [ -n "{{ PROFILE }}" ]; then
        cmd+=(--profile "{{ PROFILE }}")
    fi
    if [ -n "{{ ARTIFACT }}" ]; then
        cmd+=(--artifact "{{ ARTIFACT }}")
    fi
    cmd+=("{{ TOOL }}")
    "${cmd[@]}"

sync:
    rsync -av --delete ./output/ falcon3:/mnt/main/walkershare/waylon/sites/dots.waylonwalker.com

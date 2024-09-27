export registry := "docker.io"
export repository := "waylonwalker"
export ntfy_url := "https://ntfy.wayl.one"
export ntfy_channel := "deployments"
export docker := "podman"

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

    {{ docker }} build -f docker/Dockerfile -t {{ registry }}/{{ repository }}/devtainer:latest .

deploy-latest:
    #!/usr/bin/env bash
    set -euxo pipefail

    {{ docker }} push {{ registry }}/{{ repository }}/devtainer:latest
    curl -d "released devtainer" {{ ntfy_url }}/{{ ntfy_channel }}

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

    i_progs="
    BurntSushi/ripgrep
    MordechaiHadad/bob
    Slackadays/Clipboard
    atuinsh/atuin
    avencera/rustywind
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
    jmorganca/ollama
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
    "
    rm -rf installer
    mkdir installer
    touch installer/install.sh
    echo "#!/usr/bin/env bash" >> installer/install.sh
    echo "set -e" >> installer/install.sh
    chmod +x installer/install.sh
    for i_prog in $i_progs; do
        file=`echo $i_prog | sed 's/\//_/g'`
        curl https://i.wayl.one/$i_prog > installer/$file.sh
        chmod +x installer/$file.sh
        echo "/installer/$file.sh" >> installer/install.sh
    done



    echo "mv cli gh" >> installer/install.sh
    echo "mv Clipboard cp" >> installer/install.sh
    echo "mv tealdeer tldr" >> installer/install.sh
    echo "tldr --update" >> installer/install.sh
    echo "mv sealed-secrets kubeseal" >> installer/install.sh

    echo 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"' >> installer/install.sh
    echo 'curl https://raw.githubusercontent.com/ahmetb/kubectx/refs/heads/master/kubectx > ~/.local/bin/kubectx' >> installer/install.sh

    echo "
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

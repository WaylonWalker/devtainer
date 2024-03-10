set shell := ["bash", "-c"]
default:
  @just --choose
base: build deploy
alpine: build-alpine deploy-alpine
slim: build-slim deploy-slim

build:
    docker build -t registry.wayl.one/devtainer:latest .

deploy:
    docker push registry.wayl.one/devtainer
    curl -d "released devtainer to https://registry-ui.wayl.one/#!/taglist/devtainer" https://ntfy.wayl.one/deployments

build-alpine:
    docker build -f docker/Dockerfile.alpine -t registry.wayl.one/devtainer:alpine .

deploy-alpine:
    docker push registry.wayl.one/devtainer:alpine
    curl -d "released devtainer:alpine to https://registry-ui.wayl.one/#!/taglist/devtainer" https://ntfy.wayl.one/deployments


deploy-fokais:
    docker tag registry.wayl.one/devtainer:alpine registry.fokais.com/devtainer:alpine
    docker tag registry.wayl.one/devtainer:slim registry.fokais.com/devtainer:slim
    docker push registry.fokais.com/devtainer:alpine
    docker push registry.fokais.com/devtainer:slim

build-slim:
    docker build -f docker/Dockerfile.slim -t registry.wayl.one/devtainer:slim .
deploy-slim:
    docker push registry.wayl.one/devtainer:slim
    curl -d "released devtainer:slim to https://registry-ui.wayl.one/#!/taglist/devtainer" https://ntfy.wayl.one/deployments


update-installers:
    #!/usr/bin/env sh
    i_progs="
    BurntSushi/ripgrep
    MordechaiHadad/bob
    avencera/rustywind
    benbjohnson/litestream
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
    ducaale/xh
    extrawurst/gitui
    go-task/task
    homeport/termshot
    imsnif/bandwhich
    imsnif/diskonaut
    jmorganca/ollama
    johanhaleby/kubetail
    mgdm/htmlq
    neovim/neovim
    ogham/dog
    ogham/exa
    packwiz/packwiz
    pemistahl/grex
    sharkdp/pastel
    sirwart/ripsecrets
    starship/starship
    topgrade-rs/topgrade
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

    echo "
    if [[ -f /usr/bin/batcat ]]; then
        ln -s /usr/bin/batcat ~/.local/bin/bat
    fi
    if [[ -f /usr/bin/fdfind ]]; then
        ln -s /usr/bin/fdfind ~/.local/bin/fd
    fi
    " >> installer/install.sh

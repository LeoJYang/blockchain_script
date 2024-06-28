#!/bin/bash

function install_storage_node() {

    sudo apt-get update
    sudo apt-get install clang cmake build-essential

    check_rust_installed()
    check_go_installed()

    # Clone repo and build
    git clone -b v0.3.2 https://github.com/0glabs/0g-storage-node.git

    cd 0g-storage-node
    git submodule update --init

    cargo build --release

    cd run

    read -p "Private key (without 0x): " minerkey

    sed -i "s/miner_key = \"\"/miner_key = \"$minerkey\"/" config.toml
    sed -i 's|blockchain_rpc_endpoint = "https://rpc-testnet.0g.ai"|blockchain_rpc_endpoint = "https://storage.0gnode.xyz"|g' config.toml
    sed -i 's/log_sync_start_block_number = 80981/log_sync_start_block_number = 802/' config.toml
    sed -i 's/log_contract_address = "0x22C1CaF8cbb671F220789184fda68BfD7eaA2eE1"/log_contract_address = "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"/' config.toml
    sed -i 's/mine_contract_address = "0x8B9221eE2287aFBb34A7a1Ef72eB00fdD853FFC2"/mine_contract_address = "0x85F6722319538A805ED5733c5F4882d96F1C7384"/' config.toml

    # Run in background
    cd run
    tmux new-session -d -s zgs_node_session '../target/release/zgs_node --config config.toml'
}


check_go_installed() {
    if command -v go >/dev/null 2>&1; then
        echo "Go is installed."
        go version
    else
        echo "Installing Go..."
        sudo rm -rf /usr/local/go
        curl -L https://go.dev/dl/go1.22.0.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
        echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
        export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
        source $HOME/.bash_profile
    fi
}

check_rust_installed() {
    if command -v rustc >/dev/null 2>&1; then
        echo "Rust is installed."
        rustc --version
    else
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

install_storage_node()


#!/bin/bash

function install_storage_node() {

    sudo apt-get update
    sudo apt-get install clang cmake build-essential

    # Clone repo and build
    git clone https://github.com/0glabs/0g-storage-node.git

    cd 0g-storage-node
    git fetch
    git checkout tags/v0.3.3 --force
    git submodule update --init

    cargo build --release

    cd run
    
    sed -i '
    s|^\s*#\?\s*log_contract_address\s*=.*|log_contract_address = "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"|
    s|^\s*#\?\s*mine_contract_address\s*=.*|mine_contract_address = "0x85F6722319538A805ED5733c5F4882d96F1C7384"|
    s|^\s*#\?\s*blockchain_rpc_endpoint\s*=.*|blockchain_rpc_endpoint = "https://storage.0gnode.xyz"|
    s|^\s*#\?\s*log_sync_start_block_number\s*=.*|log_sync_start_block_number = 802|
    s|^\s*#\?\s*network_dir\s*=.*|network_dir = "network"|
    s|^\s*#\?\s*network_enr_tcp_port\s*=.*|network_enr_tcp_port = 1234|
    s|^\s*#\?\s*network_enr_udp_port\s*=.*|network_enr_udp_port = 1234|
    s|^\s*#\s*watch_loop_wait_time_ms\s*=.*|watch_loop_wait_time_ms = 1000|
    s|^\s*#\?\s*network_libp2p_port\s*=.*|network_libp2p_port = 1234|
    s|^\s*#\?\s*network_discovery_port\s*=.*|network_discovery_port = 1234|
    s|^\s*#\s*rpc_listen_address\s*=.*|rpc_listen_address = "0.0.0.0:5678"|
    s|^\s*#\s*rpc_listen_address_admin\s*=.*|rpc_listen_address_admin = "0.0.0.0:5679"|
    s|^\s*#\?\s*rpc_enabled\s*=.*|rpc_enabled = true|
    s|^\s*#\?\s*db_dir\s*=.*|db_dir = "db"|
    s|^\s*#\?\s*log_config_file\s*=.*|log_config_file = "log_config"|
    s|^\s*#\?\s*log_directory\s*=.*|log_directory = "log"|
    s|^\s*#\?\s*network_boot_nodes\s*=.*|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS","/ip4/18.167.69.68/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX"]|
    ' config.toml

    sed -i "s|^\s*#\?\s*network_enr_address\s*=.*|network_enr_address = \"$(wget -qO- eth0.me)\" |" config.toml
}

install_storage_node


#!/bin/bash

function assert() {
    "$@"

    if [ "$?" != 0 ]; then
    echo "Execute $@ failure"
    exit 1
    fi
}

function assert_command() {
    if ! which "$1" > /dev/null 2>&1;then
    echo "Command $1 not found"
    exit 1
    fi
}

function _setup(){
    . /etc/default/clash

    ip route replace default dev utun table 114

    ip rule del fwmark 114514 lookup 114 > /dev/null 2> /dev/null
    ip rule add fwmark 114514 lookup 114

    nft -f /usr/lib/clash/cn_tun.conf

    sysctl -w net/ipv4/ip_forward=1

    exit 0

}

function _clean(){
    . /etc/default/clash

    ip route del default dev utun table 114
    ip rule del fwmark 114514 lookup 114

    nft -f - << EOF
    flush table clash
    delete table clash
EOF

    exit 0
}

function _help() {
    echo "nftables rule for clash CN_TUN mode"
    echo ""
    echo "Usage: ./cn_tun.sh [option]"
    echo ""
    echo "Options:"
    echo "  setup   - setup nft rules"
    echo "  clean   - clean nft rules"
    echo ""

    exit 0
}

case "$1" in
"setup") _setup;;
"clean") _clean;;
*) _help;
esac

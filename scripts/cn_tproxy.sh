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

    ip route replace local default dev lo table 114

    ip rule del fwmark "$NETFILTER_MARK" lookup 114 > /dev/null 2> /dev/null
    ip rule add fwmark "$NETFILTER_MARK" lookup 114

    nft -f - << EOF
    table clash
    flush table clash
    
    include "/usr/lib/clash/private.nft"
    include "/usr/lib/clash/chnroute.nft"
    
    table clash {
        chain forward {
            type filter hook prerouting priority 0; policy accept;
            ip protocol != { tcp, udp } accept
            ip daddr $private_list accept
            ip daddr $chnroute_list accep
            ip protocol tcp mark set 114514 tproxy to 127.0.0.1:7893
            ip protocol udp mark set 114514 tproxy to 127.0.0.1:7893
        }
        chain forward-dns-redirect {
            type nat hook prerouting priority 0; policy accept;
            ip protocol != { tcp, udp } accept
        }
    }
EOF
    sysctl -w net/ipv4/ip_forward=1

    exit 0
}

function _clean(){
    . /etc/default/clash

    ip route del local default dev lo table 114
    ip rule del fwmark 114514 lookup 114

    nft -f - << EOF
    flush table clash
    delete table clash
EOF

    exit 0
}

function _help() {
    echo "nftables rule for clash CN_TPROXY mode"
    echo ""
    echo "Usage: ./cn_tproxy.sh [option]"
    echo ""
    echo "Options:"
    echo "  setup   - setup nftables rules"
    echo "  clean   - clean nftables rules"
    echo ""

    exit 0
}

case "$1" in
"setup") _setup;;
"clean") _clean;;
*) _help;
esac

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

    ip route replace default dev utun table "$IPROUTE2_TABLE_ID"

    ip rule del fwmark "$NETFILTER_MARK" lookup "$IPROUTE2_TABLE_ID" > /dev/null 2> /dev/null
    ip rule add fwmark "$NETFILTER_MARK" lookup "$IPROUTE2_TABLE_ID"

    nft -f - << EOF
    table clash
    flush table clash
    include "/usr/lib/clash/private.nft"
    include "/usr/lib/clash/chnroute.nft"
    table clash {
        chain forward {
            type filter hook prerouting priority 0; policy accept;           
            ip protocol != { tcp, udp } accept        
            iif utun accept
            ip daddr $private_list accept
            ip daddr $chnroute_list accept
            ip protocol { tcp, udp } mark set $NETFILTER_MARK
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

    ip route del default dev utun table "$IPROUTE2_TABLE_ID"
    ip rule del fwmark "$NETFILTER_MARK" lookup "$IPROUTE2_TABLE_ID"

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

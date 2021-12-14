#!/bin/bash

cd "`dirname $0`"

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

function _download() {
    assert_command curl
    assert_command gzip
    assert_command unzip
    assert_command cp
    assert_command mv
    assert_command cat
    assert_command tar

    case "$(uname -ms | tr ' ' '_' | tr '[A-Z]' '[a-z]')" in
    "linux_x86_64") 
        AARCH="linux-amd64"
        ;;
    "linux_aarch64")
        AARCH="linux-armv8"
        ;;
    *)
        echo "Not support platform"
        exit 1
        ;;
    esac
    
# Clash Premium core

    release_info_url="https://api.github.com/repos/Dreamacro/clash/releases/tags/premium"

    if [[ "$1" =~ "proxy" ]]; then
        url_prefix="https://ghproxy.com/"
    else
        url_prefix=""
    fi

    echo "Get Clash Premium release information"
    assert curl -s -o clash_premium_release.json "${release_info_url}"

    if [ ! -f clash_premium_release.json ]; then
        echo "Failed to get Clash Premium release information"
        exit 1
    fi

    clash_premium_download_url=$(jq ".assets[${i}].browser_download_url" clash_premium_release.json | tr -d '"' | grep -m1 ${AARCH})
    if [ "${clash_premium_download_url}" == "" ]; then
        echo "No compatible Clash Premium for your platform"
        exit 1
    fi

    echo "Start download Clash Premium from ${clash_premium_download_url}"
    assert curl -L -# -o clash-premium.gz "${url_prefix}${clash_premium_download_url}"
    if [ ! -f clash-premium.gz ]; then
        echo "Failed to download Clash Premium"
        echo "Please download and upload it to current directory manually"
        exit 1
    fi
    assert gzip -d clash-premium.gz
    assert mv clash-premium clash

# Clash dashboard

    clash_dashboard_download_url="https://github.com/Dreamacro/clash-dashboard/archive/gh-pages.zip"
    echo "Start download Clash Dashboard from ${clash_dashboard_download_url}"
    assert curl -L -# -o dashboard.zip "${url_prefix}${clash_dashboard_download_url}"
    if [ ! -f dashboard.zip ]; then
        echo "Failed to download Clash Dashboard"
        echo "Please download and upload it to current directory manually"
        exit 1
    fi
#     assert unzip dashboard.zip
#     assert mv -f -T clash-dashboard-gh-pages dashboard

    echo "Clash Premium core & dashboard have been downloaded successfully "
    

# yq 

    yq_url="https://api.github.com/repos/mikefarah/yq/releases/latest"
    echo "Get yq_release.json"
    assert curl -s -o yq_release.json "${yq_url}"

    if [ ! -f yq_release.json ]; then
        echo "Failed to get yq release information"
        exit 1
    fi

    yq_download_url=$(jq ".assets[${i}].browser_download_url" yq_release.json | tr -d '"' | grep -m1 yq_linux_amd64)
    if [ "${yq_download_url}" == "" ]; then
        echo "No compatible yq for your platform"
        exit 1
    fi

    echo "Start download yq from ${yq_download_url}"
    assert curl -L -# -o yq "${url_prefix}${yq_download_url}"
    if [ ! -f yq ]; then
        echo "Failed to download yq"
        echo "Please download and upload it to current directory manually"
        exit 1
    fi
    assert cp yq /usr/bin/yq
    assert chmod +x /usr/bin/yq


# mosdns 

    mosdns_url="https://api.github.com/repos/IrineSistiana/mosdns/releases/latest"
    echo "Get mosdns_release.json"
    assert curl -s -o mosdns_release.json "${mosdns_url}"

    if [ ! -f mosdns_release.json ]; then
        echo "Failed to get mosdns release information"
        exit 1
    fi

    mosdns_download_url=$(jq ".assets[${i}].browser_download_url" mosdns_release.json | tr -d '"' | grep -m1 ${AARCH})
    if [ "${mosdns_download_url}" == "" ]; then
        echo "No compatible mosdns for your platform"
        exit 1
    fi

    echo "Start download mosdns from ${mosdns_download_url}"
    assert curl -L -# -o mosdns.zip "${url_prefix}${mosdns_download_url}"
    if [ ! -f mosdns.zip ]; then
        echo "Failed to download mosdns"
        echo "Please download and upload it to current directory manually"
        exit 1
    fi
    assert unzip -o  mosdns.zip "mosdns"

    geoip_download_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
    echo "Start download geoip.dat from ${geoip_download_url}"
    assert curl -L -# -O ${url_prefix}${geoip_download_url}
    if [ ! -f geoip.dat ]; then
        echo "Failed to download geoip.dat"
        exit 1
    fi

    geosite_download_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
    echo "Start download geosite.dat from ${geosite_download_url}"
    assert curl -L -# -O ${url_prefix}${geosite_download_url}
    if [ ! -f geosite.dat ]; then
        echo "Failed to download geosite.dat"
        exit 1
    fi

# subconverter 

    subconverter_url="https://api.github.com/repos/tindy2013/subconverter/releases/latest"
    echo "Get subconverter_release.json"
    assert curl -s -o subconverter_release.json "${subconverter_url}"

    if [ ! -f subconverter_release.json ]; then
        echo "Failed to get subconverter release information"
        exit 1
    fi

    subconverter_download_url=$(jq ".assets[${i}].browser_download_url" subconverter_release.json | tr -d '"' | grep -m1 linux64)
    if [ "${subconverter_download_url}" == "" ]; then
        echo "No compatible subconverter for your platform"
        exit 1
    fi

    echo "Start download subconverter from ${subconverter_download_url}"
    assert curl -L -# -o subconverter.tar.gz "${url_prefix}${subconverter_download_url}"
    if [ ! -f subconverter.tar.gz ]; then
        echo "Failed to download subconverter"
        echo "Please download and upload it to current directory manually"
        exit 1
    fi
    assert tar -zxvf subconverter.tar.gz subconverter/subconverter
    

# chnroute.nft 

    chnroute_download_url="http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest"
    echo "Start download chnroute.nft from ${chnroute_download_url}"
    assert curl -L -# -o raw "${chnroute_download_url}"
    echo "define chnroute_list = {" > chnroute.nft
    assert cat raw | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' | sed s/$/,/g >> chnroute.nft
    echo "}" >> chnroute.nft


    exit 1
}

function _install() {
    assert_command install
    assert_command nft
    assert_command ip
    assert_command sed
    assert_command systemctl
    assert_command udevadm

    if [ ! -d "/lib/udev/rules.d" ];then
        echo "udev not found"
        exit 1
    fi

    if [ ! -d "/lib/systemd/system" ];then
        echo "systemd not found"
        exit 1
    fi

    if ! grep net_cls "/proc/cgroups" 2> /dev/null > /dev/null ;then
        echo "cgroup not support net_cls"
        exit 1
    fi

    if [ ! -f "./clash" ];then
        echo "Clash core not found."
        echo "Please download it from https://github.com/Dreamacro/clash/releases/tag/premium, and rename to ./clash"
    fi
    
    assert install -d -m 0755 /etc/default/
    assert install -d -m 0755 /lib/clash/
    assert install -d -m 0600 /etc/clash/

    assert install -m 0755 ./clash /bin/clash
    
    assert install -m 0644 files/clash-default /etc/default/clash

    assert install -m 0755 scripts/bypass-proxy-pid /bin/bypass-proxy-pid
    assert install -m 0755 scripts/bypass-proxy /bin/bypass-proxy

    assert install -m 0700 scripts/cgroup.sh /lib/clash/cgroup.sh
    assert install -m 0700 scripts/$1.sh /lib/clash/rules.sh

    assert install -m 0644 files/clash.service /etc/systemd/system/clash.service
    assert install -m 0644 files/99-clash.rules /etc/udev/rules.d/99-clash.rules
    assert unzip dashboard.zip
    assert mv -f -T clash-dashboard-gh-pages dashboard
    rm -rf /etc/clash/dashboard
    assert mv -f -T dashboard /etc/clash/dashboard

# supervisor
#     assert install -m 0644 supervisor/clash.conf /etc/supervisor/conf.d
#     assert install -m 0644 supervisor/mosdns.conf /etc/supervisor/conf.d
#     assert install -m 0644 supervisor/subconverter.conf /etc/supervisor/conf.d
#     assert install -m 0644 supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# nftables
    assert install -m 0644 ./chnroute.nft /lib/clash
    assert install -m 0644 files/private.nft /lib/clash
    assert install -m 0644 files/cn_tun.conf /lib/clash
    assert install -m 0644 files/cn_tproxy.conf /lib/clash
    assert install -m 0644 files/cn_redir-tun.conf /lib/clash

# systemctl
    assert install -m 0644 files/subconverter.service /etc/systemd/system/subconverter.service
    assert install -m 0644 files/mosdns.service /etc/systemd/system/mosdns.service

# subconverter
    if [ ! -d "/etc/subconverter" ];then
    tar -zxvf subconverter.tar.gz -C /etc/
    assert install -m 0644 subconverter/formyairport.ini /etc/subconverter/profiles
    assert install -m 0644 subconverter/Loyalsoldier.ini /etc/subconverter/profiles
    assert install -m 0644 subconverter/yuanlam.ini /etc/subconverter/profiles
    assert install -m 0644 subconverter/all_base.tpl /etc/subconverter/base/all_base.tpl
    fi

#mosdns
    assert install -m 0755 ./mosdns /bin/mosdns
    if [ ! -d "/etc/mosdns" ];then
    mkdir /etc/mosdns
    assert install -m 0644 ./geoip.dat /etc/mosdns
    assert install -m 0644 ./geosite.dat /etc/mosdns
    assert install -m 0644 files/config_mosdns.yaml /etc/mosdns/config.yaml
    fi
    
    if [ ! -f "/etc/clash/config.yaml" ];then
        assert install -m 0600 files/config.yaml /etc/clash/config.yaml
    fi

    FORWARD_DNS_REDIRECT=$(yq e '.dns.listen' /etc/clash/config.yaml | awk -F':' '{ print int($2) }')
    FORWARD_PROXY_REDIRECT=$(yq e '.redir-port' /etc/clash/config.yaml)

    if [[ ! "$1" =~ "tproxy" ]]; then
        FORWARD_PROXY_REDIRECT=$(yq e '.tproxy-port' /etc/clash/config.yaml)
    elif [[ ! "$1" =~ "redir" ]]; then
        FORWARD_PROXY_REDIRECT=$(yq e '.redir-port' /etc/clash/config.yaml)
    fi

    if [[ FORWARD_PROXY_REDIRECT != null ]];then
        sed -i "s/FORWARD_PROXY_REDIRECT=:\([0-9]*\)/FORWARD_PROXY_REDIRECT=:$FORWARD_PROXY_REDIRECT/" /etc/default/clash
    else
        echo "config 文件需要设置tproxy-port或者redir-port"
    fi

    if [[ FORWARD_DNS_REDIRECT != null ]];then
        sed -i "s/FORWARD_DNS_REDIRECT=:\([0-9]*\)/FORWARD_DNS_REDIRECT=:$FORWARD_DNS_REDIRECT/" /etc/default/clash
    else
        echo "config 文件需要设置dns:listen"
    fi

    if [[ ! "$1" =~ "tun" ]]; then
        sed -i '/^ExecStart=/a ExecStopPost=\/lib\/clash\/rules.sh clean' /etc/systemd/system/clash.service
        sed -i '/^ExecStart=/a ExecStartPost=\/lib\/clash\/rules.sh setup' /etc/systemd/system/clash.service
        systemctl daemon-reload
    fi

    DISTRO_NAME=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
    if [[ " centos fedora " =~ " ${DISTRO_NAME} " ]]; then
        sed -i 's/RUN+="/RUN+="\/bin\/sudo /g' /etc/udev/rules.d/99-clash.rules
        udevadm control --reload-rules
        udevadm trigger
    fi

    echo "Install successfully"
    echo ""
    echo "Home directory at /etc/clash"
    echo ""
    echo "All dns traffic will be redirected to :1053"
    echo ""
    echo "Use 'systemctl start clash' to start"
    echo "Use 'systemctl enable clash' to enable auto-restart on boot"

    exit 0
}

function _uninstall() {
    assert_command systemctl
    assert_command rm
    assert_command sleep

    systemctl stop clash
    sleep 0.5
    systemctl disable clash
    rm -rf /lib/clash
    rm -rf /etc/systemd/system/clash.service
    rm -rf /etc/udev/rules.d/99-clash.rules
    rm -rf /bin/clash
    rm -rf /bin/bypass-proxy-uid
    rm -rf /bin/bypass-proxy
    rm -rf /etc/default/clash
    rm -rf /etc/clash/ui
    
    systemctl subconverter 
    sleep 0.5
    systemctl disable subconverter
    systemctl stop mosdns
    sleep 0.5
    systemctl disable mosdns
    rm -rf /bin/mosdns
    rm -rf /etc/systemd/system/subconverter.service
    rm -rf /etc/systemd/system/mosdns.service
    rm -rf /etc/supervisor/conf.d/*

    echo "Uninstall successfully"

    exit 0
}

function _help() {
    echo "Clash Premiun Installer"
    echo ""
    echo "Usage: ./run.sh [option]"
    echo ""
    echo "Options:"
    echo "  dl          - Download latest clash premium & dashboard"
    echo "  dl_proxy    - Download latest clash premium & dashboard with proxy"
    echo "  tun         - Transfer TCP and UDP to utun device"
    echo "  tproxy      - TProxy TCP and TProxy UDP"
    echo "  uninstall   - uninstall installed clash premiun core"
    echo ""

    exit 0
}

case "$1" in
"dl") _download $1;;
"dl_proxy") _download $1;;
"redir-tun") _install $1;;
"tun") _install $1;;
"tproxy") _install $1;;
"cn_redir-tun") _install $1;;
"cn_tun") _install $1;;
"cn_tproxy") _install $1;;
"uninstall") _uninstall $1;;
*) _help;
esac

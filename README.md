# Clash Premiun Installer

Simple clash premiun core installer with full tun support for Linux.

## Usage

1. Install dependencies **git**, **nftables**, **iproute2**, **jq**, **supervisor**, [**yq**](https://github.com/mikefarah/yq/ "https://github.com/mikefarah/yq/")

   ```bash
   apt install -y git nftables iproute2 jq
   ```

2. Clone repository

   ```bash
   git clone https://ghproxy.com/https://github.com/gdfsnhsw/aclash aclash && 
   chmod +x /root/aclash/run.sh
   ```

3. Run Installer

   ```bash
   cd aioclash
   ```
   
   
   # core
   ```bash
   ./run.sh dl
   ```
   
   ```bash
   ./run.sh dl_proxy
   ```

   # install
   ```bash
   ./run.sh redir-tun
   ```

   ```bash
   ./run.sh tun
   ```
   
   ```bash
   ./run.sh tproxy
   ```

   ```bash
   ./run.sh cn_redir-tun
   ```

   ```bash
   ./run.sh cn_tun
   ```

   ```bash
   ./run.sh cn_tproxy
   ```

   # uninstall
   ```bash
   ./run.sh uninstall
   ```

## Credits

* [Kr328/clash-premium-installer](https://github.com/Kr328/clash-premium-installer)
* [yangliu/alpine-clash-gateway](https://github.com/yangliu/alpine-clash-gateway)

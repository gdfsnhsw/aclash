# Clash Premiun Installer

Simple clash premiun core installer with full tun support for Linux.

## Usage

1. Install dependencies **git**, **nftables**, **iproute2**, **jq**, **supervisor**, [**yq**](https://github.com/mikefarah/yq/ "https://github.com/mikefarah/yq/")

   ```bash
   apt install git nftables iproute2 jq supervisor
   ```

   ```bash
   wget https://ghproxy.com/https://github.com/mikefarah/yq/releases/download/v4.16.1/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
   ```

2. Clone repository

   ```bash
   git clone https://github.com/gdfsnhsw/aioclash aioclash && 
   chmod +x /root/aioclash/run.sh
   ```

3. Run Installer

   ```bash
   cd aioclash
   ```
   
   
   # core
   ```bash
   ./run.sh dl            # Download latest clash premium & dashboard
   ```
   
   ```bash
   ./run.sh dl_proxy      # Download latest clash premium & dashboard with proxy
   ```

   # install
   ```bash
   ./run.sh tun           # Transfer TCP and UDP to utun device
   ```
   
   ```bash
   ./run.sh tproxy        # TProxy TCP and TProxy UDP
   ```

   # uninstall
   ```bash
   ./run.sh uninstall
   ```

## Credits

* [Kr328/clash-premium-installer](https://github.com/Kr328/clash-premium-installer)
* [yangliu/alpine-clash-gateway](https://github.com/yangliu/alpine-clash-gateway)

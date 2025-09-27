# Setup Guide

## Install

### Ubuntu (on both server and client machines)

```sh
sudo apt update && sudo apt upgrade -y && sudo apt -y install wireguard wireguard-tools
```

### Arch

```sh
sudo pacman -Syu && sudo pacman -S wireguard-tools
```

## Check (on both server and client machines)

```sh
wg -h
```

## Server Setup

### Switch to the root user

```sh
sudo -s
```

### Create Private Directory

```sh
mkdir -p /etc/wireguard
chmod 700 /etc/wireguard
cd /etc/wireguard
```

### Generate Keys

```sh
wg genkey | tee /etc/wireguard/server_privatekey | wg pubkey | tee /etc/wireguard/server_publickey
```

### Check default ethernet intrface

```sh
ip -br link show
```

### Generate Config

```sh
sudo nano /etc/wireguard/wg0.conf
```

```ini
[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = <SERVER_PRIVATE_KEY>

PostUp   = sysctl -w net.ipv4.ip_forward=1
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o <DEFAULT_ETHERNET_INTERFACE> -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o <DEFAULT_ETHERNET_INTERFACE> -j MASQUERADE

[Peer]
PublicKey = <0_CLIENT_PRIVATE_KEY>
AllowedIPs = 10.0.0.2/24
PersistentKeepalive = 25

[Peer]
PublicKey = <1_CLIENT_PRIVATE_KEY>
AllowedIPs = 10.0.0.2/24
PersistentKeepalive = 25

[Peer]
PublicKey = <3CLIENT_PRIVATE_KEY>
AllowedIPs = 10.0.0.2/24
PersistentKeepalive = 25
```

### Start Wireguard Server and enable autostart

```sh
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
```

### Check Status of Wireguard Server

```sh
systemctl status wg-quick@wg0.service
```

## Client Setup

### Switch to the root user

```sh
sudo -s
```

### Create Private Directory

```sh
mkdir -p /etc/wireguard
chmod 700 /etc/wireguard
cd /etc/wireguard
```

### Generate Keys

```sh
wg genkey | tee /etc/wireguard/client_privatekey | wg pubkey | tee /etc/wireguard/client_publickey
```

### Check default ethernet intrface

```sh
ip -br link show
```

### Generate Config

```sh
sudo nano /etc/wireguard/wg0.conf
```

```ini
[Interface]
PrivateKey = <CLIENT_PRIVATE_KEY>
Address = 10.0.0.2/32
ListenPort = 51820 

[Peer]
PublicKey = <SERVER_PUBLIC_KEY>
AllowedIPs = 0.0.0.0/0
Endpoint = <SERVER-IP-ADDRESS/HOST>:51820
PersistentKeepalive = 25
```

### Start/Stop Vpn (Linux)

```sh
sudo wg-quick up wg0
```

```sh
sudo wg-quick down wg0
```

## Additional

### Reload configs

```sh
systemctl restart wg-quick@wg0
```

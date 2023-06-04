# nix-jump-reference
A nixOS jump server reference

## Setup
- Use [`configuration.nix`](./configuration.nix) to setup the base nixOS.
- `cd pi-hole` and `docker-compose up -d` should setup the pihole instance (enable it from the web console `<node-ip>/admin`)
- create the traffic forwarding by `source iptables-rules.sh` (see contents of file to setup the variables properly)



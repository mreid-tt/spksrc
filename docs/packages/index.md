---
title: Package Catalog
description: Complete list of packages available from SynoCommunity
tags:
  - packages
  - catalog
---

# Package Catalog

SynoCommunity provides a wide variety of open-source packages for Synology NAS devices. Browse by category or search for specific packages.

!!! note "Documentation in Progress"
    Individual package documentation pages are being added progressively. Check back for updates or contribute documentation for your favorite packages.

## Categories

### Download & Torrent

| Package | Description | Status |
|---------|-------------|--------|
| Transmission | Lightweight BitTorrent client | Active |
| ruTorrent | Web-based BitTorrent client with rtorrent | Active |
| SABnzbd | Usenet binary newsreader | Active |
| NZBGet | Efficient Usenet downloader | Active |
| Deluge | Feature-rich BitTorrent client | Active |
| qBittorrent | Qt-based BitTorrent client | Active |
| Aria2 | Download utility with multi-protocol support | Active |

### Media Management

| Package | Description | Status |
|---------|-------------|--------|
| Sonarr | TV series management | Active |
| Radarr | Movie collection management | Active |
| Lidarr | Music collection management | Active |
| Bazarr | Subtitle management | Active |
| Prowlarr | Indexer management | Active |
| Jackett | Torrent/Usenet indexer proxy | Active |
| Readarr | Book collection management | Active |

### Media Servers

| Package | Description | Status |
|---------|-------------|--------|
| Navidrome | Music streaming server | Active |
| Jellyfin | Media streaming server | Active |
| Minio | S3-compatible object storage | Active |
| TVHeadend | TV streaming server | Active |
| MPD | Music Player Daemon | Active |

### Development & Utilities

| Package | Description | Status |
|---------|-------------|--------|
| Git | Version control system | Active |
| Python 3.12 | Python runtime (also 3.10, 3.11, 3.13, 3.14) | Active |
| Vim | Text editor | Active |
| Fish | Friendly interactive shell | Active |
| Zsh | Z shell | Active |
| Mercurial | Version control system | Active |
| SynoCli Network Tools | tmux, screen, ssh, rsync, nmap, and more | Active |
| SynoCli File Tools | mc, tree, ncdu, fdupes, and more | Active |
| SynoCli Disk Tools | smartctl, hdparm, and more | Active |

### Backup & Sync

| Package | Description | Status |
|---------|-------------|--------|
| Syncthing | Continuous file synchronization | Active |
| BorgBackup | Deduplicating backup | Active |
| Restic | Fast, secure backup | Active |
| rclone | Cloud storage sync | Active |
| Duplicity | Encrypted bandwidth-efficient backup | Active |
| rdiff-backup | Reverse differential backup | Active |

### Network & Security

| Package | Description | Status |
|---------|-------------|--------|
| HAProxy | Load balancer and proxy | Active |
| Cloudflared | Cloudflare Tunnel client | Active |
| DNSCrypt-Proxy | DNS encryption proxy | Active |
| Stunnel | SSL tunneling proxy | Active |
| SSLH | Protocol multiplexer | Active |

### Home Automation

| Package | Description | Status |
|---------|-------------|--------|
| Home Assistant | Home automation platform | Active |
| Mosquitto | MQTT broker | Active |

### Web Applications

| Package | Description | Status |
|---------|-------------|--------|
| Nextcloud | Self-hosted cloud platform | Active |
| Roundcube | Webmail client | Active |
| COPS | Calibre OPDS server | Active |
| Gitea | Self-hosted Git service | Active |
| Wallabag | Read-it-later application | Active |
| tt-rss | Tiny Tiny RSS feed reader | Active |

---

## Package Information

Each package page includes:

- **Description** - What the package does
- **Installation** - Setup instructions
- **Configuration** - Settings and customization
- **Troubleshooting** - Common issues and solutions
- **Architecture Support** - Compatible devices
- **Links** - Upstream project, documentation

## Contributing Package Docs

Package documentation is community-maintained. To contribute:

1. Follow the [package documentation template](_template.md)
2. Submit a PR adding/updating the package's markdown file
3. See [Contributing](../contributing/index.md) for guidelines

## Requesting Packages

Want a package that's not listed? 

1. Check [existing issues](https://github.com/SynoCommunity/spksrc/issues) first
2. Open a new issue with the `package-request` label
3. Include: package name, upstream URL, why it would be useful

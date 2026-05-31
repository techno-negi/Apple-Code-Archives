################################################################################
# docker_notes.sh
# Author   : @techno-negi
# Platform : Lubuntu x86_64 | Docker (ubuntu:latest)
# Tools    : libimobiledevice v1.4.0, usbmuxd
# Target   : iPadOS 16+ (Developer Mode via idevicedevmodectl)
# Date     : 2026-06-01
# Notes    : Requires prior setup-notes enable-ipad-devmode.sh
################################################################################



# NOTE `docker system prune -a --volumes` is destructive and **will delete committed images** too. Here's the safe breakdown:

## What Each Flag Actually Removes

# | Command | Removes |
# |---|---|
# | `docker system prune` | Stopped containers, dangling images, unused networks, build cache |
# | `docker system prune -a` | ⬆️ + **all unused images** (including committed ones if no container is using them) |
# | `docker system prune --volumes` | ⬆️ + unused volumes |
# | `docker system prune -a --volumes` | **☢️ Everything** — the nuclear option |

## Safe Reclaimable-Only Commands

```bash
# Safe default — only removes truly dangling/temp stuff, keeps named images
docker system prune

# Remove only dangling images (untagged <none> ones)
docker image prune

# Remove only stopped containers (keeps images intact)
docker container prune

# Remove only unused volumes
docker volume prune

# Remove only unused networks
docker network prune
```

## Check What's Reclaimable First (Before Deleting)

```bash
docker system df          # summary of disk usage
docker system df -v       # verbose — shows each image/container/volume
```

# This shows exactly what's dangling vs. what's in use, so you can make an informed decision before pruning.
## Protect Your Committed Image
# As long as committed image is **tagged**, `docker system prune` (without `-a`) will never touch it: [til.devjugal](https://til.devjugal.com/docker/remove-unused-data)

```bash
# Make sure it has a proper tag
docker images | grep <libimobiledevice-ready>

# If untagged, tag it now
docker tag <image_id> <libimobiledevice-ready:latest>
```

# Tagged images are considered "in use" by Docker's prune logic — only `prune -a` goes after them. [help.univention](https://help.univention.com/t/docker-overlay-cleanup/13207)
# Replace the nuclear option  with this safer cleanup:

```bash
# Safe cleanup — removes temp/reclaimable only, keeps committed images
docker system prune
docker container prune
docker volume prune
```

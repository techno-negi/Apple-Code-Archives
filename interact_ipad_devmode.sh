################################################################################
# interact_ipad_devmode.notes
# Author   : @techno-negi
# Platform : Lubuntu x86_64 | Docker (ubuntu:latest)
# Tools    : libimobiledevice v1.4.0, usbmuxd
# Target   : iPadOS 16+ (Developer Mode via idevicedevmodectl)
# Date     : 2026-06-01
# Notes    : Requires prior setup-notes enable-ipad-devmode.sh
################################################################################

### INSIDE DOCKER SANDBOX (notes in enable-ipad-devmode.sh) ###

# 📋 Device Info & Diagnostics
ideviceinfo                        # full device info dump
ideviceinfo -k ProductVersion      # just iOS version
idevicediagnostics diagnostics All # battery, storage, network stats
idevicename                        # get/set device name
idevicedate                        # get/set device clock

# 📦 App Management
# Requires: apt install ideviceinstaller
ideviceinstaller -l                 # list all installed apps
ideviceinstaller -i app.ipa         # install an IPA
ideviceinstaller -U com.bundle.id   # uninstall an app
ideviceinstaller -a                 # list app archives

# 📁 File System Access (Mount iPad like a drive)
# Requires: apt install ifuse
mkdir ~/ipad
ifuse ~/ipad                          # mount iPad filesystem
ls ~/ipad/DCIM                        # browse photos
cp ~/ipad/DCIM/100APPLE/* ~/Photos/   # copy photos to Linux
fusermount -u ~/ipad                  # unmount

# 💾 Backup & Restore
idevicebackup2 backup --full ~/ipad-backup/   # full iTunes-compatible backup
idevicebackup2 restore ~/ipad-backup/          # restore from backup
idevicebackup2 info ~/ipad-backup/             # inspect backup contents

# 📝 System Logs (like ADB logcat for Android)
idevicesyslog                          # stream all system logs live
idevicesyslog | grep "Safari"          # filter by app name
idevicecrashreport -e ~/crashlogs/     # pull crash reports

# 📸 Screenshot (needs Developer Disk Image mounted)
idevicescreenshot screen.png           # capture iPad screen to PNG

# 🔧 Device Control
idevicediagnostics restart            # reboot iPad
idevicediagnostics shutdown           # power off
idevicediagnostics sleep              # sleep mode
idevicepair list                      # list paired devices

# 🌍 Location Spoofing (needs Developer Disk Image)
idevicesetlocation 37.3318 -122.0312  # spoof GPS to Apple HQ
idevicesetlocation 0 0                # reset location


### /// INSIDE DOCKER SANDBOX /// ###





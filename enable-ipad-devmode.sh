################################################################################
# enable-ipad-devmode.sh
# Author   : @techno-negi
# Platform : Lubuntu x86_64 | Docker (ubuntu:latest)
# Tools    : libimobiledevice v1.4.0, usbmuxd
# Target   : iPadOS 16+ (Developer Mode via idevicedevmodectl)
# Date     : 2026-06-01
# Notes    : Requires host usbmuxd + Docker USB passthrough
################################################################################

sudo usbmuxd -fvv &

sudo docker run -it --privileged \
  -v /var/run/usbmuxd:/var/run/usbmuxd \
  -v /dev/bus/usb:/dev/bus/usb \
  ubuntu:latest bash
  
## now in docker terminal
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

apt update
apt install -y libcurl4-openssl-dev

apt install build-essential pkg-config autoconf automake libtool-bin \
  libplist-dev libssl-dev libusbmuxd-dev usbmuxd git

cd ~ && git clone https://github.com/libimobiledevice/libplist.git
cd libplist && ./autogen.sh && make && make install && ldconfig && cd ~

git clone https://github.com/libimobiledevice/libimobiledevice-glue.git
cd libimobiledevice-glue && ./autogen.sh && make && make install && ldconfig && cd ~

git clone https://github.com/libimobiledevice/libtatsu.git
cd libtatsu && ./autogen.sh && make && make install && ldconfig && cd ~

git clone https://github.com/libimobiledevice/libusbmuxd.git
cd libusbmuxd && ./autogen.sh && make && make install && ldconfig && cd ~

cd ~ && git clone https://github.com/libimobiledevice/libimobiledevice.git
cd libimobiledevice && ./autogen.sh && make && make install && ldconfig

idevice_id -l        # should now show your iPad's UDID
idevicepair pair     # complete the pairing
ideviceinfo          # confirm it works

# Just reveal the hidden toggle in Settings (safest first step)
idevicedevmodectl reveal  #### BINGO  #######


######## end docker terminal ###############



#### docker clean-up afterwards #######
#### 
#docker nuke
sudo docker system prune -a --volumes

#docker info
sudo docker ps -a       # should show nothing
sudo docker images      # should show nothing
sudo docker system df   # should show 0B usage
##### clean up ######

# Before cleanup, commit the built image for reuse
sudo docker commit <container_id> libimobiledevice-ready

### docker additional comands #####
# docker new temporary image
sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb ubuntu:latest bash

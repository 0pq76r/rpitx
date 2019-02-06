#!/bin/sh

echo Install rpitx - some package need internet connection -

sudo pacman -Sy
sudo pacman -S --needed extra/git extra/libsndfile
sudo pacman -S --needed extra/imagemagick extra/fftw
#For rtl-sdr use
sudo pacman -S --needed community/rtl-sdr
# We use CSDR as a dsp for analogs modes thanks to HA7ILM
git clone https://github.com/simonyiszk/csdr
patch -i csdr_a64.diff csdr/Makefile
cd csdr || exit
make && sudo make install
cd ../ || exit

cd src || exit
git clone https://github.com/F5OEO/librpitx
patch -i ../librpitx_a64.diff librpitx/src/atv.cpp
cd librpitx/src || exit
make
cd ../../ || exit

cd pift8
git clone https://github.com/kgoba/ft8_lib
cd ../
patch -i ../rpitx_a64.diff Makefile

make
sudo make install
cd .. || exit

printf "\n\n"
printf "In order to run properly, rpitx need to modify /boot/config.txt. Are you sure (y/n) "
read -r CONT

if [ "$CONT" = "y" ]; then
  echo "Set GPU to 250Mhz in order to be stable"
   LINE='gpu_freq=250'
   FILE='/boot/config.txt'
   grep -qF "$LINE" "$FILE"  || echo "$LINE" | sudo tee --append "$FILE"
   echo "Installation completed !"
else
  echo "Warning : Rpitx should be instable and stop from transmitting !";
fi



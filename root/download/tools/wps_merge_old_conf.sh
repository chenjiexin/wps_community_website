#!/bin/bash
off=$HOME"/.config/Kingsoft/Office.conf"
kif=$HOME"/.config/Software/Kingsoft.conf"

sed -i 's:Common:common:g' $off
sed -i 's:6\.0\\::' $kif
sed -i '/Office/d' $kif
cat $kif >> $off
rm -r $HOME"/.config/Software"

git clone https://github.com/surajmandalcell/elementary-x.git  ~/.themes/elementary-x

mkdir ~/.icons
git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git ~/.icons/la-capitaine-icon-theme

gsettings set org.gnome.desktop.interface gtk-theme 'elementary-x'
gsettings set org.gnome.desktop.interface icon-theme 'la-capitaine-icon-theme'
gsettings set org.pantheon.desktop.gala.appearance button-layout 'close,minimize,maximize'

sudo apt-add-repository --yes ppa:philip.scott/elementary-tweaks
sudo apt install --yes elementary-tweaks

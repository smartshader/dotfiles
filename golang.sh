sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install -y golang-go

sudo sysctl -w fs.inotify.max_user_watches = 524288

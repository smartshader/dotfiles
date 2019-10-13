sudo apt update

sudo apt install -y vim zsh git

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sed -i '/^plugins/c\plugins=(git history kubectl)' ~/.zshrc

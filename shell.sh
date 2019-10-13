sudo apt update

sudo apt install -y vim zsh git snapd

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sed -i '/^plugins/c\plugins=(git history kubectl)' ~/.zshrc

sed -i '/^export PATH/c\export PATH=$PATH:$HOME/.pulumi/bin:$HOME/go/bin:/snap/bin' ~/.zshrc

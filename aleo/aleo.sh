#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
sleep 1 && curl -s https://api.nodes.guru/logo.sh | bash && sleep 3
echo -e '\n\e[42mSet up swapfile\e[0m\n'
curl -s https://api.nodes.guru/swap4.sh | bash
echo -e '\n\e[42mInstall dependencies\e[0m\n' && sleep 1
sudo apt update
sudo apt install make clang pkg-config libssl-dev build-essential git curl ntp jq llvm -y < "/dev/null"
echo -e '\n\e[42mInstall Rust\e[0m\n' && sleep 1
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup toolchain install nightly-2021-03-10-x86_64-unknown-linux-gnu
# toolchain=`rustup toolchain list | grep -m 1 nightly`
rustup default nightly-2021-03-10-x86_64-unknown-linux-gnu
echo -e '\n\e[42mClone snarkOS\e[0m\n' && sleep 1
cd $HOME
git clone https://github.com/AleoHQ/snarkOS
cd snarkOS
git checkout tags/v1.3.6
#git checkout e72d3d9d03d1a053ae148608e3f5b3ae857a4edf
echo -e '\n\e[42mCompile snarkOS\e[0m\n' && sleep 1
cargo build --release
sudo mv $HOME/snarkOS/target/release/snarkos /usr/bin
echo -e '\n\e[42mClone Aleo\e[0m\n' && sleep 1
cd $HOME
git clone https://github.com/AleoHQ/aleo && cd aleo
cargo install --path . --locked
echo -e '\n\e[42mCreate a key\e[0m\n' && sleep 1
aleo account new >> $HOME/aleo/account_new.txt && cat $HOME/aleo/account_new.txt && sleep 3
echo 'export ALEO_ADDRESS='$(cat $HOME/aleo/account_new.txt | awk '/Address/ {print $2}') >> $HOME/.bashrc && . $HOME/.bashrc
source $HOME/.bashrc
export ALEO_ADDRESS=$(cat $HOME/aleo/account_new.txt | awk '/Address/ {print $2}')
echo -e '\n\e[42mYour address - \e[0m' && echo ${ALEO_ADDRESS} && sleep 1
echo -e '\n\e[42mCreating a service\e[0m\n' && sleep 1
# echo "[Unit]
# Description=Aleo Node
# After=network-online.target
# [Service]
# User=$USER
# ExecStart=/usr/bin/snarkos
# Restart=always
# RestartSec=10
# LimitNOFILE=10000
# [Install]
# WantedBy=multi-user.target
# " > $HOME/aleod.service
echo "[Unit]
Description=Aleo Miner
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/snarkos --is-miner --miner-address '$ALEO_ADDRESS' --connect 46.101.144.133:4131,167.71.79.152:4131,46.101.147.96:4131,167.99.53.204:4131,128.199.15.82:4131,159.89.152.247:4131,128.199.7.1:4131,167.99.69.230:4131,178.128.18.3:4131,206.189.80.245:4131
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/aleod-miner.service
# sudo mv $HOME/aleod.service /etc/systemd/system
sudo mv $HOME/aleod-miner.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
# sudo systemctl enable aleod
# sudo systemctl restart aleod
sudo systemctl enable aleod-miner
sudo systemctl restart aleod-miner
echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 3
# if [[ `service aleod status | grep active` =~ "running" ]]; then
  # echo -e "Your Aleo node \e[32minstalled and works\e[39m!"
  # echo -e "You can check node status by the command \e[7mservice aleod status\e[0m"
  # echo -e "Press \e[7mQ\e[0m for exit from status menu"
# else
  # echo -e "Your Aleo node \e[31mwas not installed correctly\e[39m, please reinstall."
# fi
if [[ `service aleod-miner status | grep active` =~ "running" ]]; then
  echo -e "Your Aleo Miner node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice aleod-miner status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Aleo Miner node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
. $HOME/.bashrc

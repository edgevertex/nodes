FROM ubuntu:20.04

RUN apt update -y
RUN apt install -y sudo wget curl

RUN curl -s https://api.nodes.guru/swap4.sh | bash
RUN sudo apt update
RUN DEBIAN_FRONTEND="noninteractive" sudo apt install tzdata

RUN sudo apt install make clang pkg-config libssl-dev build-essential git curl ntp jq llvm -y < "/dev/null"

RUN sudo curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly-2021-03-10-x86_64-unknown-linux-gnu 
RUN rustup default nightly-2021-03-10-x86_64-unknown-linux-gnu

RUN git clone https://github.com/AleoHQ/snarkOS
WORKDIR snarkOS
RUN git checkout tags/v1.3.6 && cargo build --release

RUN sudo mv $HOME/snarkOS/target/release/snarkos /usr/bin


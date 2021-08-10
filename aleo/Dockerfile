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
RUN git checkout tags/v1.3.6 
RUN cargo build --release

RUN sudo mv /snarkOS/target/release/snarkos /usr/bin

WORKDIR /
RUN git clone https://github.com/AleoHQ/aleo
WORKDIR aleo
RUN cargo install --path . --locked

FROM ubuntu:20.04


COPY --from=0 /root/.cargo/bin/aleo /usr/bin
COPY --from=0 /usr/bin /usr/bin
RUN apt update
RUN apt install -y ca-certificates
RUN update-ca-certificates

RUN sed -z 's/\n//g' /etc/ld.so.conf >> ld.so.conf
RUN echo '\ninclude /usr/local/openssl/lib\n' >> ld.so.conf
RUN mv ld.so.conf /etc/ld.so.conf

RUN ldconfig

CMD snarkos --is-miner --miner-address $MINER_ADDRESS --connect '46.101.144.133:4131,167.71.79.152:4131,46.101.147.96:4131,167.99.53.204:4131,128.199.15.82:4131,159.89.152.247:4131,128.199.7.1:4131,167.99.69.230:4131,178.128.18.3:4131,206.189.80.245:4131'


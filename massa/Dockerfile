FROM ubuntu:20.04

RUN apt update -y
RUN apt install -y sudo 

RUN sudo apt update
RUN DEBIAN_FRONTEND="noninteractive" sudo apt install tzdata

RUN sudo apt install pkg-config curl git build-essential libssl-dev -y < "/dev/null"

RUN sudo curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update
RUN rustup toolchain install nightly
RUN rustup default nightly

RUN git clone --branch testnet https://gitlab.com/massalabs/massa.git





#RUN git clone https://github.com/AleoHQ/snarkOS --depth 1
#WORKDIR snarkOS
#RUN git checkout tags/v1.3.14 
#RUN cargo build --release
#
#RUN sudo mv /snarkOS/target/release/snarkos /usr/bin
#
#FROM ubuntu:20.04
#
#COPY --from=0 /usr/bin /usr/bin
#
## Update certificates:
#RUN apt update
#RUN apt install -y ca-certificates
#RUN update-ca-certificates
#
## Make OpenSSL work:
#RUN sed -z 's/\n//g' /etc/ld.so.conf >> ld.so.conf
#RUN echo '\ninclude /usr/local/openssl/lib\n' >> ld.so.conf
#RUN mv ld.so.conf /etc/ld.so.conf
#
#RUN ldconfig
#
#CMD snarkos

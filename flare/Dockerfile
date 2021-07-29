FROM ubuntu:20.04

RUN apt update && apt -y upgrade
RUN apt install -y git jq npm wget curl build-essential
RUN npm cache clean -f
RUN npm install -g n
RUN n 10.24.0

RUN mkdir -p $HOME/go/cache
RUN wget -c https://golang.org/dl/go1.15.5.linux-amd64.tar.gz

RUN tar -C /usr/local -xvzf go1.15.5.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV GO111MODULE=on
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV GOCACHE=$HOME/go/cache
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH


RUN echo $GOPATH
RUN echo $PATH

RUN go version

RUN wget https://github.com/yarnpkg/yarn/releases/download/v1.22.10/yarn_1.22.10_all.deb
RUN dpkg -i yarn_1.22.10_all.deb
RUN rm yarn_1.22.10_all.deb

RUN yarn --version

ENV XRP_APIs="https://xrpl.flare.network:443,https://xrpl-1.flare.network:443,https://xrplcluster.com"

WORKDIR $HOME
RUN git clone https://gitlab.com/flarenetwork/flare

WORKDIR $HOME/flare
RUN ./compile.sh

CMD ["./cmd/local.sh"]






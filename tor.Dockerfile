FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
#dependecies
RUN apt-get update && apt-get install -y \
    cmake \
    findutils \
    libclang-dev \
    libc-dbg \
    libglib2.0-0 \
    libglib2.0-dev \
    make \
    netbase \
    python3 \
    python3-networkx \
    xz-utils \
    util-linux \
    gcc \
    g++ \
    autotools-dev \
    automake \
    libevent-dev \
    libssl-dev \
    curl \
    asciidoc \
    libglib2.0-dev \
    libigraph-dev \
    git 

# install rust
# RUN curl --proto '=https' --tlsv1.2 -sSf -y https://sh.rustup.rs | sh
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
# RUN cargo

# install chutney
# RUN git clone https://git.torproject.org/chutney.git
# WORKDIR /chutney
# CMD ./tools/test-network.sh --flavor basic-min


# install shadow
WORKDIR /
RUN git clone https://github.com/shadow/shadow.git
WORKDIR /shadow
RUN ./setup build --clean --test
# RUN ./setup test
RUN ./setup install
ENV PATH="${PATH}:/root/.local/bin"
RUN shadow --version && shadow --help

#install tgen
WORKDIR /
RUN git clone https://github.com/shadow/tgen.git
WORKDIR /tgen/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
RUN make
RUN make install


#run relay
# RUN apt-get update && apt-get install -y python3-venv npm software-properties-common jq
ENV PYTHONUNBUFFERED 1

RUN apt-get update &&apt-get install -y python3 python3-pip python3-venv
ENV VENV_PATH=/root/.venvs/sting
RUN python3 -m venv $VENV_PATH
# RUN $VENV_PATH/bin/pip install git+https://github.com/initc3/auditee.git
# RUN $VENV_PATH/bin/pip install -r requirements.txt 

RUN pip3 install torpy 
RUN pip3 install requests
# COPY searcher/src/enclave/lib/ecdsa/account.py /usr/local/lib/python3.10/site-packages/eth_account/account.py
# COPY searcher/src/enclave/lib/ecdsa/account.py $VENV_PATH/lib/python3.10/site-packages/eth_account/account.py

# install tor
WORKDIR /
RUN git clone https://github.com/torproject/tor.git --branch tor-0.4.6.9
WORKDIR /tor
# RUN sh autogen.sh && ./configure && make test-network
RUN sh autogen.sh && ./configure && make && make install

WORKDIR /network
CMD shadow --template-directory shadow.data.template shadow.yaml > shadow.log

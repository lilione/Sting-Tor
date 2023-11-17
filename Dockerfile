FROM gramineproject/gramine:v1.5

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
    git \
    vim

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

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

ENV PYTHONUNBUFFERED 1

RUN apt-get update &&apt-get install -y python3 python3-pip python3-venv
ENV VENV_PATH=/root/.venvs/sting
RUN python3 -m venv $VENV_PATH

# install tor
WORKDIR /
RUN git clone https://github.com/torproject/tor.git --branch tor-0.4.6.9
WORKDIR /tor
RUN sh autogen.sh && ./configure && make && make install

RUN gramine-sgx-gen-private-key
RUN mkdir /usr/local/var

WORKDIR /network
CMD shadow --template-directory shadow.data.template shadow.yaml > shadow.log

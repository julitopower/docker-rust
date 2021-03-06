FROM ubuntu:20.10
MAINTAINER Julio Delgado <julio.delgadomangas@gmail.com>
ENV USER root
ENV HOME /root
ENV RUST_VERSION 1.48.0
ENV RUST_SRC_PATH /usr/local/src/rustc-${RUST_VERSION}-src/library

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN apt-get update
RUN apt-get install -y curl \
                       cmake \
                       file \
                       git \
                       emacs \
                       gcc \
                       g++

# Install Rust (stable) and Cargo
RUN curl https://sh.rustup.rs -sSf -o /tmp/rustup.sh
RUN /bin/bash /tmp/rustup.sh -y

RUN echo "export PATH=$HOME/.cargo/bin:$PATH" >> ${HOME}/.bashrc

# Download corresponding Rust source
WORKDIR /usr/local/src
RUN curl -sSf https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.gz -o rust-src.tar.gz
RUN tar xzf rust-src.tar.gz && ls
RUN bash -c "if [[ ! -d $RUST_SRC_PATH ]]; then \
               echo '$RUST_SRC_PATH missing!'; \
               false; \
             fi"
WORKDIR ${HOME}

# Install Racer and Rust Language Server for Rust autocompletion
ENV CARGO_PATH=$HOME/.cargo/bin/
# Racer requires rust nightly
RUN $CARGO_PATH/rustup override set nightly
RUN $CARGO_PATH/cargo install racer

# Install rustfmt to reformat Rust code
RUN $CARGO_PATH/cargo install rustfmt --force

# Install emacs configuration
COPY emacs.d ${HOME}/.emacs.d
RUN emacs --batch -l ${HOME}/.emacs.d/init.el

# Install gitconfig
COPY gitconfig ${HOME}/.gitconfig

# Enable 256 ANSI colors for Emacs
ENV TERM xterm-256color

# Rust language server
RUN $CARGO_PATH/rustup component add rls

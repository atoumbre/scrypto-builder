# Use a Rust base image
FROM rust:slim-bullseye 

RUN apt update && apt install -y \
    cmake=3.18.4-2+deb11u1 \
    clang=1:11.0-51+nmu5 \
    build-essential=12.9 \
    llvm=1:11.0-51+nmu5

# Set the working directory to /usr/src/app
WORKDIR /usr/src/app

# Install necessary tools
RUN rustup update stable
RUN cargo install cargo-audit
RUN rustup component add rustfmt
RUN rustup component add clippy
RUN rustup target add wasm32-unknown-unknown
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/radixdlt/radixdlt-scrypto.git
RUN cd radixdlt-scrypto && git checkout tags/v1.0.1
RUN cargo install --path ./radixdlt-scrypto/simulator

WORKDIR /src

# CMD ["scrypto", "build", "--path", "/src"]

# CMD ["scrypto", "--version"]

# Uncomment the following lines to run other commands
# CMD ["cargo", "clippy"]
# CMD ["cargo", "audit"]

ENTRYPOINT ["scrypto", "test", "--path", "/src"]
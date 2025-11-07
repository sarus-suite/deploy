RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
RUN [ "$(uname -m)" == "x86_64" ] && \
    rustup target add x86_64-unknown-linux-musl

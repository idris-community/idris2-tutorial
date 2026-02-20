FROM docker.io/opensuse/tumbleweed:latest

# Install dependencies
RUN zypper ref && \
    zypper --non-interactive install --allow-downgrade -t pattern devel_basis && \
    zypper --non-interactive install \
        chezscheme \
        git \
        gmp-devel \
        jq \
        rustup && \
    zypper clean

# Install pack (Idris2 package manager)
RUN echo "scheme" | bash -c "$(curl -fsSL https://raw.githubusercontent.com/stefan-hoeck/idris2-pack/main/install.bash)"

# Add the pack store bin to the path
ENV PATH="/root/.local/bin:$PATH"

# Update pack
RUN pack update-db && pack switch latest

# Install katla for code highlighting
RUN pack install-app katla

# Setup rust
ENV PATH="/root/.cargo/bin:$PATH"
RUN rustup toolchain install stable

# Install mdbook and extensions
RUN cargo install mdbook

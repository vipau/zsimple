# Use a minimal Debian base
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

# Install system packages including man-db for completions
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    ca-certificates \
    curl \
    wget \
    man-db \
    manpages \
    manpages-dev \
    sudo \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install starship globally
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Create global directories for zsh plugins
RUN mkdir -p /usr/share/zsh/plugins

# Clone zsh plugins to global locations
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
    /usr/share/zsh/plugins/zsh-autosuggestions --depth 1

RUN git clone https://github.com/zsh-users/zsh-completions \
    /usr/share/zsh/plugins/zsh-completions --depth 1

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    /usr/share/zsh/plugins/zsh-syntax-highlighting --depth 1

# Create global zsh configuration
COPY zshrc.sh /etc/zsh/zshrc
RUN chmod 644 /etc/zsh/zshrc

# Set starship config location globally
ENV STARSHIP_CONFIG=/etc/starship.toml

# Create global starship configuration
RUN mkdir -p /etc/starship# Prevent the variable from being lost to sudo
COPY starship.toml /etc/starship.toml
RUN chmod 644 /etc/starship.toml
# avoid issue of $STARSHIP_CONFIG getting lost to sudo
RUN mkdir -p /root/.config/ && ln -s /etc/starship.toml /root/.config/
# copy other files
COPY aliases.sh /root/.aliases
COPY exports.sh /root/.exports

# Set default root shell
RUN chsh -s /bin/zsh

# Create a non-root user
RUN useradd -m -s /bin/zsh penguin && \
    echo "penguin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/penguin

# Prevent the zsh welcome menu
RUN echo '# using global zshrc at /etc/zsh/zshrc' >> /home/penguin/.zshrc
# copy other files
COPY aliases.sh /home/penguin/.aliases
COPY exports.sh /home/penguin/.exports

# Set working directory
WORKDIR /home/penguin
USER penguin

# Default command
CMD ["zsh"]

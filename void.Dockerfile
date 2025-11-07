FROM ghcr.io/void-linux/void-glibc:latest

ENV TERM=xterm-256color

# Update the package database and install packages without recommended deps
RUN xbps-install -Suy && \
    xbps-install -y zsh tar git curl man-db man-pages sudo shadow ncurses-base && \
    rm -rf /var/cache/xbps/*

# Install starship
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

# Copy the same global zshrc and starship.toml as in Debian
COPY zshrc.sh /etc/zsh/zshrc
RUN chmod 644 /etc/zsh/zshrc

# Set starship config location globally
ENV STARSHIP_CONFIG=/etc/starship.toml

# Create global starship configuration
RUN mkdir -p /etc/starship
COPY starship.toml /etc/starship.toml
RUN chmod 644 /etc/starship.toml
# avoid issue of $STARSHIP_CONFIG getting lost to sudo
RUN mkdir -p /root/.config/ && ln -s /etc/starship.toml /root/.config/
# copy other files
COPY aliases.sh /root/.aliases
COPY exports.sh /root/.exports

# Set default root shell
RUN sed 's|/bin/sh|/bin/zsh|' /etc/passwd

# Create a non-root user
RUN useradd -m -s /bin/zsh penguin && \
    echo "penguin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/penguin

# Prevent the zsh welcome menu
RUN echo '# using global zshrc at /etc/zsh/zshrc' >> /home/penguin/.zshrc
# copy other files
COPY aliases.sh /home/penguin/.aliases
COPY exports.sh /home/penguin/.exports

WORKDIR /home/penguin
USER penguin

CMD ["zsh"]

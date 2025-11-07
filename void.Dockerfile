FROM ghcr.io/void-linux/void-glibc:latest

ENV TERM=xterm-256color TZ=Etc/UTC

# set hostname
RUN echo zsimple > /etc/hostname

# Update the package database and install packages without recommended deps
RUN xbps-install -Suy && \
    xbps-install -y zsh git man-db man-pages sudo shadow ncurses-base && \
    rm -rf /var/cache/xbps/*

# Create global directories for zsh plugins
RUN mkdir -p /usr/share/zsh/plugins

# Clone zsh plugins to global locations
RUN git clone https://github.com/zsh-users/zsh-autosuggestions \
    /usr/share/zsh/plugins/zsh-autosuggestions --depth 1

RUN git clone https://github.com/zsh-users/zsh-completions \
    /usr/share/zsh/plugins/zsh-completions --depth 1

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    /usr/share/zsh/plugins/zsh-syntax-highlighting --depth 1

# Copy the global zshrc
COPY zshrc.sh /etc/zsh/zshrc
RUN chmod 644 /etc/zsh/zshrc

# copy other files
COPY aliases.sh /root/.aliases
COPY exports.sh /root/.exports

# Set default root shell (not using chsh to not install util-linux package)
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

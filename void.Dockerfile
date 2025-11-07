FROM ghcr.io/void-linux/void-glibc:latest

ENV TERM=xterm-256color TZ=Etc/UTC ZSIMPLE_DISABLE_GIT=1

# Update the package database and install packages without recommended deps
RUN xbps-install -Suy && \
    xbps-install -y zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting man-db man-pages sudo shadow ncurses-base && \
    rm -rf /var/cache/xbps/*

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

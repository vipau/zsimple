# non-slim debian so we have manpages and full completion
FROM debian:stable

# upgrade all, install zsh and all optional dependencies too, then clean apt cache (for final image size)
RUN apt update && DEBIAN_FRONTEND=noninteractive apt upgrade --assume-yes && DEBIAN_FRONTEND=noninteractive apt install -y --assume-yes zsh git starship man-db curl neovim && apt clean

# copy zsimple to root home, set permissions
COPY exports.sh /root/.exports
COPY aliases.sh /root/.aliases
COPY zshrc.sh /root/.zshrc
RUN chmod -R 770 /root/.exports /root/.aliases /root/.zshrc

# run the zshrc once so that plugins get git cloned
RUN zsh -c 'source /root/.zshrc'

ENTRYPOINT ["zsh"]

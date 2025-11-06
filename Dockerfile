FROM debian:stable 
RUN apt update && apt upgrade -y && apt install -y zsh git starship && rm -rf /var/lib/apt/lists/*
COPY exports.sh /root/.exports
COPY aliases.sh /root/.aliases
COPY zshrc.sh /root/.zshrc
RUN chmod -R 770 /root/.exports /root/.aliases /root/.zshrc
RUN zsh -c 'source /root/.zshrc'
ENTRYPOINT ["zsh"]

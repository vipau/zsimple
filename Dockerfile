FROM alpine:3.14
RUN apk add --no-cache zsh git starship
COPY exports.sh /root/.exports
COPY aliases.sh /root/.aliases
COPY zshrc.sh /root/.zshrc
RUN chmod -R 770 /root/.exports /root/.aliases /root/.zshrc
RUN zsh -c 'source /root/.zshrc'
ENTRYPOINT ["zsh"]

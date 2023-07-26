FROM scratch
COPY . /
ARG PORT
EXPOSE ${PORT}
ENTRYPOINT ["/cgish/bin/run"]

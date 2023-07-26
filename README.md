
# cgish

  `cgish` is a remedial HTTP server implemented with a CGI shell script.
  The `cgish` script is run by the busybox httpd server.

  This server is intended for testing HTTP services in Docker.

  The accompanying Makefile downloads and builds busybox from source.
  The Makefile also builds a very simple Docker image.
  Additional variables for make are supplied by the file `vars.mk`.


## BUILD DOCKER IMAGE
```
  $ git clone cgish
  $ cd cgish
  $ make
```

### BUILD NOTE:
Since this project is somewhat demonstrative, rather than
production-oriented, busybox compile dependencies are not
within scope here. Its not too tough.

Container image size on my system is a svelte 2.59MB.


## EXAMPLE SERVER USAGE
```
  $ docker run --publish=8080:8080 --interactive --rm cgish 8080
  > + /bin/busybox env -i /bin/busybox httpd -f -vvv -p 0.0.0.0:8080 -h /cgish
  > 172.17.0.1:56394: connected
  > 172.17.0.1:56394: url:/
  > 172.17.0.1:56394: closed
```


## EXAMPLE OUTPUT FROM CLIENT
```
  DATE=2023-06-28 19:21:22
  SERVER=5e1813dabae1
  GATEWAY_INTERFACE=CGI/1.1
  HTTP_ACCEPT=*/*
  HTTP_HOST=localhost:8080
  HTTP_USER_AGENT=curl/7.81.0
  PATH_INFO=
  PWD=/cgish/cgi-bin
  QUERY_STRING=
  REMOTE_ADDR=172.17.0.1
  REMOTE_PORT=47276
  REQUEST_METHOD=GET
  REQUEST_URI=/
  SCRIPT_FILENAME=/cgish/cgi-bin/index.cgi
  SCRIPT_NAME=/cgi-bin/index.cgi
  SERVER_PROTOCOL=HTTP/1.1
  SERVER_SOFTWARE=busybox httpd/1.37.0.git
  SHLVL=1
```


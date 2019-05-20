# boss-docker-python3
Bossjones repo for Ubuntu 16.04 w/ Python 3.5.2 compiled from source.

# Build

`docker build -t bossjones/boss-docker-python3 .`


### Build troubleshooting
If the Docker build fails, it can be handy to try running the build with pure
Docker. That way, you don't have to think through as many layers of
abstraction. One of the design principles of Tedi is that the rendered build
context sent to Docker is very much "normal" and can be fed straight to
Docker. Like this:

```
tedi render
docker build .tedi/build/elasticsearch-full
```

This also provides a mechanism for building the results of `tedi render` with
alternative build tools.

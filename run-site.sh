#/bin/bash

set -ex

sudo docker rm gcc d rust || true

GCC=$(sudo docker run --name gcc -d -p 10240:10240 mattgodbolt/gcc-explorer:gcc)
D=$(sudo docker run --name d -d -p 10241:10241 mattgodbolt/gcc-explorer:d)
RUST=$(sudo docker run --name rust -d -p 10242:10242 mattgodbolt/gcc-explorer:rust)

trap "sudo docker stop $GCC $D $RUST" SIGINT SIGTERM

sudo docker run \
	-p 80:80 \
    --volumes-from gcc \
	-v /var/log/nginx:/var/log/nginx \
	-v $(pwd)/nginx:/etc/nginx/sites-enabled \
	--link gcc:gcc --link d:d --link rust:rust \
	dockerfile/nginx
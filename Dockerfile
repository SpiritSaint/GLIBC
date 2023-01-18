FROM ubuntu:14.04

ENV PREFIX_DIR="/usr/glibc-compat" \
	GLIBC_VERSION="2.17"

COPY container/glibc /scripts
RUN mkdir -p /glibc-build \
    && mv /scripts/configparams /glibc-build/configparams

RUN apt-get -q update && \
	apt-get -qy install bison build-essential gcc-4.6 make gawk gettext openssl python3 texinfo autoconf binutils curl && \
    curl -LfsSk https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.xz | tar xfJ - && \
    cd /glibc-build && \
    /glibc-${GLIBC_VERSION}/configure \
        --prefix=${PREFIX_DIR} \
        --libdir=${PREFIX_DIR}/lib \
        --libexecdir=${PREFIX_DIR}/lib \
        --enable-multi-arch \
        --enable-stack-protector=strong && \
    make && make install && \
    tar --dereference --hard-dereference -zcf glibc-bin-${GLIBC_VERSION}.tar.gz ${PREFIX_DIR}

#!/bin/bash
NGINX_VERSION="1.11.1"
NGINX_TARBALL="nginx-${NGINX_VERSION}.tar.gz"
PCRE_VERSION="8.39"
PCRE_TARBALL="pcre-${PCRE_VERSION}.tar.gz"
OPENSSL_VERSION="1.0.2h"
OPENSSL_TARBALL="openssl-${OPENSSL_VERSION}.tar.gz"
CC=clang
CXX=clang++
 
if [[ "${1}" == "clean" ]]; then
  rm -rf nginx*
  rm -rf pcre-*
  rm -rf openssl-*
  exit 0
fi
 
if [[ ! -d "${NGINX_TARBALL%.tar.gz}" ]]; then
  wget "http://nginx.org/download/${NGINX_TARBALL}"
  wget "http://nginx.org/download/${NGINX_TARBALL}.asc"
  tar xvzf "${NGINX_TARBALL}" && rm -f "${NGINX_TARBALL}"
fi
 
if [[ ! -d "${PCRE_TARBALL%.tar.gz}" ]]; then
  wget "http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE_TARBALL}"
  wget "http://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE_TARBALL}.sig"
  tar xvzf "${PCRE_TARBALL}" && rm -f "${PCRE_TARBALL}"
fi
 
if [[ ! -d "${OPENSSL_TARBALL%.tar.gz}" ]]; then
  wget "http://www.openssl.org/source/${OPENSSL_TARBALL}"
  wget "http://www.openssl.org/source/${OPENSSL_TARBALL}.asc"
  tar xvzf "${OPENSSL_TARBALL}" && rm -f "${OPENSSL_TARBALL}"
  cd "${OPENSSL_TARBALL%.tar.gz}"
fi

gpg "${NGINX_TARBALL}.asc"
gpg "${OPENSSL_TARBALL}.asc"
gpg "${PCRE_TARBALL}.sig"

cd "nginx-${NGINX_VERSION}"
mkdir ../nginx
./configure \
 --with-pcre=../pcre-8.39 \
	--with-openssl=../openssl-1.0.2h \
	--http-client-body-temp-path=/var/lib/nginx/body \
	--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
	--http-proxy-temp-path=/var/lib/nginx/proxy \
	--http-scgi-temp-path=/var/lib/nginx/scgi \
	--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
	--http-log-path=/var/log/nginx-access.log \
	--with-openssl-opt=no-krb5 \
	--with-cpu-opt=native \
	--with-cc=clang \
	--with-cpp=clang++ \
	--with-zlib-asm=native \
	--with-sha1-asm \
	--with-md5-asm \
	--with-pcre-jit \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-http_gzip_static_module \
	--with-ipv6 \
	--without-http_ssi_module \
	--without-http_map_module \
	--without-http_split_clients_module \
	--without-http_browser_module \
	--with-mail=dynamic \
	--with-cc-opt='-g -Ofast -march=native -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
	--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
	--prefix=/usr/share/nginx \
	--conf-path=/etc/nginx/nginx.conf \
	--http-log-path=/var/log/nginx/access.log \
	--error-log-path=/var/log/nginx/error.log \
	--lock-path=/var/lock/nginx.lock \
	--sbin-path=/usr/sbin/nginx \
	--pid-path=/run/nginx.pid \
	--with-file-aio \
	--with-stream=dynamic \
	--with-threads \
	--with-http_v2_module \
	--with-http_slice_module
 
sed -i '/CFLAGS/s/ \-O //g' objs/Makefile
make && make install

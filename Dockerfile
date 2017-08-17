FROM alpine:3.6
MAINTAINER jochenvg

# package versions
ARG DDCLIENT_VER="3.8.3"

# install build time dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	bzip2 \
	curl \
	gcc \
	make \
	tar \
	wget && \

# install runtime dependencies
 apk add --no-cache \
	inotify-tools \
	perl \
	perl-digest-sha1 \
	perl-io-socket-ssl \
	perl-json && \

# install Perl cpan modules not in alpine
 curl -L http://cpanmin.us | perl - App::cpanminus && \
 cpanm JSON::Any && \

# install ddclient
 mkdir -p \
	/tmp/ddclient && \
 curl -o \
 /tmp/ddclient.tar.bz2 -L \
	"https://sourceforge.net/projects/ddclient/files/ddclient/ddclient-${DDCLIENT_VER}/ddclient-${DDCLIENT_VER}.tar.bz2/download" && \
 tar xf \
 /tmp/ddclient.tar.bz2 -C \
	/tmp/ddclient --strip-components=1 && \
 install -Dm755 /tmp/ddclient/ddclient /usr/bin/ && \
 mkdir -p /var/cache/ddclient && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/config/.cpanm \
	/root/.cpanm \
	/tmp/*


VOLUME /etc/ddclient
CMD ["ddclient", "-foreground"]


FROM mhart/alpine-node:4.5

MAINTAINER Leonid Makarov <leonid.makarov@ffwagency.com>

RUN apk add --no-cache \
	bash \
	coreutils \
	curl \
	git \
	python \
	dbus \
	firefox-esr \
	fontconfig \
	ttf-freefont \
	xvfb

# xvfb wrapper
COPY xvfb-run /usr/bin/xvfb-run

ENV PHANTOMJS_VERSION 2.1.1
ENV CASPERJS_VERSION 1.1.3
ENV SLIMERJS_VERSION 0.10.1

# Installing dependencies from archives - not only this allows us to control versions, 
# but the resulting image size is 130MB+ less (!) compared to an npm install (440MB vs 575MB).
RUN \
	mkdir -p /opt && \
	# PhantomJS
	echo "Downloading PhantomJS v${PHANTOMJS_VERSION}..." && \
	curl -sL "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" | tar jx && \
	mv phantomjs-$PHANTOMJS_VERSION-linux-x86_64 /opt/phantomjs && \
	ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
	echo "Fixing PhantomJS on Alpine" && \
	curl -sL "https://github.com/dustinblackman/phantomized/releases/download/$PHANTOMJS_VERSION/dockerized-phantomjs.tar.gz" | tar zx -C /

RUN \
	# CasperJS
	echo "Downloading CaperJS v${CASPERJS_VERSION}..." && \
	curl -sL "https://github.com/casperjs/casperjs/archive/1.1.3.tar.gz" | tar zx && \
	mv casperjs-$CASPERJS_VERSION /opt/casperjs && \
	ln -s /opt/casperjs/bin/casperjs /usr/bin/casperjs

RUN \
	# SlimerJS
	echo "Downloading SlimerJS v${SLIMERJS_VERSION}..." && \
	curl -sL -O "http://download.slimerjs.org/releases/$SLIMERJS_VERSION/slimerjs-$SLIMERJS_VERSION.zip" && \
	unzip -q slimerjs-$SLIMERJS_VERSION.zip && rm -f slimerjs-$SLIMERJS_VERSION.zip && \
	mv slimerjs-$SLIMERJS_VERSION /opt/slimerjs && \
	# Run slimer with xvfb
	echo '#!/usr/bin/env bash\nxvfb-run /opt/slimerjs/slimerjs "$@"' > /opt/slimerjs/slimerjs.sh && \
	chmod +x /opt/slimerjs/slimerjs.sh && \
	ln -s /opt/slimerjs/slimerjs.sh /usr/bin/slimerjs

RUN \
	# BackstopJS
	echo "Installing BackstopJS..." && \
	npm install -g garris/backstopjs

WORKDIR /src

ENTRYPOINT ["backstop"]

FROM behance/docker-base:2.6-ubuntu-18.04
MAINTAINER Malcolm Jones <bossjones@theblacktonystark.com>

# source: http://stackoverflow.com/questions/28517090/docker-hub-automated-build-fails-but-locally-not
ENV HOME=/root

# Prepare packaging environment
ENV DEBIAN_FRONTEND noninteractive

# Workaround for bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=807948
RUN chmod 0777 /tmp

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN set -x; rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      autoconf \
      automake \
      bzip2 \
      dpkg-dev \
      file \
      g++ \
      gcc \
      imagemagick \
      libbz2-dev \
      libc6-dev \
      libcurl4-openssl-dev \
      libdb-dev \
      libevent-dev \
      libffi-dev \
      libgdbm-dev \
      libgeoip-dev \
      libglib2.0-dev \
      libgmp-dev \
      libjpeg-dev \
      libkrb5-dev \
      liblzma-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libncurses5-dev \
      libncursesw5-dev \
      libpng-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libtool \
      libwebp-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      make \
      patch \
      unzip \
      xz-utils \
      zlib1g-dev \
      \
  # https://lists.debian.org/debian-devel-announce/2016/09/msg00000.html
      $( \
  # if we use just "apt-cache show" here, it returns zero because "Can't select versions from package 'libmysqlclient-dev' as it is purely virtual", hence the pipe to grep
        if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then \
          echo 'default-libmysqlclient-dev'; \
        else \
          echo 'libmysqlclient-dev'; \
        fi \
      ) \
    ; \
    \
    apt-get install -y \
        git \
        curl \
        wget \
        netbase \
        curl \
        locales \
        software-properties-common \
        ca-certificates \
    && \
    locale-gen en_US.UTF-8 \
    && \
    export LANG=en_US.UTF-8 \
    && \
    apt-get install -y --no-install-recommends \
    		tcl \
    		tk \
            wget \
            curl \
            ca-certificates && \
    apt-get install -y --no-install-recommends \
    		bzr \
    		git \
    		mercurial \
    		openssh-client \
    		subversion \
    		procps && \
    apt-get install -y --no-install-recommends \
    		autoconf \
    		automake \
    		bzip2 \
    		file \
    		g++ \
    		gcc \
    		imagemagick \
        libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev \
        bash \
    		make \
    		patch \
    		xz-utils \
      && \
    apt-get install -y tcl-dev tk-dev --no-install-recommends \
    	&& \
      apt-get autoclean -y && \
      apt-get autoremove -y && \
      rm -rf /var/lib/{cache,log}/ && \
      rm -rf /var/lib/apt/lists/*.lz4

RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg \
			dirmngr \
      resolvconf \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi

# workaround for bug: https://github.com/docker/libnetwork/issues/2187
# RUN ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.7.3

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 19.1.1

# SOURCE: http://www.linuxfromscratch.org/lfs/view/development/chapter06/Python.html
# --with-system-expat: This switch enables linking against system version of Expat.
# --with-system-ffi: This switch enables linking against system version of libffi.
# --with-ensurepip=yes: This switch enables building pip and setuptools packaging programs.

# && gpg -vvv --debug-all --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
# && gpg -vvv --debug-all --batch --verify python.tar.xz.asc python.tar.xz \
# && { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \

RUN set -ex \
	&& wget -O python.tar.xz 'https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz' \
  && wget -O python.tar.xz.asc 'https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz.asc' \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& rm -r "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
    --with-system-expat \
    --with-system-ffi \
    --with-pydebug \
	&& make -j "$(nproc)" \
	&& make install \
	&& ldconfig \
	\
# explicit path to "pip3" to ensure distribution-provided "pip3" cannot interfere
	&& if [ ! -e /usr/local/bin/pip3 ]; then : \
		&& wget -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
		&& python3 /tmp/get-pip.py "pip==$PYTHON_PIP_VERSION" \
		&& rm /tmp/get-pip.py \
	; fi \
# we use "--force-reinstall" for the case where the version of pip we're trying to install is the same as the version bundled with Python
# ("Requirement already up-to-date: pip==8.1.2 in /usr/local/lib/python3.6/site-packages")
# https://github.com/docker-library/python/pull/143#issuecomment-241032683
	&& pip3 install --no-cache-dir --upgrade --force-reinstall "pip==$PYTHON_PIP_VERSION" \
# then we use "pip list" to ensure we don't have more than one pip version installed
# https://github.com/docker-library/python/pull/100
	&& [ "$(pip list |tac|tac| awk -F '[ ()]+' '$1 == "pip" { print $2; exit }')" = "$PYTHON_PIP_VERSION" ] \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a -name test -o -name tests \) \
			-o \
			\( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/python ~/.cache \
    && cd /usr/local/bin \
	&& { [ -e easy_install ] || ln -s easy_install-* easy_install; } \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config \
    && pip3 install --no-cache-dir virtualenv virtualenvwrapper ipython \
    && apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4

# Overlay the root filesystem from this repo
COPY ./container/root /

ENV PYTHONWARNINGS ignore
RUN goss -g /tests/goss.python3.yaml validate

# NOTE: intentionally NOT using s6 init as the entrypoint
# This would prevent container debugging if any of those service crash
CMD ["/bin/bash", "/run.sh"]


LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Tony Dark Industries" \
  org.label-schema.name="boss-docker-python3" \
  org.label-schema.version="3.7.3" \
  org.label-schema.url="https://github.com/bossjones/boss-docker-python3" \
  org.label-schema.vcs-url="https://github.com/bossjones/boss-docker-python3" \
  license="Apache-2.0"
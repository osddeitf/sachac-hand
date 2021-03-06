FROM debian:buster-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
  libjpeg-dev \
  libtiff5-dev \
  libpng-dev \
  libfreetype6-dev \
  libgif-dev \
  libgtk-3-dev \
  libxml2-dev \
  libpango1.0-dev \
  libcairo2-dev \
  libspiro-dev \
  libuninameslist-dev \
  python3-dev \
  python3-pip \
  ninja-build \
  cmake \
  build-essential \
  gettext \
  git \
  ca-certificates

WORKDIR /
RUN ln -s /usr/local/lib/python3.7 /usr/local/lib/python3

# fontforge
RUN git clone https://github.com/fontforge/fontforge -b 20200314 --depth=1
RUN cd fontforge && \
  mkdir build && \
  cd build && \
  cmake -GNinja .. && \
  ninja && \
  ninja install

# autotrace
RUN apt-get install -y --no-install-recommends \
  intltool autopoint libtool libgraphicsmagick1-dev libpstoedit-dev
RUN git clone https://github.com/sachac/autotrace -b graphicsmagick --depth=1
RUN cd autotrace && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install
ENV LD_LIBRARY_PATH=/usr/local/lib

# Dependencies
RUN apt-get install woff-tools -y --no-install-recommends

# For libxml2-python3
RUN pip3 install setuptools wheel

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Fix aglfn
RUN cd /usr/local/lib/python3.7/dist-packages/aglfn && \
  git clone https://github.com/adobe-type-tools/agl-aglfn --depth=1

# ENTRYPOINT [ "fontforge", "-script" ]

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

WORKDIR /tmp

RUN apt update && \
    apt install -y \
    build-essential \
    pkg-config \
    cmake \
    gcc \
    gdb \
    wget \
    vim \
    git

RUN mkdir lastools && \
    cd lastools && \
    wget https://downloads.rapidlasso.de/lastools.tar.gz && \
    tar -xvf lastools.tar.gz

ENV TIFF_VERSION 4.0.9
RUN wget http://download.osgeo.org/libtiff/tiff-${TIFF_VERSION}.tar.gz && \
    tar -xvf tiff-${TIFF_VERSION}.tar.gz && \
    cd tiff-${TIFF_VERSION} && \
    cmake . && \
    make -j $(nproc) && \
    make install -j $(nproc)

RUN apt update && \
    apt install -y \
    zlib1g \
    zlib1g-dev

ENV LIBPNG_VERSION 1.4.22
RUN git clone --branch v${LIBPNG_VERSION} --single-branch https://github.com/glennrp/libpng && \
    cd libpng && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install -j$(nproc)

RUN apt-get update && \
    apt-get install -y libjpeg62-dev \
    proj-bin \
    mlocate \
    autotools-dev \
    automake \
    libtool \
    zip \
    proj-bin \
    libproj-dev \
    ccache

ENV GEOTIFF_VERSION 1.4.3
RUN git clone --branch ${GEOTIFF_VERSION} --single-branch https://github.com/OSGeo/libgeotiff && \
    cd libgeotiff && \
    cd libgeotiff && \
    mkdir build && \
    cd build && \
    export CFLAGS="-I/usr/include -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1" && \
    cmake -DBUILD_SHARED_LIBS=ON .. && \
    make -j$(nproc) && \
    make install -j$(nproc) && \
    cd .. && \    
    ./autogen.sh && \
    ./configure && \
    make dist && \
    tar xvzf libgeotiff-${GEOTIFF_VERSION}.tar.gz && \
    cd libgeotiff-${GEOTIFF_VERSION} && \
    mkdir build_autoconf && \
    cd build_autoconf && \
    CFLAGS="-Wall -Wextra -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1 -D BUILD_SHARED_LIBS=ON"  ../configure && \
    make -j3 && \
    make check && \
    cd .. && \
    mkdir build_cmake && \
    cd build_cmake && \
    cmake -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_C_FLAGS="-Wall -Wextra -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1" -DBUILD_SHARED_LIBS=ON .. && \
    make -j3 && \
    make install

RUN apt-get update && \
    apt-get install -y \
    gawk \
    bison

ENV LAS_VERSION 2.0.1
RUN git clone --branch v${LAS_VERSION} --single-branch https://github.com/LAStools/LAStools && \
    cd LAStools && \
    cd bin && \
    wget https://downloads.rapidlasso.de/lastools.tar.gz && \
    tar -xvf lastools.tar.gz && \
    cd .. && \
    cmake -D BUILD_SHARED_LIBS=ON . && \
    make -j $(nproc) && \
    make install -j $(nproc)

RUN wget https://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz && \
    tar -xvf jpegsrc.v6b.tar.gz

RUN apt update && \
    apt install -y \
    gnupg \
    software-properties-common

RUN mkdir -m755 -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
    apt update && \
    apt install -y qgis \
    qgis-plugin-grass

ENV PATH=/tmp/LAStools/bin:$PATH
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/tmp/LAStools/LASlib/lib:/usr/local/lib"
CMD [ "bash" ]

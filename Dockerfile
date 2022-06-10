FROM ubuntu:20.04

# Suppress warning from apt-get
ENV DEBIAN_FRONTEND noninteractive

# Add repository for Geopsy
RUN apt-get update \
	&& apt-get install -y software-properties-common \
	&& add-apt-repository -y ppa:beineri/opt-qt-5.14.2-focal

# Run update and install
RUN apt-get update && apt-get install -y \
	apt-utils \
	vim \
	less \
	wget \
	gawk \
	gv \
	libcairo2-dev \
	libpango1.0-dev \
	libgd-dev \
	unzip \
	g++ \
	gfortran \
	make \
	libfftw3-dev \
	liblapack-dev \
	libopenblas-dev \
	zlib1g-dev \
	cmake \
	netcdf-bin \
	libnetcdf-dev \
	libgdal-dev \
	libncurses-dev \
	git \
	python3-dev \
	python3-setuptools \
	python3-numpy \
	python3-numpy-dev \
	python3-scipy \
	python3-matplotlib \
	python3-pyqt5 \
	python3-pyqt5.qtopengl \
	python3-yaml \
	python3-progressbar \
	python3-jinja2 \
	python3-requests \
	python3-future \
	qt514-meta-full \ 
	libgl-dev \
	libreadline-dev \
	jq \
	libcurl4-gnutls-dev \
	gmt-gshhg-full \
	gmt-dcw \
	texlive-extra-utils \
	build-essential \
	zlib1g-dev

# Prepare dir
RUN mkdir /root/dist

# Install GNUPLOT 5.2.8
COPY files/gnuplot-5.2.8.tar.gz /root/dist

RUN cd /root/dist \
	&& tar xvfz gnuplot-5.2.8.tar.gz \
	&& rm /root/dist/gnuplot-5.2.8.tar.gz\ 
	&& cd /root/dist/gnuplot-5.2.8 \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /root/dist/gnuplot-5.2.8/src \
	&& rm *.o \
	&& cd /root/dist/gnuplot-5.2.8/docs \
	&& rm *.o

# Get GSAC and Install - reduced vers NP330
COPY files/NP330.Mar-13-2022.gae.tar.gz /root/dist

RUN cd /root/dist && tar xvfz NP330.Mar-13-2022.gae.tar.gz \
	&& rm /root/dist/NP330.Mar-13-2022.gae.tar.gz \
	&& cd /root/dist/PROGRAMS.330 \
	&& ./Setup LINUX6440 \
	&& cd /root/dist/PROGRAMS.330/CALPLOT/src/XVIG/src \
	&& make all clean \
    && cd /root/dist/PROGRAMS.330/CALPLOT/src/cmd.unx \
    && make docp \
    && make all \
    && cd /root/dist/PROGRAMS.330/CALPLOT/src/clib.unx \
    && make docp \
    && make all \
    && cd /root/dist/PROGRAMS.330/CALPLOT/src/flib.unx \
    && make docp \
    && make all \
    && cd /root/dist/PROGRAMS.330/CALPLOT/src/util \
    && make all \
    && cd /root/dist/PROGRAMS.330/CALPLOT/Utility \
    && make all \
    && cd /root/dist/PROGRAMS.330/readline-8.1 \
    && ./configure \
    && make static \
    && cp -p *.h /root/dist/PROGRAMS.330/include/readline \
    && cp -p *.a /root/dist/PROGRAMS.330/lib \
    && make clean \
    && cd /root/dist/PROGRAMS.330/VOLVIII/src \
    && make all \
    && cd /root/dist/PROGRAMS.330/VOLVIII/gsac.src \
    && make all \
    && cd /root/dist/PROGRAMS.330 \
    && rm -f C C.proto Csrconly Setup \
    && rm -rf CALPLOT include readline-8.1 SUBS VOLVIII \
    && echo 'export PATH=${PATH}:/root/dist/PROGRAMS.330/bin' >> /root/.bashrc
	
# Get pyrocko
RUN cd /root/dist/ \
	&& git clone https://git.pyrocko.org/pyrocko/pyrocko.git pyrocko

# Install pyrocko
RUN cd /root/dist/pyrocko \
	&& python3 setup.py install \
	&& rm /root/dist/pyrocko/evalresp-3.3.0.tar.gz \
	&& rm /root/dist/pyrocko/libmseed-2.19.6.tar.gz

# Install qlib
COPY files/qlib2.2018.157.tar.gz /root/dist

RUN cd /root/dist \
	&& tar xvfz qlib2.2018.157.tar.gz \
	&& rm /root/dist/qlib2.2018.157.tar.gz

COPY files/Makefile.qlib /root/dist/qlib2/Makefile

RUN mkdir /usr/local/share/man/man3

RUN cd /root/dist/qlib2 \
	&& make all64 install64 

# Install qmerge
COPY files/qmerge.2014.329.tar.gz /root/dist

RUN cd /root/dist \
	&& tar xvfz qmerge.2014.329.tar.gz \
	&& rm /root/dist/qmerge.2014.329.tar.gz

COPY files/Makefile.qmerge /root/dist/qmerge/Makefile

RUN cd /root/dist/qmerge \
	&& make all install 

# Get leapseconds
RUN wget http://www.ncedc.org/ftp/pub/programs/leapseconds -O /usr/local/etc/leapseconds

# Install qedit
COPY files/qedit.2013.260.tar.gz /root/dist
COPY files/Makefile.qedit /root/dist

RUN cd /root/dist \
  && tar xvfz qedit.2013.260.tar.gz \
  && rm /root/dist/qedit.2013.260.tar.gz \
  && mv /root/dist/Makefile.qedit /root/dist/qedit/Makefile \
  && cd /root/dist/qedit \
  && make all install

# Install msi
COPY files/msi-master.zip /root/dist

RUN cd /root/dist \
	&& unzip msi-master.zip \
	&& rm /root/dist/msi-master.zip \
	&& cd /root/dist/msi-master && make \
	&& echo 'export PATH=${PATH}:/root/dist/msi-master' >> /root/.bashrc

# Get GMT sources 6 from git
RUN wget https://github.com/GenericMappingTools/gmt/releases/download/6.0.0/gmt-6.0.0-src.tar.xz -O /root/dist/gmt-6.0.0-src.tar.xz

RUN wget https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz -O /root/dist/gshhg-gmt-2.3.7.tar.gz


RUN cd /root/dist \
	&& tar -xvf gmt-6.0.0-src.tar.xz \
	&& rm /root/dist/gmt-6.0.0-src.tar.xz \
	&& mv gmt-6.0.0 gmt-src-6.0.0 \
	&& tar xvfz gshhg-gmt-2.3.7.tar.gz \
	&& rm /root/dist/gshhg-gmt-2.3.7.tar.gz

# Fix GMT installation
RUN cd /root/dist/gmt-src-6.0.0 \
	&& cp cmake/ConfigUserTemplate.cmake cmake/ConfigUser.cmake \
	&& cd /root/dist/gmt-src-6.0.0/cmake \
	&& sed -i '/set.*CMAKE_INSTALL_PREFIX/{s/prefix_path/\/root\/dist\/gmt-6.0.0/}' ConfigUser.cmake \
	&& sed -i '/set.*CMAKE_INSTALL_PREFIX/{s/#//}' ConfigUser.cmake \
	&& sed -i '/set.*GSHHG_ROOT/{s/gshhg_path/\/root\/dist\/gshhg-gmt-2.3.7/}' ConfigUser.cmake \
	&& sed -i '/set.*GSHHG_ROOT/{s/#//}' ConfigUser.cmake \
	&& sed -i '/set.*COPY_GSHHG/{s/#//}' ConfigUser.cmake

# Compile GTM and Fix GMT environment
RUN cd /root/dist/gmt-src-6.0.0 \
    && mkdir build \
    && cd /root/dist/gmt-src-6.0.0/build \
	&& cmake .. \
	&& cmake --build . \
	&& cmake --build . --target install \
	&& echo 'export PATH=/root/dist/gmt-6.0.0/bin:${PATH}' >> /root/.bashrc

# Install Geopsy.3.4.1
COPY files/geopsypack-src-3.4.1.tar.gz /root/dist
RUN cd /root/dist \
	&& tar xvfz geopsypack-src-3.4.1.tar.gz \
	&& rm /root/dist/geopsypack-src-3.4.1.tar.gz

# Patch configure to avoid interactively asking for the license
RUN cd /root/dist/geopsypack-src-3.4.1 \
	&& sed -i '/^LICENSE_ACCEPTED/{s/no/yes/}' configure

# Run configure Geopsy
RUN cd /root/dist/geopsypack-src-3.4.1 \
	&& LD_LIBRARY_PATH=/opt/qt514/lib/  PATH=$PATH:/opt/qt514/bin/ ./configure -prefix /root/dist/geopsypack-3.4.1 \
	&& make && make install \
	&& cd /root/dist \
	&& rm -r geopsypack-src-3.4.1 \
	&& echo 'export PATH=/root/dist/geopsypack-3.4.1/bin:${PATH}' >> /root/.bashrc \
	&& echo 'export LD_LIBRARY_PATH=/opt/qt514/lib/' >> /root/.bashrc \
	&& echo 'export PATH=/opt/qt514/bin:${PATH}' >> /root/.bashrc

# Install ms2sac
COPY files/ms2sac.2013.266.tar.gz /root/dist

RUN cd /root/dist \
	&& tar xvfz ms2sac.2013.266.tar.gz \
	&& rm ms2sac.2013.266.tar.gz

COPY files/Makefile.ms2sac /root/dist/ms2sac/Makefile

RUN cd /root/dist/ms2sac \
	&& make \
	&& echo 'export PATH=/root/dist/ms2sac:${PATH}' >> /root/.bashrc


# Install RDSEED
COPY files/rdseed-5.3.1.tar.gz /root/dist
RUN cd /root/dist \
	&& tar xvfz rdseed-5.3.1.tar.gz \
	&& rm /root/dist/rdseed-5.3.1.tar.gz \
	&& cd /root/dist/rdseed-5.3.1/Include \
	&& sed -i 's/void decode_steim/int decode_steim/' rdseed.h \
	&& cd /root/dist/rdseed-5.3.1 \
	&& make \
	&& mv rdseed /usr/bin

RUN rm -rf /var/lib/apt/lists/* 

# Instal HVNEA script
COPY HVNEA.20220608.docker.tar.gz /root/

RUN cd /root \
	&& tar xvfz HVNEA.20220608.docker.tar.gz \
	&& rm /root/HVNEA.20220608.docker.tar.gz \
	&& cd /root/HVNEA \
	##&& rm INSTALL \
	&& mkdir /root/HVNEA/OUT

WORKDIR /root/HVNEA

CMD /bin/bash 

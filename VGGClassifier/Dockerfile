FROM ubuntu:16.04

LABEL org.opencontainers.image.licenses="BSD-3-Clause"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    wget \
    libboost-all-dev && \
    rm -rf /var/lib/apt/lists/*


RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O miniconda-install.sh
RUN bash miniconda-install.sh -b -p /miniconda
RUN rm miniconda-install.sh
ENV PATH=/miniconda/bin:${PATH}

RUN conda config --set always_yes yes --set changeps1 no 
RUN conda update -q conda
RUN conda info -a
RUN conda install python=3.7

RUN conda install tensorflow-gpu=1.15
RUN conda install numpy
RUN conda install scipy
RUN conda install h5py

COPY pipeline /scripts

ENTRYPOINT [ "/scripts/fly_wings.sh" ]

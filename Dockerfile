FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt update
RUN apt -y --fix-broken install
RUN apt -y install python3
RUN apt -y install vim
RUN apt -y install scala
RUN apt -y install pip
RUN pip3 install psutil

RUN mkdir /experiment
COPY ./packages /experiment/packages
COPY ./solc-verify /experiment/solc-verify
COPY ./install.sh /experiment/
COPY ./solc-smt /experiment/solc-smt
COPY ./setup.sh /experiment/
COPY ./solc-smt/libz3.so /usr/lib/

COPY ./dcv /experiment/dcv
COPY ./dcv/libz3java.so /usr/lib/

WORKDIR /experiment/
RUN ./install.sh
RUN ./setup.sh

COPY ./run.sh /experiment

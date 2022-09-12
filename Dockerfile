FROM docker.io/rockylinux:8

RUN yum -y install "@Development tools"
RUN make all


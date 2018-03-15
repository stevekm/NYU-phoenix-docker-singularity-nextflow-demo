# Demo containers for use with Singularity on NYU phoenix HPC
FROM ubuntu:16.04

MAINTAINER Stephen M. Kelly

# ~~~~~ BASIC SETUP ~~~~~ #
# location for apps
ENV PATH="/opt:${PATH}"

# location for misc scripts
RUN mkdir /opt/bin
ENV PATH="/opt/bin:${PATH}"

# location for misc data
RUN mkdir /data

# mount point for for NYULMC phoenix (Singluarity)
RUN mkdir /ifs

# add test script
ADD base_test.sh /opt/bin/base_test.sh

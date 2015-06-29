FROM centos:7
MAINTAINER michael@faille.io <michael@faille.io>

# Options as variables
ENV GO_VERSION 1.4.2
ENV ARCH amd64
ENV HBASE_VERSION 1.1.0.1
ENV HBASE_HOME=/hbase/hbase-$HBASE_VERSION
ENV OPENTSDB_DIR /usr/share/opentsdb/

# YUM config
RUN echo "pub  4096R/F4A80EB5 2014-06-23 CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org> Key fingerprint = 6341 AB27 53D7 8A78 A7C2  7BB1 24C6 A8A7 F4A8 0EB5" | gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# Base soft
RUN yum install -y wget git tar java-1.8.0-openjdk-headless vim supervisord; mkdir /var/log/supervisor

# Supervisor
ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/supervisor-bosun.ini /etc/supervisor.d/bosun.ini
ADD conf/supervisor-base.ini /etc/supervisor.d/base.ini
ADD conf/supervisor/supervisor-hbase.ini /etc/supervisor.d/hbase.ini
ADD conf/supervisor/supervisor-opentsdb.ini /etc/supervisor.d/opentsdb.ini
ADD conf/supervisor-bosun.ini /etc/supervisor.d/scollector.ini
ENV JAVA_HOME /usr/lib/jvm/jre


RUN wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz && tar -C /usr/local -xzf /GO_$GO_VERSION.linux-$ARCH.tar.gz && rm /go$GO_VERSION.linux-$ARCH.tar.gz && \
    wget http://apache.mirror.vexxhost.com/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz && mkdir /hbase && cd /hbase && tar -xzf /hbase-$HBASE_VERSION-bin.tar.gz && rm /hbase-$HBASE_VERSION-bin.tar.gz



# HADOOP & HBASE Setup
VOLUME /data/persistant/hbase
ADD conf/hbase-site.xml /hbase/hbase-$HBASE_VERSION/conf/hbase-site.xml
ADD lib/hadoop-lzo-0.4.20-SNAPSHOT.jar /hbase/hbase-$HBASE_VERSION/lib/hadoop-lzo-0.4.20-SNAPSHOT.jar
ADD lib/libgplcompression.so /hbase/hbase-$HBASE_VERSION/lib/native/libgplcompression.so
EXPOSE 60000
EXPOSE 60010
EXPOSE 60030

#OPENTSDB
RUN yum install https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0/opentsdb-2.1.0.noarch.rpm -y
EXPOSE 4242


# GO
RUN mkdir /go
ENV GOPATH  /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:/go/bin

#BOSUN & SCOLLECTOR
RUN go get bosun.org/cmd/bosun; mkdir /bosun; ln -s /go/bin/bosun /bosun/bosun
RUN go get bosun.org/cmd/scollector; mkdir /scollector; ln -s /go/bin/scollector  /scollector/scollector


ADD conf/start-opentsdb.sh /data/start-opentsdb.sh


#env COMPRESSION=gzip  /data/start-opentsdb.sh

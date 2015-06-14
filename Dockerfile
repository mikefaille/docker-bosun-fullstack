FROM centos:7
MAINTAINER michael@faille.io <michael@faille.io>

ENV VERSION 1.4.2
ENV ARCH amd64
ENV HBASE_VERSION 1.1.0.1
ENV OPENTSDB_DIR /usr/share/opentsdb/

RUN echo "pub  4096R/F4A80EB5 2014-06-23 CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org> Key fingerprint = 6341 AB27 53D7 8A78 A7C2  7BB1 24C6 A8A7 F4A8 0EB5" | gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

RUN yum install -y wget git tar


RUN wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && tar -C /usr/local -xzf /go$VERSION.linux-$ARCH.tar.gz && rm /go$VERSION.linux-$ARCH.tar.gz

RUN mkdir /go
ENV GOPATH  /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:/usr/local/go/bin:/go/bin
RUN go get bosun.org/cmd/bosun
RUN yum install -y vim
VOLUME /data/persistant/hbase
RUN  mkdir /hbase
RUN wget http://apache.mirror.vexxhost.com/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz && cd /hbase && tar -xzf /hbase-$HBASE_VERSION-bin.tar.gz && rm /hbase-$HBASE_VERSION-bin.tar.gz


ADD conf/hbase-site.xml /hbase/hbase-$HBASE_VERSION/conf/hbase-site.xml
ADD lib/hadoop-lzo-0.4.20-SNAPSHOT.jar /hbase/hbase-1.1.0.1/lib/hadoop-lzo-0.4.20-SNAPSHOT.jar
ADD lib/libgplcompression.so /hbase/hbase-1.1.0.1/lib/native/libgplcompression.so


RUN yum install java-1.8.0-openjdk-headless.x86_64 -y

ENV JAVA_HOME /usr/lib/jvm/jre

RUN yum install https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0/opentsdb-2.1.0.noarch.rpm -y
ADD conf/start-opentsdb.sh /data/start-opentsdb.sh

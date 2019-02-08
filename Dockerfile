FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
ENV SCALA_VERSION 2.12.8
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR /root

# Install utilities, scala and sbt
RUN \
	apt-get -qq -y update \
	&& apt-get -qq -y install \
		apt-transport-https \
		software-properties-common \
	&& add-apt-repository -y ppa:webupd8team/java \
	&& echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
	&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get -qq -y update \
	&& apt-get -qq -y install \
		curl \
		oracle-java8-installer \
		python-software-properties \
		sbt \
		wget \
	&& wget --progress=dot:mega https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz \
	&& tar -xzf /root/scala-${SCALA_VERSION}.tgz \
	&& find /root/scala-${SCALA_VERSION}/bin -type f \! -name '*.bat' -exec ln -sf ../..'{}' /usr/bin \; \
	&& rm -rf /var/lib/apt/lists/* /root/scala-${SCALA_VERSION}.tgz /root/project
RUN	java -version \
	&& scala -version \
	&& sbt info

CMD ["/bin/bash"]

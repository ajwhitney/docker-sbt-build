FROM ubuntu:xenial

# for add-apt-repository
RUN apt-get -qq -y update
RUN apt-get -qq -y install software-properties-common python-software-properties

# Install Java 8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -qq -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -qq -y oracle-java8-installer
RUN export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:jre/bin/java::")

# Install Scala and SBT
ENV SCALA_VERSION "2.11.8"
RUN apt-get remove scala-library scala
RUN wget "www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb"
RUN dpkg -i scala-"$SCALA_VERSION".deb
RUN apt-get -qq -y update
RUN apt-get -qq -y install scala
RUN wget http://apt.typesafe.com/repo-deb-build-0002.deb
RUN dpkg -i repo-deb-build-0002.deb
RUN apt-get -qq -y update
RUN apt-get -qq -y install sbt

CMD ["/bin/bash"]

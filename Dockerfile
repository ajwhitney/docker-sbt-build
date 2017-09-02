FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

# for add-apt-repository
RUN apt-get -qq -y update
RUN apt-get -qq -y install software-properties-common python-software-properties

# Useful Utils
RUN apt-get install curl

# Install Java 8
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -qq -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -qq -y oracle-java8-installer
ENV JAVA_HOME $(readlink -f /usr/bin/java | sed "s:jre/bin/java::")

# Install Scala and SBT
ENV SCALA_VERSION 2.11.11
ENV SBT_VERSION 0.13.16

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc && \
  ln -s ~/scala-$SCALA_VERSION/bin/scala /usr/bin/scala && \
  ln -s ~/scala-$SCALA_VERSION/bin/scalac /usr/bin/scalac && \
  ln -s ~/scala-$SCALA_VERSION/bin/scaladoc /usr/bin/scaladoc && \
  ln -s ~/scala-$SCALA_VERSION/bin/scalap /usr/bin/scalap && \
  ln -s ~/scala-$SCALA_VERSION/bin/fsc /usr/bin/fsc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

#RUN apt-get remove scala-library scala
#RUN wget "www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb"
#RUN dpkg -i scala-"$SCALA_VERSION".deb
#RUN apt-get -qq -y update
#RUN apt-get -qq -y install scala
#RUN wget http://apt.typesafe.com/repo-deb-build-0002.deb
#RUN dpkg -i repo-deb-build-0002.deb
#RUN apt-get -qq -y update
#RUN apt-get -qq -y install sbt

CMD ["/bin/bash"]

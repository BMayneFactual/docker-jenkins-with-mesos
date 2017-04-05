FROM jenkins
USER root

RUN apt-get update && apt-get -y install apt-utils libsasl2-modules libevent-dev 
RUN curl -s http://repos.mesosphere.com/debian/pool/main/m/mesos/mesos_1.1.0-2.0.107.debian81_amd64.deb > mesos.deb
RUN dpkg -x mesos.deb /tmp/mesos-pkg && rm mesos.deb

RUN cp /tmp/mesos-pkg/usr/lib/libmesos* /usr/lib/
RUN mkdir -p /var/jenkins_backups && chown jenkins:jenkins /var/jenkins_backups

ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so
ENV MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY

ADD plugins.txt .
RUN plugins.sh plugins.txt

#expose a backups volume for easy retrieval later
VOLUME ["/var/jenkins_home","/var/jenkins_backups"]

# sbt
RUN apt-get install -y apt-transport-https
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install -y sbt


#cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

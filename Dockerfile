FROM jenkins
USER root

RUN apt-get update && apt-get -y install apt-utils libsasl2-modules

RUN curl -s http://repos.mesosphere.com/debian/pool/main/m/mesos/mesos_0.28.0-2.0.16.debian81_amd64.deb > mesos.deb
RUN dpkg -x mesos.deb /tmp/mesos-pkg && rm mesos.deb

RUN cp /tmp/mesos-pkg/usr/lib/libmesos* /usr/lib/
RUN cp /tmp/mesos-pkg/usr/local/lib/libmesos* /usr/local/lib/

ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so
ENV MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY

ADD plugins.txt .
RUN plugins.sh plugins.txt

#cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



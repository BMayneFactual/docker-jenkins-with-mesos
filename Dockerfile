FROM jenkins
USER root

RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && apt-get update
RUN apt-get download mesos

RUN dpkg -x mesos_* /tmp/mesos-pkg && rm mesos_*

RUN cp /tmp/mesos-pkg/usr/lib/libmesos* /usr/lib/
RUN cp /tmp/mesos-pkg/usr/local/lib/libmesos* /usr/local/lib/

ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/lib/libmesos.so
ENV MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY

ADD plugins.txt .
RUN plugins.sh plugins.txt

#cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



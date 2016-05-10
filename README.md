# docker-jenkins-with-mesos
Jenkins that runs with the mesos framework inside marathon

This just extends the standard jenkins docker with libmesos and the mesos plugin.  It expects you to run it on marathon.  Ideally, you should use a persistent volume if you expect your data to survive reboots.

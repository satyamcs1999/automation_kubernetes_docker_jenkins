FROM centos

RUN yum install wget -y

RUN yum install curl -y

RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

RUN yum install jenkins -y

RUN yum install java-11-openjdk.x86_64 -y

RUN yum install git -y

RUN yum install python3 -y

CMD mkdir /root/python

CMD mkdir /root/perl

CMD mkdir /root/ruby

COPY docker.repo  /etc/yum.repos.d/ 

RUN yum install docker-ce  --nobest -y

CMD killall firewalld

CMD /usr/bin/dockerd

CMD java -jar /usr/lib/jenkins/jenkins.war

COPY dfile1  /root/python/

COPY dfile2  /root/perl/

COPY dfile3  /root/ruby/

CMD mkdir /pycode

CMD mkdir /perlcode

CMD mkdir /rubycode

CMD mkdir /code
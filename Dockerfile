FROM docker.io/fedora

LABEL lab.version="1-beta"
LABEL vendor="lab"
LABEL lab.release-date="2018-02-1"
LABEL lab.version.is-production=""

RUN dnf -y update; dnf -y install librabbitmq-tools librabbitmq rabbitmq-java-client httpd openssh-server mariadb-connector-c mariadb-libs libwebsockets mariadb-java-client procps-ng java-1.8.0-openjdk net-tools iputils iproute screen mc vim bind-utils ; dnf clean all; dnf update -y ; systemctl enable httpd.service sshd.service  ; mkdir -p /opt/scripts/ ; mkdir -p /root/.ssh/ ; mkdir /opt/wildfly/
# create a locked service user
RUN useradd -r nexus; usermod -L nexus

ADD scripts/start.sh /opt/scripts/start.sh
ADD scripts/wildfly.service /lib/systemd/system/wildfly.service
ADD scripts/nexus.service /lib/systemd/system/nexus.service
ADD fedora.key.pub /root/.ssh/authorized_keys
# just copy bz2 file , auto extract
ADD wildfly.bz2 /opt/   
#ADD nexus-3.10.0-04-unix.tar.gz /opt/
RUN systemctl enable wildfly.service
#RUN systemctl enable nexus.service

#WORKDIR /opt
# no need explict extract files
#RUN tar -xvf /opt/wildfly.bz2 -C /opt
#ENV PATH userpath /opt/wildfly

#RUN passwd
EXPOSE 80
EXPOSE 22
# wildfly server
EXPOSE 9000
EXPOSE 9990
EXPOSE 8443
EXPOSE 8080
# mysql server
EXPOSE 3306
# nexus server
EXPOSE 8081
# start system
CMD ["/usr/sbin/init"]


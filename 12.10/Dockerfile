
FROM debian:jessie

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		file \
		libaio1 \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& groupadd --system informix \
	&& useradd --system -m -d /opt/informix -g informix informix \
	&& echo "informix:informix" | chpasswd \
	\
	&& mkdir /var/log/informix \
	&& chown informix:informix /var/log/informix \
	\
	&& echo "+ +" > /etc/hosts.equiv \
	&& echo "ol_informix1210          9088/tcp" >> /etc/services \
	&& echo "dr_informix1210          9089/tcp" >> /etc/services \
	&& echo "lo_informix1210          9090/tcp" >> /etc/services \
	&& echo "ol_informix1210_json    27017/tcp" >> /etc/services


ADD 12.10.FC8DE-dist.tar.xz /
ADD run.sh /opt/informix/run.sh


EXPOSE 9088
EXPOSE 9089
EXPOSE 27017

USER informix
CMD [ "/bin/bash", "/opt/informix/run.sh" ]


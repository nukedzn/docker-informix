#!/bin/bash
#

initfile=/data/informix/.init
logfile=/var/log/informix/online.log
oninitargs=yv

# default dbspace sizes
physdbs=30720
logdbs=29696
datadbs=524288
sbspace=32768
tempdbs=262144

# setup environment
. "${HOME}/.profile"

if [ -z "${INFORMIXDIR}" ] ; then
	echo "INFORMIXDIR not set, something is not right!!!"
	echo "--- env ---"
	echo "$(env)"
	exit 1
fi

if [ ! -f "${initfile}" ] ; then

	# configure dbspace sizes
	sed -i s/__physdbs__/${physdbs}/    ${INFORMIXDIR}/etc/sysadmin/sch_init_ol_informix1210.sql
	sed -i s/__logdbs__/${logdbs}/      ${INFORMIXDIR}/etc/sysadmin/sch_init_ol_informix1210.sql
	sed -i s/__datadbs__/${datadbs}/    ${INFORMIXDIR}/etc/sysadmin/sch_init_ol_informix1210.sql
	sed -i s/__sbspace__/${sbspace}/    ${INFORMIXDIR}/etc/sysadmin/sch_init_ol_informix1210.sql
	sed -i s/__tempdbs__/${tempdbs}/    ${INFORMIXDIR}/etc/sysadmin/sch_init_ol_informix1210.sql

	# flag to initialise informix
	oninitargs="${oninitargs}i"

	touch ${initfile}

fi

# update sqlhosts with docker hostname
sed -i s/hostname/`hostname`/ ${INFORMIXSQLHOSTS}

# startup informix
oninit -${oninitargs}


# logs
tail -f ${logfile} &
tailpid=$!

# SIGTERM trap
trap "kill ${tailpid}; onmode -ky; exit $?" SIGTERM

wait ${tailpid}


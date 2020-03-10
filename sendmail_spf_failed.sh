#!/bin/bash
MAILSOURCE='root'
MAILDESTINATION='root'

DESTINATIONPATH='/root'
DESTINATIONFILE="${DESTINATIONPATH}/spf_failed_list.txt"

> ${DESTINATIONFILE}
for i in $(grep "DNS=" /var/cpanel/users/* | awk -F '=' '{print $2}'); do
        echo "@${i}" >> ${DESTINATIONFILE}
        grep -E "@${i}.*SPF:" /var/log/exim_mainlog | awk -F 'from ' '{print $2}' | uniq -c >> ${DESTINATIONFILE}
        mail -s 'sendmail_spf_failed.sh' -r ${MAILSOURCE} ${MAILDESTINATION} < ${DESTINATIONFILE}  
done


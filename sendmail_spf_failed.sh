#!/bin/bash
MAILSOURCE='root'
MAILDESTINATION='root'

DESTINATIONPATH='/root'
DESTINATIONFILE="${DESTINATIONPATH}/spf_failed_list.txt"

> ${DESTINATIONFILE}
for i in $(cat /etc/trueuserdomains | awk -F':' '{print $1}'); do
        echo "@${i}" >> ${DESTINATIONFILE}
        grep -E "@${i}.*SPF:" /var/log/exim_mainlog | grep "$(date --date="yesterday" +"%Y-%m-%d")" | awk -F 'H=|X=|F=|:' '{print $4}' | sort | uniq -c >> ${DESTINATIONFILE}        
done
mail -s 'sendmail_spf_failed.sh' -r ${MAILSOURCE} ${MAILDESTINATION} < ${DESTINATIONFILE}  

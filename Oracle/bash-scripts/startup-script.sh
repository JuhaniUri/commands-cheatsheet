!/bin/sh
# chkconfig: 345 99 10
# description: Oracle auto start-stop script.
#
# Change the value of ORACLE_HOME to specify the correct Oracle home
# directory for your installation.

ORACLE_HOME=/opt/product/12.1.0.2/db_1
#
# Change the value of ORACLE to the login name of the
# oracle owner at your site.
ORA_OWNER=oracle


if [ ! -f $ORA_HOME/bin/dbstart ]
then
    echo "Oracle startup: cannot start"
    exit
fi

case "$1" in
    'start')
        # Start the Oracle databases:
        # The following command assumes that the oracle login
        # will not prompt the user for any values
        su - $ORA_OWNER -c "$ORA_HOME/bin/dbstart $ORA_HOME"
        su - $ORA_OWNER -c "$ORA_HOME/bin/lsnrctl start LISTENER"
        touch /var/lock/subsys/dbora
        ;;
    'stop')
        # Stop the Oracle databases:
        # The following command assumes that the oracle login
        # will not prompt the user for any values
        su - $ORA_OWNER -c "$ORA_HOME/bin/lsnrctl stop LISTENER"
        su - $ORA_OWNER -c "$ORA_HOME/bin/dbshut $ORA_HOME"
        rm -f /var/lock/subsys/dbora
        ;;
esac

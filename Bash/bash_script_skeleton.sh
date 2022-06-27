#!/bin/bash
# General variables



main() {
    lock_ckeck
    settings
    run
}

run() {
    echo "Do something"
}

lock_ckeck() {
# Check is process is already running.
# If lock file already exists exit.
    LOCK_FILE=/tmp/script.lock
    if [ -e $LOCK_FILE ]
        then
        echo "export already running"
        exit 0;
    fi
# Create a lock file containing the current
# process id to prevent other tests from running.
echo $$ > $LOCK_FILE
}


syntax() {
    echo ""
    echo "Command description"
    echo ""
    echo "Usage:"
    echo "  command [options] [arguments]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Display this help message"
}



die() {
    builtin echo $@
    exit 1
}

main $@

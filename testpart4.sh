#!/bin/bash

################## FUNCTIONS START 
start()
{
    # input the directory with the node project in it
    directory=$1
    
    cd $directory

    # runs the stop script inside the package.json
    npm start

}

stop()
{
    directory=$1
    
    cd $directory
    # runs the stop script inside the package.json
    npm stop
}
################## FUNCTIONS END



################## VARIABLES 

command=$1

################## VARIABLES 



################## CASE START
# ./testpart4.sh "slkjdnfkdjsnakjnd"

case $command in
    "start")
        start $2
    ;;
    "stop")
        stop $2
    ;;
    *)
        echo "use start or stop as your command"
        exit 1
    ;;

esac

exit 0

################## CASE END 
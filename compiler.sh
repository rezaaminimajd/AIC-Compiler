#! /bin/bash

LANG=$2
CODE_PATH=`realpath $1`
ROOT_DIR=$PWD
LOG_PATH=$ROOT_DIR/compile.log
BIN_PATH=$ROOT_DIR/binary

# takes a string and append it to the log file as well as the console tty
function log {
  echo "$1" | tee -a $LOG_PATH
}

# generates info log
function info {
    log "===[INFO]===[`date +'%F-%T'`]=== : $1"
}

# generates warn log
function warn {
    log "===[WARN]===[`date +'%F-%T'`]=== : $1"
}

# generates FATAL log and exits with -1
function fatal {
    log "===[WARN]===[`date +'%F-%T'`]=== : $1"
    exit -1
}

# check weather or not exitcode was 0 and return
function check {
    if [ $1 -eq 0 ];then
        info "code compiled successfully!"
    else
        fatal "couldn't compile code!"
    fi
}
    
 
# empty log file
echo "" > $LOG_PATH

# make an isolated aread
mkdir isolated
cd isolated
info "made an isolated area"

# change directory to codebase
tar -xvzf $CODE_PATH
cd `ls -d */ | head -n1`
info "entered the code base"

#compile
case $LANG in

  python|py|python3|PYTHON|PY|PYTHON3)
    
    info "language detected: python"
    info "start compiling using pyinstaller"
    pyinstaller --onefile Controller.py >$LOG_PATH 2>&1
    check $?
    mv dist/Controller $BIN_PATH
    
    ;;

  cpp|c|C|CPP)
    info "language detected: C"
    info "start compiling using CMAKE"
    mkdir build
    cd build
    cmake .. >$LOG_PATH 2>&1
    make >$LOG_PATH 2>&1
    check $?
    mv client/client $BIN_PATH
    
    ;;

  java|JAVA)
    fatal "not currently supported!\n use [jar] instead"
    
    ;;

  jar|JAR)
    info "language detected: jar"
    info "start compiling using jar-stub"
    cat jar-stub.sh `ls | head -n1` > $BIN_PATH 2> $LOG_PATH  
    check
    
    ;;

  bin|BIN)
    warn "no compiling needed!"
    mv `ls | head -n1` $BIN_PATH 
    ;;

  *)
    fatal "type unknown!"
    ;;
esac


# make a tar.gz file
cd $ROOT_DIR
tar -cvzf bin.tgz binary

if [ $? -eq 0 ];then
    info "bin.zip file is ready to use"
else
    fatal "couldn't make the zip file"
fi

# clean up
rm -rf isolated


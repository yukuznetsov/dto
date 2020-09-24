#!/bin/sh

### Comment one of next lines to make 'testing' or 'production' branch:
BRANCH="test"
#BRANCH="prod"

### Comment next line to prevent service's descriptions downloading:
DOWNLOAD="yes"

WGET=`which wget`
WSDL2H=`which wsdl2h`
SOAPC2=`which soapcpp2`
DIFF=`which diff`
RM=`which rm`
MKDIR=`which mkdir`

WGET_FLAGS="-t 3"
WSDL2H_FLAGS="-c++ -c++11 -p -t typemap.dat"
#SOAPC2_FLAGS="-c++ -c++11 -1 -j -C -r"
SOAPC2_FLAGS="-c++ -c++11 -Ed -1 -j -C -r"

WSDL_DIR="../.truckstop.com"
SOAP_DIR="../.soap"
TEMP_DIR="../.temp"

if [ $BRANCH != '' ]; then
    echo "Preparing" $BRANCH "version."
else
    echo "'BRANCH' variable has to be defined."
    exit 1
fi

if [ $WGET = '' ]; then
    echo "Can't find 'wget'. Install 'wget' package first."
    exit 1
else
    echo "wget found:......."$WGET
fi

if [ $WSDL2H = '' ]; then
    echo "Can't find 'wsdl2h'. Install 'gsoap' package first."
    exit 1
else
    echo "wsdl2h found:....."$WSDL2H
fi

if [ $SOAPC2 = '' ]; then
    echo "Can't find 'soapcpp2'. Install 'gsoap' package first."
    exit 1
else
    echo "soapcpp2 found:..."$SOAPC2
fi

if [ $DIFF = '' ]; then
    echo "Can't find 'diff'. Install 'diffutils' package first."
    exit 1
else
    echo "diff found:..."$SOAPC2
fi

$MKDIR -p $WSDL_DIR

echo "\nDownloading wsdl files...\n"
if [ "$DOWNLOAD" = "yes" ]; then
    if [ "$BRANCH" = "test" ]; then
        $WGET $WGET_FLAGS http://testws.truckstop.com:8080/V13/Searching/LoadSearch.svc?singleWsdl -O $WSDL_DIR/LoadSearch.$BRANCH.wsdl
        if [ $? != 0 ]; then
            echo "Can't download LoadSearch(test) service wsdl description. Try later."
            exit 1
        else
            echo "LoadSearch(test) service wsdl description was downloaded successfully."
        fi
        $WGET $WGET_FLAGS http://testws.truckstop.com:8080/V13/RateMate/RateMate.svc?singleWsdl -O $WSDL_DIR/RateMate.$BRANCH.wsdl
        if [ $? != 0 ]; then
            echo "Can't download RateMate(test) service wsdl description. Try later."
            exit 1
        else
            echo "RateMate(test) service wsdl description was downloaded successfully."
        fi
    elif [ "$BRANCH" = "prod" ]; then
        $WGET $WGET_FLAGS http://webservices.truckstop.com/v13/Searching/LoadSearch.svc?singleWsdl -O $WSDL_DIR/LoadSearch.$BRANCH.wsdl
        if [ $? != 0 ]; then
            echo "Can't download LoadSearch(prod) service wsdl description. Try later."
            exit 1
        else
            echo "LoadSearch(prod) service wsdl description was downloaded successfully."
        fi
        $WGET $WGET_FLAGS http://webservices.truckstop.com/v13/RateMate/RateMate.svc?singleWsdl -O $WSDL_DIR/RateMate.$BRANCH.wsdl
        if [ $? != 0 ]; then
            echo "Can't download RateMate(prod) service wsdl description. Try later."
            exit 1
        else
            echo "RateMate(prod) service wsdl description was downloaded successfully."
        fi
    else
        echo "Unrecognized branch - $BRANCH."
    fi
else
    echo "\nDownloading wsdl files skiped by adjustment.\n"
fi

$MKDIR -p $SOAP_DIR
$MKDIR -p $TEMP_DIR

`$WSDL2H $WSDL2H_FLAGS $WSDL_DIR/LoadSearch.$BRANCH.wsdl $WSDL_DIR/RateMate.$BRANCH.wsdl -o $TEMP_DIR/TruckStop.h && $SOAPC2 $SOAPC2_FLAGS -d $SOAP_DIR $TEMP_DIR/TruckStop.h`
if [ $? != 0 ]; then
    echo "\nCan't make service's wrappers - wsdl2h or soapcpp2 exited unclean. Report errors."
    exit 1
fi

NSMAP_FILES=`ls $SOAP_DIR/*.nsmap`
`$DIFF $NSMAP_FILES`
if [ $? != 0 ]; then
    echo "\nCan't make service's wrappers - *.nsmap files are differ. Report errors."
    exit 1
else
    echo "\nAll done."
fi

for file in $NSMAP_FILES
do
    `cat $file > $SOAP_DIR/nsmap.h`
done

`$RM -f RECV.log`
`$RM -f TEST.log`

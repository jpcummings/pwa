#! /bin/sh

if [ ! -d $OSCLAS ]; then
	mkdir $OSCLAS;
fi

cd $OSCLAS; ../configure --includedir=$CLAS_PACK/inc_derived --libdir=$CLAS_LIB;


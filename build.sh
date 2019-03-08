#!/bin/bash

#
#  Simple build script.
#
#  Requires: FoBiS and Ford
#

#compiler flags:
case "$OSTYPE" in 
        darwin*)
        path=/opt/intel/compilers_and_libraries_2019.2.184/mac
        ;;
        linux*)
        path=/opt/ud/intel_xe_2019u2/compilers_and_libraries_2019.2.187/linux
        ;;
        *)
        ;;
esac

source $path/bin/compilervars.sh intel64
source $path/mkl/bin/mklvars.sh intel64

MODCODE='function_parser.f90'       # module file name
LIBOUT='libfparser.a'               # name of library
DOCDIR='./doc/'                     # build directory for documentation
SRCDIR='./src/'                     # library source directory
TESTSRCDIR='./src/tests/'           # unit test source directory
BINDIR='./bin/'                     # build directory for unit tests
LIBDIR='./lib/'                     # build directory for library
FORDMD='fortran_function_parser.md' # FORD config file name

rm -f ./lib/*.mod
rm -f ./lib/*.o
rm -f ./lib/*.a
rm -f ./bin/tests
rm -f ./bin/*.o

FCOMPILER='intel' #Set compiler to gfortran
FCOMPILERFLAGS='-c -Ofast -mkl -parallel -heap-arrays'
#FCOMPILERFLAGS='-Ofast -mkl -parallel -heap-arrays'

#build using FoBiS:
if hash FoBiS.py 2>/dev/null; then

    echo "Building library..."

    FoBiS.py build -compiler ${FCOMPILER} -cflags "${FCOMPILERFLAGS}" -dbld ${LIBDIR} -s ${SRCDIR} -dmod ./ -dobj ./ -t ${MODCODE} -o ${LIBOUT} -mklib static -colors

    #echo "Building test programs..."

    #FoBiS.py build -compiler ${FCOMPILER} -cflags "${FCOMPILERFLAGS}" -dbld ${BINDIR} -s ${TESTSRCDIR} -dmod ./ -dobj ./ -colors -libs ${LIBDIR}${LIBOUT} --include ${LIBDIR}

else
    echo "FoBiS.py not found! Cannot build library. Install using: sudo pip install FoBiS.py"
fi

# build the documentation using FORD:
#
#if hash ford 2>/dev/null; then
#
#    echo "Building documentation..."
#
#    ford ${FORDMD}
#
#else
#    echo "Ford not found! Cannot build documentation. Install using: sudo pip install ford"
#fi

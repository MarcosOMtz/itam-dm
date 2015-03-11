#!/bin/bash

cd ../../../data/KDD1998

#Descomprime en paralelo todo los .Z
ls *.Z | parallel '
if [ -f {.} ] 
then 
	echo "Ya está: {.}"
else 
	gunzip -c {}  >> {.}
	echo "Descomprimio exitosamente: {}"
fi
'



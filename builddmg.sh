#!/bin/bash

APPNAME=PDFSlide
VERSION=0.1
DIST=universal
DISTTMP=$APPNAME

rm -rf dist
mkdir dist
mkdir $DISTTMP

cp -r build/Release/PDFSlide.app $DISTTMP/
cp COPYING $DISTTMP/

hdiutil create -srcfolder $DISTTMP dist/$APPNAME.dmg
rm -rf $DISTTMP

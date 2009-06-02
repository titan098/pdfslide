#!/bin/bash

APPNAME=PDFSlide
VERSION=0.1
DIST=universal
DISTTMP=$APPNAME
SRCPATH=`pwd`
SRCDIR=`basename $SRCPATH`
GIT=/opt/local/bin/git

rm -rf /tmp/dist
mkdir /tmp/dist

#create the source archive
cd /tmp
rm -rf /tmp/$SRCDIR
$GIT clone $SRCPATH $SRCDIR
cd /tmp/$SRCDIR
$GIT checkout $VERSION
#strip cloned repo out of tmp
rm -rf .git

mkdir $DISTTMP
#build the release
xcodebuild -configuration Release

#copy files for disk image creating
cp -r build/Release/PDFSlide.app $DISTTMP/
cp COPYING $DISTTMP/

#create the disk image 
hdiutil create -srcfolder $DISTTMP /tmp/dist/$APPNAME-$VERSION.dmg
#rm -rf $DISTTMP
rm -rf build

#create the source archive
cd /tmp
tar cfz /tmp/dist/$APPNAME-$VERSION-src.tar.gz $SRCDIR

#copy /tmp/dist back to srcdir
cp -R dist $SRCPATH

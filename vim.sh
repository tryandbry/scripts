#!/bin/bash

VIMRC=/etc

if [ -e /etc/vimrc ]
then
cp $VIMRC/vimrc $VIMRC/vimrc.old.`date +%Y-%m-%d`
fi

echo "#### Adding parameters for editing code" >> $VIMRC/vimrc
echo "" >> $VIMRC/vimrc
echo ":syntax on" >> $VIMRC/vimrc
echo "set tabstop=2" >> $VIMRC/vimrc
echo "set shiftwidth=2" >> $VIMRC/vimrc
echo "set expandtab" >> $VIMRC/vimrc

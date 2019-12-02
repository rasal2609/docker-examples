#!/usr/bin/bash

# generate some I/O
dd if=/dev/random bs=4096 of=/mysql/db03/io.test count=65536 > /dev/null &

# 
iostat -tcxzN 1 10 | grep mysql

#!/bin/bash
tcpdump -i any -s 0 -l -w - dst port 3306 | strings 

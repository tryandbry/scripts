#!/bin/bash

iptables -F
iptables -I INPUT -p tcp --dport 20 -j ACCEPT
iptables -I INPUT -p tcp --dport 80 -j ACCEPT

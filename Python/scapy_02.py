#!/usr/bin/env python3
#coding utf-8

import os
from scapy.all import *

sniff(filter="icmp and host 103.235.46.39", count=2)

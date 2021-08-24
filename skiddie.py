#!/usr/bin/python
# References
# md5 in python: https://mkyong.com/python/python-md5-hashing-example/
# md5 differences unix vs python: https://superuser.com/questions/1192917/why-does-my-md5sum-hash-not-match-other-md5s

import sys
import os
import hashlib

# Variables
OP_OBFUSCATED = '6a46446f206e6f74206265206f766572636f6d65206279206576696x2x20627574206f766572636f6d65206576696x207769746820676f6f64202d20526f6d616e732031323a3231'
VALID_md5 = '0c5d5f7125f2b4480eceb234f11973d9'
KEYS = ["A", "B", "C", "D", "E", "F", "G"]

# Replace x char with a key, then try finding a valid md5
for i in KEYS:
    OP_TEMP = OP_OBFUSCATED.replace("x", i)
    OP_TEMP = OP_TEMP.lower()
    OP_TEMP = OP_TEMP.encode()
    OP_TEMP = (hashlib.md5(OP_TEMP).hexdigest())
    if OP_TEMP == VALID_md5:
        print (OP_TEMP, "IS valid using letter " + i.lower() + " !")
        VALID_MATCH = OP_TEMP
    else:
        print (OP_TEMP, "IS not valid!")

print (f"\n")

# Replace x with C now that we know its valid then decode OP DATA with hexdump
OP_KEY = OP_OBFUSCATED.replace("x", "c")
OP_REVEAL = os.system("echo " + OP_KEY + " | xxd -p -r ")
print (OP_REVEAL)

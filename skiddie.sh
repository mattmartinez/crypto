#!/bin/bash
# References
# mempool reference: https://mempool.emzy.de/de/tx/057954bb28527ff9c7701c6fd2b7f770163718ded09745da56cc95e7606afe99
# embedding OP_RETURN: https://bitcoindev.network/guides/bitcoinjs-lib/embedding-data-with-op_return/
# awk: https://www.baeldung.com/linux/bash-remove-first-characters

echo "Your only hint:"
echo "Treasure map marks the spot"
echo ""

# Scrambled OP code from tx 057954bb28527ff9c7701c6fd2b7f770163718ded09745da56cc95e7606afe99 on block 666666
OP_OBFUSCATED="6a46446f206e6f74206265206f766572636f6d65206279206576696x2x20627574206f766572636f6d65206576696x207769746820676f6f64202d20526f6d616e732031323a3231"

# Set the only valid md5 hash
VALID_md5="cd2d54ccf80335b843a3bd1a5b9c4182"

# Set keys to choose from to decipher
KEYS=("A B C D E F G")

# Test each key and replace x in the OP base64_decode (x marks the spot on a map.. ?)
echo "Testing keys against x character"
for i in $KEYS; do OP_TEMP=`echo -ne $OP_OBFUSCATED | sed "s/\x/${i}/g"|md5`;
echo "Testing ${i}" $OP_TEMP
  if [ "$OP_TEMP" = "$VALID_md5" ]; then
    echo "VALID"
  else
    echo "INVALID"
  fi
echo ""
done

sleep 2

# Try lower case testing each key and replace x in the OP base64_decode
echo "Testing keys against x in lowercase"
for i in $KEYS; do OP_TEMP_LOWER=`echo -ne $OP_OBFUSCATED | sed "s/\x/${i}/g" | tr [:upper:] [:lower:]|md5`;
echo Testing "${i}" $OP_TEMP_LOWER | tr [:upper:] [:lower:]
  if [ "$OP_TEMP_LOWER" = "$VALID_md5" ]; then
    echo "VALID"
  else
    echo "INVALID"
  fi
echo ""
done

sleep 2

# lower c is valid, lets reveal the message.
echo Decoding OP DATA with hexdump
echo $OP_OBFUSCATED | sed "s/\x/c/g" | tr [:upper:] [:lower:] | xxd -p -r | awk 'sub(/^.{2}/,"")'
echo ""

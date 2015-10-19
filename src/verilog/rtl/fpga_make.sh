#!/bin/sh

##Copy the *_defintitions file into all the file in the folder

TOP=fpga_core
ADEF=$TOP/alu_definitions.v
DDEF=$TOP/decode_definitions.v
GDEF=$TOP/global_defintions.v
LDEF=$TOP/lsu_definitions.v
IDEF=$TOP/issue_definitions.v

for f in $TOP/*; do
    if [[ ($f != $ADEF) && ($f != $DDEF) && ($f != $GDEF) && ($f != $LDEF) && ($f != $IDEF)  ]];then
        echo "Adding the defintions file to $f"
        ed -s $f <<< $'1i\n`include "global_definitions.v"\n.\nwq'
        ed -s $f <<< $'1i\n`include "lsu_definitions.v"\n.\nwq'
        ed -s $f <<< $'1i\n`include "issue_definitions.v"\n.\nwq'
        ed -s $f <<< $'1i\n`include "decode_definitions.v"\n.\nwq'
        ed -s $f <<< $'1i\n`include "alu_definitions.v"\n.\nwq'
        ed -s $f <<< $'1i\n`define FPGA_BUILD 1\n.\nwq'
    else
        echo "Not including $f"
    fi
done

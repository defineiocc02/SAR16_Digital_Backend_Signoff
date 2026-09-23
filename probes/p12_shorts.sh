#!/bin/bash
# What does Calibre's own SHORTS report say?  It is the authoritative list of
# nets it merged.
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs

echo "########## size / head ##########"
stat -c '%s B  %n' $L/lvs.rep.shorts
head -50 $L/lvs.rep.shorts

echo
echo "########## entries mentioning rst_n ##########"
grep -an 'rst_n' $L/lvs.rep.shorts | head -20

echo
echo "########## how many short groups ##########"
grep -acE 'SHORT|Short circuit|^ *[0-9]+ +Net' $L/lvs.rep.shorts

echo
echo "########## the VDD group in full (first 60 lines of it) ##########"
awk '/VDD/{f=1} f{print; n++} n>60{exit}' $L/lvs.rep.shorts

echo
echo "########## ERC report ##########"
cat $L/erc.rep

echo
echo "########## deck: every CONNECT / SCONNECT / soft-connect rule ##########"
grep -anE '^\s*(CONNECT|SCONNECT|SOFTConnect|\*CONNECT)' $L/mylvs.lvs | head -40

echo
echo "########## deck: nwell/psub to power ties ##########"
grep -anE 'CONNECT.*(nwell|psub|VDD|VSS)' $L/mylvs.lvs | head -30

set work $::env(SAR16_IMPL_DIR)
read_db $work/results/extracted.odb
report_wire_length -net * -detailed_route -verbose -file $work/reports/wire_lengths.csv
foreach name {net106 net108 net111 net99 net113 _0827_ _0934_} {
 check_antennas -net $name -verbose -report_file $work/reports/antenna_target_${name}.rpt
}
exit

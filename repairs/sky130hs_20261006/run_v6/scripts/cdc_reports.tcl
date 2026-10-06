# Run after SPEF annotation and propagation. Main reports keep all actual
# constraints. Separate measurement-only min paths do not assert phase timing.
to_file $work/reports/${tag}_local_reset_recovery.rpt {report_checks -path_group asynchronous -path_delay max -group_path_count 10 -digits 6}
to_file $work/reports/${tag}_local_reset_removal.rpt {report_checks -path_group asynchronous -path_delay min -group_path_count 10 -digits 6}
set cdcfile $work/reports/${tag}_cdc_max_paths.rpt
set fp [open $cdcfile w];close $fp
set jf $work/reports/${tag}_cdc_max_paths.jsonl
set fp [open $jf w];close $fp
foreach rec $cdc_entries {
 lassign $rec kind src dst bound sp dp
 set from [get_cells -of_objects $sp]
 set fp [open $cdcfile a];puts $fp "CDC_ENTRY $kind $src $dst BOUND_NS $bound";close $fp
 report_checks -from $from -to $dp -path_delay max -group_path_count 1 -format full_clock_expanded -digits 6 -fields {slew capacitance fanout net input_pin} >> $cdcfile
 report_checks -from $from -to $dp -path_delay max -group_path_count 1 -format json -digits 9 >> $jf
}
# Audit first-to-second-stage paths are timed normally in destination domains.
set sf $work/reports/${tag}_synchronizer_stage12.rpt
set fp [open $sf w];close $fp
foreach target {req_s1 ack_s1 done_s1} {
 set sp [reg_q_pin u_srm_residue.$target]
 report_checks -from [get_cells -of_objects $sp] -path_delay min_max -group_path_count 3 -digits 6 >> $sf
}
foreach target {ones_g_s1 tot_g_s1} {
 for {set b 0} {$b < 5} {incr b} {
  set sp [reg_q_pin [format {u_srm_residue.%s[%d]} $target $b]]
  report_checks -from [get_cells -of_objects $sp] -path_delay min_max -group_path_count 1 -digits 6 >> $sf
 }
}
# A conservative skew certificate follows from non-negative physical data-path
# delays and every bit's enforced max bound (< one source period). Also report
# actual min/max data-path delay span without an asynchronous clock phase claim.
set mf $work/reports/${tag}_cdc_measurement_min.rpt
set fp [open $mf w];close $fp
foreach rec $cdc_entries {
 lassign $rec kind src dst bound sp dp
 if {$kind != "gray"} {continue}
 set from [get_cells -of_objects $sp]
 unset_path_exceptions -hold -from $from -to $dp
 set_min_delay 0 -ignore_clock_latency -from $from -to $dp
 set fp [open $mf a];puts $fp "CDC_ENTRY $kind $src $dst MEASUREMENT_ONLY_MIN";close $fp
 report_checks -from $from -to $dp -path_delay min -group_path_count 1 -digits 6 -format full_clock_expanded >> $mf
 # Restore actual asynchronous hold exception after the measurement.
 unset_path_exceptions -hold -from $from -to $dp
 set_false_path -hold -from $from -to $dp
}
puts "CDC_MAX_DELAY_AND_SPAN_AUDIT_COMPLETE $tag"

set w $::env(SAR16_CANDIDATE)
read_db $w/results/routed.odb
set_thread_count 4
drt::check_drc -output_file $w/reports/route_drc.rpt
puts "CANDIDATE_ROUTER_DRC_COMPLETED"
exit

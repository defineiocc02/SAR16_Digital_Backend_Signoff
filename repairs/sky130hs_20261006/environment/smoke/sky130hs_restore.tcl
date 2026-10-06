set p $::env(SKY130HS_ROOT)
read_lef $p/lef/sky130_fd_sc_hs.tlef
read_lef $p/lef/sky130_fd_sc_hs_merged.lef
read_liberty $p/lib/sky130_fd_sc_hs__tt_025C_1v80.lib
set db [ord::get_db]
set libs [$db getLibs]
set master_count 0
foreach lib $libs { incr master_count [llength [$lib getMasters]] }
if {$master_count != 390} { error "Expected 390 SKY130HS masters, found $master_count" }
set liberty_count [llength [get_lib_cells *]]
if {$liberty_count < 300} { error "Too few SKY130HS Liberty cells: $liberty_count" }
puts "SKY130HS_MASTER_COUNT $master_count"
puts "SKY130HS_LIBERTY_COUNT $liberty_count"
puts "SKY130HS_PINNED_RESTORE_SMOKE_PASS"
exit

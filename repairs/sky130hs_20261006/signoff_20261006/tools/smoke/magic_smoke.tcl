drc on
load tool_smoke
box 0 0 20 20
paint metal1
drc check
drc catchup
puts "MAGIC_SMOKE_CLEAN_DRC=[drc list count total]"
gds write tool_smoke_magic.gds
save tool_smoke
extract all
ext2spice lvs
ext2spice -o tool_smoke_magic.spice
load bad_smoke
box 0 0 1 1
paint metal1
drc check
drc catchup
set n [drc list count total]
puts "MAGIC_SMOKE_DELIBERATE_DRC=$n"
if {$n <= 0} {error "Deliberate narrow metal was not flagged"}
puts "MAGIC_SMOKE_PASS"
quit -noprompt

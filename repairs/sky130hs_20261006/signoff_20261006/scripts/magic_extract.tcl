set w $::env(SAR16_SIGNOFF)
drc off
gds readonly true
gds rescale false
cif istyle sky130()
gds maskhints true
gds read $w/results/baseline.gds
load sar_digi_paper_core -dereference
select top cell
expand
file mkdir $w/results/extraction
cd $w/results/extraction
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
extract unique
extract all
ext2spice lvs
ext2spice -o $w/results/baseline.extracted.spice sar_digi_paper_core.ext
feedback save $w/reports/magic_extraction_feedback.txt
puts "MAGIC_EXTRACT_COMPLETE"
quit -noprompt

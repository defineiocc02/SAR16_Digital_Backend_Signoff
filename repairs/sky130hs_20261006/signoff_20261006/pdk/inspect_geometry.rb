require 'json'
root=File.dirname(__FILE__)
base=File.expand_path('../../../environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs/gds/sky130_fd_sc_hs.gds', __FILE__)
base=File.join(File.dirname(File.dirname(root)), 'environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs/gds/sky130_fd_sc_hs.gds')
l=RBA::Layout.new
l.read(base)
puts "DBU #{l.dbu}; cells #{l.cells}"
puts l.each_cell.take(5).map{|c|c.name}.join(',')
s=RBA::Layout.new
s.read(File.join(root,'src/skywater-pdk-libs-sky130_fd_sc_hs-1d051f49bfe4e2fe9108d702a8bc2e9c081005a4/cells/conb/sky130_fd_sc_hs__conb_1.gds'))
puts "Source DBU #{s.dbu}; cells #{s.cells}"
puts s.each_cell.map{|c|c.name}.join(',')

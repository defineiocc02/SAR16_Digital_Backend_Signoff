require 'fileutils'
ly = RBA::Layout.new
ly.dbu = 0.001
cell = ly.create_cell('TOOL_SMOKE')
layer = ly.layer(67, 20)
cell.shapes(layer).insert(RBA::Box.new(0, 0, 1000, 1000))
cell.shapes(layer).insert(RBA::Box.new(2000, 0, 2050, 1000))
ly.write(File.join($smoke_dir, 'tool_smoke.gds'))
copy = RBA::Layout.new
copy.read(File.join($smoke_dir, 'tool_smoke.gds'))
raise 'GDS round-trip failed' unless copy.top_cell.name == 'TOOL_SMOKE'
reg = RBA::Region.new(copy.top_cell.begin_shapes_rec(copy.layer(67, 20)))
errors = reg.width_check(140)
raise 'Expected deliberate width violation' unless errors.size > 0
puts 'KLAYOUT_SMOKE_PASS: GDS round-trip; width-check detected deliberate narrow rectangle'

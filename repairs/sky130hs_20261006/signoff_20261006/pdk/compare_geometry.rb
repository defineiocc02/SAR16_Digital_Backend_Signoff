require 'json'
root=File.dirname(__FILE__)
base=File.join(File.dirname(File.dirname(root)), 'environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs/gds/sky130_fd_sc_hs.gds')
l=RBA::Layout.new
l.read(base)
used=JSON.parse(File.read(File.join(root,'used_cells.json')))
results=[]
used.each do |name|
  family=name.split('__')[1].sub(/_[0-9]+$/, '')
  p=File.join(root, 'src/skywater-pdk-libs-sky130_fd_sc_hs-1d051f49bfe4e2fe9108d702a8bc2e9c081005a4/cells', family, name+'.gds')
  s=RBA::Layout.new
  s.read(p)
  raise 'Different DBU' if (l.dbu-s.dbu).abs>1e-12
  c=l.cell(name); d=s.cell(name)
  raise "Missing #{name}" if !c || !d
  layers=(l.layer_infos+s.layer_infos).map{|x|[x.layer,x.datatype]}.uniq
  diffs=[]
  layers.each do |n,t|
    i=l.find_layer(n,t); j=s.find_layer(n,t)
    a=i ? RBA::Region.new(c.begin_shapes_rec(i)) : RBA::Region.new
    b=j ? RBA::Region.new(d.begin_shapes_rec(j)) : RBA::Region.new
    diff=a^b
    diffs << {layer:n,datatype:t,area_um2:diff.area*l.dbu*l.dbu,bbox:diff.bbox.to_s} if !diff.is_empty?
  end
  results << {cell:name,geometry_equal:diffs.empty?,differences:diffs}
end
File.write(File.join(root,'orfs_vs_upstream_geometry.json'),JSON.pretty_generate({orfs_gds:base,source_commit:'1d051f49bfe4e2fe9108d702a8bc2e9c081005a4',tested_cells:results.size,equal_cells:results.count{|x|x[:geometry_equal]},results:results})+"\n")
puts "Geometrically equal: #{results.count{|x|x[:geometry_equal]}} / #{results.size}"
puts results.select{|x|!x[:geometry_equal]}.to_json

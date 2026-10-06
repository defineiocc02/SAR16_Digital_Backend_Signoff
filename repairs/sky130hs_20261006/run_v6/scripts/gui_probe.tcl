read_db $::env(SAR16_IMPL_DIR)/results/extracted.odb
puts "ENABLED [gui::enabled]"
puts "SAVE [gui::save_display_controls]"
foreach prefix {Nets Signals Routing Layers} {
 foreach suffix {Power Ground Signal Clock met1} {
  set rc [catch {gui::check_display_controls "$prefix/$suffix" visible} val]
  puts "CONTROL $prefix/$suffix -> $rc / $val"
 }
}
save_image $::env(SAR16_IMPL_DIR)/reports/gui_probe.png -width 1400 -area {0 0 392.98 392.98}
exit

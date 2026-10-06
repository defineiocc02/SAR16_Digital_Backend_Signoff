foreach c {repair_antennas check_antennas detailed_route write_guides set_nets_to_route global_route repair_timing} {help $c}
puts "GUI_COMMANDS [info commands gui::*]"
exit

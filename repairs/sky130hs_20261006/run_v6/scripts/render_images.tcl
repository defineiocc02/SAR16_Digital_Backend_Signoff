set work $::env(SAR16_IMPL_DIR)
read_db $work/results/extracted.odb
file mkdir $work/images
save_image $work/images/01_routed_full.png -width 2000 -area {0 0 392.98 392.98}
gui::set_display_controls "Nets/Power" visible false
gui::set_display_controls "Nets/Ground" visible false
save_image $work/images/02_routed_signals.png -width 2000 -area {0 0 392.98 392.98}
# First mention uses the actual post-reconstruction output branches; the prior
# route is unavailable and no before/after geometry claim is made.
gui::highlight_net net106 0
gui::highlight_net net108 1
save_image $work/images/03_raw_output_branches.png -width 2000 -area {0 0 392.98 392.98}
gui::clear_highlights -1
gui::highlight_net _0827_ 0
gui::highlight_net net111 1
save_image $work/images/04_eco_target_branches.png -width 2000 -area {0 0 392.98 392.98}
gui::clear_highlights -1
foreach layer {met1 met2 met3 met4 met5} {
 gui::set_display_controls "Layers/*" visible false
 gui::set_display_controls "Layers/$layer" visible true
 save_image $work/images/layer_${layer}.png -width 1800 -area {0 0 392.98 392.98}
}
exit

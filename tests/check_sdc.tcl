# No EDA semantics are simulated here. Test propagation of required-command errors.
set candidate [file join [file dirname [file dirname [file normalize [info script]]]] constraints sar_digi_paper_core_pnr.sdc]
set mock_failure ""
set missing_port ""
set mock_clocks [dict create]

proc get_ports {args} {
    global missing_port
    set pattern [lindex $args end]
    if {$pattern eq $missing_port} {return {}}
    return $pattern
}
proc get_clocks {args} {
    global mock_clocks
    set name [lindex $args end]
    if {[dict exists $mock_clocks $name]} {return [list $name]}
    return {}
}
proc sizeof_collection {value} {return [llength $value]}
proc get_attribute {clock attribute} {
    global mock_clocks
    if {$attribute ne "period"} {error "unsupported mock attribute"}
    return [dict get $mock_clocks [lindex $clock 0]]
}
proc all_inputs {} {return {clk dec_clk rst_n raw_bits_i}}
proc all_outputs {} {return {raw_code_o}}
proc remove_from_collection {value removed} {return $value}
proc current_block {} {return sar_digi_paper_core}
proc mock_command {command args} {
    global mock_failure mock_clocks
    if {$command eq $mock_failure} {error "injected failure of $command"}
    if {$command eq "create_clock"} {
        set name [lindex $args [expr {[lsearch -exact $args -name] + 1}]]
        set period [lindex $args [expr {[lsearch -exact $args -period] + 1}]]
        dict set mock_clocks $name $period
    }
    return {}
}
foreach command {
    create_clock set_propagated_clock set_clock_uncertainty set_clock_latency
    set_clock_transition set_clock_groups set_false_path set_input_delay
    set_input_transition set_output_delay set_load set_max_transition set_max_fanout
} {
    proc $command {args} [format {return [mock_command %s {*}$args]} $command]
}

set cases 0
foreach fault {
    {} create_clock set_clock_uncertainty set_clock_groups set_false_path
    set_input_delay set_output_delay set_load set_max_transition set_max_fanout
} {
    set mock_failure $fault
    set mock_clocks [dict create]
    set status [catch {source $candidate} message]
    if {$fault eq ""} {
        if {$status != 0} {error "normal source failed: $message"}
        if {[dict get $mock_clocks clk] != 10.0 || [dict get $mock_clocks dec_clk] != 3.0} {
            error "clock assumptions changed"
        }
    } elseif {$status == 0 || [string first "injected failure of $fault" $message] < 0} {
        error "required constraint failure was swallowed: $fault ($message)"
    }
    incr cases
}
set mock_failure ""
set missing_port rst_n
set mock_clocks [dict create]
if {![catch {source $candidate} message] || [string first "Required SDC port pattern is missing: rst_n" $message] < 0} {
    error "missing required port was not rejected"
}
incr cases
puts "SDC_FAILFAST_PASS cases=$cases (Tcl mocks only; FC validation pending)"

proc to_file {filename body} {
    utl::redirectFileBegin $filename
    set status [catch {uplevel 1 $body} value options]
    utl::redirectFileEnd
    if {$status} { return -options $options $value }
    return $value
}

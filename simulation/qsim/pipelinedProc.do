onerror {quit -f}
vlib work
vlog -work work pipelinedProc.vo
vlog -work work pipelinedProc.vt
vsim -novopt -c -t 1ps -L cycloneiv_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.pipelinedProc_vlg_vec_tst
vcd file -direction pipelinedProc.msim.vcd
vcd add -internal pipelinedProc_vlg_vec_tst/*
vcd add -internal pipelinedProc_vlg_vec_tst/i1/*
add wave /*
run -all

vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/ramif/*
run 0
coverage save top.ucdb -onexit
run -all

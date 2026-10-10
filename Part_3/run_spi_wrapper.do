vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/spi_wrapperif/*
run 0
coverage save top.ucdb -onexit
run -all

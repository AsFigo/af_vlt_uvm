.PHONY: vlt clean

vlt:
	verilator -j `nproc` -f flist 2>&1 | tee af_vlt_uvm_comp.log
	./obj_dir/Vaf_hello_world_uvm 2>&1 | tee af_vlt_uvm_run.log

clean:
	rm -fr obj_dir *.log

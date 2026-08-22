.PHONY: vlt clean

vlt:
	verilator -f flist 2>&1 | tee vlt_comp.log
	./obj_dir/Vaf_hello_world_uvm 2>&1 | tee vlt_run.log

clean:
	rm -fr obj_dir *.log

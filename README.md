# af_vlt_uvm

Getting UVM to compile and run on Verilator takes more setup than it should.
This repo gives you a working Verilator+UVM flow out of the box, plus the
`af_uvm` macro library for everyday testbench tasks.

Inspired by Go2UVM (VerifWorks).

## Getting started

Clone the repo and source the setup script once per shell session:

```sh
git clone https://github.com/asfigo/af_vlt_uvm
cd af_vlt_uvm

# bash/zsh — works from any directory
source setup.sh

# csh/tcsh — must cd to repo root first
cd af_vlt_uvm
source setup.csh
```

This sets `AF_VLT_UVM_HOME` (repo root), `UVM_HOME` (bundled UVM BCL), and `AF_UVM_HOME` (af_uvm library). All flists reference `scripts/af_uvm_src.f` via `${AF_VLT_UVM_HOME}`, so examples work from any directory.

## Quick start

```sh
cd examples/af_hello_world_uvm/sim_dir
make vlt
```

## Documentation

TBD: https://asfigo.github.io/af_vlt_uvm

## License

Apache 2.0 — Copyright 2023-2026 AsFigo Technologies, UK.

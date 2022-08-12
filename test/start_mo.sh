#!/bin/bash
ulimit -n 102400
nohup ./mo-server ./system_vars_config.toml > mo-server.log &

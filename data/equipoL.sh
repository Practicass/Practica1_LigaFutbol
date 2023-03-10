#!/bin/bash
cat LigaHost.csv | cut -d ';' -f  6,8-9,15 | sort | uniq  >equipoL.csv
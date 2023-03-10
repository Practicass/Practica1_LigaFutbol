#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 6-7  | sort | uniq  >equipoV.csv
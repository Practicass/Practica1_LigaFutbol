#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 14-16  | sort | uniq  >estadios.csv
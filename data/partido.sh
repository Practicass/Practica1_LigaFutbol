#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 7,20,21  | sort | uniq  >partido.csv
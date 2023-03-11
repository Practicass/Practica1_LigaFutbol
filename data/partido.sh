#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 6-9,15,20-22 | cut -d '"' -f 1   | sort | uniq  >partido.csv
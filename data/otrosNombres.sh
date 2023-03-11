#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 6,18,22 | cut -d '"' -f 1  | sort | uniq  >otrosNombres.csv
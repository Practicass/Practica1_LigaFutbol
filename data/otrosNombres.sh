#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 14,18  | sort | uniq  >otrosNombres.csv
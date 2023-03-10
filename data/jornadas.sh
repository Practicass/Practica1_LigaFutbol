#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 4,6  | sort | uniq  >jornada.csv
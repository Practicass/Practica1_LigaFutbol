#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 5,19-20  | sort | uniq  >jornada.csv
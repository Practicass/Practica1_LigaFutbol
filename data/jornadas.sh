#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 5,19-20,22 | cut -d '"' -f 1  | sort | uniq  >jornada.csv
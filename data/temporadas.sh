#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 1-3,19,22 | cut -d '"' -f 1  | sort | uniq  >temporada.csv
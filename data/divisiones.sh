#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 3  | sort | uniq  >divisiones.csv
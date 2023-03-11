#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 6,10-15,22 | cut -d '"' -f 1   | sort | uniq  >equipos.csv
#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 5,9-14  | sort | uniq  >equipos.csv
#!/bin/bash
cat LigaHost.csv | cut -d ';' -f   | sort | uniq  >partido.csv
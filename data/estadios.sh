#!/bin/bash
cat LigaHost.csv | cut -d ';' -f 15-17,22 | cut -d '"' -f 1   | sort | uniq >estadios.csv
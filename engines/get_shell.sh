#!/bin/bash -eu

base_name=$1
docker run -p 8001:8001 -i -t adalogics.com/software-analysis-toolkit/$base_name /bin/bash

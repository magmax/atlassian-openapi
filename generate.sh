#!/bin/bash

lang=${1:-python}
apis=${2:-$(ls -1 *.yaml|cut -d "." -f 1)}

for api in $apis; do
  docker run --rm \
    -v ${PWD}:/local \
    openapitools/openapi-generator-cli generate \
    -i /local/${api}.yaml \
    -g ${lang}\
    -o /local/out/${lang}/${api}
done

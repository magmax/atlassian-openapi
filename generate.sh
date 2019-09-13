#!/bin/bash

lang=${1:-python}
apis=${2:-$(find spec -name '*.yaml')}
version=${3:-0.0.$(date +%y%m%d)}

url=

for api in $apis; do
  filename=$(basename ${api})
  apiname="${filename%.*}"
  docker run --rm \
    -v ${PWD}:/local \
    openapitools/openapi-generator-cli generate \
    -i /local/${api} \
    -g ${lang}\
    --skip-validate-spec \
    --additional-properties=packageName=${apiname}openapi,projectName=${apiname}-openapi,packageVersion=${version},packageUrl=${url} \
    -o /local/out/${lang}/${apiname}
done

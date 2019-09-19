#!/bin/bash

lang=${1:-python}
apis=${2:-$(find spec -name '*.yaml')}
version=${3:-0.1.$(date +%y%m%d)}

declare -A uris
uris["bitbucket"]="https://pypi.org/project/bitbucket-openapi/"
uris["jira"]="https://pypi.org/project/jira-openapi/"

for api in $apis; do
  filename=$(basename ${api})
  apiname="${filename%.*}"
  url=${uris[$apiname]}
  docker run --rm \
    -v ${PWD}:/local \
    openapitools/openapi-generator-cli generate \
    -i /local/${api} \
    -g ${lang}\
    --skip-validate-spec \
    --additional-properties=packageName=${apiname}openapi,projectName=${apiname}-openapi,packageVersion=${version},packageUrl=${url} \
    -o /local/libs/${lang}/${apiname}
done

sudo chown -R $(whoami):$(whoami) libs 

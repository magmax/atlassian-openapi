#!/usr/bin/env python

import re
import json
import sys
import yaml


class long_text(str): pass


def patch_dict(d):
    if not isinstance(d, dict):
        return
    for k, v in d.items():
        if isinstance(v, str) and ('\n' in v or len(v) > 40):
            d[k] = long_text(v)
        elif isinstance(v, dict):
            patch_dict(v)
        elif isinstance(v, list):
            for i in v:
                patch_dict(i)


def normalize_operation_id(name):
    # snake case
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    result = re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

    result = result.replace('-', '')
    result = result.replace('__', '_')

    result = result.strip('_')

    return result


def patch_paths(d):
    prefixes = {
        'get': 'get',
        'post': 'create',
        'put': 'update',
        'delete': 'delete',
    }
    for path, methods in d['paths'].items():
        for method, props in methods.items():
            if method == 'parameters':
                continue
            if 'operationId' not in props:
                prefix = prefixes[method.lower()]
                name = path.replace('/', '_').replace('{', 'by_').replace('}', '')
                props['operationId'] = normalize_operation_id(f"{prefix}_{name}")
            else:
                props['operationId'] = normalize_operation_id(props['operationId'])


def literal_representer(dumper, data):
    return dumper.represent_scalar(u'tag:yaml.org,2002:str', data, style='|')


def main():
    data = simplejson.loads(str(sys.stdin.read()))
    patch_dict(data)
    patch_paths(data)
    yaml.add_representer(long_text, literal_representer)
    r = yaml.dump(data, default_flow_style=False)
    print(r)
    #print json.keys()


if __name__ == '__main__':
    main()

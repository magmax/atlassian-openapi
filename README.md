# Atlassian-OpenApi

OpenApi generated libraries for Atlassian projects.

Status: 

- bitbucket: Taken from Atlassian and functional.
- jira: not started.
- confluence: not started.

# Why another atlassian library?

There are some official libraries, but they are not maintained and they do not
use the OpenApi generator.

This project aims for that, and can be used to generate libraries for any
language.

Difference:

Pybitbucket:

```
import configparser
from pybitbucket import auth
from pybitbucket import bitbucket as bb
from pybitbucket.repository import Repository


c = configparser.ConfigParser()
c.read(['config.cfg'])
client = bb.Client(
    auth.BasicAuthenticator(
        c.get('credentials', 'username'),
        c.get('credentials', 'password'),
        c.get('credentials', 'email'),
    )
)
Repository.find_repository_by_full_name('arco_group/hello.ice', client=client)
```

Same with bitbucket-openapi:

```
import configparser
import bitbucketopenapi as bb

c = configparser.ConfigParser()
c.read(['config.cfg'])

configuration = bb.Configuration(
        c.get('credentials', 'username'),
        c.get('credentials', 'password'),
        c.get('credentials', 'email'),
)
client = bb.ApiClient(configuration)
c = bb.RepositoriesApi(client)
c.get_repositories_by_username_by_repo_slug('arco_group', 'hello.ice')
```


# Contribute

Original specs are taken from:

- BitBucket: https://bitbucket.org/api/swagger.json
- Jira: https://developer.atlassian.com/cloud/jira/platform/swagger-v3.v3.json

Then, they are converted to YAML with the tool `tools/json2yaml.py`, which
patches it too, leaving the result at `specs` dir.

All the specifications in the `specs` dir are processed with the `generate.sh`
script, generating the final lib for the desired language.


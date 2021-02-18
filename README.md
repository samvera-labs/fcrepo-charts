Fedora Commons Helm Chart
=========================

Fedora is the flexible, modular, open source repository platform with native
linked data support.

## Installation

```sh
helm repo add fcrepo https://samvera-labs.github.com/fcrepo-chart
helm install fcrepo
```

### Or from local

```sh
helm dep up chart/fcrepo
helm install fcrepo chart/fcrepo
```

## Configuration

By default, this chart deploys with Postgresql as the backend for Fedora.
Without other configuration, it will deploy a new Postgresql instance/database
as a service available to the `fcrepo` deployment.

In practice, users may want to forego installing postgres for two reasons:

_First_, when you are deploying Fedora into a more complex application
environment you may wish to reuse an existing Postgres instance already
maintained with that environment.

In this case, `fcrepo` should be deployed with postgresql explictly disabled, but
postgresqlHost set to your upstream value. postgresqlPassword and postgresqlUsername
can be set here or will default to the global values if those are provided. For example
.Values.global.postgersql.postgresqlUsername will override .Values.postgersql.postgresqlUsername.

This is usually done in the context of a parent chart which provides the postgresql instance, for example:

```yaml
fcrepo:
  enabled: true
  servicePort: 8080
  postgresql:
    enabled: false
    postgresqlHost: someurl.rds.amazonaws.com
    postgresqlUsername: yourUser # Optional, may be defined globally
    postgresqlPassword: wouldntyouliketoknow  # Optional, may be defined globally
```

_Second_, because they want to use another backend for Fedora. This use case is broadly unsupported here. In theory, you can get a default (Infinispan) configuration by setting `postgresql.enabled` to `false`. **THIS CONFIGURATION IS NOT SUPPORTED AT THIS TIME**:

```sh
helm install --set postgresql.enabled=false fcrepo-test chart/fcrepo
```

## Storage
If binary storage in S3 is desired, then please specify the following values

```yaml
s3:
  enabled: true
  bucket:
  access_key:
  secret_key:
```

This will enable S3 support, which is only supported in Fcrepo 4.7.5+

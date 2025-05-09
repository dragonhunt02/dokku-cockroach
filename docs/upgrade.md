CockroachDB plugin does not handle upgrading data for major versions automatically (eg. v24 => v25). Upgrades should be done manually. Users are encouraged to upgrade to the latest minor release for their cockroach version before performing a major upgrade.

It is recommended to route app requests to cluster using load balancer to prevent service disruption during upgrade.

Upgrading image with dokku won't upgrade other nodes in cluster. You have to manually upgrade every node in the cluster with the new version to finalize the upgrade. More information is available at https://www.cockroachlabs.com/docs/v25.1/upgrade-cockroach-version.html

For safety purposes, it is recommended to export a backup before starting an upgrade.
```shell
# export the database contents
dokku cockroach:export lollipop-24 > /tmp/lollipop-24.tar
```

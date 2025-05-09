# dokku cockroach

Unofficial cockroach plugin for dokku. Currently defaults to installing [cockroachdb/cockroach v25.1.1](https://hub.docker.com/r/cockroachdb/cockroach/).

## Requirements

- dokku 0.19.x+
- docker 1.8.x

## Installation

```shell
# on 0.19.x+
sudo dokku plugin:install https://github.com/dokku/dokku-cockroach.git --name cockroach
```

## Commands

```
cockroach:app-links <app>                          # list all cockroach service links for a given app
cockroach:backup <service> <bucket-name> [--use-iam] # create a backup of the cockroach service to an existing s3 bucket
cockroach:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url> # set up authentication for backups on the cockroach service
cockroach:backup-deauth <service>                  # remove backup authentication for the cockroach service
cockroach:backup-schedule <service> <schedule> <bucket-name> [--use-iam] # schedule a backup of the cockroach service
cockroach:backup-schedule-cat <service>            # cat the contents of the configured backup cronfile for the service
cockroach:backup-set-encryption <service> <passphrase> # set encryption for all future backups of cockroach service
cockroach:backup-set-public-key-encryption <service> <public-key-id> # set GPG Public Key encryption for all future backups of cockroach service
cockroach:backup-unschedule <service>              # unschedule the backup of the cockroach service
cockroach:backup-unset-encryption <service>        # unset encryption for future backups of the cockroach service
cockroach:backup-unset-public-key-encryption <service> # unset GPG Public Key encryption for future backups of the cockroach service
cockroach:ca-export <service> <dest-path> <flags>  # export service CA keys to directory and remove private key from service
cockroach:ca-import <service> <src-path>           # import service CA keys ('ca.key' and 'ca.crt') from directory
cockroach:clone <service> <new-service> [--clone-flags...] # create container <new-name> then copy data from <name> into <new-name>
cockroach:connect <service> <cockroach-flags>      # connect to the service via the cockroach connection tool
cockroach:create <service> [--create-flags...]     # create a cockroach service
cockroach:destroy <service> [-f|--force]           # delete the cockroach service/data/container if there are no links left
cockroach:enter <service>                          # enter or run a command in a running cockroach service container
cockroach:exists <service>                         # check if the cockroach service exists
cockroach:export <service>                         # export a tar dump of the cockroach service database using BACKUP
cockroach:expose <service> <ports...>              # expose a cockroach service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)
cockroach:haproxy-destroy <service> [-f|--force]   # delete the cockroach haproxy load balancer service/data/container if there are no links left
cockroach:haproxy-start <service>                  # create a cockroach haproxy load balancer service
cockroach:import <service>                         # import a tar dump into the cockroach service database
cockroach:info <service> [--single-info-flag]      # print the service information
cockroach:link <service> <app> [--link-flags...]   # link the cockroach service to the app
cockroach:linked <service> <app>                   # check if the cockroach service is linked to an app
cockroach:links <service>                          # list all apps linked to the cockroach service
cockroach:list                                     # list all cockroach services
cockroach:logs <service> [-t|--tail] <tail-num-optional> # print the most recent log(s) for this service
cockroach:node-add <-> <->                         # import service CA keys ('ca.key' and 'ca.crt') from directory
cockroach:pause <service>                          # pause a running cockroach service
cockroach:promote <service> <app>                  # promote service <service> as DATABASE_URL in <app>
cockroach:restart <service>                        # graceful shutdown and restart of the cockroach service container
cockroach:set <service> <key> <value>              # set or clear a property for a service
cockroach:start <service>                          # start a previously stopped cockroach service
cockroach:stop <service>                           # stop a running cockroach service
cockroach:unexpose <service>                       # unexpose a previously exposed cockroach service
cockroach:unlink <service> <app>                   # unlink the cockroach service from the app
cockroach:upgrade <service> [--upgrade-flags...]   # upgrade service <service> to the specified versions
```

## Usage

Help for any commands can be displayed by specifying the command as an argument to cockroach:help. Plugin help output in conjunction with any files in the `docs/` folder is used to generate the plugin documentation. Please consult the `cockroach:help` command for any undocumented commands.

### Basic Usage

### create a cockroach service

```shell
# usage
dokku cockroach:create <service> [--create-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit in megabytes (default: unlimited)
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-p|--password PASSWORD`: override the user-level service password
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-r|--root-password PASSWORD`: override the root-level service password
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for cockroach docker container

Create a cockroach service named lollipop:

```shell
dokku cockroach:create lollipop
```

You can also specify the image and image version to use for the service. It *must* be compatible with the cockroachdb/cockroach image.

```shell
export COCKROACH_IMAGE="cockroachdb/cockroach"
export COCKROACH_IMAGE_VERSION="${PLUGIN_IMAGE_VERSION}"
dokku cockroach:create lollipop
```

You can also specify to use CockroachDB `FOSS` `${PLUGIN_IMAGE_VERSION}` docker image built from [oxidecomputer/cockroach](https://github.com/oxidecomputer/cockroach):

```shell
export COCKROACH_FOSS_ENABLED=true
dokku cockroach:create lollipop
```

You can also specify custom environment variables to start the cockroach service in semicolon-separated form.

```shell
export COCKROACH_CUSTOM_ENV="USER=alpha;HOST=beta"
dokku cockroach:create lollipop
```

### print the service information

```shell
# usage
dokku cockroach:info <service> [--single-info-flag]
```

flags:

- `--config-dir`: show the service configuration directory
- `--data-dir`: show the service data directory
- `--dsn`: show the service DSN
- `--exposed-ports`: show service exposed ports
- `--id`: show the service container id
- `--internal-ip`: show the service internal ip
- `--initial-network`: show the initial network being connected to
- `--links`: show the service app links
- `--post-create-network`: show the networks to attach to after service container creation
- `--post-start-network`: show the networks to attach to after service container start
- `--service-root`: show the service root directory
- `--status`: show the service running status
- `--version`: show the service image version

Get connection information as follows:

```shell
dokku cockroach:info lollipop
```

You can also retrieve a specific piece of service info via flags:

```shell
dokku cockroach:info lollipop --config-dir
dokku cockroach:info lollipop --data-dir
dokku cockroach:info lollipop --dsn
dokku cockroach:info lollipop --exposed-ports
dokku cockroach:info lollipop --id
dokku cockroach:info lollipop --internal-ip
dokku cockroach:info lollipop --initial-network
dokku cockroach:info lollipop --links
dokku cockroach:info lollipop --post-create-network
dokku cockroach:info lollipop --post-start-network
dokku cockroach:info lollipop --service-root
dokku cockroach:info lollipop --status
dokku cockroach:info lollipop --version
```

### list all cockroach services

```shell
# usage
dokku cockroach:list
```

List all services:

```shell
dokku cockroach:list
```

### print the most recent log(s) for this service

```shell
# usage
dokku cockroach:logs <service> [-t|--tail] <tail-num-optional>
```

flags:

- `-t|--tail [<tail-num>]`: do not stop when end of the logs are reached and wait for additional output

You can tail logs for a particular service:

```shell
dokku cockroach:logs lollipop
```

By default, logs will not be tailed, but you can do this with the --tail flag:

```shell
dokku cockroach:logs lollipop --tail
```

The default tail setting is to show all logs, but an initial count can also be specified:

```shell
dokku cockroach:logs lollipop --tail 5
```

### link the cockroach service to the app

```shell
# usage
dokku cockroach:link <service> <app> [--link-flags...]
```

flags:

- `-a|--alias "BLUE_DATABASE"`: an alternative alias to use for linking to an app via environment variable
- `-q|--querystring "pool=5"`: ampersand delimited querystring arguments to append to the service link
- `-n|--no-restart "false"`: whether or not to restart the app on link (default: true)

A cockroach service can be linked to a container. This will use native docker links via the docker-options plugin. Here we link it to our `playground` app.

> NOTE: this will restart your app

```shell
dokku cockroach:link lollipop playground
```

The following environment variables will be set automatically by docker (not on the app itself, so they won’t be listed when calling dokku config):

```
DOKKU_COCKROACH_LOLLIPOP_NAME=/lollipop/DATABASE
DOKKU_COCKROACH_LOLLIPOP_PORT=tcp://172.17.0.1:26257
DOKKU_COCKROACH_LOLLIPOP_PORT_26257_TCP=tcp://172.17.0.1:26257
DOKKU_COCKROACH_LOLLIPOP_PORT_26257_TCP_PROTO=tcp
DOKKU_COCKROACH_LOLLIPOP_PORT_26257_TCP_PORT=26257
DOKKU_COCKROACH_LOLLIPOP_PORT_26257_TCP_ADDR=172.17.0.1
```

The following will be set on the linked application by default:

```
DATABASE_URL=postgres://lollipop:SOME_PASSWORD@dokku-cockroach-lollipop:26257/lollipop
```

The host exposed here only works internally in docker containers. If you want your container to be reachable from outside, you should use the `expose` subcommand. Another service can be linked to your app:

```shell
dokku cockroach:link other_service playground
```

It is possible to change the protocol for `DATABASE_URL` by setting the environment variable `COCKROACH_DATABASE_SCHEME` on the app. Doing so will after linking will cause the plugin to think the service is not linked, and we advise you to unlink before proceeding.

```shell
dokku config:set playground COCKROACH_DATABASE_SCHEME=postgres2
dokku cockroach:link lollipop playground
```

This will cause `DATABASE_URL` to be set as:

```
postgres2://lollipop:SOME_PASSWORD@dokku-cockroach-lollipop:26257/lollipop
```

### unlink the cockroach service from the app

```shell
# usage
dokku cockroach:unlink <service> <app>
```

flags:

- `-n|--no-restart "false"`: whether or not to restart the app on unlink (default: true)

You can unlink a cockroach service:

> NOTE: this will restart your app and unset related environment variables

```shell
dokku cockroach:unlink lollipop playground
```

### set or clear a property for a service

```shell
# usage
dokku cockroach:set <service> <key> <value>
```

Set the network to attach after the service container is started:

```shell
dokku cockroach:set lollipop post-create-network custom-network
```

Set multiple networks:

```shell
dokku cockroach:set lollipop post-create-network custom-network,other-network
```

Unset the post-create-network value:

```shell
dokku cockroach:set lollipop post-create-network
```

### Service Lifecycle

The lifecycle of each service can be managed through the following commands:

### connect to the service via the cockroach connection tool

```shell
# usage
dokku cockroach:connect <service> <cockroach-flags>
```

Connect to the service via the cockroach sql connection tool:

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku cockroach:connect lollipop [--cockroach-flags...]
```

You can also pass additional arguments to `cockroach sql` console

```shell
# Example to allow 'DROP DATABASE...' and similar unsafe operations
dokku cockroach:connect lollipop --safe-updates=false
```

### enter or run a command in a running cockroach service container

```shell
# usage
dokku cockroach:enter <service>
```

A bash prompt can be opened against a running service. Filesystem changes will not be saved to disk.

> NOTE: disconnecting from ssh while running this command may leave zombie processes due to moby/moby#9098

```shell
dokku cockroach:enter lollipop
```

You may also run a command directly against the service. Filesystem changes will not be saved to disk.

```shell
dokku cockroach:enter lollipop touch /tmp/test
```

### expose a cockroach service on custom host:port if provided (random port on the 0.0.0.0 interface if otherwise unspecified)

```shell
# usage
dokku cockroach:expose <service> <ports...>
```

Expose the service on the service's normal ports, allowing access to it from the public interface (`0.0.0.0`):

```shell
dokku cockroach:expose lollipop 26257 8080
```

Expose the service on the service's normal ports, with the first on a specified ip address (127.0.0.1):

```shell
dokku cockroach:expose lollipop 127.0.0.1:26257 8080
```

### unexpose a previously exposed cockroach service

```shell
# usage
dokku cockroach:unexpose <service>
```

Unexpose the service, removing access to it from the public interface (`0.0.0.0`):

```shell
dokku cockroach:unexpose lollipop
```

### promote service <service> as DATABASE_URL in <app>

```shell
# usage
dokku cockroach:promote <service> <app>
```

If you have a cockroach service linked to an app and try to link another cockroach service another link environment variable will be generated automatically:

```
DOKKU_DATABASE_BLUE_URL=postgres://other_service:ANOTHER_PASSWORD@dokku-cockroach-other-service:26257/other_service
```

You can promote the new service to be the primary one:

> NOTE: this will restart your app

```shell
dokku cockroach:promote other_service playground
```

This will replace `DATABASE_URL` with the url from other_service and generate another environment variable to hold the previous value if necessary. You could end up with the following for example:

```
DATABASE_URL=postgres://other_service:ANOTHER_PASSWORD@dokku-cockroach-other-service:26257/other_service
DOKKU_DATABASE_BLUE_URL=postgres://other_service:ANOTHER_PASSWORD@dokku-cockroach-other-service:26257/other_service
DOKKU_DATABASE_SILVER_URL=postgres://lollipop:SOME_PASSWORD@dokku-cockroach-lollipop:26257/lollipop
```

### start a previously stopped cockroach service

```shell
# usage
dokku cockroach:start <service>
```

Start the service:

```shell
dokku cockroach:start lollipop
```

### stop a running cockroach service

```shell
# usage
dokku cockroach:stop <service>
```

Stop the service and removes the running container:

```shell
dokku cockroach:stop lollipop
```

### pause a running cockroach service

```shell
# usage
dokku cockroach:pause <service>
```

Pause the running container for the service:

```shell
dokku cockroach:pause lollipop
```

### graceful shutdown and restart of the cockroach service container

```shell
# usage
dokku cockroach:restart <service>
```

Restart the service:

```shell
dokku cockroach:restart lollipop
```

### upgrade service <service> to the specified versions

```shell
# usage
dokku cockroach:upgrade <service> [--upgrade-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-R|--restart-apps "true"`: whether or not to force an app restart (default: false)
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for cockroach docker container

You can upgrade an existing service to a new image or image-version:

```shell
dokku cockroach:upgrade lollipop
```

CockroachDB plugin does not handle upgrading data for major versions automatically (eg. v24 => v25). Upgrades should be done manually. Users are encouraged to upgrade to the latest minor release for their cockroach version before performing a major upgrade.

It is recommended to route app requests to cluster using load balancer to prevent service disruption during upgrade.

Upgrading image with dokku won't upgrade other nodes in cluster. You have to manually upgrade every node in the cluster with the new version to finalize the upgrade. More information is available at https://www.cockroachlabs.com/docs/v25.1/upgrade-cockroach-version.html

For safety purposes, it is recommended to export a backup before starting an upgrade.
```shell
# export the database contents
dokku cockroach:export lollipop-24 > /tmp/lollipop-24.tar
```

### Service Automation

Service scripting can be executed using the following commands:

### list all cockroach service links for a given app

```shell
# usage
dokku cockroach:app-links <app>
```

List all cockroach services that are linked to the `playground` app.

```shell
dokku cockroach:app-links playground
```

### create container <new-name> then copy data from <name> into <new-name>

```shell
# usage
dokku cockroach:clone <service> <new-service> [--clone-flags...]
```

flags:

- `-c|--config-options "--args --go=here"`: extra arguments to pass to the container create command (default: `None`)
- `-C|--custom-env "USER=alpha;HOST=beta"`: semi-colon delimited environment variables to start the service with
- `-i|--image IMAGE`: the image name to start the service with
- `-I|--image-version IMAGE_VERSION`: the image version to start the service with
- `-m|--memory MEMORY`: container memory limit in megabytes (default: unlimited)
- `-N|--initial-network INITIAL_NETWORK`: the initial network to attach the service to
- `-p|--password PASSWORD`: override the user-level service password
- `-P|--post-create-network NETWORKS`: a comma-separated list of networks to attach the service container to after service creation
- `-r|--root-password PASSWORD`: override the root-level service password
- `-S|--post-start-network NETWORKS`: a comma-separated list of networks to attach the service container to after service start
- `-s|--shm-size SHM_SIZE`: override shared memory size for cockroach docker container

You can clone an existing service to a new one:

```shell
dokku cockroach:clone lollipop lollipop-2
```

### check if the cockroach service exists

```shell
# usage
dokku cockroach:exists <service>
```

Here we check if the lollipop cockroach service exists.

```shell
dokku cockroach:exists lollipop
```

### check if the cockroach service is linked to an app

```shell
# usage
dokku cockroach:linked <service> <app>
```

Here we check if the lollipop cockroach service is linked to the `playground` app.

```shell
dokku cockroach:linked lollipop playground
```

### list all apps linked to the cockroach service

```shell
# usage
dokku cockroach:links <service>
```

List all apps linked to the `lollipop` cockroach service.

```shell
dokku cockroach:links lollipop
```

### Data Management

The underlying service data can be imported and exported with the following commands:

### import service CA keys ('ca.key' and 'ca.crt') from directory

```shell
# usage
dokku cockroach:ca-import <service> <src-path>
```

Import CockroachDB Certificate Authority public/private keys from directory.

> NOTE: All existing service certificates will be removed and regenerated using imported 'ca.key'.

```shell
dokku cockroach:ca-import lollipop ./certs/path/
```

### export service CA keys to directory and remove private key from service

```shell
# usage
dokku cockroach:ca-export <service> <dest-path> <flags>
```

flags:

- `--force-copy`: Don't remove ca.key private key from service after export

Export CockroachDB Certificate Authority public/private keys to directory.

> NOTE: Private key will be removed from service after export, so you won't be able to add new nodes.

```shell
dokku cockroach:ca-export lollipop ./certs/path/ [--force-copy]
```

### import a tar dump into the cockroach service database

```shell
# usage
dokku cockroach:import <service>
```

Import a datastore dump:

```shell
dokku cockroach:import lollipop < data.tar
```

### export a tar dump of the cockroach service database using BACKUP

```shell
# usage
dokku cockroach:export <service>
```

By default, datastore output is exported to stdout:

```shell
dokku cockroach:export lollipop
```

You can redirect this output to a file:

```shell
dokku cockroach:export lollipop > data.tar
```

Note that the export will result in a `.tar` file containing a CockroachDB `BACKUP` data. It can be converted to original format as follows

```shell
tar -xvf data.tar
```

### Backups

Datastore backups are supported via AWS S3 and S3 compatible services like [minio](https://github.com/minio/minio).

You may skip the `backup-auth` step if your dokku install is running within EC2 and has access to the bucket via an IAM profile. In that case, use the `--use-iam` option with the `backup` command.

Backups can be performed using the backup commands:

### set up authentication for backups on the cockroach service

```shell
# usage
dokku cockroach:backup-auth <service> <aws-access-key-id> <aws-secret-access-key> <aws-default-region> <aws-signature-version> <endpoint-url>
```

Setup s3 backup authentication:

```shell
dokku cockroach:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
```

Setup s3 backup authentication with different region:

```shell
dokku cockroach:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION
```

Setup s3 backup authentication with different signature version and endpoint:

```shell
dokku cockroach:backup-auth lollipop AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION AWS_SIGNATURE_VERSION ENDPOINT_URL
```

More specific example for minio auth:

```shell
dokku cockroach:backup-auth lollipop MINIO_ACCESS_KEY_ID MINIO_SECRET_ACCESS_KEY us-east-1 s3v4 https://YOURMINIOSERVICE
```

### remove backup authentication for the cockroach service

```shell
# usage
dokku cockroach:backup-deauth <service>
```

Remove s3 authentication:

```shell
dokku cockroach:backup-deauth lollipop
```

### create a backup of the cockroach service to an existing s3 bucket

```shell
# usage
dokku cockroach:backup <service> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Backup the `lollipop` service to the `my-s3-bucket` bucket on `AWS`:`

```shell
dokku cockroach:backup lollipop my-s3-bucket --use-iam
```

Restore a backup file (assuming it was extracted via `tar -xf backup.tgz`):

```shell
dokku cockroach:import lollipop < backup-folder/export
```

### set encryption for all future backups of cockroach service

```shell
# usage
dokku cockroach:backup-set-encryption <service> <passphrase>
```

Set the GPG-compatible passphrase for encrypting backups for backups:

```shell
dokku cockroach:backup-set-encryption lollipop
```

### set GPG Public Key encryption for all future backups of cockroach service

```shell
# usage
dokku cockroach:backup-set-public-key-encryption <service> <public-key-id>
```

Set the `GPG` Public Key for encrypting backups:

```shell
dokku cockroach:backup-set-public-key-encryption lollipop
```

### unset encryption for future backups of the cockroach service

```shell
# usage
dokku cockroach:backup-unset-encryption <service>
```

Unset the `GPG` encryption passphrase for backups:

```shell
dokku cockroach:backup-unset-encryption lollipop
```

### unset GPG Public Key encryption for future backups of the cockroach service

```shell
# usage
dokku cockroach:backup-unset-public-key-encryption <service>
```

Unset the `GPG` Public Key encryption for backups:

```shell
dokku cockroach:backup-unset-public-key-encryption lollipop
```

### schedule a backup of the cockroach service

```shell
# usage
dokku cockroach:backup-schedule <service> <schedule> <bucket-name> [--use-iam]
```

flags:

- `-u|--use-iam`: use the IAM profile associated with the current server

Schedule a backup:

> 'schedule' is a crontab expression, eg. "0 3 * * *" for each day at 3am

```shell
dokku cockroach:backup-schedule lollipop "0 3 * * *" my-s3-bucket
```

Schedule a backup and authenticate via iam:

```shell
dokku cockroach:backup-schedule lollipop "0 3 * * *" my-s3-bucket --use-iam
```

### cat the contents of the configured backup cronfile for the service

```shell
# usage
dokku cockroach:backup-schedule-cat <service>
```

Cat the contents of the configured backup cronfile for the service:

```shell
dokku cockroach:backup-schedule-cat lollipop
```

### unschedule the backup of the cockroach service

```shell
# usage
dokku cockroach:backup-unschedule <service>
```

Remove the scheduled backup from cron:

```shell
dokku cockroach:backup-unschedule lollipop
```

### Disabling `docker image pull` calls

If you wish to disable the `docker image pull` calls that the plugin triggers, you may set the `COCKROACH_DISABLE_PULL` environment variable to `true`. Once disabled, you will need to pull the service image you wish to deploy as shown in the `stderr` output.

Please ensure the proper images are in place when `docker image pull` is disabled.

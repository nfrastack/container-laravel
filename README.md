# nfrastack/container-laravel

## About

This repository will build a container image for running [Laravel](https://laravel.net/) applications either in a development or production capacity, including [Nginx](https://www.nginx.org) w/[PHP-FPM](https://php.net).

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Artisan Setup Commands](#artisan-setup-commands)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-laravel/pkgs/container/container-laravel) and [Docker Hub](https://hub.docker.com/r/nfrastack/laravel).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-laravel:(image_tag)
docker.io/nfrastack/laravel:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional phpversion>-<optional distro>-<optional distro_variant>`

Example:

`docker.io/nfrastack/container-laravel:latest` or

`ghcr.io/nfrastack/container-laravel:1.0-php84-alpine`

* `latest` will be the most recent commit

* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest

| PHP version | Alpine Base | Tag            | Debian Base | Tag                    |
| ----------- | ----------- | -------------- | ----------- | ---------------------- |
| latest      | edge        | `:alpine-edge` |             |                        |
| 8.5.x       | 3.23        | `:8.5-alpine`  | Trixie      | `:8.5-debian`          |
| 8.4.x       | 3.23        | `:8.4-alpine`  | Trixie      | `:8.4-debian`          |
|             |             |                | Bookworm    | `:8.4-debian_bookworm` |
| 8.3.x       | 3.22        | `:8.3-alpine`  | Bookworm    | `:8.3-debian_trixie`   |
|             |             |                | Trixie      | `:8.3-debian`          |
| 8.2.x       | 3.22        | `:8.2-alpine`  | Trixie      | `:8.2-debian`          |
|             |             |                | Bookworm    | `:8.2-debian_bookworm` |
| 8.1.x       | 3.19        | `:8.1-alpine`  |             |                        |
| 8.0.x       | 3.16        | `:8.0-alpine`  |             |                        |
| 7.4.x       | 3.15        | `:7.4-alpine`  |             |                        |

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories/files should be mapped for persistent storage in order to utilize the container effectively.

| Directory       | Description      |
| --------------- | ---------------- |
| `/www/html`     | Root Directory   |
| `/logs/laravel` | Laravel Logfiles |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                                 | Description         |
| --------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)               | Base Image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)                | Nginx Webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM Interpreter |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

### Operation Mode

| Parameter                          | Description                                                                                                                                     | Default                   | `_FILE` |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- | ------- |
| `SETUP_TYPE`                       | `AUTO` writes .env on first boot. `MANUAL` skips the configure_*.                                                                               | `AUTO`                    |         |
| `DATA_PATH`                        | Base persistent-storage path                                                                                                                    | `/data`                   |         |
| `ENABLE_CONFIG_REDIRECTION`        | Redirect `.env` to `${CONFIG_PATH}/${CONFIG_FILE}` via symlink                                                                                  | `FALSE`                   |         |
| `CONFIG_PATH`                      | Persistent config directory                                                                                                                     | `${DATA_PATH}/config/`    |         |
| `CONFIG_FILE`                      | Filename inside `CONFIG_PATH` that the .env symlink points at                                                                                   | `config`                  |         |
| `ENABLE_LOG_REDIRECTION`           | Redirect `storage/logs` to `${LOG_PATH}` via symlink                                                                                            | `FALSE`                   |         |
| `LOG_PATH`                         | Persistent log directory                                                                                                                        | `/logs/laravel/`          |         |
| `ENABLE_STORAGE_REDIRECTION`       | Redirect `storage/` to `${STORAGE_PATH}` via symlink. Also gates downstream-image persistence (e.g. BookStack's uploads/themes/version-marker). | `FALSE`                   |         |
| `STORAGE_PATH`                     | Persistent storage directory                                                                                                                    | `${DATA_PATH}/storage/`   |         |
| `LARAVEL_IMAGE_MODE`               | `production` or `development`. See Image Mode Details below.                                                                                    | `development`             |         |
| `LARAVEL_INSTALL_DATA_PATH`        | Where a downstream image may bake its source. See Downstream Images.                                                                            | `/container/data/laravel` |         |
| `LARAVEL_COPY_ENV_EXAMPLE`         | Seed `.env` from `.env.example` on first install                                                                                                | `TRUE`                    |         |
| `LARAVEL_MIGRATE_ON_FIRST_INSTALL` | Run `php artisan migrate --force` during first-install post-source                                                                              | `TRUE`                    |         |
| `ENABLE_LARAVEL_ARTISAN_SERVE`     | Run Laravel's artisan dev server (development only)                                                                                             | `TRUE`                    |         |
| `ENABLE_LARAVEL_ENV_WATCHER`       | Watch `.env` for changes and reload                                                                                                             | `TRUE`                    |         |
| `ENABLE_LARAVEL_NPM_RUN_DEV`       | Run `npm run dev` in dev mode                                                                                                                   | `TRUE`                    |         |
| `ENABLE_LARAVEL_VITE_HMR`          | Enable Vite HMR. See Vite HMR section.                                                                                                          | `FALSE`                   |         |
| `ENABLE_LARAVEL_WORKER`            | Enable the Laravel queue worker service                                                                                                         | `FALSE`                   |         |
| `ARTISAN_SERVE_LISTEN_IP`          | Listen IP for `artisan serve`                                                                                                                   | `0.0.0.0`                 |         |
| `ARTISAN_SERVE_LISTEN_PORT`        | Listen port for `artisan serve`                                                                                                                 | `8000`                    |         |

### Git Repository Clone

When `LARAVEL_GIT_REPO` is set, the container will clone the specified repository instead of creating a fresh Laravel project. This is useful for deploying existing applications from Git.

| Parameter                        | Description                                                                                                                                                                                                                                                                                       | Default | `_FILE` |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------- |
| `LARAVEL_GIT_REPO`               | Git URL to clone on first boot (e.g. `https://git.example.com/org/app`). Leave empty for default                                                                                                                                                                                                  |         | x       |
| `LARAVEL_GIT_BRANCH`             | Branch to checkout                                                                                                                                                                                                                                                                                | `main`  |         |
| `LARAVEL_GIT_TOKEN`              | Authentication token injected into the Git clone URL for private repositories                                                                                                                                                                                                                     |         | x       |
| `LARAVEL_COMPOSER_AUTH`          | JSON string passed as `COMPOSER_AUTH` for private package authentication (see [Composer docs](https://getcomposer.org/doc/articles/authentication-for-private-packages.md)). Persisted to `${NGINX_USER}`'s `.bashrc` so interactive `composer update` runs inside the container also pick it up. |         | x       |
| `LARAVEL_COMPOSER_SETUP`         | Run `composer install` after cloning                                                                                                                                                                                                                                                              | `TRUE`  |         |
| `LARAVEL_NPM_SETUP`              | Run `npm install` and `npm run build` after cloning                                                                                                                                                                                                                                               | `TRUE`  |         |
| `LARAVEL_ARTISAN_SETUP_COMMANDS` | Artisan commands to run after the first-install clone. See [Artisan Setup Commands](#artisan-setup-commands).                                                                                                                                                                                     |         |         |

### Artisan Setup Commands

After the container clones a repository, installs Composer dependencies, and runs migrations on first boot, you can provide one or more artisan commands to be executed automatically. This is useful for seeding data, creating initial users, publishing assets, or any other bootstrapping step that turns a fresh clone into a ready-to-use application.

#### Simple usage

Set `LARAVEL_ARTISAN_SETUP_COMMANDS` to a newline-separated list of artisan sub-commands (everything that comes after `php artisan`):

```yaml
environment:
  LARAVEL_ARTISAN_SETUP_COMMANDS: |
    laravel:setup --admin-email=admin --admin-password=password|cache:clear|storage:link
```

Each line is run as a separate `php artisan <command>` call under the web-server user. Blank lines and lines beginning with `#` are skipped. Commands can also be separated with `|` instead of newlines.

#### Numbered slots

When you need distinct setup stages — for example when a downstream image needs to insert commands between two steps — use the numbered variants `LARAVEL_ARTISAN_SETUP_COMMANDS01` through `LARAVEL_ARTISAN_SETUP_COMMANDS09`.

The unnumbered variable always runs first, followed by slots `01` → `09` in order. Any slot that is not set is silently skipped.

```yaml
environment:
  LARAVEL_ARTISAN_SETUP_COMMANDS: |
    config:cache
  LARAVEL_ARTISAN_SETUP_COMMANDS01: |
    db:seed --class=InitialSeeder
  LARAVEL_ARTISAN_SETUP_COMMANDS02: |
    db:seed --class=ExtraSeeder
    cache:clear
```

#### Calling a specific slot from a downstream image

A downstream image's own init script can call a single slot by passing its two-digit number:

```bash
laravel_artisan_setup_commands 02
```

This runs only `LARAVEL_ARTISAN_SETUP_COMMANDS02` if the variable is not set.

| Parameter                                  | Description                                                                                           | Default | `_FILE` |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------- | ------- | ------- |
| `LARAVEL_ARTISAN_SETUP_COMMANDS`           | Artisan commands to run on first-install (newline- or pipe-separated, everything after `php artisan`) |         |         |
| `LARAVEL_ARTISAN_SETUP_COMMANDS01`         | Slot 01 — runs after the unnumbered variable                                                          |         |         |
| `LARAVEL_ARTISAN_SETUP_COMMANDS02`         | Slot 02                                                                                               |         |         |
| `LARAVEL_ARTISAN_SETUP_COMMANDS03`... `09` | Additional ordered slots                                                                              |         |         |

### Vite HMR (Remote Development)

When developing remotely, Vite's Hot Module Replacement needs to know the external hostname so the browser can connect back to the Vite dev server.

When `ENABLE_LARAVEL_VITE_HMR` is `TRUE`, the container automatically:

1. Extracts the hostname from `APP_URL` in `.env` (or uses the `VITE_HMR_HOST` env var if set directly)
2. Writes `VITE_HMR_HOST` into `.env`
3. Patches `vite.config.js` to add remote HMR configuration (if not already present) — sets `host: '0.0.0.0'`, configures `wss` protocol, and uses `/@vite/hmr` as the websocket path for clean reverse proxy routing

No changes to your application code are required — the container handles everything.

You will also need to add reverse proxy rules to route Vite traffic to port `5173`. For Traefik:

```yaml
labels:
  # Explicitly link the app router to its service (required when multiple services exist)
  - traefik.http.routers.myapp.service=myapp
  # Vite HMR
  - traefik.http.routers.myapp-vite.rule=Host(`myapp.example.com`) && (PathPrefix(`/@vite`) || PathPrefix(`/@fs`) || PathPrefix(`/resources`) || PathPrefix(`/node_modules`))
  - traefik.http.routers.myapp-vite.service=myapp-vite
  - traefik.http.services.myapp-vite.loadbalancer.server.port=5173
```

| Parameter                 | Description                                                                      | Default | `_FILE` |
| ------------------------- | -------------------------------------------------------------------------------- | ------- | ------- |
| `ENABLE_LARAVEL_VITE_HMR` | Extract hostname from `APP_URL` and write `VITE_HMR_HOST` to `.env` for Vite HMR | `FALSE` |         |

### Auto Configuration

| Parameter                   | Description                              | Default | `_FILE` |
| --------------------------- | ---------------------------------------- | ------- | ------- |
| `LARAVEL_CONFIGURE_APP_KEY` | Enable configure App Key Routines        | `FALSE` |         |
| `LARAVEL_CONFIGURE_DB`      | Enable configure DB Routines             | `FALSE` |         |
| `LARAVEL_CONFIGURE_LARAVEL` | Enable configuring base laravel routines | `FALSE` |         |
| `LARAVEL_CONFIGURE_LDAP`    | Enable configuring LDAP routines         | `FALSE` |         |
| `LARAVEL_CONFIGURE_LOGGING` | Enable configuring logging routines      | `FALSE` |         |
| `LARAVEL_CONFIGURE_MAIL`    | Enable configuring mail routines         | `FALSE` |         |

### Database Options

Activated when `LARAVEL_CONFIGURE_DB=TRUE`.

| Parameter                      | Description                                                                                        | Default   | `_FILE` |
| ------------------------------ | -------------------------------------------------------------------------------------------------- | --------- | ------- |
| `DB_TYPE`                      | `mariadb`, `mysql`, `pgsql`/`postgres*`, or `sqlite`                                               | `mariadb` |         |
| `DB_HOST`                      | Host or container name of the Database Server                                                      |           | x       |
| `DB_PORT`                      | Port (3306 mariadb/mysql, 5432 postgres; ignored for sqlite)                                       | `3306`    | x       |
| `DB_NAME`                      | Database name (`DB_DATABASE` in .env)                                                              |           | x       |
| `DB_USER`                      | Username (`DB_USERNAME` in .env)                                                                   |           | x       |
| `DB_PASS`                      | Password (`DB_PASSWORD` in .env)                                                                   |           | x       |
| `DB_SSL`                       | mariadb/mysql only - `TRUE` forces `--ssl`, `FALSE` forces `--skip-ssl`, unset uses driver default |           |         |
| `DB_SSL_CA`                    | mariadb/mysql only - specifies the CA file using `--ssl-ca`, forces `--ssl`                        |           |         |
| `DB_SSL_MODE`                  | postgres only - libpq sslmode (`disable`, `prefer`, `require`)                                     | `prefer`  |         |
| `LARAVEL_DB_FRESH_CHECK_TABLE` | Marker table `laravel_db_is_populated` looks for                                                   | `users`   |         |

### Site Options

Activated when `LARAVEL_CONFIGURE_LARAVEL=TRUE`

| Parameter          | Description                                                        | Default                      | `_FILE` |
| ------------------ | ------------------------------------------------------------------ | ---------------------------- | ------- |
| `DISPLAY_ERRORS`   | Display Errors on Website                                          | `FALSE`                      |         |
| `SITE_URL`         | The url your site listens on example `https://laravel.example.com` |                              |         |
| `APP_NAME`         | Application Name                                                   | `Application`                |         |
| `APP_DEBUG`        | Enable Laravel Debug Mode                                          | `FALSE` (prod), `TRUE` (dev) |         |
| `BROADCAST_DRIVER` | Laravel Broadcast Driver                                           | `log`                        |         |
| `CACHE_DRIVER`     | Laravel Cache Driver                                               | `file`                       |         |
| `SESSION_DRIVER`   | Laravel Session Driver                                             | `file`                       |         |
| `SESSION_LIFETIME` | Laravel Session Lifetime in minutes                                | `120`                        |         |

### Logging Options

Activated when `LARAVEL_CONFIGURE_LOGGING=TRUE`

| Parameter     | Description         | Default  | `_FILE` |
| ------------- | ------------------- | -------- | ------- |
| `LOG_CHANNEL` | Laravel Log Channel | `single` |         |
| `LOG_LEVEL`   | Laravel Log Level   | `info`   |         |

### Mail Options

Activated when `LARAVEL_CONFIGURE_MAIL=TRUE`

| Parameter           | Description          | Default         | `_FILE` |
| ------------------- | -------------------- | --------------- | ------- |
| `MAIL_TYPE`         | Mail Type            | `smtp`          |         |
| `MAIL_FROM_ADDRESS` | Mail From Address    |                 |         |
| `MAIL_FROM_NAME`    | Mail From Name       |                 |         |
| `SMTP_HOST`         | SMTP Server Hostname | `postfix-relay` |         |
| `SMTP_PORT`         | SMTP Server Port     | `25`            |         |
| `SMTP_USER`         | SMTP Username        | `null`          |         |
| `SMTP_PASS`         | SMTP Password        | `null`          |         |
| `SMTP_ENCRYPTION`   | SMTP Encryption Type | `null`          |         |

### LDAP Options

Activated when `LARAVEL_CONFIGURE_LDAP=TRUE`

| Parameter         | Description                  | Default   | `_FILE` |
| ----------------- | ---------------------------- | --------- | ------- |
| `LDAP_HOST`       | LDAP Server Hostname         |           |         |
| `LDAP_PORT`       | LDAP Server Port             | `389`     |         |
| `LDAP_BASE_DN`    | LDAP Base Distinguished Name |           |         |
| `LDAP_BIND_USER`  | LDAP Bind User               |           |         |
| `LDAP_BIND_PASS`  | LDAP Bind Password           |           |         |
| `LDAP_CONNECTION` | LDAP Connection Name         | `default` |         |
| `LDAP_SSL`        | Enable LDAP SSL              | `FALSE`   |         |
| `LDAP_TLS`        | Enable LDAP TLS              | `FALSE`   |         |
| `LDAP_TIMEOUT`    | LDAP Connection Timeout      | `5`       |         |
| `LOG_LDAP`        | Enable LDAP Logging          | `FALSE`   |         |

#### LARAVEL_ENV_PREFIX Passthrough

Any container environment variable whose name starts with `${LARAVEL_ENV_PREFIX}` is rewritten into the application's `.env` file with the prefix stripped.

| Parameter            | Description                                                           | Default | `_FILE` |
| -------------------- | --------------------------------------------------------------------- | ------- | ------- |
| `LARAVEL_ENV_PREFIX` | Prefix for runtime-passthrough env vars. Set to your app's namespace. | `ENV_`  |         |

With `LARAVEL_ENV_PREFIX=ENV_` (default), setting `ENV_FOO=bar` in compose writes `FOO=bar` into `.env`. Three special values trigger removal of the matching `.env` line:

- `ENV_FOO=unset`
- `ENV_FOO=null`
- `ENV_FOO=` (empty string)

`*_FILE` docker-secrets pointers are resolved automatically.

The skip list excludes container control variables: `LARAVEL_ENV_PREFIX`, plus `LARAVEL_GIT_*`, `LARAVEL_COMPOSER_*`, `LARAVEL_NPM_*`, `LARAVEL_ADMIN_*`, `LARAVEL_ARTISAN_SETUP_COMMANDS*`, `LARAVEL_IMAGE_MODE`, `LARAVEL_CONFIGURE_*`, `LARAVEL_INSTALL_DATA_PATH`, `LARAVEL_COPY_ENV_EXAMPLE`, `LARAVEL_MIGRATE_ON_FIRST_INSTALL`, `LARAVEL_DB_FRESH_CHECK_TABLE`, and all `*_FILE` pointers.
These never leak into `.env` even if your prefix happens to be `LARAVEL_`.

Downstream images that pick a more specific prefix (e.g. `LARAVEL_ENV_PREFIX=APPLICATION_`) MUST avoid storing internal control state under that namespace - any `APPLICATION_FOO` in the process env would be passthrough-stripped to `FOO=` in `.env`. Use function-local variables for image-internal state.

#### Downstream Images

A downstream image can be built `FROM nfrastack/laravel` and inherit the entire pipeline: source-laydown, redirects, configure_* helpers, LARAVEL_ENV_PREFIX passthrough, plus a clean place to add image-specific config logic.

- Bake source at build time** into `${LARAVEL_INSTALL_DATA_PATH}/install/`. The runtime `laravel_setup_webroot` detects a non-empty `install/` subdirectory at that path and copies it into `${NGINX_WEBROOT}` instead of git-cloning or composer-creating.
- Set parent toggles via the Containerfile `BUILD_ENV`**, namespaced under `30-laravel/`. Common settings:

```dockerfile
BUILD_ENV=" \
    30-laravel/LARAVEL_INSTALL_DATA_PATH=/container/data/yourapp \
    30-laravel/LARAVEL_COMPOSER_SETUP=FALSE \
    30-laravel/LARAVEL_NPM_SETUP=FALSE \
    30-laravel/LARAVEL_MIGRATE_ON_FIRST_INSTALL=FALSE \
    30-laravel/LARAVEL_COPY_ENV_EXAMPLE=FALSE \
    30-laravel/LARAVEL_CONFIGURE_DB=TRUE \
    30-laravel/LARAVEL_CONFIGURE_APP_KEY=TRUE \
"
```

- Number your init script `40-*` or higher** so it runs after `30-laravel`. Inside, use `prepare_service 30-laravel,40-yourapp` (comma-separated) to load both function/default sets - which gives you access to `laravel_env_update`, `laravel_env_remove`, `laravel_db_is_populated` from the parent image inside your own helpers.
- Call `laravel_env_passthrough` at the END of your init script so user-supplied `${LARAVEL_ENV_PREFIX}*` overrides are the final word in `.env|config`.

##### Replacing this images shipped nginx fragments

I ship two opinionated nginx location fragments that get linked into every site's `sites.enabled/<site>/location/` directory:

| File                      | Contents                                                                          | Toggle                              | Default |
| ------------------------- | --------------------------------------------------------------------------------- | ----------------------------------- | --- |
| `30-01-router.conf`       | `location /` with the standard Laravel front-controller fallback to `index.php`.  | `LARAVEL_NGINX_ENABLE_ROUTER`       | `TRUE` |
| `30-02-static_paths.conf` | `location /uploads` and `location /media` blocks with `autoindex off`.            | `LARAVEL_NGINX_ENABLE_STATIC_PATHS` | `TRUE` |

Set to `FALSE` in your downstream image's BUILD_ENV or runtime to suppress the fragment. When and why you'd flip these off:

- Different `location /` router required or different `try_files` chain, different front controller file, custom routing logic). Set `LARAVEL_NGINX_ENABLE_ROUTER=FALSE` and ship your own file at your image's own layer prefix, e.g. `sites.available/<yoursite>/location/40-myapp-router.conf`.
- Your app doesn't have `/uploads` or `/media` URL paths and you don't want stray autoindex directives sitting in the runtime config. Set `LARAVEL_NGINX_ENABLE_STATIC_PATHS=FALSE`.

```dockerfile
BUILD_ENV=" \
    30-laravel/LARAVEL_NGINX_ENABLE_ROUTER=FALSE \
    30-laravel/LARAVEL_NGINX_ENABLE_STATIC_PATHS=FALSE \
"
```

#### Image Mode Details

The `LARAVEL_IMAGE_MODE` environment variable is crucial for determining how the container operates in different environments. This setting automatically configures multiple environment variables to optimize the container for either development or production use.

##### Production Mode (`LARAVEL_IMAGE_MODE=production`)

Use `LARAVEL_IMAGE_MODE=production` for:
- Production deployments
- Staging environments
- Load testing
- Any environment serving real traffic

Use `LARAVEL_IMAGE_MODE=development` only for:
- Local development
- Testing new features
- Quick prototyping

When set to `production`, the container is optimized for production workloads:

- Web Server: Uses Nginx + PHP-FPM
- Performance: Disables development tools and debugging features
- File Management: Enables persistent storage redirection for config, logs, and storage
- Queue Processing: Enables Laravel Worker for background job processing

**Automatically configured variables:**
```dotenv
ENABLE_LARAVEL_ARTISAN_SERVE=FALSE    # Disables artisan serve
ENABLE_LARAVEL_ENV_WATCHER=TRUE       # Monitors .env changes
ENABLE_LARAVEL_NPM_RUN_DEV=FALSE      # Disables NPM dev server
ENABLE_LARAVEL_WORKER=TRUE            # Enables queue worker
ENABLE_CONFIG_REDIRECTION=TRUE        # Persists config files
ENABLE_LOG_REDIRECTION=TRUE           # Persists log files
ENABLE_STORAGE_REDIRECTION=TRUE       # Persists storage files
```

##### Development Mode (`LARAVEL_IMAGE_MODE=development`)

When set to `development` (default), the container is optimized for development workflows:

- Web Server: Can optionally use Laravel's built-in artisan serve for quick development
- Development Tools: Enables hot reloading, NPM dev server, and debugging features
- File Management: Keeps files local
- Queue Processing: Disabled by default and can be manually enabled

**Automatically configured variables:**
```dotenv
ENABLE_LARAVEL_ARTISAN_SERVE=TRUE     # Enables artisan serve option
ENABLE_LARAVEL_ENV_WATCHER=TRUE       # Monitors .env changes
ENABLE_LARAVEL_NPM_RUN_DEV=TRUE       # Enables NPM dev server
ENABLE_LARAVEL_WORKER=TRUE            # Disabled (enable manually if needed)
ENABLE_CONFIG_REDIRECTION=FALSE       # Local config files
ENABLE_LOG_REDIRECTION=FALSE          # Local log files
ENABLE_STORAGE_REDIRECTION=FALSE      # Local storage files
```

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

* For community help, tips, and community discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://laravel.net/>
* <https://github.com/laravel-helpdesk/laravel/wiki/Installation-Guide>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

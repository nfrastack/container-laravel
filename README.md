# nfrastack/container-nginx-php-fpm

## About

This repository will build a conatiner image for running [Laravel](https://laravel.net/) applications either in a development or production capacity, including [Nginx](https://www.nginx.org) w/[PHP-FPM](https://php.net).

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
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-laravel/pkgs/container/container-laravel) and [Docker Hub](https://hub.docker.com/r/nfrastack/nginx-php-fpm).

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
| 8.4.x       | 3.22        | `:8.4-alpine`  | Trixie      | `:8.4-debian`          |
|             |             |                | Bookworm    | `:8.4-debian_bookworm` |
| 8.3.x       | 3.22        | `:8.3-alpine`  | Bookworm    | `:8.3-debian_trixie`   |
|             |             |                | Trixie      | `:8.3-debian`          |
| 8.2.x       | 3.22        | `:8.2-alpine`  | Trixie      | `:8.2-debian`          |
|             |             |                | Bookworm    | `:8.2-debian_bookworm` |
| 8.1.x       | 3.19        | `:8.1-alpine`  |             |                        |
| 8.0.x       | 3.16        | `:8.0-alpine`  |             |                        |
| 7.4.x       | 3.15        | `:7.4-alpine`  |             |                        |
| 7.3.x       | 3.12        | `:7.3-alpine`  |             |                        |
| 7.2.x       | 3.9         | `:7.2-alpine`  |             |                        |
| 7.1.x       | 3.7         | `:7.1-alpine`  |             |                        |
| 7.0.x       | 3.5         | `:7.0-alpine`  |             |                        |
| 5.6.x       | 3.8         | `:5.6-alpine`  |             |                        |
| 5.5.x       | 3.4         | `:5.5-latest`  |             |                        |
| 5.3.x       | 3.4         | `:5.3-latest`  |             |                        |

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

| Image                                                                | Description         |
| -------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)              | Base Image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)               | Nginx Webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM Interpreter |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

### Operation Mode
| Parameter                      | Description                                                                                                 | Default                 | `_FILE` |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------- | ----------------------- | ------- |
| `SETUP_TYPE`                   | Automatically edit configuration after first bootup `AUTO` or `MANUAL`                                      | `AUTO`                  |         |
| `DATA_PATH`                    | Base Data Path                                                                                              | `/data`                 |         |
| `ENABLE_CONFIG_REDIRECTION`    | Enable Config File Redirection to Persistent Storage                                                        | `FALSE`                 |         |
| `CONFIG_PATH`                  | Path to Configuration Directory                                                                             | `${DATA_PATH}/config/`  |         |
| `CONFIG_FILE`                  | Configuration File Name                                                                                     | `config`                |         |
| `ENABLE_LOG_REDIRECTION`       | Enable Log File Redirection to Persistent Storage                                                           | `FALSE`                 |         |
| `LOG_PATH`                     | Logfile location                                                                                            | `/www/html/laravel`     |         |
| `ENABLE_STORAGE_REDIRECTION`   | Enable Storage Directory Redirection to Persistent Storage                                                  | `FALSE`                 |         |
| `STORAGE_PATH`                 | Path to Storage Directory                                                                                   | `${DATA_PATH}/storage/` |         |
| `LARAVEL_IMAGE_MODE`           | Laravel Image Mode - `production` or `development`. See [Image Mode Details](#image-mode-details) below | `development`           |         |
| `ENABLE_LARAVEL_ARTISAN_SERVE` | Enable Laravel Artisan Serve (Development only - not suitable for production)                               | `TRUE`                  |         |
| `ENABLE_LARAVEL_ENV_WATCHER`   | Enable Laravel Environment File Watcher                                                                     | `TRUE`                  |         |
| `ENABLE_LARAVEL_NPM_RUN_DEV`   | Enable Laravel NPM Development Server                                                                       | `TRUE`                  |         |
| `ENABLE_LARAVEL_WORKER`        | Enable Laravel Queue Worker                                                                                 | `FALSE`                 |         |
| `ARTISAN_SERVE_LISTEN_IP`      | IP Address for Artisan Serve to Listen On                                                                   | `0.0.0.0`               |         |
| `ARTISAN_SERVE_LISTEN_PORT`    | Port for Artisan Serve to Listen On                                                                         | `8000`                  |         |


### Database Options (Future)
| Parameter | Description                                                       | Default | `_FILE` |
| --------- | ----------------------------------------------------------------- | ------- | ------- |
| `DB_TYPE` | Type of the Database. Currently supported are `mysql` and `pgsql` | `mysql` |         |
| `DB_HOST` | Host or container name of the Databse Server e.g. `laravel-db`    |         | x       |
| `DB_PORT` | Database Port e.g.`3306` for mysql, `5432` for postgres           | `3306`  | x       |
| `DB_NAME` | Database name e.g. `laravel`                                      |         | x       |
| `DB_USER` | Username for above Database e.g. `laravel`                        |         | x       |
| `DB_PASS` | Password for above Database e.g. `password`                       |         | x       |

### Site Options (Future)
| Parameter        | Description               | Default | `_FILE` |
| ---------------- | ------------------------- | ------- | ------- |
| `DISPLAY_ERRORS` | Display Errors on Website | `FALSE` |         |

| `SITE_URL`         | The url your site listens on example `https://laravel.example.com`     |                              |         |
| `APP_NAME`         | Application Name                                                       | `Application`                |         |
| `APP_DEBUG`        | Enable Laravel Debug Mode                                              | `FALSE` (prod), `TRUE` (dev) |         |
| `BROADCAST_DRIVER` | Laravel Broadcast Driver                                               | `log`                        |         |
| `CACHE_DRIVER`     | Laravel Cache Driver                                                   | `file`                       |         |
| `SESSION_DRIVER`   | Laravel Session Driver                                                 | `file`                       |         |
| `SESSION_LIFETIME` | Laravel Session Lifetime in minutes                                    | `120`                        |         |
| `LOG_CHANNEL`      | Laravel Log Channel                                                    | `single`                     |         |
| `LOG_LEVEL`        | Laravel Log Level                                                      | `info`                       |         |
| `MEDIA_DISK`       | Laravel Media Disk Name                                                | `public`                     |         |

### Mail Options (Future)
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

### LDAP Options (Future)
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

- Web Server: Uses Nginx + PHP-FPM for robust, scalable web serving
- Performance: Disables development tools and debugging features
- File Management: Enables persistent storage redirection for config, logs, and storage
- Queue Processing: Enables Laravel Worker for background job processing

**Automatically configured variables:**
```bash
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
- File Management: Keeps files local for faster development cycles
- Queue Processing: Disabled by default (can be manually enabled)

**Automatically configured variables:**
```
ENABLE_LARAVEL_ARTISAN_SERVE=TRUE     # Enables artisan serve option
ENABLE_LARAVEL_ENV_WATCHER=TRUE       # Monitors .env changes
ENABLE_LARAVEL_NPM_RUN_DEV=TRUE       # Enables NPM dev server
ENABLE_LARAVEL_WORKER=FALSE           # Disabled (enable manually if needed)
ENABLE_CONFIG_REDIRECTION=FALSE       # Local config files
ENABLE_LOG_REDIRECTION=FALSE          # Local log files
ENABLE_STORAGE_REDIRECTION=FALSE      # Local storage files
```

### Why Production Mode Matters

Laravel Artisan Serve Limitations:

- Artisan serve is Laravel's built-in development server
- It's single-threaded and not designed for production traffic
- It lacks the performance, security, and stability features of proper web servers
- Cannot handle concurrent requests effectively

Production Benefits:
- **Nginx + PHP-FPM**: Multi-process, multi-threaded architecture for handling concurrent requests
- Performance: Optimized for high-traffic, production workloads
- Security: Production-hardened web server configuration
- Reliability: Better error handling and recovery mechanisms
- Scalability: Can handle thousands of concurrent connections
- Production mode enables file redirection to keep important data outside the container
- Configuration, logs, and storage persist across container restarts

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

# github.com/tiredofit/docker-laravel

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-laravel?style=flat-square)](https://github.com/tiredofit/docker-laravel/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-laravel/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-laravel/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/laravel.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/laravel/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/laravel.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/laravel/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a Docker Image for running [Laravel](https://laravel.net/) applications either in a development or production capacity

* Automatically installs and sets up base Laravel codebase if not exist
* Config, Logfile, and Storage redirection to keep your codebase inside the container and volatile files out


## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents


- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Requires access to a MySQL/MariaDB or Postgres Server

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/laravel)

```bash
docker pull docker.io/tiredofit/laravel:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-laravel/pkgs/container/docker-laravel)

```
docker pull ghcr.io/tiredofit/docker-laravel:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

## Configuration

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/compose.yml) that can be modified for development or production use.

- Set various [environment variables](#environment-variables) to understand the capabilities of this image.
- Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

**The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.**

- Login to the web server and enter in your admin email address, admin password and start configuring the system!

### Persistent Storage
The following directories are used for configuration and can be mapped for persistent storage.

| Directory            | Description                                                                     |
| -------------------- | ------------------------------------------------------------------------------- |
| `/www/logs/laravel/` | (optional) If you want to store laravel.logs somewhere else                     |
| `/data/storage`      | (Optional) Volatile data for the application that is outisde of codebase        |
| `/data/config`       | (Optional) Volatile config file for the application that is outisde of codebase |
| *OR*                 |                                                                                 |
| `/www/html`          | (Optional) If you want to expose the laravel sourcecode expose this volume      |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                         | Description                            |
| ------------------------------------------------------------- | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/)        | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)           | Nginx webserver                        |
| [PHP-FPM](https://github.com/tiredofit/docker-nginx-php-fpm/) | PHP Interpreter                        |

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
| `LARAVEL_IMAGE_MODE`           | **Laravel Image Mode** - `production` or `development`. See [Image Mode Details](#image-mode-details) below | `development`           |         |
| `ENABLE_LARAVEL_ARTISAN_SERVE` | Enable Laravel Artisan Serve (Development only - not suitable for production)                               | `TRUE`                  |         |
| `ENABLE_LARAVEL_ENV_WATCHER`   | Enable Laravel Environment File Watcher                                                                     | `TRUE`                  |         |
| `ENABLE_LARAVEL_NPM_RUN_DEV`   | Enable Laravel NPM Development Server                                                                       | `TRUE`                  |         |
| `ENABLE_LARAVEL_WORKER`        | Enable Laravel Queue Worker                                                                                 | `FALSE`                 |         |
| `ARTISAN_SERVE_LISTEN_IP`      | IP Address for Artisan Serve to Listen On                                                                   | `0.0.0.0`               |         |
| `ARTISAN_SERVE_LISTEN_PORT`    | Port for Artisan Serve to Listen On                                                                         | `8000`                  |         |

## Image Mode Details

The `LARAVEL_IMAGE_MODE` environment variable is crucial for determining how the container operates in different environments. This setting automatically configures multiple environment variables to optimize the container for either development or production use.

### Production Mode (`LARAVEL_IMAGE_MODE=production`)

When set to `production`, the container is optimized for production workloads:

- **Web Server**: Uses Nginx + PHP-FPM for robust, scalable web serving
- **Performance**: Disables development tools and debugging features
- **File Management**: Enables persistent storage redirection for config, logs, and storage
- **Queue Processing**: Enables Laravel Worker for background job processing

**Automatically configured variables:**
```
ENABLE_LARAVEL_ARTISAN_SERVE=FALSE    # Disables artisan serve
ENABLE_LARAVEL_ENV_WATCHER=TRUE       # Monitors .env changes
ENABLE_LARAVEL_NPM_RUN_DEV=FALSE      # Disables NPM dev server
ENABLE_LARAVEL_WORKER=TRUE            # Enables queue worker
ENABLE_CONFIG_REDIRECTION=TRUE        # Persists config files
ENABLE_LOG_REDIRECTION=TRUE           # Persists log files
ENABLE_STORAGE_REDIRECTION=TRUE       # Persists storage files
```

### Development Mode (`LARAVEL_IMAGE_MODE=development`)

When set to `development` (default), the container is optimized for development workflows:

- **Web Server**: Can optionally use Laravel's built-in artisan serve for quick development
- **Development Tools**: Enables hot reloading, NPM dev server, and debugging features
- **File Management**: Keeps files local for faster development cycles
- **Queue Processing**: Disabled by default (can be manually enabled)

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

**Laravel Artisan Serve Limitations:**
- Artisan serve (`php artisan serve`) is Laravel's built-in development server
- It's single-threaded and not designed for production traffic
- It lacks the performance, security, and stability features of proper web servers
- Cannot handle concurrent requests effectively

**Production Benefits:**
- **Nginx + PHP-FPM**: Multi-process, multi-threaded architecture for handling concurrent requests
- **Performance**: Optimized for high-traffic, production workloads
- **Security**: Production-hardened web server configuration
- **Reliability**: Better error handling and recovery mechanisms
- **Scalability**: Can handle thousands of concurrent connections

**File Persistence:**
- Production mode enables file redirection to keep important data outside the container
- Configuration, logs, and storage persist across container restarts
- Essential for production deployments where containers may be recreated

### Recommendation

Always use `LARAVEL_IMAGE_MODE=production` for:
- Production deployments
- Staging environments
- Load testing
- Any environment serving real traffic

Use `LARAVEL_IMAGE_MODE=development` only for:
- Local development
- Testing new features
- Quick prototyping

### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- [Sponsor me](https://tiredofit.ca/sponsor) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- [Sponsor me](https://tiredofit.ca/sponsor) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- [Sponsor me](https://tiredofit.ca/sponsor) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://laravel.net/>
* <https://github.com/laravel-helpdesk/laravel/wiki/Installation-Guide>

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**drudock-php** is a collection of Docker images for Drupal PHP-FPM containers, published as `4alldigital/drudock-php` on Docker Hub. Each PHP version has its own directory with a Dockerfile and configuration files. These images are used as part of the [DruDock](https://github.com/4AllDigital/DockerDrupalCli) development environment.

## Build and Push Commands

Build a specific PHP version image:
```bash
docker build -t 4alldigital/drudock-php:<version> --platform linux/amd64 ./<version>/ --no-cache
```

Build and push (per-version scripts exist):
```bash
./<version>/pushUpdate.sh
```

The root `pushUpdate.sh` is for a different image (sonar-scanner) — do not confuse it with PHP image builds.

## Repository Structure

Each PHP version directory (`5.6/`, `7.0/`, `7.1/`, `7.2/`, `7.3/`, `7.4/`, `8.0/`, `8.1/`, `8.3/`, `8.4/`) contains:

- `Dockerfile` — Base PHP-FPM image built on `phusion/baseimage`
- `Dockerfile-devtools` — Extends the base image with xdebug, Drupal Console, PHP_CodeSniffer (phpcs/phpcbf), and SSH (present in 7.1+)
- `config/` — PHP-FPM configs (`php-fpm.conf`, `www.conf`, `docker.conf`, `php.ini`, `cli-php.ini`), xdebug config (`20-xdebug.ini`), htaccess, and `mysql.conf`
- `pushUpdate.sh` — Builds and pushes that version's image to Docker Hub

## Architecture Differences Across Versions

**Legacy (5.6, 7.0):** Uses supervisord to manage php-fpm + sshd. Includes SSH keys directly in the image. Base image is older phusion/baseimage (0.9.x). Working directory is not explicitly set.

**Modern (7.1+):** Runs php-fpm directly as CMD (no supervisord). No SSH in base image (SSH moved to devtools variant). Uses `phusion/baseimage:master-amd64` (7.1-7.4) or `phusion/baseimage:noble-1.0.0` (8.x). Working directory is `/app/web`. Includes `docker.conf` pool configuration.

## Key Patterns

- Drush version varies by PHP version (8.x for old PHP, ^10 for 7.3-7.4, ^12-13 for 8.x)
- PHP extensions list differs per version — some packages were removed or renamed between PHP versions (e.g., `php-json` merged into core in 8.0+, `mcrypt` removed in 7.2+)
- All images expose port 9000 (PHP-FPM)
- Config files use paths matching the PHP version: `/etc/php/<version>/fpm/`

## Adding a New PHP Version

1. Copy the latest version directory (e.g., `8.4/`) as template
2. Update all PHP version references in Dockerfile (package names, paths, CMD)
3. Update the Drush version requirement for PHP compatibility
4. Update `pushUpdate.sh` with the correct tag
5. Adjust config file paths in COPY statements
6. Check if any PHP extensions need adding/removing for the new version

# Quick reference

- **Maintained by**:  
     [Dimitar "Arruor" Nikov](https://github.com/arruor/docker-library)

- **Where to get help**:  
     [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://dockr.ly/slack), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker)

- **Based on Official PHP images with some handy customisations**

# Supported tags and respective `Dockerfile` links

-	[`php-cli:latest`, `php-cli:8.2.10`, `php-cli:8.10`, `php-cli:8`](https://github.com/arruor/docker-library/blob/main/alpine/php/cli/Dockerfile)
-	[`php-fpm:latest`, `php-fpm:8.2.10`, `php-fpm:8.10`, `php-fpm:8`](https://github.com/arruor/docker-library/blob/main/alpine/php/fpm/Dockerfile)

# Quick reference (cont.)

- **Where to file issues**:  
     Official PHP images: [https://github.com/docker-library/php/issues](https://github.com/docker-library/php/issues)
 
     Customised images: [https://github.com/arruor/docker-library/issues](https://github.com/arruor/docker-library/issues)

- **Modifications to official image**: 
  - Extra extensions added: bcmath bz2 calendar dba exif ffi gd gettext gmp imap intl ldap mysqli odbc opcache pcntl pdo_dblib pdo_mysql pdo_odbc pdo_pgsql pgsql pspell shmop snmp soap sockets sysvmsg sysvsem sysvshm tidy xsl zip
  - 3rd party extensions added: xmlrpc ssh2 rrd msgpack igbinary memcached mongodb redis xdebug tideways_xhprof
  - Configure options for GD extension: `--enable-gd --with-webp --with-jpeg --with-xpm --with-freetype --enable-gd-jis-conv --with-avif`
  - Configure options for Redis extension: `--enable-redis --enable-redis-igbinary --enable-redis-msgpack --enable-redis-lzf --with-liblzf --enable-redis-zstd --enable-redis-lz4 --with-liblz4`

- **Image updates**:  
     [official-images repo's `library/php` label](https://github.com/docker-library/official-images/issues?q=label%3Alibrary%2Fphp)  
     [official-images repo's `library/php` file](https://github.com/docker-library/official-images/blob/master/library/php) ([history](https://github.com/docker-library/official-images/commits/master/library/php))

# How to use this image

### Create a `Dockerfile` in your PHP project

```dockerfile
FROM arruor/php-cli:latest
COPY <app dir> /usr/src/myapp
WORKDIR /usr/src/myapp
CMD [ "php", "./your-script.php" ]
```

Then, run the commands to build and run the Docker image:

```console
$ docker build -t my-php-app .
$ docker run -it --rm --name my-running-app my-php-app
```

### Run a single PHP script

For many simple, single file projects, you may find it inconvenient to write a complete `Dockerfile`. In such cases, you can run a PHP script by using the PHP Docker image directly:

```console
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp arruor/php-cli:latest php your-script.php
```

## How to install more PHP extensions

Many extensions are already compiled into the image, so it's worth checking the output of `php -m` or `php -i` before going through the effort of compiling more.

We provide the helper scripts `docker-php-ext-configure`, `docker-php-ext-install`, and `docker-php-ext-enable` to more easily install PHP extensions.

In order to keep the images smaller, PHP's source is kept in a compressed tar file. To facilitate linking of PHP's source with any extension, we also provide the helper script `docker-php-source` to easily extract the tar or delete the extracted source. Note: if you do use `docker-php-source` to extract the source, be sure to delete it in the same layer of the docker image.

```Dockerfile
FROM arruor/php-cli:latest
RUN docker-php-source extract \
	# do important things \
	&& docker-php-source delete
```

### PHP Core Extensions

For example, if you want to have a PHP-FPM image with the `gd` extension, you can inherit the base image that you like, and write your own `Dockerfile` like this:

```dockerfile
FROM arruor/php-fpm:latest
RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache --update \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
```

Remember, you must install dependencies for your extensions manually. If an extension needs custom `configure` arguments, you can use the `docker-php-ext-configure` script like this example. There is no need to run `docker-php-source` manually in this case, since that is handled by the `configure` and `install` scripts.

If you are having difficulty figuring out which Debian or Alpine packages need to be installed before `docker-php-ext-install`, then have a look at [the `install-php-extensions` project](https://github.com/mlocati/docker-php-extension-installer). This script builds upon the `docker-php-ext-*` scripts and simplifies the installation of PHP extensions by automatically adding and removing Alpine (apk) packages. For example, to install the GD extension you simply have to run `install-php-extensions gd`. This tool is contributed by community members and is not included in the images, please refer to their Git repository for installation, usage, and issues.

See also ["Dockerizing Compiled Software"](https://tianon.xyz/post/2017/12/26/dockerize-compiled-software.html) for a description of the technique Tianon uses for determining the necessary build-time dependencies for any bit of software (which applies directly to compiling PHP extensions).

### Default extensions

Some extensions are compiled by default. This depends on the PHP version you are using. Run `php -m` in the container to get a list for your specific version.

### PECL extensions

Some extensions are not provided with the PHP source, but are instead available through [PECL](https://pecl.php.net/). To install a PECL extension, use `pecl install` to download and compile it, then use `docker-php-ext-enable` to enable it:

```dockerfile
FROM arruor/php-cli:latest
RUN pecl install redis-5.3.7 \
	&& pecl install xdebug-3.2.2 \
	&& docker-php-ext-enable redis xdebug
```

```dockerfile
FROM arruor/php-cli:latest
RUN apk --no-cache update && apk --no-cache upgrade && apk add --no-cache --update libmemcached-dev zlib-dev \
	&& pecl install memcached-3.2.0 \
	&& docker-php-ext-enable memcached
```

It is *strongly* recommended that users use an explicit version number in their `pecl install` invocations to ensure proper PHP version compatibility (PECL does not check the PHP version compatibility when choosing a version of the extension to install, but does when trying to install it).

For example, `memcached-2.2.0` has no PHP version constraints (https://pecl.php.net/package/memcached/2.2.0), but `memcached-3.2.0` requires PHP 7.0.0 or newer (https://pecl.php.net/package/memcached/3.2.0). When doing `pecl install memcached` (no specific version) on PHP 5.6, PECL will try to install the latest release and fail.

Beyond the compatibility issue, it's also a good practice to ensure you know when your dependencies receive updates and can control those updates directly.

Unlike PHP core extensions, PECL extensions should be installed in series to fail properly if something went wrong. Otherwise, errors are just skipped by PECL. For example, `pecl install memcached-3.2.0 && pecl install redis-5.3.7` instead of `pecl install memcached-3.2.0 redis-5.3.7`. However, `docker-php-ext-enable memcached redis` is fine to be all in one command.

### Other extensions

Some extensions are not provided via either Core or PECL; these can be installed too, although the process is less automated:

```dockerfile
FROM arruor/php-cli:latest
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
	&& mkdir -p xcache \
	&& tar -xf xcache.tar.gz -C xcache --strip-components=1 \
	&& rm xcache.tar.gz \
	&& ( \
		cd xcache \
		&& phpize \
		&& ./configure --enable-xcache \
		&& make -j "$(nproc)" \
		&& make install \
	) \
	&& rm -r xcache \
	&& docker-php-ext-enable xcache
```

The `docker-php-ext-*` scripts *can* accept an arbitrary path, but it must be absolute (to disambiguate from built-in extension names), so the above example could also be written as the following:

```dockerfile
FROM arruor/php-cli:latest
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
	&& mkdir -p /tmp/xcache \
	&& tar -xf xcache.tar.gz -C /tmp/xcache --strip-components=1 \
	&& rm xcache.tar.gz \
	&& docker-php-ext-configure /tmp/xcache --enable-xcache \
	&& docker-php-ext-install /tmp/xcache \
	&& rm -r /tmp/xcache
```

## Running as an arbitrary user

For running the Apache variants as an arbitrary user, there are a couple choices:

-	If your kernel [is version 4.11 or newer](https://github.com/moby/moby/issues/8460#issuecomment-312459310), you can add `--sysctl net.ipv4.ip_unprivileged_port_start=0` (which [will be the default in a future version of Docker](https://github.com/moby/moby/pull/41030)) and then `--user` should work as it does for FPM.
-	If you adjust the Apache configuration to use an "unprivileged" port (greater than 1024 by default), then `--user` should work as it does for FPM regardless of kernel version.

For running the FPM variants as an arbitrary user, the `--user` flag to `docker run` should be used (which can accept both a username/group in the container's `/etc/passwd` file like `--user daemon` or a specific UID/GID like `--user 1000:1000`).

## Configuration

This image ships with the default [`php.ini-development`](https://github.com/php/php-src/blob/master/php.ini-development) and [`php.ini-production`](https://github.com/php/php-src/blob/master/php.ini-production) configuration files.

It is *strongly* recommended using the production config for images used in production environments!

The default config can be customized by copying configuration files into the `$PHP_INI_DIR/conf.d/` directory.

### Example

```dockerfile
FROM arruor/php-cli:latest

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
```

In many production environments, it is also recommended to (build and) enable the PHP core OPCache extension for performance. See [the upstream OPCache documentation](https://www.php.net/manual/en/book.opcache.php) for more details.

# Image Variants

The `php` images come in many flavors, each designed for a specific use case.

## `php-cli:<version>`

This variant contains the [PHP CLI](https://secure.php.net/manual/en/features.commandline.php) tool with default mods. If you need a web server, this is probably not the image you are looking for. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as a base from which to build other images.

It also is the only variant which contains the (not recommended) `php-cgi` binary, which is likely necessary for some things like [PPM](https://github.com/php-pm/php-pm).

Note that *all* variants of `php` contain the PHP CLI (`/usr/local/bin/php`).

## `php-fpm:<version>`

This variant contains PHP-FPM, which is a FastCGI implementation for PHP. See [the PHP-FPM website](https://php-fpm.org/) for more information about PHP-FPM.

In order to use this image variant, some kind of reverse proxy (such as NGINX, Apache, or other tool which speaks the FastCGI protocol) will be required.

Some potentially helpful resources:

-	[PHP-FPM.org](https://php-fpm.org/)
-	[simplified example by @md5](https://gist.github.com/md5/d9206eacb5a0ff5d6be0)
-	[very detailed article by Pascal Landau](https://www.pascallandau.com/blog/php-php-fpm-and-nginx-on-docker-in-windows-10/)
-	[Stack Overflow discussion](https://stackoverflow.com/q/29905953/433558)
-	[Apache httpd Wiki example](https://wiki.apache.org/httpd/PHPFPMWordpress)

**WARNING:** the FastCGI protocol is inherently trusting, and thus *extremely* insecure to expose outside a private container network -- unless you know *exactly* what you are doing (and are willing to accept the extreme risk), do not use Docker's `--publish` (`-p`) flag with this image variant.

# License

View [license information](http://php.net/license/) for the software contained in the official image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
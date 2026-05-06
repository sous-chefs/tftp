# tftp_server

Installs and configures a TFTP server using the operating system package.

## Actions

* `:create` - Installs the package, creates the TFTP root directory, configures the daemon, and starts the service. Default.
* `:delete` - Stops and disables the service, removes managed configuration, removes the TFTP root directory, and removes the package.

## Properties

* `instance` - String, name property. Resource instance name.
* `packages` - String or Array, platform-specific default. Package or packages that provide the TFTP server.
* `directory` - String, default `'/var/lib/tftpboot'`. Directory served by the TFTP daemon.
* `directory_owner` - String, default `'root'`. Owner for the TFTP root directory.
* `directory_group` - String, platform-specific default. Group for the TFTP root directory.
* `directory_mode` - String, default `'0755'`. Mode for the TFTP root directory.
* `username` - String, default `'tftp'`. User used by the TFTP daemon on platforms that support it.
* `address` - String, default `'0.0.0.0:69'`. Listen address used on Debian-family platforms.
* `options` - String, default `'--secure'`. TFTP daemon options used on Debian-family platforms.
* `service_name` - String, platform-specific default. Systemd service or socket unit to manage.
* `config_file` - String or nil, platform-specific default. Debian-family `tftpd-hpa` environment file.
* `config` - Hash, platform-specific default. Debian-family `tftpd-hpa` environment values.

## Examples

### Basic usage

```ruby
tftp_server 'default'
```

### Custom directory

```ruby
tftp_server 'default' do
  directory '/srv/tftp'
  directory_mode '0750'
end
```

### Custom Debian daemon options

```ruby
tftp_server 'default' do
  username 'nobody'
  address '127.0.0.1:1069'
  options '--secure --create'
end
```

### Remove the server

```ruby
tftp_server 'default' do
  action :delete
end
```

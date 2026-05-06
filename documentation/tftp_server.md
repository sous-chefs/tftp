# tftp_server

Installs and configures a TFTP server using the operating system package.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Installs the package, creates the TFTP root directory, configures the daemon, and starts the service. Default. |
| `:delete` | Stops and disables the service, removes managed configuration, removes the TFTP root directory, and removes the package. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `instance` | String | name property | Resource instance name. |
| `packages` | String, Array | platform-specific | Package or packages that provide the TFTP server. |
| `directory` | String | `'/var/lib/tftpboot'` | Directory served by the TFTP daemon. |
| `directory_owner` | String | `'root'` | Owner for the TFTP root directory. |
| `directory_group` | String | platform-specific | Group for the TFTP root directory. |
| `directory_mode` | String | `'0755'` | Mode for the TFTP root directory. |
| `username` | String | `'tftp'` | User used by the TFTP daemon on platforms that support it. |
| `address` | String | `'0.0.0.0:69'` | Listen address used on Debian-family platforms. |
| `options` | String | `'--secure'` | TFTP daemon options used on Debian-family platforms. |
| `service_name` | String | platform-specific | Systemd service or socket unit to manage. |
| `config_file` | String, nil | platform-specific | Debian-family `tftpd-hpa` environment file. |
| `config` | Hash | platform-specific | Debian-family `tftpd-hpa` environment values. |

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

# Migration

## Migrating from recipes and attributes

Version 5.0.0 removes the legacy `tftp::default` and `tftp::server` recipes and the `node['tftp']` attributes. Use the `tftp_server` custom resource instead.

### Before

```ruby
run_list 'recipe[tftp::server]'

default['tftp']['directory'] = '/var/lib/tftpboot'
default['tftp']['permissions'] = '0755'
default['tftp']['username'] = 'tftp'
```

### After

```ruby
tftp_server 'default' do
  directory '/var/lib/tftpboot'
  directory_mode '0755'
  username 'tftp'
end
```

## Attribute Mapping

| Legacy attribute | Resource property |
|------------------|-------------------|
| `node['tftp']['pkgs']` | `packages` |
| `node['tftp']['directory']` | `directory` |
| `node['tftp']['permissions']` | `directory_mode` |
| `node['tftp']['owner']` | `directory_owner` |
| `node['tftp']['group']` | `directory_group` |
| `node['tftp']['username']` | `username` |
| `node['tftp']['service_name']` | `service_name` |
| `node['tftp']['config_file']` | `config_file` |
| `node['tftp']['conf']` | `config` |

## Test Cookbook Example

The cookbook's default Kitchen suite now uses `recipe[test::default]`:

```ruby
tftp_server 'default' do
  directory node['tftp_test']['directory']
  directory_mode node['tftp_test']['directory_mode']
  username node['tftp_test']['username']
  address node['tftp_test']['address']
  options node['tftp_test']['options']
  action :create
end
```

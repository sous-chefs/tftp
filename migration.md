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

* `node['tftp']['pkgs']` maps to `packages`.
* `node['tftp']['directory']` maps to `directory`.
* `node['tftp']['permissions']` maps to `directory_mode`.
* `node['tftp']['owner']` maps to `directory_owner`.
* `node['tftp']['group']` maps to `directory_group`.
* `node['tftp']['username']` maps to `username`.
* `node['tftp']['service_name']` maps to `service_name`.
* `node['tftp']['config_file']` maps to `config_file`.
* `node['tftp']['conf']` maps to `config`.

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

# tftp Cookbook CHANGELOG

This file is used to list changes made in each version of the tftp cookbook.

## 3.0.1 (2017-06-28)

- Test with Local Delivery instead of Rake
- Update apache2 license string to be a SPDX compliant string
- Move the template out of the default dir since Chef 12 does not require this
- Support Amazon Linux on Chef 13 and add amazon linux to the metadata
- Avoid deprecation warning in the Chefspecs

## 3.0.0 (2016-09-16)
- Switch to kitchen-dokken for testing in Travis
- Replace serverspec tests with inspec
- Add chef_version metadata
- Clean up service commands
- Require Chef 12.1A
- Use multipackage installs to speed up chef runs

## v2.0.0 (2016-05-20):

- Completely refactored to use the xinetd cookbook and to allow all config variables to be passed in via a config hash. See the attributes file for the new defaults and usage.

## v1.6.0 (2016-05-19):

- Add a new attribute for controlling the user / group of tftp directories. Also properly set these to the defaults for RHEL/Fedora/Debian based systems

## v1.5.0 (2016-05-18):

- Add a new attribute for controlling the permissions on the tftp directory

## v1.4.0 (2016-04-28):

- Added support for RHEL 7 by installing xinetd on all RHEL systems to ensure it's present

## v1.3.0:

- Switch to platform family to support additional RHEL and Debian derivatives
- Setup / Start the services after creating the dirs and templating the configs to prevent starting the service is a 1/2 working state and/or failures that would halt the chef run
- Fix service starts/restarts on Ubuntu
- Replace minitest testing with serverspec
- Added gitignore and chefignore files
- Added Test Kitchen config
- Added Rubocop config
- Added Travis config
- Added Berksfile
- Updated Testing and Contributing docs
- Added maintainers.toml and maintainers.md files
- Added Gemfile with development dependencies
- Added Travis and cookbook version badges to the Readme
- Expanded the requirements section in the Readme
- Added a Rakefile for simplified testing
- Added additional platforms to the metadata.rb
- Added issues_url and source_url to the metadata.rb
- Updated Opscode -> Chef Software
- Added basic Chefspec converge test
- Converted symbols to strings for Foodcritic
- Resolved all Rubocop warnings
- Add License file

## v1.2.0:

- [COOK-3297] - Improved support for customized settings for RedHat based systems, the default options were also corrected
- Resolved xinetd restarting on every chef run

## v1.1.0:

- [COOK-1849] - Add RHEL support

## v1.0.0:

- [COOK-1536] - tftp service doesn't restart if down

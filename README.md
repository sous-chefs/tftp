# tftp Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/tftp.svg?branch=master)](http://travis-ci.org/chef-cookbooks/tftp) [![Cookbook Version](https://img.shields.io/cookbook/v/tftp.svg)](https://supermarket.chef.io/cookbooks/tftp)

Configures the Trivial File Transfer Protocol server `tftpd`. This cookbook may be used in conjunction with the `pxe_dust` to create PXE-bootable Ubuntu installs.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle

### Chef

- Chef 12.1+

### Cookbooks

- xinetd

## Recipes

### default

The default recipe passes through to the server recipe.

### server

The node will install and use the `tftpd` application to provide files via tftp. Typically those nodes will be requesting images via PXE and configured from their BIOS as clients, so there is not a client recipe yet.

## Usage

Nodes using the `tftp::server` recipe will provide tftp access to whatever files are in their `['tftp']['directory']`.

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2016, Chef Software, Inc.

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

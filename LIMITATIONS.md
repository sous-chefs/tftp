# Limitations

## Package Availability

This cookbook installs the TFTP server packages provided by the operating system repositories. It does not configure third-party repositories or build TFTP from source.

### APT (Debian/Ubuntu)

* Debian 12 and 13 provide `tftpd-hpa` from the distribution repositories.
* Ubuntu 22.04 and 24.04 provide `tftpd-hpa` from the distribution repositories.
* Current Debian and Ubuntu package indexes publish `tftpd-hpa` for common architectures including `amd64`, `arm64`, `armhf`, `ppc64el`, `riscv64`, and `s390x`.

### DNF/YUM (RHEL family)

* RHEL-family distributions provide `tftp-server` from the distribution repositories.
* AlmaLinux 9 AppStream publishes `tftp-server` for `x86_64` and `aarch64`; compatible RHEL-family rebuilds are expected to provide the same package from AppStream or equivalent repositories.
* Amazon Linux 2023 support is limited to packages available in the Amazon Linux repositories for the selected release.
* Amazon Linux 2 is not included in the modern platform matrix because it reaches end of life on June 30, 2026.

### Zypper (SUSE)

* This cookbook does not currently support SUSE or openSUSE platforms.

## Architecture Limitations

* Platform support is limited to architectures where the operating system publishes `tftpd-hpa` or `tftp-server`.
* Kitchen and CI coverage use Linux container images and do not validate every architecture published by the package repositories.

## Source/Compiled Installation

This cookbook does not support source builds. Use operating system packages.

## Known Issues

* TFTP listens on UDP port 69. Converging multiple instances on the same host requires custom service and port management outside this resource.
* RHEL-family platforms use the packaged `tftp.socket` systemd socket and a drop-in override for `tftp.service`.

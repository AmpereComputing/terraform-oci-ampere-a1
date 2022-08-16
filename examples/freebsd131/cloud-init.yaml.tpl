#cloud-config

package_update: true
package_upgrade: true

packages:
  - tmux
  - rsync
  - git
  - curl
  - bzip2
  - python3
  - python3-devel
  - python3-pip-wheel
  - gcc
  - gcc-c++
  - bzip2
  - screen

groups:
  - ampere
system_info:
  default_user:
    groups: [ampere]

runcmd:
  - echo 'OCI Ampere FreeBSD Example' >> /etc/motd

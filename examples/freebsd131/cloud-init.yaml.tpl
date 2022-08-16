#cloud-config

package_update: true
package_upgrade: true

packages:
  - tmux
  - rsync
  - git
  - curl
  - bzip2

groups:
  - ampere
system_info:
  default_user:
    groups: [ampere]

runcmd:
  - echo 'OCI Ampere FreeBSD Example' >> /etc/motd

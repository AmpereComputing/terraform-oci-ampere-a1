#cloud-config

package_update: true
package_upgrade: true

packages:
  - tmux
  - rsync
  - git
  - curl
  - bzip2
  - python39
  - lib64python39-devel
  - python-pip
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
  - echo 'OCI Ampere OpenMandriva Example' >> /etc/motd

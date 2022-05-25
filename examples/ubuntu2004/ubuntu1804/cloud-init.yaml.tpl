#cloud-config

package_update: true
package_upgrade: true

packages:
  - screen
  - rsync
  - git
  - curl
  - python2
  - pip
  - ffmpeg
  - parallel
  - bc
  - time
  - htop
  - unzip
  - numactl
  - sysstat

runcmd:
  - echo 'OCI Ampere A1 Ubuntu 18.04 Example' >> /etc/motd

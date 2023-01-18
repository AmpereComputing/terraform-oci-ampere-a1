#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

package_update: true
package_upgrade: true

packages:
  - screen
  - rsync
  - git
  - curl
  - docker-ce
  - docker-ce-cli
  - python3-pip
  - python3-dev
  - python3-selinux
  - python3-setuptools
  - python3-venv
  - libffi-dev
  - gcc
  - libssl-dev

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - pip3 install -U pip
  - pip3 install -U wheel
  - cd /opt && git clone https://github.com/delimitrou/DeathStarBench
  - mkdir /etc/apt/keyrings
  - sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  - echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
  - sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
  - kubeadm init --control-plane-endpoint "ip address of nw i/f “
  - mkdir -p /home/ubuntu/.kube
  - cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  - sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
  - cd /opt && curl https://docs.projectcalico.org/manifests/calico.yaml -O
  - kubectl apply -f /opt/calico.yaml
  - kubectl taint nodes --all node-role.kubernetes.io/master-

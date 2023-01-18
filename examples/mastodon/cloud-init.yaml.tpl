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

write_files:
  - path: /opt/mastodon/docker-compose.yml
    permissions: "0644"
    owner: "ubuntu"
    content: |
      version: '3'
      services:
        db:
          restart: always
          image: postgres:14-alpine
          shm_size: 256mb
          networks:
            - internal_network
          healthcheck:
            test: ['CMD', 'pg_isready', '-U', 'postgres']
          volumes:
            - ./postgres14:/var/lib/postgresql/data
          environment:
            - 'POSTGRES_HOST_AUTH_METHOD=trust'
      
        redis:
          restart: always
          image: redis:7-alpine
          networks:
            - internal_network
          healthcheck:
            test: ['CMD', 'redis-cli', 'ping']
          volumes:
            - ./redis:/data
      
        # es:
        #   restart: always
        #   image: docker.elastic.co/elasticsearch/elasticsearch:7.17.4
        #   environment:
        #     - "ES_JAVA_OPTS=-Xms512m -Xmx512m -Des.enforce.bootstrap.checks=true"
        #     - "xpack.license.self_generated.type=basic"
        #     - "xpack.security.enabled=false"
        #     - "xpack.watcher.enabled=false"
        #     - "xpack.graph.enabled=false"
        #     - "xpack.ml.enabled=false"
        #     - "bootstrap.memory_lock=true"
        #     - "cluster.name=es-mastodon"
        #     - "discovery.type=single-node"
        #     - "thread_pool.write.queue_size=1000"
        #   networks:
        #      - external_network
        #      - internal_network
        #   healthcheck:
        #      test: ["CMD-SHELL", "curl --silent --fail localhost:9200/_cluster/health || exit 1"]
        #   volumes:
        #      - ./elasticsearch:/usr/share/elasticsearch/data
        #   ulimits:
        #     memlock:
        #       soft: -1
        #       hard: -1
        #     nofile:
        #       soft: 65536
        #       hard: 65536
        #   ports:
        #     - '127.0.0.1:9200:9200'
      
        web:
          build: .
          image: tootsuite/mastodon
          restart: always
          env_file: .env.production
          command: bash -c "rm -f /mastodon/tmp/pids/server.pid; bundle exec rails s -p 3000"
          networks:
            - external_network
            - internal_network
          healthcheck:
            # prettier-ignore
            test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:3000/health || exit 1']
          ports:
            - '127.0.0.1:3000:3000'
          depends_on:
            - db
            - redis
            # - es
          volumes:
            - ./public/system:/mastodon/public/system
      
        streaming:
          build: .
          image: tootsuite/mastodon
          restart: always
          env_file: .env.production
          command: node ./streaming
          networks:
            - external_network
            - internal_network
          healthcheck:
            # prettier-ignore
            test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1']
          ports:
            - '127.0.0.1:4000:4000'
          depends_on:
            - db
            - redis
      
        sidekiq:
          build: .
          image: tootsuite/mastodon
          restart: always
          env_file: .env.production
          command: bundle exec sidekiq
          depends_on:
            - db
            - redis
          networks:
            - external_network
            - internal_network
          volumes:
            - ./public/system:/mastodon/public/system
          healthcheck:
            test: ['CMD-SHELL', "ps aux | grep '[s]idekiq\ 6' || false"]
      
        ## Uncomment to enable federation with tor instances along with adding the following ENV variables
        ## http_proxy=http://privoxy:8118
        ## ALLOW_ACCESS_TO_HIDDEN_SERVICE=true
        # tor:
        #   image: sirboops/tor
        #   networks:
        #      - external_network
        #      - internal_network
        #
        # privoxy:
        #   image: sirboops/privoxy
        #   volumes:
        #     - ./priv-config:/opt/config
        #   networks:
        #     - external_network
        #     - internal_network
      
      networks:
        external_network:
        internal_network:
          internal: true

runcmd:
  - pip3 install -U pip
  - pip3 install -U wheel
  - sudo -u ubuntu git clone https://github.com/mastodon/mastodon /home/ubuntu/mastodon
# Uncomment to launch the file we write to /opt/mastedon/docker-compose.yml
# - sudo -u ubuntu docker-compose -f /opt/mastodon/docker-compose.yml up -d
# Launch upstream that we clone from repo
  - sudo -u ubuntu docker-compose -f /home/ubuntu/mastodon/docker-compose.yml up -d
  - echo 'OCI Ampere A1 Mastodon Example' >> /etc/motd


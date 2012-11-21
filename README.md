## DESCRIPTION

Provides LWRP's and service recipes to install and configure
[Sensu](https://github.com/sensu/sensu/wiki), a monitoring framework.

This cookbook provides the building blocks for creating a monitoring
cookbook specific to your environment (wrapper).

An example wrapper cookbook can be found
[HERE](https://github.com/portertech/chef-monitor).

[How to Write Reusable Chef Cookbooks](http://bit.ly/10r993N)

## TESTING

This cookbook comes with a Gemfile, Cheffile, and a Vagrantfile for
testing and evaluating Sensu.

```
cd examples
gem install bundler
bundle install
librarian-chef install
vagrant up
vagrant ssh
```

## COOKBOOK DEPENDENCIES

* [APT](http://community.opscode.com/cookbooks/apt)
* [YUM](http://community.opscode.com/cookbooks/yum)
* [RabbitMQ](http://community.opscode.com/cookbooks/rabbitmq)
* [Redis*](https://github.com/miah/chef-redis)

## REQUIREMENTS

### SSL configuration

Running Sensu with SSL is recommended, this cookbook uses a data bag
`sensu`, with an item `ssl`, containing the SSL certificates required.
This cookbook comes with a tool to generate the certificates and data
bag item.

```
cd examples/ssl
./ssl_certs.sh generate
knife data bag create sensu
knife data bag from file sensu ssl.json
./ssl_certs.sh clean
```

## RECIPES

### sensu::default

Installs Sensu and creates a base configuration file, intended to be
extended. This recipe must be included before any of the Sensu LWRP's
can be used. This recipe does not enable or start any services.

### sensu::rabbitmq

Installs and configures RabbitMQ for Sensu, from configuring SSL to
creating a vhost and credentials. This recipe relies heavily on the
community RabbitMQ cookbook LWRP's.

### sensu::redis

Installs and configures Redis for Sensu.

## ATTRIBUTES

### Installation

`node.sensu.version` - Sensu build to install.

`node.sensu.use_unstable_repo` - If the build resides on the
unstable repository.

`node.sensu.directory` - Sensu configuration directory.

`node.sensu.log_directory` - Sensu log directory.

`node.sensu.use_ssl` - If Sensu and RabbitMQ are to use SSL.

`node.sensu.use_embedded_ruby` - If Sensu Ruby handlers and plugins
are to use the embedded Ruby in the monolithic package.

### RabbitMQ

`node.sensu.rabbitmq.host` - RabbitMQ host.

`node.sensu.rabbitmq.port` - RabbitMQ port, usually for SSL.

`node.sensu.rabbitmq.ssl` - RabbitMQ SSL configuration, DO NOT EDIT THIS.

`node.sensu.rabbitmq.vhost` - RabbitMQ vhost for Sensu.

`node.sensu.rabbitmq.user` - RabbitMQ user for Sensu.

`node.sensu.rabbitmq.password` - RabbitMQ password for Sensu.

### Redis

`node.sensu.redis.host` - Redis host.

`node.sensu.redis.port` - Redis port.

### Sensu API

`node.sensu.api.host` - Sensu API host, for other services to reach it.

`node.sensu.api.port` - Sensu API port.

### Sensu Dashboard

`node.sensu.dashboard.port` - Sensu Dashboard port.

`node.sensu.dashboard.user` - Sensu basic authentication username.

`node.sensu.dashboard.password` - Sensu basic authentication password.

## SUPPORT

Please visit #sensu on irc.freenode.net and we will be more than happy
to help.

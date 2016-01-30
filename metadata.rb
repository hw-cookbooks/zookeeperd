maintainer 'Heavy Water'
maintainer_email 'support@hw-ops.com'
license 'Apache 2.0'

name 'zookeeperd'
version '0.2.8'
description 'Installs and configures Apache Zookeeper'

depends 'apt'
depends 'discovery', '>= 0.2.0'
depends 'java'
depends 'yum'
depends 'runit', '>= 1.0.0'
depends 'dpkg_autostart'

name             'lib-tomcat'
maintainer       'TAMU Libraries'
maintainer_email 'helpdesk@library.tamu.edu'
license          'All rights reserved'
description      'Installs/Configures lib-tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

depends          'ark', '<=1.0.1'
depends          'java', '<=1.39.0'
depends          'lib-task', '0.3.4'
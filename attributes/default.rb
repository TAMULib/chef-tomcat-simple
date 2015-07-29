default['tomcat']['version'] = '7.0.47'
default['tomcat']['url_base'] = 'http://archive.apache.org/dist/tomcat/'
default['tomcat']['port'] = 9000 
default['tomcat']['uid'] = 91
default['tomcat']['gid'] = 91
default['tomcat']['user'] = 'tomcat'
default['tomcat']['group'] = 'tomcat'
default['tomcat']['home'] = '/data/tomcat'
default['tomcat']['bin_prefix'] = '/opt'
default['tomcat']['shell'] = '/sbin/nologin'
default['tomcat']['disabled'] = false
default['tomcat']['X']['ms'] = '1g'
default['tomcat']['X']['mx'] = '2g'
default['tomcat']['XX']['MaxPermSize'] = '256m'
default['tomcat']['linking'] = false
  
default['tomcat']['server']
  
default['tomcat']['log']['catalina_level'] = 'FINE'
default['tomcat']['log']['catalina_size'] = '5M'
default['tomcat']['log']['daily_level'] = 'FINE'
default['tomcat']['log']['daily_limit'] = '2000000'
default['tomcat']['log']['daily_count'] = '5'
default['tomcat']['log']['containerBase_level'] = 'INFO'

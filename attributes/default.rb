default['tomcat']['version'] = '8.0.33'
default['tomcat']['dist']['uri'] = 'http://aptcache.l/files/apache/'
default['tomcat']['dist']['alt_uri'] = 'http://archive.apache.org/dist/'
default['tomcat']['url_base'] = "#{node['tomcat']['dist']['uri']}tomcat/"
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
default['tomcat']['linking'] = false
  
default['tomcat']['server']
  
default['tomcat']['log']['catalina_level'] = 'FINE'
default['tomcat']['log']['daily_level'] = 'FINE'
default['tomcat']['log']['containerBase_level'] = 'INFO'
  
default['tomcat']['cache']['dir'] = 'work'
  
default['tomcat']['manager']['password'] = 'enMnK!v2Y8Qq'

##############
#DEPENDANCIES#
##############
  
default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['oracle']['accept_oracle_download_terms'] = true
  
default['lib-task']['log']['locations'] = ['/opt/tomcat/logs/catalina.out', '/opt/tomcat/logs/*.log']
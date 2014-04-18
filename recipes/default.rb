#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'
include_recipe 'ark'

tomcat = node['tomcat']

url_prefix = 
  'tomcat-' + tomcat['version'].split('.')[0] + '/v' + tomcat['version'] + '/bin/'
tomcat_tar = tomcat['source_prefix'] + tomcat['version'] + tomcat['source_postfix']

src = URI.join(tomcat['url_base'], url_prefix, tomcat_tar).to_s

dest = File.join(tomcat['bin_prefix'], 'tomcat')

log src

directory '/data' do
  owner 'root'
  group 'root'
  mode 0755
end

group tomcat['group'] do
  system true
  gid tomcat['gid']
end

user tomcat['user'] do
  comment 'Apache Tomcat'
  gid tomcat['gid']
  home tomcat['home']
  shell '/sbin/nologin'
  supports :manage_home => true
  system true
  uid tomcat['uid']
end

ark 'tomcat' do
  url src
  version tomcat['version']
  path tomcat['bin_prefix']
  owner tomcat['user']
  group tomcat['group']
  action :put
end

%w(conf logs temp webapps work).each do |dir|
  link "#{tomcat['home']}/#{dir}" do
    owner tomcat['user']
    group tomcat['group']
    to File.join(dest, dir)
  end
end

template '/etc/init.d/tomcat' do
  source 'tomcat.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    :binhome => File.join(tomcat['bin_prefix'], 'tomcat'),
    :tomcat_user => tomcat['user'],
    :x => tomcat['X'],
    :xx => tomcat['XX']
  )
end

service 'tomcat' do 
  only_if { not node['tomcat']['disabled'] }
  action [:start, :enable]
  supports :restart => true, :status => true
end

template "#{tomcat['home']}/conf/server.xml" do
  only_if { not node['tomcat']['disabled'] }
  source "server.xml.erb"
  owner tomcat['user']
  group tomcat['group']
  mode 0644
  variables(
    :port => tomcat['port']
  )
  notifies :restart, 'service[tomcat]', :delayed
end

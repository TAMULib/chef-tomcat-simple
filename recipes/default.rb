#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, LibTask::Helper)

include_recipe 'java'
include_recipe 'ark'
include_recipe 'lib-task::logrotate'

java = node['java']
tomcat = node['tomcat']

url_prefix = 'tomcat-' + tomcat['version'].split('.')[0] + '/v' + 
  tomcat['version'] + '/bin/'
tomcat_tar = 'apache-tomcat-' + tomcat['version'] + '.tar.gz'
  
# Check Tomcat Distribution
if !(status_ok? URI.join(tomcat['url_base'], url_prefix, tomcat_tar).to_s)
  node.override['tomcat']['url_base'] = "#{node['tomcat']['dist']['alt_uri']}tomcat/"
  log 'message' do
    message 'TESTING TOMCAT'
    level :error
  end
end
  
src = URI.join(tomcat['url_base'], url_prefix, tomcat_tar).to_s

dest = File.join(tomcat['bin_prefix'], 'tomcat')

log src

ruby_block "set-init" do
  block do
    node.default['tomcat']['init'] = true
  end
  action :nothing
end

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
  retries 3
  notifies :run, "ruby_block[set-init]", :immediately
end

directory File.join(dest, tomcat['cache']['dir']) do
  only_if { node['tomcat']['cache']['mount'] }
    recursive true
    action :delete
  not_if { File.symlink?(File.join(dest, tomcat['cache']['dir'])) }
end

link File.join(dest, tomcat['cache']['dir']) do
  only_if { node['tomcat']['cache']['mount'] }
    owner tomcat['user']
    group tomcat['group']
    to node['tomcat']['cache']['mount']
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
    :java_home => java['java_home'],
    :tomcat_user => tomcat['user'],
    :tomcat_home => dest,
    :x => tomcat['X'],
    :xx => tomcat['XX']
  )
end

template "#{tomcat['home']}/conf/server.xml" do
  only_if { not node['tomcat']['disabled'] }
  source "server.xml.erb"
  owner tomcat['user']
  group tomcat['group']
  mode 0644
  variables(
    :port => tomcat['port'],
    :server => tomcat['server']
  )
end

template "#{tomcat['home']}/conf/context.xml" do
  only_if { not node['tomcat']['disabled'] }
  source "context.xml.erb"
  owner tomcat['user']
  group tomcat['group']
  mode 0644
  variables(
    :linking => tomcat['linking']
  )
end

template "#{tomcat['home']}/conf/logging.properties" do
  only_if { not node['tomcat']['disabled'] }
  source "logging.properties.erb"
  owner tomcat['user']
  group tomcat['group']
  mode 0644
  variables(
    :log => tomcat['log']
  )
end

template "#{tomcat['home']}/conf/tomcat-users.xml" do
  only_if { not node['tomcat']['disabled'] }
  source "tomcat-users.xml.erb"
  owner tomcat['user']
  group tomcat['group']
  mode 0644
  variables(
    :manager => tomcat['manager']
  )
end

service 'tomcat' do 
  only_if { not node['tomcat']['disabled'] and not node['tomcat']['service_disabled'] }
  action :enable
  supports :restart => true, :status => true
  subscribes :restart, "template[#{tomcat['home']}/conf/server.xml]", :delayed
end


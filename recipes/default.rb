#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

tomcat = node['tomcat']
src = "#{tomcat['source_prefix']}#{tomcat['version']}#{tomcat['source_postfix']}"
extract = "#{tomcat['binhome']}/#{tomcat['source_prefix']}#{tomcat['version']}"

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


remote_file "/tmp/#{src}" do
  source "#{tomcat['source_url']}#{src}" 
  mode 0644
  checksum tomcat['source_checksum']
end

directory tomcat['binhome'] do
  user tomcat['user']
  group tomcat['group']
  mode 0755
end

execute "extract-tomcat" do
  user "tomcat"
  group "tomcat"
  command "tar -C #{tomcat['binhome']} -#{tomcat['extract']} -f /tmp/#{src}"
  creates extract
end

link "#{tomcat['binhome']}/current" do
  owner tomcat['user']
  group tomcat['group']
  to extract
end

%w(conf logs temp webapps work).each do |dir|
  link "#{tomcat['home']}/#{dir}" do
    owner tomcat['user']
    group tomcat['group']
    to "#{tomcat['binhome']}/current/#{dir}"
  end
end

template '/etc/init.d/tomcat' do
  source 'tomcat.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    :binhome => tomcat['binhome'],
    :tomcat_user => tomcat['user'],
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
    :port => tomcat['port'],
  )
  notifies :restart, 'service[tomcat]', :delayed
end

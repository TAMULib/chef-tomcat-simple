#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/data" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

tarball = "apache-tomcat-7.0.47.tar.gz"

remote_file "/tmp/#{tarball}" do
  source "http://apache.osuosl.org/tomcat/tomcat-7/v7.0.47/bin/#{tarball}"
  mode "0644"
  checksum "efbae77efad579b655ae175754cad3df"
end

execute "tar tomcat" do
  user "root"
  group "root"

  installation_dir = "/data"
  cwd installation_dir
  command "tar -xzvf /data/#{tarball}"
  creates installation_dir + "/tomcat"
  action :run
end

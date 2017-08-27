# -*- coding: utf-8 -*-
#
# Cookbook Name:: cnapp
# Attributes:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
override['java']['jdk_version'] = '7'
default[:cnapp][:manager_balancer]='cnappbalancer'

default[:cnapp][:httpd_mod_cluster_url]='http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz'
default[:cnapp][:tomcat_mod_cluster_url]='http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-parent-1.3.1.Final-bin.tar.gz'

default[:cnapp][:prevayler_url]='http://repo1.maven.org/maven2/org/prevayler/prevayler-core/2.6/prevayler-core-2.6.jar'
default[:cnapp][:static_content_url]='https://s3.amazonaws.com/infra-assessment/static.zip'
default[:cnapp][:companynews_app_url]='https://s3.amazonaws.com/infra-assessment/companyNews.war'

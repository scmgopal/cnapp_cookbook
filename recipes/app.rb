include_recipe 'java'

tomcat_install 'cnapp' do
  version '7.0.81'
end

execute "restart_tomcat" do                                                                    
  cwd '/opt/tomcat_cnapp/bin'
  command './shutdown.sh ; sleep 5 ; ./startup.sh'
  action :nothing                                                                                                                    
end

directory '/tmp/temp_tomcat' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file 'download_mod_cluster_tomcat' do
  path '/tmp/temp_tomcat/mod_cluster-parent-1.3.1.Final-bin.tar.gz'
  source node[:cnapp][:tomcat_mod_cluster_url]
  notifies :run, 'execute[extract_mod_cluster_tomcat]'
  not_if { ::File.exist?('/opt/tomcat_cnapp/lib/mod_cluster-container-tomcat7-1.3.1.Final.jar') }
end

execute "extract_mod_cluster_tomcat" do                                                                    
  cwd '/tmp/temp_tomcat'
  command 'tar zxvf /tmp/temp_tomcat/mod_cluster-parent-1.3.1.Final-bin.tar.gz -C .'
  action :run                                                                                                                    
end                                                                                   

execute "copy_mod_cluster_tomcat" do
  cwd '/tmp/temp_tomcat/JBossWeb-Tomcat/lib'
  command "rm -f mod_cluster-container-tomcat6-1.3.1.Final.jar mod_cluster-container-tomcat8-1.3.1.Final.jar ; wget #{node[:cnapp][:prevayler_url]}; cp * /opt/tomcat_cnapp/lib/. ; chown -R tomcat_cnapp:tomcat_cnapp /opt/tomcat_cnapp/"
  not_if { ::File.exist?('/opt/tomcat_cnapp/lib/mod_cluster-container-tomcat7-1.3.1.Final.jar') }
  action :run
end

template '/opt/tomcat_cnapp/conf/server.xml' do
   source 'server.xml.erb'
end

remote_file 'Deploy companyNEws Application' do
  path '/opt/tomcat_cnapp/webapps/companyNews.war'
  source node[:cnapp][:companynews_app_url]
  notifies :run, 'execute[restart_tomcat]'
end

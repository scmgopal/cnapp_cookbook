httpd_service 'default' do
  action [:create]
end

service 'httpd' do
  action :nothing
end

package %w(unzip vim net-tools)  do
  action :install
end

service 'firewalld' do
  action :stop
end

remote_file 'download_mod_cluster_httpd' do
  path '/tmp/mod_cluster-1.2.6.Final-linux2-x64-so.tar.gz'
  source node[:cnapp][:httpd_mod_cluster_url]
  notifies :run, 'execute[extract_mod_cluster_httpd]'
  not_if { ::File.exist?('/etc/httpd/modules/mod_cluster.so') }
end

execute "extract_mod_cluster_httpd" do
  cwd '/etc/httpd/modules'
  command 'tar zxvf /tmp/mod_cluster-1.2.6.Final-linux2-x64-so.tar.gz -C .'
  notifies :restart, 'service[httpd]'
  action :run
end
#
# httpd_config 'cnapp_configuration' do
#   source 'cnapp.conf.erb'
#   variables(:manager_balancer_name => node[:cnapp][:manager_balancer])
#   notifies :restart, 'service[httpd]'
#   action :create
# end

template '/etc/httpd/conf.modules.d/cnapp.conf' do
   source 'cnapp.conf.erb'
   variables(:manager_balancer_name => node[:cnapp][:manager_balancer])
   notifies :restart, 'service[httpd]'
end

template '/etc/httpd/conf.modules.d/00-proxy.conf' do
   source '00-proxy.conf.erb'
end

remote_file 'download_static_content' do
  path '/tmp/static.zip'
  source node[:cnapp][:static_content_url]
  notifies :run, 'execute[deploy_static_content]'
end

execute "deploy_static_content" do
  cwd '/var/www/html'
  command 'unzip -o /tmp/static.zip ; mv static/* . ; rm -R static'
  action :run
end

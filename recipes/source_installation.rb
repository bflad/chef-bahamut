
user node['bahamut']['user'] do
  comment "IRC Service Account"
  home node['bahamut']['home_path']
  shell   "/bin/bash"
  system  true
  action  :create 
end

remote_file "#{Chef::Config[:file_cache_path]}/bahamut-#{node['confluence']['version']}.tar.gz" do
  source node['bahamut']['url']
  checksum node['bahamut']['checksum']
  mode "0644"
  action :create_if_missing
end

execute "Extracting Bahamut #{node['bahamut']['version']}" do
  cwd Chef::Config[:file_cache_path]
  user node['bahamut']['user']
  command "tar -zxf bahamut-#{node['bahamut']['version']}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/#{node['bahamut']['version']}"
end

execute "Compiling and Installing Bahamut #{node['bahamut']['version']}" do
  cwd "#{Chef::Config[:file_cache_path]}/#{node['bahamut']['version']}"
  user node['bahamut']['user']
  command "./configure #{node['bahamut']['configure_flags']} && make && make install"
  creates "#{node['bahamut']['install_path']}/ircd"
end

execute "Generating Bahamut Certificate" do
  cwd node['bahamut']['install_path']
  user node['bahamut']['user']
  command "./make-cert.sh"
  creates "#{node['bahamut']['install_path']}/ircd.crt"
end

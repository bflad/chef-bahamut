
default['bahamut']['user']         = "ircd"

default['bahamut']['home_path']    = "/home/#{node['bahamut']['user']}"
default['bahamut']['install_path'] = "#{node['bahamut']['home_path']}/bahamut"
default['bahamut']['configure_flags'] = "--prefix=#{node['bahamut']['install_path']}"

default['bahamut']['version'] = "2.0.5"

default['bahamut']['checksum'] = case node['bahamut']['version']
when "2.0.5"; "cd08765f651dd388ee0303eb355256631e48a9dc7d3aa765c33ab3c5c4814e98"
end
default['bahamut']['url'] = "http://code.dal.net/release/bahamut-#{node['bahamut']['version']}.tar.gz"

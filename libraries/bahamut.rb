
class Chef::Recipe::Bahamut
  def self.settings(node)
    begin
      if Chef::Config[:solo]
        begin
          settings = Chef::DataBagItem.load("ircd","bahamut")['local']
        rescue
          Chef::Log.info("No environment bahamut data bag found")
        end
        begin
          fqdn_settings = Chef::DataBagItem.load("ircd","bahamut")[node['fqdn']]
          settings.merge!(fqdn_settings) if settings
          settings ||= fqdn_settings
        rescue
          Chef::Log.info("No FQDN bahamut data bag itme found")
        end
      else
        begin
          settings = Chef::EncryptedDataBagItem.load("ircd","bahamut")[node.chef_environment]
        rescue
          Chef::Log.info("No environment bahamut encrypted data bag found")
        end
        begin
          fqdn_settings = Chef::EncryptedDataBagItem.load("ircd","bahamut")[node['fqdn']]
          settings.merge!(fqdn_settings) if settings
          settings ||= fqdn_settings
        rescue
          Chef::Log.info("No FQDN bahamut data bag itme found")
        end
      end
    ensure
      settings ||= node['bahamut']
    end

    settings
  end
end

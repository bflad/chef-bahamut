name              "bahamut"
maintainer        "Brian Flad"
maintainer_email  "bflad417@gmail.com"
license           "Apache 2.0"
description       "Installs/Configures Bahamut IRC daemon"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"
recipe            "bahamut", "Installs/configures Bahamut"
recipe            "bahamut::configuration", "Configures Bahamut"
recipe            "bahamut::source_installation", "Compiles and installs Bahamut from source"

%w{ amazon centos redhat scientific ubuntu }.each do |os|
  supports os
end

%w{ build-essential }.each do |cb|
  depends cb
end

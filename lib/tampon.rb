require 'tampon/configuration'
module Tampon
  require 'railtie' if defined?(Rails)

  Configuration.load! Configuration::GLOBAL_CONFIG_FILE if Tampon::Configuration.user_settings?
  Configuration.load! Configuration::PROJECT_CONFIG_FILE if Tampon::Configuration.project_settings?
end

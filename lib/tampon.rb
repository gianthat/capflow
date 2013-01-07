require 'tampon/configuration'
require 'tampon/version'

if defined?(Bundler)
  #Bundler.setup
  #Bundler.require(:default)
end

module Tampon

  if defined?(Rails)
    require 'railtie' 
    Tampon::Version.base_dir = Rails.root
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  Configuration.load! Configuration::PROJECT_CONFIG_FILE if Tampon::Configuration.project_settings?

end

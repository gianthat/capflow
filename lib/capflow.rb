require 'capflow/configuration'
require 'capflow/version'

if defined?(Bundler)
  #Bundler.setup
  #Bundler.require(:default)
end

module Capflow

  if defined?(Rails)
    require 'railtie' 
    Capflow::Version.base_dir = Rails.root
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  Configuration.load! Configuration::PROJECT_CONFIG_FILE if Capflow::Configuration.project_settings?

end

require 'yaml'
module Tampon
  module Configuration

    extend self

    CONFIG_FILE_NAME    = '.tamponrc'
    GLOBAL_CONFIG_FILE  = "#{Dir.home}/#{CONFIG_FILE_NAME}"
    PROJECT_CONFIG_FILE = "#{Dir.pwd}/#{CONFIG_FILE_NAME}" 

    @_config = Hashie::Mash.new
    attr_reader :_config

    def load!(filename, options={})
      settings = Hashie::Mash.new YAML::load_file(filename)
      @_config.deep_merge!(settings)
    end

    def method_missing(name, *args, &block)
      @_config.send(name.to_sym) || fail(NoMethodError, "unknown configuration root #{name}", caller)
    end

    def user_settings?
      File.exists? GLOBAL_CONFIG_FILE
    end

    def project_settings?
      File.exists? PROJECT_CONFIG_FILE
    end

  end
end

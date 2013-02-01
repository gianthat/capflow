require 'yaml'
require 'ablerc'
module Capflow
  module Configuration

    extend self

    CONFIG_FILE_NAME    = '.capflowrc'
    GLOBAL_CONFIG_FILE  = "#{Dir.home}/#{CONFIG_FILE_NAME}"
    PROJECT_CONFIG_FILE = "#{Dir.pwd}/#{CONFIG_FILE_NAME}" 

    attr_reader :_config
    @_ablerc

    def ablerc
      Ablerc
    end

    def load!(filename, options={})
      @_ablerc ||= Ablerc.load! Capflow.root
    end

    def method_missing(name, *args, &block)
      Ablerc.config.send(name.to_sym) || fail(NoMethodError, "unknown configuration root #{name}", caller)
    end

    def user_settings?
      File.exists? GLOBAL_CONFIG_FILE
    end

    def project_settings?
      File.exists? PROJECT_CONFIG_FILE
    end

  end
end

require 'capflow'
require 'versionomy'
require 'rails'
module Capflow
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/capflow.rake"
    end
  end
end

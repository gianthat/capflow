require 'tampon'
require 'rails'
module Tampon
  class Railtie < Rails::Railtie

    rake_tasks do
      load "tasks/tampon.rake"
    end
  end
end

module Tampon
  module Version

    extend self

    attr_accessor :base_dir

    def write_version( options )
      version = Versionomy.create options
      File.open(File.join(Tampon::Version.base_dir, 'VERSION'), 'w') do |file|
        file.write version
      end
      version
    end

    def load_version
      Versionomy.parse File.read(File.join(Tampon::Version.base_dir, 'VERSION'))
    end

    def to_s
      load_version.to_s
    end
  end
end

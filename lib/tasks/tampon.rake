namespace :gitflow do
  desc 'Gitflow setup for use with tampon'
  task :prepare do
     if (`git branch -r --no-color` =~ /develop/).nil?
      #doesn't exist remotely
       puts "Creating Develop Branch"
      `git push origin origin:refs/heads/develop`
      `git fetch origin`
      `git checkout --track -b develop origin/develop`
     else
       if (`git branch --no-color` =~ /develop/).nil?
         puts "Tracking Remote Develop Branch"
         #doesn't exist locally but exists remotely
         `git checkout --track -B develop origin/develop`
       end
     end
    `git flow init -df`
    `git config gitflow.branch.develop "develop"`
    `git config gitflow.branch.master "master"`
    `git config gitflow.prefix.versiontag "v"`
    `git config gitflow.prefix.feature "feature/"`
    `git config gitflow.prefix.release "release/"`
    `git config gitflow.prefix.hotfix "hotfix/"`
    `git config gitflow.prefix.support "support/"`
    
  end

end

namespace :tampon do
  desc "Show available releases"
  task :releases do 
    puts `git tag`.split("\n").compact.collect{|version| Versionomy.parse(version)}.sort.reverse
    exit
  end

  task :configuration do
    puts "Gitflow"
    Tampon::Configuration.ablerc.stub.generate :local
    exit
  end
end

# from https://github.com/technicalpickles/jeweler/blob/master/lib/jeweler/tasks.rb
namespace :version do
  desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH. Also recognizes BUILD, which defaults to nil"
  task :write do
    version = Tampon::Version.write_version( :major => ENV['MAJOR'].to_i, :minor => ENV['MINOR'].to_i, :tiny => ENV['PATCH'].to_i, :build => (ENV['BUILD'] || nil ) )
    $stdout.puts "Updated version: #{version.to_s}"
  end

  namespace :bump do
    desc "Bump the major version by 1"
    task :major => [:version_required, :version] do
      #jeweler.bump_major_version
      $stdout.puts "Updated version: #{jeweler.version}"
    end

    desc "Bump the a minor version by 1"
    task :minor => [:version_required, :version] do
      #jeweler.bump_minor_version
      $stdout.puts "Updated version: #{jeweler.version}"
    end

    desc "Bump the patch version by 1"
    task :patch => [:version_required, :version] do
      #jeweler.bump_patch_version
      $stdout.puts "Updated version: #{jeweler.version}"
    end
  end
end

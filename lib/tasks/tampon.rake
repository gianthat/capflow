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
  end
end

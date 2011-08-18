module Capistrano
  module Helpers
    module TamponHelper
      
        def who
          (`git config user.name` || `whoami`).chomp
        end

        def tags
          `git tag`.split("\n").compact
        end

        def non_release_tags
          tags - releases 
        end

        def current_branch
          branches.select{|b| b =~ /^\*\s/}.first.gsub(/^\*\s/,"")
        end

        def branches
         `git branch --no-color`.split("\n")
        end

        def version_tag_prefix
          `git config gitflow.prefix.versiontag`.split("\n").first
        end

        def releases
          tags.select{|t| t =~ /^#{version_tag_prefix}(\d+)/}
        end

        def latest_release
          releases.sort{|x,y| x.split(version_tag_prefix).last <=> y.split(version_tag_prefix).last}.last
        end

        def available_tags
          Capistrano::CLI.ui.say "Available Tags:"
          Capistrano::CLI.ui.say "#{non_release_tags.join("\n")}"
        end

        def available_releases
          Capistrano::CLI.ui.say "\nAvailable Releases:"
          Capistrano::CLI.ui.say "#{releases.join("\n")}"
        end

        def deploy_from
          if stage == :production
            Capistrano::CLI.ui.ask "\nRelease to deploy: [#{current_branch}] ".color(:yellow).bright.to_url
          elsif stage == :staging
            Capistrano::CLI.ui.ask "\nTag or release to deploy (make sure to push the tag/release first): [#{current_branch}] ".color(:yellow).bright.to_url
          end
        end



    end
  end
end

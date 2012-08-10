require 'capistrano'
require 'capistrano/helpers/tampon_helper'
require 'versionomy'
require 'stringex'

module Capistrano
  class Tampon
    trap("SIGINT") { puts "Leaving Tampon!".color(:red); exit }
    # I gave up for now, since namespace can't call include
 #   include Capistrano::Helpers::TamponHelper
    def self.load_into(capistrano_configuration)

      capistrano_configuration.load do
        before "deploy:update_code", "tampon:calculate_tag"
        before "tampon:calculate_tag", "tampon:verify_up_to_date"

        namespace :tampon do
              
        def who
          identity = (`git config user.name` || `whoami`)
          identity.chomp.to_url
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
          tags.select{|t| t =~ /^#{version_tag_prefix}(\d+)/}.collect{|version| Versionomy.parse(version) }.sort
        end

        def latest_release
          releases.reverse.first.to_s
        end

        def available_tags
          Capistrano::CLI.ui.say "Available Tags:"
          Capistrano::CLI.ui.say "#{non_release_tags.join("\n")}"
        end

        def available_releases
          Capistrano::CLI.ui.say "\nAvailable Releases:".color :green
          Capistrano::CLI.ui.say "#{releases.sort.reverse.join("\n")}"
        end

        def banner

          <<-BANNER
\nTampon for Gitflow
  ,-------------.
 (o) _ __ _____  )--.
  `-------------'    )
                    (     /
                     `---'
          BANNER
        end



          def deploy_from
            puts banner
            if stage == :production
              available_releases
              from_destination = Capistrano::CLI.ui.ask("\nRelease to deploy:".color(:yellow).bright) do |q|
                q.default = latest_release
              end
            else
              create_tag = Capistrano::CLI.ui.agree("Do you want to tag deployment? [y/N]".color(:yellow)) do |q|
                q.default = 'N'
              end
              return next_tag if create_tag
              available_tags
              from_destination = Capistrano::CLI.ui.ask "\nBranch, tag or release to deploy:".color(:yellow).bright do |q|
                q.default = current_branch
              end
            end
            return from_destination
          end

          def next_tag
            hwhen   = Date.today.to_s
            what = Capistrano::CLI.ui.ask("What does this release introduce? (this will be normalized and used in the tag for this release)".color(:yellow)).to_url
            new_staging_tag = "#{hwhen}-#{who}-#{what}"
            puts "Tagging current branch for deployment to staging as '#{new_staging_tag}'".color(:green)
            system "git tag -a -m 'tagging current code for deployment to staging' #{new_staging_tag}"
            return new_staging_tag
          end

          def using_git?
            fetch(:scm, :git).to_sym == :git
          end

          task :verify_up_to_date do
            if using_git?
              set :local_branch, `git branch --no-color 2> /dev/null | sed -e '/^[^*]/d'`.gsub(/\* /, '').chomp
              set :local_sha, `git log --pretty=format:%H HEAD -1`.chomp
              set :origin_sha, `git log --pretty=format:%H #{local_branch} -1`
              unless local_sha == origin_sha
                abort """
Your #{local_branch} branch is not up to date with origin/#{local_branch}.
Please make sure you have pulled and pushed all code before deploying:

    git pull origin #{local_branch}
    # run tests, etc
    git push origin #{local_branch}

    """
              end
            end
          end

          desc "Calculate the tag to deploy"
          task :calculate_tag do
            if using_git?
              # make sure we have any other deployment tags that have been pushed by others so our auto-increment code doesn't create conflicting tags
              `git fetch`
              if stage == :production
                  tag_production
              else
                  tag_staging
              end


                system "git push --tags origin #{local_branch}"
                if $? != 0
                  abort "git push failed"
                end

            end
          end

          desc "Mark the current code as a staging/qa release"
          task :tag_staging do
            #current_sha = `git log --pretty=format:%H HEAD -1`
            #last_staging_tag_sha = if last_staging_tag
             #                        `git log --pretty=format:%H #{last_staging_tag} -1`
              #                     end

            #if last_staging_tag_sha == current_sha
            #  puts "Not re-tagging staging because latest tag (#{last_staging_tag}) already points to HEAD"
            #  new_staging_tag = last_staging_tag
            #else
            #
            staging_destination = deploy_from

            #end

            set :branch, staging_destination
          end

          desc "Push the approved tag to production. Pass in tag to deploy with '-s tag=staging-YYYY-MM-DD-X-feature'."
          task :tag_production do

            production_destination = deploy_from

             really_deploy = Capistrano::CLI.ui.ask("Do you really want to deploy #{production_destination}? [y/N]").to_url

             exit(1) unless really_deploy =~ /^[Yy]$/

            set :branch, production_destination
          end
        end

        namespace :deploy do
          namespace :pending do
            task :compare do
              #gitflow.commit_log
            end
          end
        end

      end

    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Tampon.load_into(Capistrano::Configuration.instance)
end

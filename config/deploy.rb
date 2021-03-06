require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"

require 'bundler/capistrano'
load 'deploy/assets'

require 'capistrano/ext/multistage'
set :stages, %w(production development)
set :default_stage, "development"

set :application, "ada"
set :repository,  "git@github.com:wids-eria/ada.git"
set :scm, :git

set :user, :deploy
ssh_options[:forward_agent] = true

set :deploy_to, "/home/deploy/applications/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :normalize_asset_timestamps, false


# CALLBACKS #########

after 'deploy:finalize_update', 'deploy:symlink_db'
after 'deploy:finalize_update', 'deploy:symlink_unity_crossdomain'
after 'deploy:finalize_update', 'deploy:symlink_external_site_config'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  desc "Symlink crossdomain.xml"
  task :symlink_unity_crossdomain do
    run "ln -nfs #{deploy_to}/shared/config/crossdomain.xml #{release_path}/public/crossdomain.xml"
  end

  desc "Symlink external site config"
  task :symlink_external_site_config do
    run "ln -nfs #{deploy_to}/shared/config/initializers/external_hosts.rb #{release_path}/config/initializers/external_hosts.rb"
  end


  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end
end

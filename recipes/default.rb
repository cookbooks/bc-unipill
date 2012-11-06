#
# Cookbook Name:: unipill
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pid_file = "#{node.betterplace.app.folder}/shared/bluepill/var/pids/unicorn/#{node.unicorn.pid}"

template "#{node.betterplace.app.folder}/shared/config/unicorn.rb" do
  source 'unicorn/unicorn.rb.erb'
  owner              node.betterplace.user.runner
  group              node.betterplace.user.runner
  variables(
    :listen => { node.unicorn.port => node.unicorn.options, "'#{node.betterplace.app.folder}/shared/run/#{node.unicorn.socket.file}'" => node.unicorn.socket.options },
    :working_directory => "#{node.betterplace.app.folder}/current",
    :bundle_gemfile   => "#{node.betterplace.app.folder}/current/Gemfile",
    :worker_timeout   =>   node.unicorn.worker_timeout,
    :gem_home         =>   node.unicorn.gem_home,
    :worker_processes =>   node.unicorn.worker_processes,
    :logger           =>   "#{node.betterplace.app.folder}/shared/#{node.unicorn.logger}",
    :stderr_path      =>   "#{node.betterplace.app.folder}/shared/#{node.unicorn.stderr_path}",
    :stdout_path      =>   "#{node.betterplace.app.folder}/shared/#{node.unicorn.stdout_path}",
    :pid              =>   pid_file,
    :process_name     =>   node.unicorn.process_name
  )
end

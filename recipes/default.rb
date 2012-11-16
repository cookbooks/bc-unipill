#
# Cookbook Name:: unipill
# Recipe:: default
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

pid_folder = "#{node.unipill.shared}/pids"

directory pid_folder do
  owner node.unipill.user
  group node.unipill.group
  recursive true
  mode '0775'
end

%w(config log run).each do |subdir|
  directory "#{node.unipill.shared}/#{subdir}" do
    owner node.unipill.user
    group node.unipill.group
    recursive true
    mode '0775'
    not_if "test -d \"#{node.unipill.shared}/#{subdir}\""
  end
end

pid_file = "#{pid_folder}/unicorn.pid"

template "#{node.unipill.shared}/config/unicorn.rb" do
  source 'unicorn.rb.erb'
  owner node.unipill.user
  group node.unipill.group
  mode '0664'
  variables(
    :listen => { node.unipill.port => node.unipill.options, "'#{node.unipill.shared}/run/unicorn.socket'" => node.unipill.socket.options },
    :working_directory => node.unipill.rails_root,
    :bundle_gemfile   => "#{node.unipill.rails_root}/Gemfile",
    :worker_timeout   =>   node.unipill.worker_timeout,
    :worker_processes =>   node.unipill.worker_processes,
    :stderr_path      =>   "#{node.unipill.shared}/log/stderr.log",
    :stdout_path      =>   "#{node.unipill.shared}/log/stdout.log",
    :pid              =>   pid_file
  )
end

directory node.unipill.bluepill_root do
  owner node.unipill.user
  group node.unipill.group
  recursive true
  mode '0775'
end

template "#{node.unipill.bluepill_root}/Gemfile" do
  source 'bluepill/Gemfile.erb'
  owner node.unipill.user
  group node.unipill.group
  mode '0664'
end

directory "#{node.unipill.bluepill_root}/pills" do
  owner node.unipill.user
  group node.unipill.group
  recursive true
  mode '0775'
end

%w(resque_scheduler resque_workers unicorn).each do |pill_name|
  template "#{node.unipill.bluepill_root}/pills/#{pill_name}.pill" do
    source "bluepill/pills/#{pill_name}.pill.erb"
    owner node.unipill.user
    group node.unipill.group
    mode '0664'
    variables(:bluepill_base => "#{node.unipill.shared}/bluepill/var",
              :rails_root => node.unipill.rails_root,
              :rails_env => node.unipill.rails_env,
              :log_file => "#{node.unipill.shared}/bluepill/log/#{pill_name}.log",
              :pid_file => "#{node.unipill.shared}/pids/#{pill_name}.pid",
              :bin_path => "#{node.unipill.bin_root}/bin")
  end
end

execute "cd '#{node.unipill.bluepill_root}' ; PATH=#{node.unipill.bin_paths.join(':')} bundle install"

directory "#{node.unipill.bin_root}/bin" do
  owner 'root'
  group 'root'
  recursive true
  mode '0775'
  not_if "test -d \"#{node.unipill.bin_root}/bin\""
end

env_file = "#{node.unipill.bin_root}/bin/ruby_env"

template env_file do
  source 'bpill.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables :bin_paths => node.unipill.bin_paths,
            :gem_paths => node.unipill.gem_paths,
            :ruby_version => node.unipill.ruby_version,
            :rails_env => node.unipill.rails_env,
            :rails_root => node.unipill.rails_root
end

template "#{node.unipill.bin_root}/bin/bpill" do
  source 'bpill.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables :bluepill_log => "#{node.unipill.shared}/bluepill/log/",
            :bluepill_base => "#{node.unipill.shared}/bluepill/var",
            :bluepill_path => node.unipill.bluepill_root,
            :env_file => env_file
end

template "#{node.unipill.bin_root}/bin/process_killer" do
  source 'process_killer.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
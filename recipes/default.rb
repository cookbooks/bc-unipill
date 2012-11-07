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

unicorn_pid_folder = "#{node.unipill.shared}/pids/unicorn"

directory unicorn_pid_folder do
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

pid_file = "#{unicorn_pid_folder}/unicorn.pid"

template "#{node.unipill.shared}/config/unicorn.rb" do
  source 'unicorn.rb.erb'
  owner node.unipill.user
  group node.unipill.group
  variables(
    :listen => { node.unipill.port => node.unipill.options, "'#{node.unipill.shared}/run/unicorn.socket'" => node.unipill.socket.options },
    :working_directory => node.unipill.rails_root,
    :bundle_gemfile   => "#{node.unipill.rails_root}/Gemfile",
    :worker_timeout   =>   node.unipill.worker_timeout,
    :worker_processes =>   node.unipill.worker_processes,
    :stderr_path      =>   "#{node.unipill.shared}/stderr.log",
    :stdout_path      =>   "#{node.unipill.shared}/stdout.log",
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
  end
end

execute "cd '#{node.unipill.bluepill_root}' ; #{node.unipill.ruby_path}/bundle install"

directory "#{node.unipill.bin_root}/bin" do
  owner 'root'
  group 'root'
  recursive true
  mode '0775'
  not_if "test -d \"#{node.unipill.bin_root}/bin\""
end

template "#{node.unipill.bin_root}/bin/bpill" do
  source 'bpill.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables :ruby_path => node.unipill.ruby_path, :bluepill_path => node.unipill.bluepill_root
end
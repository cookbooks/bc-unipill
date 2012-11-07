default.unipill.rails_root = '/var/apps/unipill/current'
default.unipill.shared = '/var/apps/unipill/shared'
default.unipill.user = 'root'
default.unipill.group = 'root'
default.unipill.bin_root = '/opt/local'
default.unipill.bluepill_root = '/opt/local/bluepill'
default.unipill.ruby_path = '/opt/chef/embedded/bin'

# Unicorn settings
default.unipill.worker_timeout = 180
default.unipill.worker_processes = 4
default.unipill.port = 8499
default.unipill.gem_home = nil
default.unipill.options = ":tcp_nodelay => true, :backlog => 4096"
default.unipill.socket.options = ":backlog => 64"


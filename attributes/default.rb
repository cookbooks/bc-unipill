default.unipill.rails_root = '/var/apps/unipill/current'
default.unipill.shared = '/var/apps/shared'
default.unipill.user = 'root'
default.unipill.group = 'root'

# Unicorn default options
default.unipill.worker_timeout = 180
default.unipill.worker_processes = 4
default.unipill.port = 8499
default.unipill.gem_home = nil
default.unipill.stderr_path = 'log/stderr.log'
default.unipill.stdout_path = 'log/stdout.log'
default.unipill.logger = 'log/unicorn.log'
default.unipill.pid = 'unicorn.pid'
default.unipill.process_name = 'unicorn'
default.unipill.options = ":tcp_nodelay => true, :backlog => 4096"
default.unipill.socket.file = "unicorn.socket"
default.unipill.socket.options = ":backlog => 64"
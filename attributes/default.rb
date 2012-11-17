default.unipill.rails_root = '/var/apps/unipill/current'
default.unipill.rails_env = 'production'
default.unipill.shared = '/var/apps/unipill/shared'
default.unipill.user = 'root'
default.unipill.group = 'root'
default.unipill.bin_root = '/opt/local'
default.unipill.bluepill_root = '/opt/local/bluepill'
default.unipill.bin_paths = ["/opt/local/bin", '/opt/chef/embedded/bin']
default.unipill.gem_paths = ["/opt/chef/embedded/lib/ruby/gems/1.9.1", "/opt/chef/embedded/lib/ruby/gems/1.9.1/@global"]
default.unipill.ruby_version = '1.9.3'

# Unicorn settings
default.unipill.worker_timeout = 180
default.unipill.worker_processes = 4
default.unipill.port = 8499
default.unipill.gem_home = nil
default.unipill.options = ":tcp_nodelay => true, :backlog => 4096"
default.unipill.socket.options = ":backlog => 64"

# Pill options
default.unipill.pill_options.unicorn.gc_settings = "RUBY_HEAP_MIN_SLOTS=1300000 RUBY_HEAP_SLOTS_INCREMENT=80000 RUBY_HEAP_SLOTS_GROWTH_FACTOR=1.2 RUBY_GC_MALLOC_LIMIT=80000000 RUBY_HEAP_FREE_MIN=4096"
default.unipill.pill_options.resque_workers.num_workers = 2
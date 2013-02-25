Gem::Specification.new {|s|
	s.name         = 'thread'
	s.version      = '0.0.2'
	s.author       = 'meh.'
	s.email        = 'meh@schizofreni.co'
	s.homepage     = 'http://github.com/meh/ruby-thread'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Various extensions to the base thread stdlib.'
	s.description  = 'Includes a thread pool, message passing capabilities, a recursive mutex, promise and future.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']
}

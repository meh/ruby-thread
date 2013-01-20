Gem::Specification.new {|s|
	s.name         = 'ruby-thread'
	s.version      = '0.0.1'
	s.author       = 'alamoz'
	s.email        = 'adrien_lamothe@yahoo.com'
	s.homepage     = 'http://github.com/alamoz/ruby-thread'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Various extensions to the base thread stdlib.'
	s.description  = 'Includes a thread pool, message passing capabilities and a recursive mutex.'

	s.files = Dir["lib/**/*"] + ["README.md"]
	s.require_paths = ['lib']
}

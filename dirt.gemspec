Gem::Specification.new do |s|
  s.name        = 'dirt'
  s.version     = '1.1.5'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'DCI Framework for Ruby'
  s.description = 'Provides a convenient basis to begin creating DCI style applications. '
  s.authors     = ['Tenjin']
  s.email       = 'contact@tenjin.ca'
  s.homepage    = 'http://www.tenjin.ca'

  s.files       = `git ls-files`.split("\n").reject { |path| path =~ /\.gitignore$|.*\.gemspec$/ }
  s.test_files  = `git ls-files -- spec/*`.split("\n")
end

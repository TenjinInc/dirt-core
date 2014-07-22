Gem::Specification.new do |s|
  s.name         = 'dirt'
  s.version      = '2.2.0'
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = 'DCI Framework for Ruby'
  s.description  = 'Provides a convenient basis to begin creating DCI style applications. '
  s.authors      = ['Tenjin']
  s.email        = 'contact@tenjin.ca'
  s.homepage     = 'http://www.tenjin.ca'

  s.files        = `git ls-files`.split("\n").reject { |path| path =~ /\.gitignore$|.*\.gemspec$/ }

  s.required_ruby_version = ">= 1.9.3"
  s.add_dependency 'activesupport', '>= 3.2'
end

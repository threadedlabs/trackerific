# encoding: utf-8 -*-

require File.expand_path('../lib/trackerific/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = %q{trackerific}
  gem.version = Trackerific::VERSION

  gem.authors = ["Travis Haynes"]
  gem.date = Time.now.strftime('%Y-%m-%d')
  gem.description = %q{Package tracking made easy for Rails. Currently supported services include FedEx, UPS, and USPS.}
  gem.email = %q{travis.j.haynes@gmail.com}
  gem.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.homepage = %q{http://github.com/travishaynes/trackerific}
  gem.licenses = ["MIT"]
  gem.require_paths = ["lib"]
  gem.summary = %q{Trackerific provides package tracking.}

  gem.add_dependency 'httparty'
  gem.add_dependency 'builder'
  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_dependency 'i18n'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'ruby-debug19'
  gem.add_development_dependency 'yardstick'
end

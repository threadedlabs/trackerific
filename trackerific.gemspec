# encoding: utf-8 -*-

require File.expand_path('../lib/trackerific/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = %q{trackerific}
  gem.version = Trackerific::VERSION

  gem.authors = ["Adam Hawkins"]
  gem.email = %q{me@broadcastingadam.com}

  gem.date = Time.now.strftime('%Y-%m-%d')
  gem.description = %q{No nonense package tracking for Ruby. UPS, Fedex, USPS and more supported}
  gem.summary = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.homepage = %q{http://github.com/threadedlabs/trackerific}

  gem.licenses = ["MIT"]
  gem.require_paths = ["lib"]

  gem.add_dependency 'httparty'
  gem.add_dependency 'builder'
  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_dependency 'i18n'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'mechanize'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end

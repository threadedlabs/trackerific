#!/usr/bin/env rake
require "bundler/gem_tasks"

# measure coverage
require 'yardstick/rake/measurement'

Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = 'measurement/report.txt'
end

# verify coverage
require 'yardstick/rake/verify'

Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
  spec.rspec_opts = ['-c']
end

task :default => :spec

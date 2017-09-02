$:.unshift File.expand_path('../lib', __FILE__)
require 'ascii_charts/version'

Gem::Specification.new do |s|
  s.name = 'ascii-charts'
  s.version = AsciiCharts::VERSION

  s.authors = ['Ben Lund']
  s.description = 'Library to draw simple ASCII charts (x,y graph plots and histograms)'
  s.summary = 'Very simple API, your data may already in the correct format to be plotted. Dynamically scales the y-axis. Simple configuration options, including chart title.'
  s.email = 'ben@benlund.com'
  s.homepage = 'http://github.com/benlund/ascii_charts'
  s.licenses = ['MIT']

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end

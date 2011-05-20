# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib', __FILE__)
require 'ascii_charts'

Gem::Specification.new do |s|
  s.name = 'ascii_charts'
  s.version = AsciiCharts::VERSION

  s.authors = ['Ben Lund']  
  s.description = 'Library to draw simple ASCII charts (x,y graph plots and histograms)'
  s.summary = 'Very simple API, your data may already in the correct format to be plotted. Dynamically scales the y-axis. Simple configuration options, including chart title.'
  s.email = 'ben@benlund.com'
  s.homepage = 'http://github.com/benlund/ascii_charts'

  s.files = ['lib/ascii_charts.rb']
end

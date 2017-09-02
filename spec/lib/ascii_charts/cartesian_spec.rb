require 'spec_helper'

describe AsciiCharts::Cartesian do
  it 'displays a graph of points' do
    xs1 = (1..10)
    ys1 = Array.new(10) { |_| (rand * 12).round }

    xs2 = (1..10)
    ys2 = Array.new(10) { |_| (rand * 12).round }

    graph = AsciiCharts::Cartesian.new(xs1.zip(ys1)).draw

    puts graph
  end
end

require 'spec_helper'

describe AsciiCharts::Cartesian do
  it 'displays a graph of series' do
    xs1 = (1..10).to_a
    ys1 = (1..10).to_a
    ys2 = (1..10).to_a.reverse

    graph = AsciiCharts::Cartesian.new(
      [
        xs1,
        ys1,
        ys2
      ],
      markers: ['👋', '👍', '👌']
    )

    expect(graph.lines.size).to be(15)

    drawing = graph.draw
    expect(drawing).to include('👋')
    expect(drawing).to include('👍')
    expect(drawing).to_not include('👌')
  end
end

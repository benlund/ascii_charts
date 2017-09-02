require 'ascii_charts/chart'

module AsciiCharts
  class Cartesian < Chart

    def lines
      if self.data.size == 0
        return [[' ', self.options[:title], ' ', '|', '+-', ' ']]
      end

      lines = [' ']

      bar_width = self.max_xval_width + 1

      lines << (' ' * self.max_yval_width) + ' ' + self.rounded_data.map{|pair| pair[0].to_s.center(bar_width)}.join('')

      self.y_range.each_with_index do |current_y, i|
        yval = current_y.to_s
        bar = if 0 == i
                '+'
              else
                '|'
              end
        current_line = [(' ' * (self.max_yval_width - yval.length) ) + "#{current_y}#{bar}"]

        self.rounded_data.each do |pair|
          marker = if (0 == i) && options[:hide_zero]
                     '-'
                   else
                     '*'
                   end
          filler = if 0 == i
                     '-'
                   else
                     ' '
                   end
          comparison = if self.options[:bar]
                         current_y <= pair[1]
                       else
                         current_y == pair[1]
                       end
          if comparison
            current_line << marker.center(bar_width, filler)
          else
            current_line << filler * bar_width
          end
        end
        lines << current_line.join('')
        current_y = current_y + self.step_size
      end
      lines << ' '
      if self.options[:title]
        lines << self.options[:title].center(lines[1].length)
      end
      lines << ' '
      lines.reverse
    end

  end
end

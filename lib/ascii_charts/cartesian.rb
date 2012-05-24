require 'ascii_charts/chart'

module AsciiCharts
  class Cartesian < Chart

    def lines
      if self.data.size == 0
        return [[' ', self.options[:title], ' ', '|', '+-', ' ']]
      end

      lines = [' ']

      bar_width = self.max_xval_width + 1

      lines << (' ' * self.max_yval_width) + ' ' + self.rounded_data.map{|point| point[0].to_s.center(bar_width)}.join('')

      self.y_range.each_with_index do |current_y, i|
        yval = current_y.to_s
        bar = if 0 == i
                '+'
              else
                '|'
              end
        current_line = [(' ' * (self.max_yval_width - yval.length) ) + "#{current_y}#{bar}"]

        self.rounded_data.each do |point|
          def marker(series, i)
            if (0 == i) && options[:hide_zero]
              marker = '-'
            else
              if (options[:markers])
                marker = options[:markers][series]

                # unicode characters need to be treated as two-character strings for string.center() to work correctly
                if marker.length > 1
                  marker += if 0 == i
                              '-'
                            else
                              ' '
                            end
                end
              else
                marker = '*'
              end
            end
            marker
          end

          filler = if 0 == i
                     '-'
                   else
                     ' '
                   end

          matching_series = false
          lowest_point = INFINITY
          (1..(point.length - 1)).each do |series|
            if self.options[:bar]
              if current_y <= point[series] && lowest_point > point[series]
                matching_series = series
                lowest_point = point[series]
              end
            else
              if current_y == point[series]
                matching_series = series
              end
            end
          end

          if matching_series
            current_line << marker(matching_series - 1, i).center(bar_width, filler)
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

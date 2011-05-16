module AsciiCharts

  class Chart

    attr_reader :data, :options

    #data is a sorted array of [x, y] pairs

    def initialize(data, options={})
      @data = data
      @options = options
    end

    def lines
      raise "lines must be overridden"
    end

    def draw
      lines.join("\n")
    end

    def to_string
      draw
    end

  end

  class Cartesian < Chart

    def lines
      max_xval_width = 1
      max_yval_width = 1
      max_yval = 0

      lines = [' ']

      self.data.each do |pair|
        if (xw = pair[0].to_s.length) > max_xval_width
          max_xval_width = xw
        end
        if (yw = pair[1].to_s.length) > max_yval_width
          max_yval_width = yw
        end
        if pair[1] > max_yval
          max_yval = pair[1]
        end
      end
      
      bar_width = max_xval_width + 1

      lines << (' ' * max_yval_width) + ' ' + data.map{|pair| pair[0].to_s.center(bar_width)}.join('')

      (0..max_yval).each do |i|
        yval = i.to_s
        bar = if 0 == i
                '+'
              else
                '|'
              end
        current_line = [(' ' * (max_yval_width - yval.length) ) + "#{i}#{bar}"]
        
        self.data.each do |pair|
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
                         i <= pair[1]
                       else
                         i == pair[1]
                       end
          if comparison
            current_line << marker.center(bar_width, filler)
          else
            current_line << filler * bar_width
          end
        end
        lines << current_line.join('')
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

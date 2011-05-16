module AsciiCharts

  class Chart

    attr_reader :options, :data

    DEFAULT_MAX_Y_SPAN = 10

    #data is a sorted array of [x, y] pairs

    def initialize(data, options={})
      @data = data
      @options = options
    end

    def rounded_data
      @rounded_data ||= begin
                          self.prepare
                          self.data.map{|pair| [pair[0], self.round_value(pair[1])]}
                        end
    end

    def prepare
      if !@prepared
        self.scan_data
        self.set_step_size
        @prepared = true
      end
    end

    def set_step_size
      if self.options[:y_step_size]
        @step_size = self.options[:y_step_size]
      else
        max_y_span = self.options[:max_y_span] || DEFAULT_MAX_Y_SPAN
        y_span = (@max_yval - @min_yval).to_f
        if @all_ints
          step_size = 1
          puts "picking new step size"
          while (y_span / step_size) > max_y_span
            step_size = self.next_step_up(step_size)
          end
          @step_size = step_size
        else
          @step_size = self.next_step_down(y_span / max_y_span)
        end
      end
    end

    STEPS = [1, 2, 5]

    def next_step_up(val)
      order = Math.log10(val).floor.to_i
      step = val / (10 ** order)
      next_index = STEPS.index(step) + 1
      if STEPS.size == next_index
        next_index = 0
        order += 1
      end
      STEPS[next_index] * (10 ** order)
    end

    def next_step_down(val)
      order = Math.log10(val).floor.to_i
      step = val / (10 ** order)
      next_index = STEPS.index(step) - 1
      if -1 == next_index
        STEPS.size - 1
        order -= 1
      end
      STEPS[next_index] * (10 ** order)
    end

    def round_value(val)
      remainder = val % @step_size
      if (remainder * 2) >= @step_size
        (val - remainder) + step_size
      else
        val - remainder
      end
    end

    def scan_data
      @max_xval_width = 1
      @max_yval_width = 1
      @max_yval = 0
      @min_yval = 0
      @all_ints = true

      self.data.each do |pair|
        if (xw = pair[0].to_s.length) > @max_xval_width
          @max_xval_width = xw
        end
        if (yw = pair[1].to_s.length) > @max_yval_width
          @max_yval_width = yw
        end
        if pair[1] > @max_yval
          @max_yval = pair[1]
        end
        if pair[1] < @min_yval
          @min_yval = pair[1]
        end
        if @all_ints && !pair[1].is_a?(Integer)
          @all_ints = false
        end
      end
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

      self.prepare ##@@ argh, remove the need for this

      lines = [' ']
      
      bar_width = @max_xval_width + 1

      lines << (' ' * @max_yval_width) + ' ' + self.rounded_data.map{|pair| pair[0].to_s.center(bar_width)}.join('')

      first_y = self.round_value(@min_yval)
      if first_y > @min_yval
        first_y = first_y - @step_size
      end
      last_y = self.round_value(@max_yval)
      if last_y < @max_yval
        last_y = last_y + @step_size
      end
      current_y = first_y
      while current_y <= last_y
        yval = current_y.to_s
        bar = if current_y == first_y
                '+'
              else
                '|'
              end
        current_line = [(' ' * (@max_yval_width - yval.length) ) + "#{current_y}#{bar}"]
        
        self.rounded_data.each do |pair|
          marker = if (current_y == first_y) && options[:hide_zero]
                     '-'
                   else
                     '*'
                   end
          filler = if current_y == first_y
                     '-'
                   else
                     ' '
                   end
          comparison = if self.options[:bar]
                         current_y <= self.round_value(pair[1])
                       else
                         current_y == self.round_value(pair[1])
                       end
          if comparison
            current_line << marker.center(bar_width, filler)
          else
            current_line << filler * bar_width
          end
        end
        lines << current_line.join('')
        current_y = current_y + @step_size
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

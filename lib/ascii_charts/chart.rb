module AsciiCharts
  class Chart

    attr_reader :options, :data

    DEFAULT_MAX_Y_VALS = 20
    DEFAULT_MIN_Y_VALS = 10
    INFINITY = +1.0/0.0

    #data is a sorted array of [x, y] pairs

    def initialize(data, options={})
      if (data[0].length == 2)
        @data = data # treat as array of points
      else
        @data = series_to_points(data) # treat as array of series
      end

      @options = options
    end

    def series_to_points(arr_of_series)
      points = []
      (0..(arr_of_series[0].length - 1)).each do |i|
        point = []
        (0..(arr_of_series.length - 1)).each do |series|
          point.push(arr_of_series[series][i])
        end
        points.push(point)
      end
      points
    end

    def rounded_data
      @rounded_data ||= self.data.map do |point|
        point.each_with_index.map do |coord, i|
          if i == 0
            coord
          else
            round_value(coord)
          end
        end
      end
    end

    def step_size
      if !defined? @step_size
        if self.options[:y_step_size]
          @step_size = self.options[:y_step_size]
        else
          max_y_vals = self.options[:max_y_vals] || DEFAULT_MAX_Y_VALS
          min_y_vals = self.options[:max_y_vals] || DEFAULT_MIN_Y_VALS
          y_span = (self.max_yval - self.min_yval).to_f

          step_size = self.nearest_step( y_span.to_f / (self.data.size + 1) )

          if @all_ints && (step_size < 1)
            step_size = 1
          else
            while (y_span / step_size) < min_y_vals
              candidate_step_size = self.next_step_down(step_size)
              if @all_ints && (candidate_step_size < 1) ## don't go below one
                break
              end
              step_size = candidate_step_size
            end
          end

          #go up if we undershot, or were never over
          while (y_span / step_size) > max_y_vals
            step_size = self.next_step_up(step_size)
          end
          @step_size = step_size
        end
        if !@all_ints && @step_size.is_a?(Integer)
          @step_size = @step_size.to_f
        end
      end
      @step_size
    end

    STEPS = [1, 2, 5]

    def from_step(val)
      if 0 == val
        [0, 0]
      else
        order = Math.log10(val).floor.to_i
        num = (val / (10 ** order))
        [num, order]
      end
    end

    def to_step(num, order)
      s = num * (10 ** order)
      if order < 0
        s.to_f
      else
        s
      end
    end

    def nearest_step(val)
      num, order = self.from_step(val)
      self.to_step(2, order) ##@@
    end

    def next_step_up(val)
      num, order = self.from_step(val)
      next_index = STEPS.index(num.to_i) + 1
      if STEPS.size == next_index
        next_index = 0
        order += 1
      end
      self.to_step(STEPS[next_index], order)
    end

    def next_step_down(val)
      num, order = self.from_step(val)
      next_index = STEPS.index(num.to_i) - 1
      if -1 == next_index
        STEPS.size - 1
        order -= 1
      end
      self.to_step(STEPS[next_index], order)
    end

    #round to nearest step size, making sure we curtail precision to same order of magnitude as the step size to avoid 0.4 + 0.2 = 0.6000000000000001
    def round_value(val)
      remainder = val % self.step_size
      unprecised = if (remainder * 2) >= self.step_size
                     (val - remainder) + self.step_size
                   else
                     val - remainder
                   end
      if self.step_size < 1
        precision = -Math.log10(self.step_size).floor
        (unprecised * (10 ** precision)).to_i.to_f / (10 ** precision)
      else
        unprecised
      end
    end

    def max_yval
      if !defined? @max_yval
        scan_data
      end
      @max_yval
    end

    def min_yval
      if !defined? @min_yval
        scan_data
      end
      @min_yval
    end

    def all_ints
      if !defined? @all_ints
        scan_data
      end
      @all_ints
    end

    def scan_data
      @max_yval = 0
      @min_yval = 0
      @all_ints = true

      @max_xval_width = 1

      self.data.each do |point|
        if (xw = point[0].to_s.length) > @max_xval_width
          @max_xval_width = xw
        end

        point[1..-1].each do |yval|
          if yval > @max_yval
            @max_yval = yval
          end
          if yval < @min_yval
            @min_yval = yval
          end
          if @all_ints && !yval.is_a?(Integer)
            @all_ints = false
          end
        end
      end
    end

    def max_xval_width
      if !defined? @max_xval_width
        scan_data
      end
      @max_xval_width
    end

    def max_yval_width
      if !defined? @max_yval_width
        scan_y_range
      end
      @max_yval_width
    end

    def scan_y_range
      @max_yval_width = 1

      self.y_range.each do |yval|
        if (yw = yval.to_s.length) > @max_yval_width
          @max_yval_width = yw
        end
      end
    end

    def y_range
      if !defined? @y_range
        @y_range = []
        first_y = self.round_value(self.min_yval)
        if first_y > self.min_yval
          first_y = first_y - self.step_size
        end
        last_y = self.round_value(self.max_yval)
        if last_y < self.max_yval
          last_y = last_y + self.step_size
        end
        current_y = first_y
        while current_y <= last_y
          @y_range << current_y
          current_y = self.round_value(current_y + self.step_size) ## to avoid fp arithmetic oddness
        end
      end
      @y_range
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
end

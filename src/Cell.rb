
class Cell
	attr_reader :index, :x,:y, :w,:h

	def initialize args
		@x = args[:x]
		@y = args[:y]
		size = args[:size] || Settings.cells[:size]
		@w = size[:w]
		@h = size[:h]
		@index = {
			x: args[:index][:x],
			y: args[:index][:y]
		}

		@color = Settings.cells[:color]
		@border_color = Settings.cells[:border_color]
		@border_padding = 2

		@bomb_count = 0
		@type = :field
	end

	def to_bomb!
		@type = :bomb
	end

	def is_bomb?
		return @type == :bomb
	end

	def is_field?
		return @type == :field
	end

	def draw
		# Draw border
		Gosu.draw_rect @x,@y, @w,@h, @border_color, 5
		# Draw cell
		Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - @border_padding * 2), (@h - @border_padding * 2), @color, 10
	end
end


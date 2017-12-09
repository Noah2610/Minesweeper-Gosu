
class Cell
	attr_reader :index, :x,:y, :w,:h
	attr_accessor :bomb_count

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

		@font = RES.cell_font
		@font_color_field = Gosu::Color.argb 0xff_0000ff
		@font_color_bomb = Gosu::Color.argb 0xff_ff0000

		@hidden = true
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

	def no_bombs?
		return false  if (is_bomb?)
		return @bomb_count == 0
	end

	def activate!
		return  unless (@hidden)
		@hidden = false
	end

	def draw
		# Draw border
		Gosu.draw_rect @x,@y, @w,@h, @border_color, 5
		# Draw cell
		Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @color, 10

		# Draw bomb_count
		unless (@hidden)
			if (is_field?)
				@font.draw_rel @bomb_count.to_s, (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @font_color_field
			elsif (is_bomb?)
				@font.draw_rel "B", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @font_color_bomb
			end
		end
	end
end


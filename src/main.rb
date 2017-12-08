

class Game < Gosu::Window
	attr_reader :cells

	def initialize
		@bg_color = Gosu::Color.argb 0xff_ffffff

		@grid = Grid.new

		super Settings.screen[:w], Settings.screen[:h]
		self.caption = "Minesweeper!"
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
	end

	def update
	end

	def draw
		# Background
		Gosu.draw_rect 0,0, Settings.screen[:w],Settings.screen[:h], @bg_color, 0

		# Draw Grid
		@grid.draw
	end
end


RES = Resource.new
$game = Game.new
$game.show


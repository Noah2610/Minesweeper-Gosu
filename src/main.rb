

class Game < Gosu::Window
	attr_reader :cells

	def initialize
		@bg_color = Gosu::Color.argb 0xff_ffffff

		@grid = Grid.new

		super Settings.screen[:w] * 2, Settings.screen[:h] * 2
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


$game = Game.new
$game.show


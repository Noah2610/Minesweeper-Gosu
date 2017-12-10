

class Game < Gosu::Window
	attr_reader :cells

	def initialize
		@colors = {
			bg:        Gosu::Color.argb(0xff_ffffff),
			win:       Gosu::Color.argb(0xff_0044ff),
			lose:      Gosu::Color.argb(0xff_ff4400),
			final_bg:  Gosu::Color.argb(0x99_cccccc)
		}

		@has_won = false
		@has_lost = false

		@final_font = Gosu::Font.new 64

		@panel = Panel.new
		panel_size = Settings.panel[:size]
		@grid = Grid.new y: panel_size[:h]

		super Settings.screen[:w], Settings.screen[:h]
		self.caption = "Minesweeper!"
	end

	def win
		@panel.set_smiley :happy
		@has_won = true
	end

	def lose
		@panel.set_smiley :angry
		@has_lost = true
	end

	def button_down id
		close   if (id == Gosu::KB_Q)

		return  if (@has_won || @has_lost)

		controls = Settings.controls
		if (controls[:primary].include? id)
			@grid.click x: mouse_x, y: mouse_y
		elsif (controls[:secondary].include? id)
			@grid.click_alt x: mouse_x, y: mouse_y
		end
	end

	def needs_cursor?
		true
	end

	def update
	end

	def draw
		screen = Settings.screen

		# Background
		Gosu.draw_rect 0,0, screen[:w],screen[:h], @colors[:bg], 0
		# Draw panel
		@panel.draw
		# Draw Grid
		@grid.draw

		if (@has_won || @has_lost)
			# Draw background of text
			Gosu.draw_rect (screen[:w] / 2 - 192), (screen[:h] / 2 - 64), 384,128, @colors[:final_bg], 40
			if (@has_won && !@has_lost)     # WON
				@final_font.draw_rel "You WIN!", (screen[:w] / 2), (screen[:h] / 2), 50, 0.5,0.4, 1,1, @colors[:win]
			# Draw when lost
			elsif (@has_lost && !@has_won)  # LOST
				@final_font.draw_rel "You LOSE!", (screen[:w] / 2), (screen[:h] / 2), 50, 0.5,0.4, 1,1, @colors[:lose]
			end
		end
	end
end


RES = Resource.new
$game = Game.new
$game.show


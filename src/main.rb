

class Game < Gosu::Window
	attr_reader :cells, :panel, :game_running, :has_won, :has_lost

	def initialize
		@colors = {
			bg:        Gosu::Color.argb(0xff_ffffff),
			win:       Gosu::Color.argb(0xff_0044ff),
			lose:      Gosu::Color.argb(0xff_ff4400),
			final_bg:  Gosu::Color.argb(0x99_cccccc)
		}

		@game_running = true
		@has_won = false
		@has_lost = false

		@final_font = Gosu::Font.new 64

		@grid_args = {
			y:     $settings.panel[:size][:h],
			grid:  { x: 16, y: 8 }
		}

		@panel = Panel.new
		@grid = Grid.new @grid_args
		@panel.update_bomb_display bombs: @grid.bomb_count

		super $settings.screen[:w], $settings.screen[:h]
		self.caption = "Minesweeper!"
	end

	def win
		@final_time = @panel.stop_timer
		@panel.set_smiley :happy
		@game_running = false
		@has_won = true
	end

	def lose
		@final_time = @panel.stop_timer
		@panel.set_smiley :angry
		@game_running = false
		@has_lost = true
	end

	def reset
		@game_running = true
		@has_won = false
		@has_lost = false
		@panel.reset
		@grid = Grid.new @grid_args
		@panel.update_bomb_display bombs: @grid.bomb_count
	end

	def button_down id
		close   if (id == Gosu::KB_Q)

		controls = $settings.controls
		if (controls[:primary].include? id)
			@grid.click x: mouse_x, y: mouse_y      if (@game_running)
			@panel.click x: mouse_x, y: mouse_y
		elsif (controls[:secondary].include? id)
			@grid.click_alt x: mouse_x, y: mouse_y  if (@game_running)
			@panel.click x: mouse_x, y: mouse_y
		elsif (controls[:reset].include? id)
			reset
		end
	end

	def needs_cursor?
		true
	end

	def update
		@grid.mouse_pos x: mouse_x, y: mouse_y  if (@game_running)
		@panel.update                           if ($update_counter % 4 == 0)
		$update_counter += 1
	end

	def draw
		screen = $settings.screen

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


$update_counter = 0
RES = Resource.new
$settings = Settings.new
$game = Game.new
$game.show


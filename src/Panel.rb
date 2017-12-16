
class Panel
	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.panel[:size][:w] - @x
		@h = args[:h] || $settings.panel[:size][:h]

		@colors = $settings.panel[:colors]

		@time = nil
		@time_start = nil
		@font = Gosu::Font.new 32
		@font_high = Gosu::Font.new 20
		@font_extra = Gosu::Font.new 16

		@smileys = RES.smiley_images
		@smiley_state = :neutral

		if (@h <= @w)
			@smiley_scale = (@h.to_f * 0.9) / @smileys[:neutral].height.to_f
		elsif (@w < @h)
			@smiley_scale = (@w.to_f * 0.9) / @smileys[:neutral].width.to_f
		end

		@bomb_count = 0
		@flagged_count = 0
	end

	def click pos
		if ((pos[:x] >= @x + (@w / 2) - (@smileys[@smiley_state].width / 2)) &&
			  (pos[:x] <= @x + (@w / 2) + (@smileys[@smiley_state].width / 2)) &&
				(pos[:y] >= @y + (@h / 2) - (@smileys[@smiley_state].height / 2)) &&
				(pos[:y] <= @y + (@h / 2) + (@smileys[@smiley_state].height / 2))
			 )
			$game.reset
		end
	end

	def reset
		set_smiley :neutral
		@time = nil
		@time_start = nil
		@bomb_count = 0
		@flagged_count = 0
	end

	def set_smiley state
		case state
		when :neutral
			@smiley_state = :neutral
		when :happy
			@smiley_state = :happy
		when :angry
			@smiley_state = :angry
		else
			@smiley_state = :neutral
		end
	end

	def start_timer
		@time_start = Time.now
	end

	def stop_timer
		@time_start = nil
		return convert_time(@time)  unless (@time.nil?)
		return "00:00.00"
	end

	def convert_time time
		"#{time.min.to_s.rjust(2,"0")}:#{time.sec.to_s.rjust(2,"0")}.#{time.nsec.to_s[0..1].rjust(2,"0")}"
	end

	def update_bomb_display args
		@bomb_count = args[:bombs]     unless (args[:bombs].nil?)
		@flagged_count = args[:flags]  unless (args[:flags].nil?)
	end

	def update
		@time = Time.at(Time.now - @time_start)  unless (@time_start.nil?)
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @colors[:bg], 5

		# Draw smiley
		@smileys[@smiley_state].draw (@x + (@w / 2) - ((@smileys[@smiley_state].width * @smiley_scale) / 2)), (@y + (@h / 2) - ((@smileys[@smiley_state].height * @smiley_scale) / 2)), 15, @smiley_scale,@smiley_scale

		# Print flagged cells / bomb cell count
		@font.draw_rel "#{@flagged_count} F / #{@bomb_count} B", (@x + 32),(@y + @h / 2),25, 0,0.4, 1,1, @colors[:font]

		# Print time
		unless (@time.nil?)
			color = @colors[:font]
			if    ($game.has_won)
				color = @colors[:font_won]
			elsif ($game.has_lost)
				color = @colors[:font_lost]
			end
			@font.draw_rel convert_time(@time), (@x + @w - 32),(@y + @h / 2),25, 1,($savefile.highscore.nil? ? 0.4 : 0.6), 1,1, color
		else
			@font.draw_rel "00:00.00", (@x + @w - 32),(@y + @h / 2),25, 1,($savefile.highscore.nil? ? 0.4 : 0.6), 1,1, @colors[:font]
		end

		# Print highscore
		unless ($savefile.highscore.nil?)
			@font_high.draw_rel "Highscore: ", (@x + @w - 112),(@y + @h / 2),25, 1,-0.5, 1,1, @colors[:font]
			@font_high.draw_rel $savefile.highscore, (@x + @w - 32),(@y + @h / 2),25, 1,-0.5, 1,1, @colors[:font_high]
		end

		# Display that grid has been resized to fit into screen
		if ($game.grid.adjusted_grid)
			@font_extra.draw_rel "Grid resized to #{$game.grid.grid[:x]}x#{$game.grid.grid[:y]}", (@x + (@w / 4)),(@y + @h / 2),25, 0,0.4, 1,1, @colors[:font]
		else
			@font_extra.draw_rel "#{$game.grid.grid[:x]}x#{$game.grid.grid[:y]}", (@x + (@w / 4)),(@y + @h / 2),25, 0,0.4, 1.25,1.25, @colors[:font]
		end
	end
end


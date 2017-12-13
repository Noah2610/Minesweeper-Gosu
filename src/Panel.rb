
class Panel
	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || $settings.panel[:size][:w] - @x
		@h = args[:h] || $settings.panel[:size][:h] - @y

		@colors = $settings.panel[:colors]

		@time = nil
		@time_start = nil
		@font = Gosu::Font.new 32

		@smileys = RES.smiley_images
		@smiley_state = :neutral

		@smiley_scale = (@h.to_f * 0.9) / @smileys[:neutral].height.to_f
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

	def update
		@time = Time.at(Time.now - @time_start)  unless (@time_start.nil?)
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @colors[:bg], 5

		# Draw smiley
		@smileys[@smiley_state].draw (@x + (@w / 2) - (@smileys[@smiley_state].width / 2)), (@y + (@h / 2) - (@smileys[@smiley_state].height / 2)), 15, @smiley_scale,@smiley_scale

		# Print time
		unless (@time.nil?)
			color = @colors[:font]
			if    ($game.has_won)
				color = @colors[:font_won]
			elsif ($game.has_lost)
				color = @colors[:font_lost]
			end
			@font.draw_rel convert_time(@time), (@w - 32),(@h / 2),25, 1,0.4, 1,1, color
		else
			@font.draw_rel "00:00.00", (@w - 32),(@h / 2),25, 1,0.4, 1,1, @colors[:font]
		end
	end
end


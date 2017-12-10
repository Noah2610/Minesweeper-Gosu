
class Panel
	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || Settings.panel[:size][:w] - @x
		@h = args[:h] || Settings.panel[:size][:h] - @y

		@colors = Settings.panel[:colors]

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

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @colors[:bg], 5

		# Draw smiley
		@smileys[@smiley_state].draw (@x + (@w / 2) - (@smileys[@smiley_state].width / 2)), (@y + (@h / 2) - (@smileys[@smiley_state].height / 2)), 15, @smiley_scale,@smiley_scale
	end
end


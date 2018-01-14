
class Cell
	attr_reader :index, :x,:y, :w,:h
	attr_accessor :bomb_count

	def initialize args
		@x = args[:x]
		@y = args[:y]
		size = args[:size] || $settings.cells[:size]
		@w = size[:w]
		@h = size[:h]
		@index = {
			x: args[:index][:x],
			y: args[:index][:y]
		}

		@colors = $settings.cells[:colors]
		@border_padding = $settings.cells[:border_padding]

		@font = RES.cell_font

		@hidden = true
		@activated = false
		@bomb_count = 0
		@type = :field
		@flagged = false
		@mouse_hovering = false
	end

	def set_pos pos
		@x = pos[:x]    unless (pos[:x].nil?)
		@y = pos[:y]    unless (pos[:y].nil?)
	end

	def add_pos pos
		@x += pos[:x]   unless (pos[:x].nil?)
		@y += pos[:y]   unless (pos[:y].nil?)
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
		return  if (!@hidden && @activated)
		@hidden = false
		@activated = true
	end

	def is_activated?
		return !@hidden
	end

	def flag!
		case @flagged
		when false
			@flagged = true
		when true
			@flagged = false
		end
	end

	def is_flagged?
		return @flagged
	end

	def mouse_hover
		@mouse_hovering = true
	end

	def no_mouse_hover
		@mouse_hovering = false
	end

	def reveal
		@hidden = false
	end

	def draw
		# Draw border
		Gosu.draw_rect @x,@y, @w,@h, @colors[:border], 5

		# Draw bomb_count
		if (@hidden)
			if (is_flagged?)
				# Draw cell bg
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:flagged], 10              unless (@mouse_hovering)
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:flagged_mouse_hover], 10  if (@mouse_hovering)
				@font.draw_rel "?", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_flagged]
			else
				# Draw cell bg
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:hidden], 10               unless (@mouse_hovering)
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:hidden_mouse_hover], 10   if (@mouse_hovering)
			end
		elsif (@activated)               # Activated by player
			if (is_field?)
				# Draw field
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:shown], 10                unless (@mouse_hovering)
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:shown_mouse_hover], 10    if (@mouse_hovering)
				# Bomb count font
				@font.draw_rel @bomb_count.to_s, (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_field]    unless (no_bombs?)
			elsif (is_bomb?)
				# Draw bomb
				Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:bomb_shown], 10
				# Bomb font
				@font.draw_rel "B", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_bomb]
			end
		elsif (!@hidden && !@activated)  # Revealed without player activation (after losing)
			if (is_field?)
				if (is_flagged?)
					# Draw cell bg
					Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:flagged], 10
					@font.draw_rel "X", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_flagged]
					# Bomb count font
					@font.draw_rel @bomb_count.to_s, (@x + (@w / 2)), (@y + (@h / 2)), 16, 0.5,0.4, 1,1, @colors[:font_field]    unless (no_bombs?)
				else
					# Draw cell bg
					Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:hidden], 10
					# Bomb count font
					@font.draw_rel @bomb_count.to_s, (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_field]    unless (no_bombs?)
				end
			elsif (is_bomb?)
				if (is_flagged?)
					# Draw cell bg
					Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:flagged], 10
					@font.draw_rel "?", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_flagged]
				else
					# Draw cell bg
					Gosu.draw_rect (@x + @border_padding), (@y + @border_padding), (@w - (@border_padding * 2)), (@h - (@border_padding * 2)), @colors[:hidden], 10
					# Bomb font
					@font.draw_rel "B", (@x + (@w / 2)), (@y + (@h / 2)), 15, 0.5,0.4, 1,1, @colors[:font_bomb]
				end
			end
		end
	end
end


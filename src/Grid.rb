
class Grid
	def initialize args = {}
		@x = args[:x] || 0
		@y = args[:y] || 0
		@w = args[:w] || Settings.screen[:w] - @x
		@h = args[:h] || Settings.screen[:h] - @y
		@cell_size = args[:cell_size] || Settings.cells[:size]

		@activated_cells = []
		@bomb_count = 0

		@cell_hover = nil

		@cells = gen_cells
		check_adjacent
	end

	def click pos
		cell = find_cell pos: { x: pos[:x], y: pos[:y] }
		return  if (cell.nil? || cell.is_flagged?)
		activate_cell cell
		# Check if all cells are activated - win condition
		if (@activated_cells.size == @cells.flatten.size - @bomb_count)
			$game.win
		end
	end

	def click_alt pos
		cell = find_cell pos: { x: pos[:x], y: pos[:y] }
		return  if (cell.nil? || cell.is_activated?)
		cell.flag!
	end

	def mouse_pos pos
		cell = find_cell pos: { x: pos[:x], y: pos[:y] }
		return  if (cell.nil?)
		if (cell != @cell_hover)
			@cell_hover.no_mouse_hover  unless (@cell_hover.nil?)
			@cell_hover = cell
			@cell_hover.mouse_hover
		end
	end

	def activate_cell cell
		return  if (cell.nil?)
		cell.activate!
		# lose condition
		if (cell.is_bomb?)
			$game.lose
			return
		end
		@activated_cells << cell
		if (cell.no_bombs?)
			get_adjacent_cells(cell).each do |c|
				next  if (@activated_cells.include? c)
				activate_cell c
			end
		end
	end

	def gen_cells
		cells = []

		(@h.to_f / @cell_size[:h].to_f).floor.times do |row|
			cells_row = []
			(@w.to_f / @cell_size[:w].to_f).floor.times do |col|
				cells_row << Cell.new(
					x: (@x + (@cell_size[:w] * col)),
					y: (@y + (@cell_size[:h] * row)),
					index: { x: col, y: row },
					size: { w: @cell_size[:w], h: @cell_size[:h] }
				)
			end
			cells << cells_row
		end

		# Add bombs
		@bomb_count = ((cells.flatten.size.to_f / 100.0) * Settings.cells[:bombs]).round
		@bomb_count.times do |n|
			success = false
			while (!success)
				cell = cells.sample.sample
				unless (cell.is_bomb?)
					cell.to_bomb!
					success = true
				end
			end
		end

		return cells

	end

	def check_adjacent
		@cells.each do |row|
			row.each do |cell|
				next  if (cell.is_bomb?)
				get_adjacent_cells(cell).each do |adj|
					next  if (adj.nil?)
					cell.bomb_count += 1  if (adj.is_bomb?)
				end
			end
		end
	end

	def find_cell args
		# Find by index
		if (args.has_key? :index)
			index = args[:index]
			return nil  if (@cells[index[:y]].nil? || @cells[index[:y]][index[:x]].nil?)
			return @cells[index[:y]][index[:x]]

		# Find by position (x,y) - collision checking
		elsif (args.has_key? :pos)
			pos = args[:pos]
			@cells.each do |row|
				row.each do |cell|
					if ((pos[:x] >= cell.x &&
							 pos[:y] >= cell.y) &&
							(pos[:x] < (cell.x + cell.w) &&
							 pos[:y] < (cell.y + cell.h))
						 )
						return cell
					end
				end
			end
		end
		return nil
	end

	def get_adjacent_cells cell
		cells = []
		[-1,0,1].each do |n1|
			[-1,0,1].each do |n2|
				next  if (
					(n1 == 0 && n2 == 0) ||
					(cell.index[:x] + n2 < 0 || cell.index[:y] + n1 < 0)
				)
				found = find_cell(
					index: {
						x: (cell.index[:x] + n2),
						y: (cell.index[:y] + n1)
					}
				)
				cells << found  unless (cell.nil?)
			end
		end

		return cells
	end

	def draw
		# Draw cells
		@cells.each do |row|
			row.each &:draw
		end
	end
end



class Resource
	def initialize
		@fonts = {
			cells: Gosu::Font.new(24)
		}
	end

	def cell_font
		return @fonts[:cells]
	end
end


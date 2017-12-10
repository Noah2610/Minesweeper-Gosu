
class Resource
	def initialize
		@fonts = {
			cells: Gosu::Font.new(24)
		}
		@images = {
			smiley: {
				neutral:  Gosu::Image.new("./images/smiley_neutral.png", retro: true),
				happy:    Gosu::Image.new("./images/smiley_happy.png", retro: true),
				angry:    Gosu::Image.new("./images/smiley_angry.png", retro: true)
			}
		}
	end

	def cell_font
		return @fonts[:cells]
	end

	def smiley_images
		return @images[:smiley]
	end
end


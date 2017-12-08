
class Settings
	def self.screen
		{
			w: 640,
			h: 480
		}
	end

	def self.cells
		{
			size: {
				w: 32,
				h: 32
			},
			bombs:        20.0,    # in percent
			color:        Gosu::Color.argb(0xff_999999),
			border_color: Gosu::Color.argb(0xff_000000)
		}
	end

end


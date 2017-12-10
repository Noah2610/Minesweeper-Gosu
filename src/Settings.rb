
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
			colors: {
				hidden:     Gosu::Color.argb(0xff_999999),
				shown:      Gosu::Color.argb(0xff_cccccc),
				bomb_shown: Gosu::Color.argb(0xff_222222),
				border:     Gosu::Color.argb(0xff_000000)
			}
		}
	end

end


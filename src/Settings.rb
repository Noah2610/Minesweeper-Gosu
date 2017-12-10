
class Settings
	def self.screen
		{
			w: 640,
			h: 480
		}
	end

	def self.controls
		{
			primary:    [Gosu::MS_LEFT, Gosu::KB_C],
			secondary:  [Gosu::MS_RIGHT, Gosu::KB_X]
		}
	end

	def self.cells
		{
			size: {
				w: 32,
				h: 32
			},
			bombs:          20.0,    # in percent
			border_padding: 2,
			colors: {
				hidden:        Gosu::Color.argb(0xff_999999),
				shown:         Gosu::Color.argb(0xff_cccccc),
				bomb_shown:    Gosu::Color.argb(0xff_222222),
				border:        Gosu::Color.argb(0xff_000000),
				flagged:       Gosu::Color.argb(0xff_444444),
				font_field:    Gosu::Color.argb(0xff_0000ff),
				font_bomb:     Gosu::Color.argb(0xff_ff0000),
				font_flagged:  Gosu::Color.argb(0xff_cc4422)
			}
		}
	end

end


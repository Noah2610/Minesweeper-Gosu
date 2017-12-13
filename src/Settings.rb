
class Settings
	def initialize
		@screen = {
			w: 960,
			h: 640
		}

		@controls = {
			primary:    [ Gosu::MS_LEFT,  Gosu::KB_C ],
			secondary:  [ Gosu::MS_RIGHT, Gosu::KB_X ],
			reset:      [ Gosu::KB_N,     Gosu::KB_R, Gosu::KB_Z ]
		}

		@cells = {
			size: {
				w: 32,
				h: 32
			},
			bombs:          20.0,    # in percent
			border_padding: 2,
			colors: {
				hidden:               Gosu::Color.argb(0xff_999999),
				hidden_mouse_hover:   Gosu::Color.argb(0xff_bbbbbb),
				shown:                Gosu::Color.argb(0xff_cccccc),
				bomb_shown:           Gosu::Color.argb(0xff_222222),
				border:               Gosu::Color.argb(0xff_000000),
				flagged:              Gosu::Color.argb(0xff_444444),
				flagged_mouse_hover:  Gosu::Color.argb(0xff_666666),
				font_field:           Gosu::Color.argb(0xff_0000ff),
				font_bomb:            Gosu::Color.argb(0xff_ff0000),
				font_flagged:         Gosu::Color.argb(0xff_cc4422)
			}
		}

		@panel = {
			size: {
				w:     screen[:w],
				h:     64
			},
			colors: {
				bg:         Gosu::Color.argb(0xff_cccccc),
				font:       Gosu::Color.argb(0xff_000000),
				font_won:   Gosu::Color.argb(0xff_a4c639),
				font_lost:  Gosu::Color.argb(0xff_af002a)
			}
		}
	end

	def screen
		@screen
	end

	def controls
		@controls
	end

	def cells
		@cells
	end

	def panel
		@panel
	end

end


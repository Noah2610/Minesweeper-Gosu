
class Settings
	def initialize
		@screen = $savefile.settings :screen
		@screen = {
			w: 960,
			h: 640
		}  if (@screen.nil?)

		@controls = {
			primary:    [ Gosu::MS_LEFT,  Gosu::KB_C ],
			secondary:  [ Gosu::MS_RIGHT, Gosu::KB_X ],
			reset:      [ Gosu::KB_N,     Gosu::KB_R, Gosu::KB_Z ],
			up:         [ Gosu::KB_K, Gosu::KB_UP ],
			down:       [ Gosu::KB_J, Gosu::KB_DOWN ],
			left:       [ Gosu::KB_H, Gosu::KB_LEFT ],
			right:      [ Gosu::KB_L, Gosu::KB_RIGHT ]
		}

		@cells = {
			size:           $savefile.settings(:cell_size),
			bombs:          $savefile.settings(:bombs),
			border_padding: 2,
			colors: {
				hidden:               Gosu::Color.argb(0xff_999999),
				hidden_mouse_hover:   Gosu::Color.argb(0xff_bbbbbb),
				shown:                Gosu::Color.argb(0xff_cccccc),
				shown_mouse_hover:    Gosu::Color.argb(0xff_eeeeee),
				bomb_shown:           Gosu::Color.argb(0xff_222222),
				border:               Gosu::Color.argb(0xff_000000),
				flagged:              Gosu::Color.argb(0xff_444444),
				flagged_mouse_hover:  Gosu::Color.argb(0xff_666666),
				font_field:           Gosu::Color.argb(0xff_0000ff),
				font_bomb:            Gosu::Color.argb(0xff_ff0000),
				font_flagged:         Gosu::Color.argb(0xff_cc4422)
			}
		}
		@cells[:bombs] = 20.0  if (@cells[:bombs].nil?)  # in percent
		@cells[:size] = {
			w: 32,
			h: 32
		}  if (@cells[:size].nil?)

		@panel = {
			size: {
				w:     screen[:w],
				h:     64
			},
			colors: {
				bg:         Gosu::Color.argb(0xff_cccccc),
				font:       Gosu::Color.argb(0xff_000000),
				font_won:   Gosu::Color.argb(0xff_a4c639),
				font_lost:  Gosu::Color.argb(0xff_af002a),
				font_high:  Gosu::Color.argb(0xff_008000)
			}
		}

		@quick_start = !!$savefile.settings(:quick_start)

		@adjust_screen_to_grid = !!$savefile.settings(:adjust_screen_to_grid)
	end

	def screen
		@screen
	end

	def set_screen args
		@screen[:w] = args[:w]  unless (args[:w].nil?)
		@screen[:h] = args[:h]  unless (args[:h].nil?)
	end

	def adjust_screen_to_grid?
		!!@adjust_screen_to_grid
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

	def quick_start?
		@quick_start
	end

end


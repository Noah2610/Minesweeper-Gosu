
class SaveFile
	attr_reader :prev_highscore

	def initialize filename
		@file = File.join DIR, filename
		@content = YAML.load_file @file  if (File.exists? @file)
		@content = {}                    if (!@content)
		@prev_highscore = nil
	end

	def settings target
		settings = @content["settings"]
		if (settings)

			case target
			when :screen
				if (settings["resolution"])
					return {
						w: settings["resolution"].split("x")[0].to_i,
						h: settings["resolution"].split("x")[1].to_i
					}
				end

			when :grid
				if (settings["grid"])
					return {
						grid: {
							x: settings["grid"].split("x")[0].to_i,
							y: settings["grid"].split("x")[1].to_i
						}
					}
				end

			when :cell_size
				if (settings["cell_size"])
					return {
						w: settings["cell_size"].split("x")[0].to_i,
						h: settings["cell_size"].split("x")[1].to_i
					}
				end

			when :bombs
				if (settings["bomb_percent"])
					return settings["bomb_percent"].to_f
				end

			when :quick_start
				if (!settings["quick_start"].nil?)
					return !!settings["quick_start"]
				end

			when :adjust_screen_to_grid
				if (!settings["adjust_screen_to_grid"].nil?)
					return !!settings["adjust_screen_to_grid"]
				end

			end

		end
		return nil
	end

	def highscore which = :time, grid = "#{$game.grid.grid[:x].to_i}x#{$game.grid.grid[:y].to_i}"
		@content["highscores"] ||= {}
		@content["highscores"][grid] ||= nil
		high = @content["highscores"][grid]
		if (high)
			case which
			when :time
				return high.split(" | ")[0]

			when :grid
				return grid

			when :date
				return high.split(" | ")[1]

			when :clock
				return high.split(" | ")[2]

			when :bombs
				return high.split(" | ")[3]

			when :full, :all
				return {
					time:   highscore(:time),
					grid:   highscore(:grid),
					date:   highscore(:date),
					clock:  highscore(:clock),
					bombs:  highscore(:bombs)
				}
			end
		end
		return nil
	end

	def set_highscore args
		@prev_highscore = @content["highscores"][args[:grid]]
		@content["highscores"] ||= {}
		@content["highscores"][args[:grid]] = "#{args[:time]} | #{args[:date]} | #{args[:clock]} | #{args[:bombs]}"
	end

	def compare_time time1, time2, opt = :time
		opt = :diff  if (opt == :difference)
		if    (!time1.nil? && time2.nil?)
			return time1  if (opt == :time)
			return nil    if (opt == :diff)
		elsif (!time2.nil? && time1.nil?)
			return time2  if (opt == :time)
			return nil    if (opt == :diff)
		elsif (time1.nil? && time2.nil?)
			return nil
		end

		t1 = Time.strptime(time1, "%M:%S.%N")
		t2 = Time.strptime(time2, "%M:%S.%N")

		case opt
		when :time
			# Compares times and returns smaller time (higher score)
			if    (t1 < t2)
				return time1
			elsif (t2 < t1)
				return time2
			elsif (t1 == t2)
				return time1
			end
			return nil

		when :diff
			# Compares times and returns the difference
			diff = t1.to_f - t2.to_f
			pre = diff >= 0 ? "+" : "-"
			secs = diff.dup.abs
			mins = (secs / 60.0).floor
			ret = ""
			if (mins > 0)
				secs -= mins * 60
				ret = "#{pre} #{mins.to_s.rjust(2,"0")}:#{secs.floor.to_s.rjust(2,"0")}#{secs.to_s[/\..+$/][0..2]}"
			elsif (mins == 0)
				ret = "#{pre} #{secs.floor.to_s.rjust(2,"0")}#{secs.to_s[/\..+$/][0..2]}"
			end
			return (ret)

		end

	end

	def save_score time
		now = Time.now
		today = now.strftime "%Y-%m-%d"
		clock = now.strftime "%H:%M"
		grid = "#{$game.grid.grid[:x].to_i}x#{$game.grid.grid[:y].to_i}"

		# Save score
		@content["scores"] ||= {}
		@content["scores"][grid] ||= {}
		@content["scores"][grid][today] ||= []
		@content["scores"][grid][today] << "#{time} | #{clock} | #{$settings.cells[:bombs]}%"

		# Check and save highscore
		high = compare_time time, highscore
		unless (high.nil?)
			if (high == highscore)
				set_highscore highscore(:all)
			else
				set_highscore(
					time:  time,
					grid:  grid,
					date:  today,
					clock: clock,
					bombs: "#{$settings.cells[:bombs]}%"
				)
			end
		end

		save_to_file
	end

	def save_to_file
		file = File.new @file, "w"
		file.write @content.to_yaml + "..."
		file.close
	end

end


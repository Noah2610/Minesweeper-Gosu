
class SaveFile
	def initialize filename
		@file = File.join DIR, filename
		@content = YAML.load_file @file  if (File.exists? @file)
		@content = {}                    if (!@content)
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

			when :bombs
				if (settings["bomb_percent"])
					return settings["bomb_percent"].to_f
				end

			end

		end
		return nil
	end

	def highscore which = :time
		@content["highscore"] ||= "59:59.99"
		high = @content["highscore"]
		if (high)
			case which
			when :time
				return high.split(" | ")[0]

			when :grid
				return high.split(" | ")[1]

			when :date
				return high.split(" | ")[2]

			when :clock
				return high.split(" | ")[3]

			when :full, :all
				return {
					time:   highscore(:time),
					grid:   highscore(:grid),
					date:   highscore(:date),
					clock:  highscore(:clock)
				}
			end
		end
		return nil
	end

	def set_highscore args
		@content["highscore"] = "#{args[:time]} | #{args[:grid]} | #{args[:date]} | #{args[:clock]}"
	end

	def compare_time time1, time2
		# Compares times and returns smaller time (higher score)
		if    (!time1.nil? && time2.nil?)
			return time1
		elsif (!time2.nil? && time1.nil?)
			return time2
		elsif (time1.nil? && time2.nil?)
			return nil
		end

		t1 = DateTime.strptime(time1, "%M:%S.%N")
		t2 = DateTime.strptime(time2, "%M:%S.%N")

		if    (t1 < t2)
			return time1
		elsif (t2 < t1)
			return time2
		elsif (t1 == t2)
			return time1
		end
		return nil

	end

	def save_score time
		now = Time.now
		today = now.strftime "%Y-%m-%d"
		clock = now.strftime "%H:%M"
		grid = "#{$game.grid.grid[:x]}x#{$game.grid.grid[:y]}"

		# Save score
		@content["scores"] ||= {}
		@content["scores"][grid] ||= {}
		@content["scores"][grid][today] ||= []
		@content["scores"][grid][today] << "#{time} | #{clock}"

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
					clock: clock
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


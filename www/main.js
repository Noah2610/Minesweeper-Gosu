
$(document).ready(function () {
	function toggle_score_group() {
		var group = $(this);
		var uls = group.siblings('ul');

		if (group.hasClass("collapsed")) {
			// Expand
			group.removeClass("collapsed");
			uls.each(function () {
				$(this).css("display", "block");
			});
		} else {
			// Collapse
			group.addClass("collapsed");
			uls.each(function () {
				$(this).css("display", "none");
			});
		}
	}

	function sort_scores(g1, g2) {
			var grid1 = {
				x: parseInt(g1.split(" | ")[0].split("x")[0]),
				y: parseInt(g1.split(" | ")[0].split("x")[1])
			}
			var perc1 = parseInt(g1.split(" | ")[1].replace("%",""));
			var grid2 = {
				x: parseInt(g2.split(" | ")[0].split("x")[0]),
				y: parseInt(g2.split(" | ")[0].split("x")[1])
			}
			var perc2 = parseInt(g2.split(" | ")[1].replace("%",""));

			var val1 = ((grid1.x * grid1.y) / 100.0) * perc1;
			var val2 = ((grid2.x * grid2.y) / 100.0) * perc2;

			return val2 - val1;
	}

	function get_highscores(highscores) {
		var ul = $('#highscores ul');
		Object.keys(highscores).sort(sort_scores).forEach(function (group) {
			high = highscores[group];
			console.log(group + " :: " + high);

			var li = $(document.createElement("li"));
				li.addClass("list-group-item");
				li.append('<strong>'+ group +'</strong><br />');
				li.append('<span>'+ high +'</span>');
			ul.append(li);
		});
	}

	function get_scores(scores) {
		var body = $('#scores #scores_body');

		Object.keys(scores).sort(sort_scores).forEach(function (group) {
			var ul = $(document.createElement("ul"));
				ul.addClass("list-group");

			var li = $(document.createElement("li"));
				li.addClass("list-group-item");
				li.append('<h4 class="scores_groups collapsed">'+ group +'</h4>');

			Object.keys(scores[group]).forEach(function (date) {
				var ul_dates = $(document.createElement("ul"));
					ul_dates.addClass("list-group");
					ul_dates.css("display", "none");

				var li_dates = $(document.createElement("li"));
					li_dates.addClass("list-group-item");
					li_dates.append('<strong>'+ date +'</strong>');

				var ul_scores = $(document.createElement("ul"));
					ul_scores.addClass("list-group");

				scores[group][date].forEach(function (score) {
					var li_scores = $(document.createElement("li"));
						li_scores.addClass("list-group-item");
						li_scores.text(score);

					ul_scores.append(li_scores);
				});

				li_dates.append(ul_scores);
				ul_dates.append(li_dates);

				li.append(ul_dates);
			});

			ul.append(li);
			body.append(ul);

			li.find('h4').get(0).addEventListener("click", toggle_score_group);
		});

	}

	$.getJSON("./savefile.json", function (json) {
		get_highscores(json.highscores);
		get_scores(json.scores);
	});
});


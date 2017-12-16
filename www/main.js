


$(document).ready(function () {
	function get_highscores(highscores) {
		var ul = $('#highscores ul');
		Object.keys(highscores).forEach(function (group) {
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

		Object.keys(scores).forEach(function (group) {
			var ul = $(document.createElement("ul"));
				ul.addClass("list-group");

			var li = $(document.createElement("li"));
				li.addClass("list-group-item");
				li.append('<h4>'+ group +'</h4>');

			Object.keys(scores[group]).forEach(function (date) {
				// Dates
				var ul_dates = $(document.createElement("ul"));
					ul_dates.addClass("list-group");

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
		});

	}

	$.getJSON("./savefile.json", function (json) {
		get_highscores(json.highscores);
		get_scores(json.scores);
	});
});


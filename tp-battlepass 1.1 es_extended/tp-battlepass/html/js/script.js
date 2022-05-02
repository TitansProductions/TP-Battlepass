var levelscheck       = 0;

var reward_chances    = "";
var battlepass_levels = 0;
var currentLevel      = 0;

var selectedSource    = 0;

function closeBattlepass() {
    $.post("http://tp-battlepass/closeNUI", JSON.stringify({}));
}

$(function() {
	window.addEventListener('message', function(event) {
		var item = event.data;

		if (item.type == "enable_battlepass") {
			document.body.style.display = item.enable ? "block" : "none";

			document.getElementById("showloading").style.display="none";
			document.getElementById("enable_battlepass").style.display="block";

		}else if (item.type == "enable_loading") {
			document.body.style.display = item.enable ? "block" : "none";

			document.getElementById("enable_battlepass").style.display="none";
			document.getElementById("showloading").style.display="block";


		}else if (item.action === 'mainData'){
			battlepass_levels = item.battlepass_levels;
		}
		else if (item.action === 'addPlayerDetails'){
			$("#left-side").html('');

			currentLevel = item.level;

			$("#left-side").append(

				`<div id="level_progress_main">`+

				`<div class="">`+
				 

				`</div>`+

					`<span id="level_progress">Lv. `+ item.level +`</span> | <span id="level_progress_perc">`+ item.percentage +`%</span>`+
					`<div class="level_progress_background">`+
						`<div data-size="`+ item.percentage +`" class="level_progress_status"></div>`+
					`</div>`+

				`</div>`+

				`</div>`

			);

			// LEVEL PROGRESS BAR 
			const progress_bars = document.querySelectorAll('.level_progress_status');
			progress_bars.forEach(bar => {
                const { size } = bar.dataset;
                bar.style.width = `${size}%`;
            });
		}

		else if (item.action === 'addCenterRewardDisplay'){
			$("#packdisplay").html('');

			$("#packdisplay").append(
				`<div id="packDisplayBox">`+
					`<div id="pack_display_box_det">`+
					`<div>`+
					   `<div  id="pack_display_level_box_description_title">★ Lv. ` + item.level + ` ` + `Reward Description</div>`+
					   `<div id="pack_display_level_box_description">`+ item.description +`</div>`+
			   	   `</div>`+
					  `<img src="`+ item.image +`" id="pack_level_box_img">`+
					  `<div id="pack_display_level_box_description_itemname">`+ item.item +`</div>`+
					`</div>`+

					`<div id="level_box_display_claim" level='`+ item.level + `' >`+
					`<i class="fa fa-gift"> RECEIVE LEVEL REWARD</i></i>`+
				    `</div>`+

				`</div>`+

				`</div>`
			);
		
		} 

		else if (item.action === 'addCenterDisplay'){
			$("#packdisplay").html('');

			$("#packdisplay").append(
				`<div id="packDisplayBox">`+
					`<div id="pack_display_box_det">`+
					`<div>`+
					`<div  id="pack_display_level_box_description_title">★ Lv. ` + item.level + ` ` + `Reward Description</div>`+
					`<div id="pack_display_level_box_description">`+ item.description +`</div>`+
			   	   `</div>`+
					  `<img src="`+ item.image +`" id="pack_level_box_img">`+
					  `<div id="pack_display_level_box_description_itemname">`+ item.item +`</div>`+
					`</div>`+

				`</div>`+

				`</div>`
			);
		
		} 
		else if (item.action === 'addLevels'){
			levelscheck++
			if (levelscheck==1){
				$("#levelpacks").html('');
				$("#packdisplay").html('');
			}
			
			var level_detail = item.level_detail

			if (item.status == "waiting"){

				$("#levelpacks").append(
					`<div id="levelBox">`+
						`<div id="level_box_det">`+
						`<div id=" ">ㅤ</div>`+
							`<img src="`+ level_detail.image +`" id="level_box_img">`+
							`<div>`+
								`<span id="level_box_reward"> `+ level_detail.title +` </span>  <br>`+
								`<span id="level_box_reward_cost"> Cost is: ` + item.cost + ` Cash </span>  <br>`+
							`</div>`+
							`<div id="level_box_claimer" level='`+ levelscheck + `' item='` + level_detail.title + `' description='` + level_detail.description + `' image='` + level_detail.image + `' >`+
								`<i class="fas fa-lock"></i>`+
							`</div>`+
							
							`<div id="level_box_canBuy" level='`+ levelscheck +`'>`+
							    `<i class="fas fa-coins"> BUY LEVEL </i>`+
							`</div>`+

						`</div>`+
						`<div id=" ">ㅤ</div>`+
						`<div id="level_counter">LEVEL `+ levelscheck+`</div>`+
					`</div>`
				);
			}
			else if (item.status == "claimed"){
				$("#levelpacks").append(
					`<div id="levelBox">`+

						`<div id="level_box_det">`+
						`<div id=" ">ㅤ</div>`+
							`<img src="`+ level_detail.image +`" id="level_box_img">`+
							`<div>`+
								`<span id="level_box_reward"> `+ level_detail.title +` </span>  <br>`+
								`<span id="level_box_reward_cost">No Cost</span>  <br>`+
							`</div>`+
							`<div id="level_box_claimer" level='`+ levelscheck + `' item='` + level_detail.title + `' description='` + level_detail.description + `' image='` + level_detail.image + `' >`+
								`<i class="fa fa-check"></i>`+
							`</div>`+

						`</div>`+
						`<div id=" ">ㅤ</div>`+
						`<div id="level_counter">LEVEL `+ levelscheck+`</div>`+
					`</div>`
				);
			}
			else if (item.status == "loading"){
				$("#levelpacks").append(
					`<div id="levelBox">`+
						`<div id="level_box_det">`+
						
						`<div id=" ">ㅤ</div>`+
							`<img src="`+ level_detail.image +`" id="level_box_img">`+
							`<div>`+
								`<span id="level_box_reward"> `+ level_detail.title +` </span>  <br>`+
								`<span id="level_box_reward_cost"> Cost is: ` + item.cost + ` Cash </span>  <br>`+
							`</div>`+
							`<div id="level_box_claimer" level='`+ levelscheck + `' item='` + level_detail.title + `' description='` + level_detail.description + `' image='` + level_detail.image + `' >`+
								`<i class="far fa-clock"></i>`+
							`</div>`+

							`<div id="level_box_canBuy" level='`+ levelscheck +`'>`+
							    `<i class="fas fa-coins"> BUY LEVEL </i>`+
						    `</div>`+

						`</div>`+
						`<div id=" ">ㅤ</div>`+
						`<div id="level_counter">LEVEL `+ levelscheck+`</div>`+
					`</div>`
				);
			}
			else if (item.status == "canClaim"){
				$("#levelpacks").append(
					`<div id="levelBox">`+
						`<div id="level_box_det">`+
						`<div id=" ">ㅤ</div>`+
							`<img src="`+ level_detail.image +`" id="level_box_img">`+
							`<div>`+
								`<span id="level_box_reward"> `+ level_detail.title +` </span>  <br>`+
								`<span id="level_box_reward_cost">No Cost</span>  <br>`+
							`</div>`+
							`<div id="level_box_canClaim" level='`+ levelscheck + `' item='` + level_detail.title + `' description='` + level_detail.description + `' image='` + level_detail.image + `' >`+
								`<i class="fa fa-gift"></i></i>`+
							`</div>`+

						`</div>`+

						`<div id=" ">ㅤ</div>`+
						`<div id="level_counter">LEVEL `+ levelscheck+`</div>`+
					`</div>`
				);
			}

			if (levelscheck==battlepass_levels){
				levelscheck= 0
			}
		}

	});

	$("body").on("keyup", function (key) {
		if (key.which == 27){
			closeBattlepass();
		}
	});

	// LEVEL UP
	$("#levelpacks").on("click", "#level_box_canBuy", function() {
        var $button = $(this);
        var $level = $button.attr('level')

		$.post('http://tp-battlepass/buyLevel', JSON.stringify({
			currentLevel : currentLevel,
			level : $level
		}))
		return

	});

	// CLAIM REWARD
	$("#packdisplay").on("click", "#level_box_display_claim", function() {
        var $button = $(this);
        var $level = $button.attr('level')

		$.post('http://tp-battlepass/claimRewards', JSON.stringify({
			level : $level
		}))
		return

	});

	$("#levelpacks").on("click", "#level_box_canClaim", function() {
        var $button = $(this);
        var $level = $button.attr('level')
        var $item = $button.attr('item')
		var $description = $button.attr('description')
		var $image = $button.attr('image')

		$.post('http://tp-battlepass/displayReceivedReward', JSON.stringify({
			item : $item,
			description : $description,
			level : $level,
			image : $image
		}))
		return

	});

	$("#levelpacks").on("click", "#level_box_claimer", function() {
        var $button = $(this);
        var $level = $button.attr('level')
        var $item = $button.attr('item')
		var $description = $button.attr('description')
		var $image = $button.attr('image')

		$.post('http://tp-battlepass/displayReward', JSON.stringify({
			item : $item,
			description : $description,
			level : $level,
			image : $image
		}))
		return

	});
});



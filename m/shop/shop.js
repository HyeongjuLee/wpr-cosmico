/* 깨방 */

	function bgup(aidx) {

		//document.getElementById('shop_list').style.backgroundImage = '';
		//document.getElementById(aidx).style.backgroundColor = 'black';
		$("#shop_list li .ups").css("display","none");
		$("#"+aidx).css({
			"display":"block",
			"background":"url(/images/loading_bg70.png) 0 0 repeat;"
		});
		//$("#"+aidx).css("display","block");
		//document.getElementById(aidx).style.display = 'block';
		//document.getElementById(aidx).style.backgroundImage = "url('/images/loading_bg70.png')";
		//document.getElementById(aidx).style.backgroundRepeat = 'repeat';

	}

	function bgDown(aidx) {

		$("#"+aidx).css({
			"display":"none"
		});




	}

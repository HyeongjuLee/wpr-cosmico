$(document).ready(function() {

	$('.remainingTXT').each(function () {
		// count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
		var $maxcount = $('.maxCount', this);
		var $count = $('.count', this);
		var $input = $(this).closest("div.input").find("textarea");

		// .text()가 문자열을 반환하기에 이 문자를 숫자로 만들기 위해 1을 곱한다.
		var maximumByte = $maxcount.text() * 1;
		// update 함수는 keyup, paste, input 이벤트에서 호출한다.
		var update = function () {
			var before = $count.text() * 1;
			var str_len = $input.val().length;
			var cbyte = 0;
			var li_len = 0;
			for (i = 0; i < str_len; i++) {
				var ls_one_char = $input.val().charAt(i);
				if (escape(ls_one_char).length > 4) {
					cbyte += 2; //한글이면 2를 더한다
				} else {
					cbyte++; //한글아니면 1을 다한다
				}
				if (cbyte <= maximumByte) {
					li_len = i + 1;
				}
			}
			// 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
			if (parseInt(cbyte) > parseInt(maximumByte)) {
				alert('허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.');
				var str = $input.val();
				var str2 = $input.val().substr(0, li_len);
				$input.val(str2);
				var cbyte = 0;
				for (i = 0; i < $input.val().length; i++) {
					var ls_one_char = $input.val().charAt(i);
					if (escape(ls_one_char).length > 4) {
						cbyte += 2; //한글이면 2를 더한다
					} else {
						cbyte++; //한글아니면 1을 다한다
					}
				}
			}
			$count.text(cbyte);
		};
		// input, keyup, paste 이벤트와 update 함수를 바인드한다
		$input.bind('input keyup keydown paste change', function () {
			//limitLines($(this),event);

			var rows = $input.val().split('\n').length;
			var maxRows = 3;
			//alert(rows);
			if( rows > maxRows){
				alert('3줄 까지만 가능합니다');
				modifiedText = $input.val().split("\n").slice(0, maxRows);
				$input.val(modifiedText.join("\n"));
			}			
			
			setTimeout(update, 0)
		});
		update();
	});

});






function chkImg(f) {


		if (f.strImg.value == "") {
			alert("이미지를 선택해주세요.");
			f.strImg.focus();
			return false;
		} else {
			if (!checkFileName(f.strImg)) return false;
			if (!checkFileExt(f.strImg, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
		}

		if (f.isLink.value == 'T')
		{
			if (f.strLink.value == '')
			{
				alert("링크 사용으로 선택 시 링크 주소를 반드시 넣어주셔야합니다.");
				f.strLink.focus();
				return false;
			}
		}

}

function menuMode(f) {

	if (f.strImg.value.length > 0) {			
		if (!checkFileName(f.strImg)) return false;
		if (!checkFileExt(f.strImg, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
	}

}





function delThis(idx) {

	var f = document.mfrm;

	if (confirm('삭제 하시겠습니까?\n\n삭제 후 복구할 수 없습니다.'))
	{
		f.intIDX.value = idx;
		f.mode.value = 'DELETE';
		f.submit();
	}

}

function chgView(idx,values) {

	var f = document.mfrm;

	if (confirm('노출상태를 변경하시겠습니까?'))
	{
		f.intIDX.value = idx;
		f.value1.value = values;
		f.mode.value = 'chgView';
		f.submit();
	}

}

function sortUp(idx){
	var f = document.mfrm;

	if (confirm('카테고리 우선순위를 올리시겠습니까?'))
	{
		f.mode.value = 'SORTUP';
		f.intIDX.value = idx;
		f.submit();

	}
}

function sortDown(idx){
	var f = document.mfrm;

	if (confirm('카테고리 우선순위를 내리시겠습니까?'))
	{
		f.mode.value = 'SORTDN';
		f.intIDX.value = idx;
		f.submit();

	}

}




$(function() {
	$('.writtenTXT').each(function() {
		// count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
		var $countMin = $('.countMin', this);
		var $input = $(this).prev();
		// .text()가 문자열을 반환하기에 이 문자를 숫자로 만들기 위해 1을 곱한다.
		var countMin = $countMin.text() * 1;
		var countMax = $('.countMax', this).text() * 1;
		// update 함수는 keyup, paste, input 이벤트에서 호출한다.
		var update = function() {
			var before = $countMin.text() * 1;
			var now = countMin + $input.val().length;
			// 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
			if (now > countMax) {
				var str = $input.val();
				alert(countMax+ '자까지 입력할 수 있습니다.');
				$input.val(str.substr(0, countMax));
				now = countMax;
			}
			// 필요한 경우 DOM을 수정한다.
			if (before != now) {
				$countMin.text(now);
			}
		};
		// input, keyup, paste 이벤트와 update 함수를 바인드한다
		$input.bind('input keyup paste', function() {
			setTimeout(update, 0)
		});
		update();
	});
});
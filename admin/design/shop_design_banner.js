$(document).ready(function() {

	$('.remainingTXT').each(function () {
		// count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
		var $maxcount = $('.maxCount', this);
		var $maxRow = $('.maxRow', this);
		var $count = $('.count', this);
		//var $input = $(this).closest("div.input").find("textarea");
		var $input = $(this).prev();

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
			var maxRows = $maxRow.text() * 1;
			if (maxRows == 0) {
				maxRows = 1
			}
			//alert(maxRows);
			if( rows > maxRows){
				alert(maxRows+'줄 까지만 가능합니다');
				modifiedText = $input.val().split("\n").slice(0, maxRows);
				$input.val(modifiedText.join("\n"));
			}

			setTimeout(update, 0)
		});
		update();
	});

});


	function openModify(trIDS) {
		var $WrapTr = $("#"+trIDS);
		var $frm = $("form[name=frmc]");
		//alert($("input[name=OristrImg]", $WrapTr).val());
		$("input[name=intIDX]", $frm).val($("input[name=intIDX]", $WrapTr).val());
		$("input[name=isUse]:radio[value="+ $("input[name=isUse]", $WrapTr).val() +"]", $frm).attr("checked",true);
		$("input[name=OristrImg]", $frm).val($(".strImg", $WrapTr).text());
		$("select[name=isLink]", $frm).val($("input[name=isLink]", $WrapTr).val());
		$("select[name=isLinkTarget]", $frm).val($("input[name=isLinkTarget]", $WrapTr).val());
		$("input[name=strLink]", $frm).val($("input[name=strLink]", $WrapTr).val());
		$("input[name=strTitle]", $frm).val($(".strTitle", $WrapTr).text());
		$("input[name=strSubTitle]", $frm).val($("input[name=strSubTitle]", $WrapTr).val());
		$("textarea[name=strScontent]", $frm).val($("input[name=strScontent]", $WrapTr).val());

		/*
			<input type="hidden" name="isUse" value="<%=arrList_isUse%>" />
			<input type="hidden" name="OristrImg" value="<%=arrList_strImg%>" />
			<input type="hidden" name="strTitle" value="<%=arrList_strTitle%>" />
			<input type="hidden" name="isLink" value="<%=arrList_isLink%>" />
			<input type="hidden" name="isLinkTarget" value="<%=arrList_isLinkTarget%>" />
			<input type="hidden" name="strLink" value="<%=arrList_strLink%>" />
			<input type="hidden" name="strScontent" value="<%=arrList_strScontent%>" />
		*/

		$("#ModalScrollable1").modal('show');

	}



function chkImg(f) {


		if (f.strImg.value == "") {
			alert("이미지를 선택해주세요.");
			f.strImg.focus();
			return false;
		} else {
			if (!checkFileName(f.strImg)) return false;
			if (!checkFileExt(f.strImg, "jpg,jpeg,gif,png", "이미지(jpg(jpeg), gif,png) 파일만 선택해 주세요.")) return false;
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

function delThis(idx) {

	var f = document.mfrm;

	if (confirm('삭제 하시겠습니까?\n\n삭제 후 복구할 수 없습니다.'))
	{
		f.intIDX.value = idx;
		f.mode.value = 'DELETE';
		f.submit();
	}

}
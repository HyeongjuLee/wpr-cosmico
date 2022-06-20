/*한글 */


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


function submitThisLine(intIDX,mode,values) {
	var f = document.mfrm;


	if (confirm("변경하시겠습니까?"))
	{
		f.intIDX.value = intIDX;
		f.mode.value = mode;
		f.values.value = values;
		f.submit();
	}

}
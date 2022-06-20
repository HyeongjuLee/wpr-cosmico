function chkGFrm(f) {

	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);


	if (f.intCate.value == '')
	{
		alert("카테고리를 선택해주세요.");
		f.intCate.focus();
		return false;
	}

	if (f.strAticle.value == '')
	{
		alert("조 내지는 항을 선택해주세요.");
		f.strAticle.focus();
		return false;
	}

	if (f.strSubject.value == '')
	{
		alert("제목을 입력해주세요.");
		f.strSubject.focus();
		return false;
	}

	if (f.strContent.value == '')
	{
		alert("내용을 입력해주세요.");
		oEditors[0].exec("FOCUS", []);
		return false;
	}

	// if (checkDataImages(f.strContent.value)) {
	// 	alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
	// 	return false;
	// }

	var msg = "등록하시겠습니까?";
	if(confirm(msg)){
		return true;
	}else{
		return false;
	}



}

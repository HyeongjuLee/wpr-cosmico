
function wChk() {
	var f = document.workingFrm;
	
		if(!chkNull(f.strName, "\'관리사 이름 \'을 입력해 주세요")) return;
		if(!chkNull(f.strPosition, "\'직책(급) \'을 선택해 주세요")) return;
		if(!chkNull(f.intAge, "\'나이\'을 입력해 주세요")) return;
		if(!chkNull(f.joinDate, "\'입사일 \'을 선택(기입)해 주세요")) return;
		if (!isDate(f.joinDate.value)) {
			alert("유효하지 않은 일자입니다. (1990-01-01 형식으로 입력해주셔야합니다.)");
			f.joinDate.focus();
			return;
		}
		if(!chkNull(f.strForte, "\'전문관리분야\'를 입력해 주세요")) return;
		if(!chkNull(f.strCareer, "\'경력\'을 입력해 주세요")) return;
		if(!chkNull(f.strPic, "\'사진\'을 선택해 주세요")) return;
		
		f.submit();

}

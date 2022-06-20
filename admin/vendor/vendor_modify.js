
function submitInsert(f) {
/*
	if (f.strShopID.value == '')
	{
		alert('제조사(판매처) ID 를 입력해주세요');
		f.strShopID.focus();
		return false;
	}
*/




	if (f.strComName.value == '')
	{
		alert('판매처 이름을 입력해주세요');
		f.strComName.focus();
		return false;
	}
	if (f.strPass.value == '')
	{
		alert('판매처 접속암호를 입력해주세요');
		f.strPass.focus();
		return false;
	}
	if (f.FeeType.value==''){
		alert('지불방식을 선택해주세요');
		f.FeeType.focus();
		return false;
	}
	if (f.intFee.value==''){
		alert('배송비를 입력해주세요');
		f.intFee.focus();
		return false;
	}
	if (f.intLimit.value==''){
		alert('배송비한도를 입력해주세요');
		f.intLimit.focus();
		return false;
	}
	if (confirm("등록하시겠습니까?")) {
		f.target = "_self";
		return;
	} else {
		return false;
	}

}
	function join_idcheck() {

		var ids = document.gform.strShopID;
		if (ids.value == '')
		{

			alert("아이디를 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (!checkID(ids.value.trim(), 4, 20)){
			alert("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
			ids.focus();
			return false;
		}
		createRequest();

		var url = 'vendor_id_check.asp?ids='+ids.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("idCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}


function submitInsert(f) {
/*
	if (f.strShopID.value == '')
	{
		alert('제조사(판매처) ID 를 입력해주세요');
		f.strShopID.focus();
		return false;
	}
*/
	if (f.strShopID.value == "")
	{
		alert("아이디를 입력해주세요");
		f.strShopID.focus();
		return false;
	} else {
		if (!checkID(f.strShopID.value, 4, 13)){
			alert("아이디는 영문 혹은 숫자 4자~13자리로 해주세요.");
			f.strShopID.focus();
			return false;
		}
		if (f.idcheck.value == 'F'){
			alert("아이디 중복확인을 해주세요.");
			f.strShopID.focus();
			return false;
		}
/*
		if (f.strShopID.value != f.chkID.value){
			alert("중복확인한 아이디와 현재 등록된 아이디가 틀립니다. 다시한번 아이디 중복확인을 해주세요.");
			f.strShopID.focus();
			return false;
		}
*/
	}



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
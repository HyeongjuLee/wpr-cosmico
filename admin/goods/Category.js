// 커뮤니티 메뉴
	function menuIn(f) {
		if (f.strCateName.value == '')
		{
			alert("메뉴명이 비었습니다.");
			f.strCateName.focus();
			return false;
		}

	}

	function menuMode(f) {
		if (f.strCateName.value == '')
		{
			alert("메뉴명이 비어있습니다.");
			f.strCateName.focus();
			return false;
		}
	}

	function delok(uidx){
		var f = document.delFrm;

		if (confirm("메뉴를 삭제하시겠습니까?\n\n\※ 해당 메뉴의 하위의 메뉴도 같이 삭제됩니다.\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
			f.strCateCode.value = uidx;
			f.submit();

		}
	}
	function sortUp(uidx){
		var f = document.sortFrm;

			f.mode.value = 'SORTUP';
			f.strCateCode.value = uidx;
			f.submit();

		}


	function sortDown(uidx){
		var f = document.sortFrm;

			f.mode.value = 'SORTDOWN';
			f.strCateCode.value = uidx;
			f.submit();

		}
	function ChgView(uidx){
		var f = document.sortFrm;



		if (confirm("해당메뉴의 노출상태를 변경하시겠습니까?")) {
			f.mode.value = 'CHGVIEW';
			f.strCateCode.value = uidx;
			f.submit();

		}
	}


function chgCateType(values) {
	if (values == 'S')
	{
		$("#cate_shop").css({"display":""});
		$("#cate_link").css({"display":"none"});
	} else {
		$("#cate_shop").css({"display":"none"});
		$("#cate_link").css({"display":""});
	}
}
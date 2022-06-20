// 커뮤니티 메뉴
	function chkGFrm(f) {

		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

		if (f.fIDX.value == '')
		{
			alert("메뉴 위치가 비었습니다.");
			f.fIDX.focus();
			return false;
		}

		if (checkDataImages(f.strContent.value)) {
			alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
			return false;
		}

		 var msg = "등록하시겠습니까?";
		 if(confirm(msg)){
			return true;
		 }else{
			return false;
		 }


	}


	function delok(uidx){
		var f = document.delFrm;

		if (confirm("메뉴를 삭제하시겠습니까?\n\n\\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
			f.intIDX.value = uidx;
			f.submit();

		}
	}
	function sortUp(uidx){
		var f = document.sortFrm;

			f.mode.value = 'SORTUP';
			f.intIDX.value = uidx;
			f.submit();

		}

	function sortDown(uidx){
		var f = document.sortFrm;

			f.mode.value = 'SORTDOWN';
			f.intIDX.value = uidx;
			f.submit();

		}

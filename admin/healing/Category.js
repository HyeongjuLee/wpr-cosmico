// 커뮤니티 메뉴
	function menuIn(f) {
		if (f.strTitle.value == '')
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


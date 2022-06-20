// 요금제
	function feeMode(f) {
		if (f.CateName.value == '')
		{
			alert("카테고리명이 없습니다.");
			f.CateName.focus();
			return false;
		}
	}

	function feeIn(f) {
		if (f.CateName.value == '')
		{
			alert("요금제명이 비었습니다.");
			f.CateName.focus();
			return false;
		}

	}

	function chgPhoneFee(uidx) {
		var f = document.chgFrm;

		if (confirm("현재 등록된 단말기에 저장된 모든 요금내용을 변경하시겠습니까? \n\n변경 후 롤백할 수 없습니다.※")) {
			f.strCateCode.value = uidx;
			f.submit();

		}

	}



	function delok(uidx){
		var f = document.delFrm;

		if (confirm("요금제를 삭제하시겠습니까?※\n\n\※ 해당 요금제 하위의 요금제도 삭제됩니다.※")) {
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


	function delPhone(uidx) {
		var f = document.delFrm;

		if (confirm("기기를 삭제하시겠습니까? 삭제후 복구되지 않습니다.※")) {
			f.intIDX.value = uidx;
			f.submit();

		}
	}

	function delGoods(uidx,pidx){
		var f = document.delGFrm;

		if (confirm("요금제를 삭제하시겠습니까?※\n\n\※ 삭제된 요금제는 복구 되지 않습니다.1※")) {
			f.phoneIDX.value = uidx;
			f.ops.value = pidx;
			f.submit();

		}
	}

// 단말기 등록 시작
	function phoneSubmit(f) {
		oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []);
		f.content1.value = document.getElementById("ir1").value;
		
		
		if (f.model.value=='')
		{
			alert("모델명을 기입해주세요");
			f.model.focus();
			return false;
		}

		if (f.viewname.value=='')
		{
			alert("상품 표시명을 기입해주세요");
			f.viewname.focus();
			return false;
		}

		if (f.price.value=='')
		{
			alert("출고가를 기입해주세요");
			f.price.focus();
			return false;
		}

		if (f.com.value=='')
		{
			alert("통신규격을 선택해주세요");
			return false;
		}

		if (f.color.value=='')
		{
			alert("단말기의 색상을 기입해주세요");
			f.color.focus();
			return false;
		}

		if (f.voteImg.value=='')
		{
			alert("추천상품 이미지를 선택해주세요");
			f.voteImg.focus();
			return false;
		}

		if (f.BasicImg.value=='')
		{
			alert("기본 이미지를 선택해주세요");
			f.BasicImg.focus();
			return false;
		}


		for (i=1; i<=4; i++) {
			objItem = eval("f.joinPrice"+i);
			if (chkEmpty(objItem)) {
				switch(i)
				{
					case 1 : viewTxt = "가입비 ";
					break;
					case 2 : viewTxt = "유심비 ";
					break;
					case 3 : viewTxt = "채권보증료 ";
					break;
					case 4 : viewTxt = "기변보상시 ";
					break;
				
				}
				alert(viewTxt + "유형을 선택해주세요.");
				//objItem.focus();
				return false;
			}
		}




	}
// 단말기 등록 종료










// 부가서비스
	function serviceIn(f) {

		if (f.strTitle.value == '')
		{
			alert("부가서비스의 서비스명을 입력해주세요");
			f.strTitle.focus();
			return false;
		}
		if (f.intPrice.value == '')
		{
			alert("부가서비스의 월 요금을 입력해주세요");
			f.intPrice.focus();
			return false;
		}
	}

	function serviceMode(f) {
		if (f.intIDX.value == '')
		{
			alert("필수값이 없습니다. 새로고침 후 다시 시도해주세요.");
			f.intIDX.focus();
			return false;
		}
		if (f.strTitle.value == '')
		{
			alert("부가서비스의 서비스명을 입력해주세요");
			f.strTitle.focus();
			return false;
		}
		if (f.intPrice.value == '')
		{
			alert("부가서비스의 월 요금을 입력해주세요");
			f.intPrice.focus();
			return false;
		}
	}
	function serviceDel(idn) {
		var f = document.delFrm;

		if (confirm("부가서비스를 삭제하시겠습니까?※\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
			f.intIDX.value = idn;
			f.submit();

		}

	}


// 수정

// 단말기 등록 시작
	function phoneModSubmit(f) {
		 oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []);
		 f.content1.value = document.getElementById("ir1").value;

		if (f.model.value=='')
		{
			alert("모델명을 기입해주세요");
			f.model.focus();
			return false;
		}

		if (f.viewname.value=='')
		{
			alert("상품 표시명을 기입해주세요");
			f.viewname.focus();
			return false;
		}

		if (f.price.value=='')
		{
			alert("출고가를 기입해주세요");
			f.price.focus();
			return false;
		}

		if (f.com.value=='')
		{
			alert("통신규격을 선택해주세요");
			return false;
		}

		if (f.color.value=='')
		{
			alert("단말기의 색상을 기입해주세요");
			f.color.focus();
			return false;
		}


		for (i=1; i<=4; i++) {
			objItem = eval("f.joinPrice"+i);
			if (chkEmpty(objItem)) {
				switch(i)
				{
					case 1 : viewTxt = "가입비 ";
					break;
					case 2 : viewTxt = "유심비 ";
					break;
					case 3 : viewTxt = "채권보증료 ";
					break;
					case 4 : viewTxt = "기변보상시 ";
					break;
				
				}
				alert(viewTxt + "유형을 선택해주세요.");
				//objItem.focus();
				return false;
			}
		}




}

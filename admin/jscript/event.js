	function eventFrmc(f){
		 oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []);
		 f.content1.value = document.getElementById("ir1").value;

		
		if(!chkNull(f.strSubject, "\'이벤트 제목\'을 입력해 주세요")) return false;
		if(!chkNull(f.start_date, "\'이벤트 시작일\'을 입력해 주세요")) return false;
		if (!isDate(f.start_date.value)) {
			alert("유효하지 않은 일자입니다. (1990-01-01 형식으로 입력해주셔야합니다.)");
			f.start_date.focus();
			return false;
		}
		if(!chkNull(f.last_date, "\'이벤트 종료일\'을 입력해 주세요")) return false;
		if (!isDate(f.last_date.value)) {
			alert("유효하지 않은 일자입니다. (1990-01-01 형식으로 입력해주셔야합니다.)");
			f.last_date.focus();
			return false;
		}
		if(!chkNull(f.state, "\'이벤트 상태 \'를 선택해 주세요")) return false;
		if(!chkNull(f.strGoods, "\'이벤트 상품을 간략 \'하게 입력해 주세요")) return false;
		if(!chkNull(f.strDesc, "\'이벤트에 대한 설명\'을 간략하게 입력해 주세요")) return false;
		if(!chkNull(f.strPic, "\'리스트에 기록할 사진\'을 선택해 주세요")) return false;
		if(!chkNull(f.content1, "\'이벤트 내용\'을 입력해 주세요")) return false;




		 var msg = "등록하시겠습니까?";
		 if(confirm(msg)){
			return true;
		 }else{
			return false;
		 }
	}



	function eventFrmcs(f){
		 oEditors.getById["ir1"].exec("UPDATE_IR_FIELD", []);
		 f.content1.value = document.getElementById("ir1").value;

		
		if(!chkNull(f.strSubject, "\'이벤트 제목\'을 입력해 주세요")) return false;
		if(!chkNull(f.start_date, "\'이벤트 시작일\'을 입력해 주세요")) return false;
		if (!isDate(f.start_date.value)) {
			alert("유효하지 않은 일자입니다. (1990-01-01 형식으로 입력해주셔야합니다.)");
			f.start_date.focus();
			return false;
		}
		if(!chkNull(f.last_date, "\'이벤트 종료일\'을 입력해 주세요")) return false;
		if (!isDate(f.last_date.value)) {
			alert("유효하지 않은 일자입니다. (1990-01-01 형식으로 입력해주셔야합니다.)");
			return false;
		}
		if(!chkNull(f.state, "\'이벤트 상태 \'를 선택해 주세요")) return false;
		if(!chkNull(f.strGoods, "\'이벤트 상품을 간략 \'하게 입력해 주세요")) return false;
		if(!chkNull(f.strDesc, "\'이벤트에 대한 설명\'을 간략하게 입력해 주세요")) return false;
		if(!chkNull(f.content1, "\'이벤트 내용\'을 입력해 주세요")) return false;




		 var msg = "등록하시겠습니까?";
		 if(confirm(msg)){
			return true;
		 }else{
			return false;
		 }
	}


	function bannerin(){
		var f = document.banFrm;
		if(!chkNull(f.evenURL, "\'이벤트 주소\'을 입력해 주세요")) return;
		if(!chkNull(f.evenIMG, "\'배너 이미지를\'을 선택해 주세요")) return;
		f.submit();
		
	}


function delok(uidx){
	var f = document.delFrm;

	if (confirm("이벤트 배너를 삭제하시겠습니까? ")) {
		f.intIDX.value = uidx;
		f.submit();

	}
}
function sortUp(uidx){
	var f = document.sortFrm;

		f.mode.value = 'up';
		f.intIDX.value = uidx;
		f.submit();

	}


function sortDown(uidx){
	var f = document.sortFrm;

		f.mode.value = 'down';
		f.intIDX.value = uidx;
		f.submit();

	}

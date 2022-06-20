<!--



function insertChk(f) {

	if (f.strDtoDName.value =='')
	{
		alert("택배사 이름을 입력하셔야합니다.");
		f.strDtoDName.focus();
		return false
	}
	if (f.strDtoDURL.value =='')
	{
		alert("택배사 홈페이지 주소를 입력하셔야합니다.");
		f.strDtoDURL.focus();
		return false
	}


}


function dtod_trace(messege)
{
	alert('해당택배사의 배송추적주소는 '+messege+' 입니다');
}


function delok(idx){
	var f = document.frm_update;
	if (confirm("배송업체를 삭제하시겠습니까? \n\n\삭제된 배송업체는 복구가 불가능하며, 새로 입력 하셔야합니다.")) {
		f.intIDX.value = idx;
		f.iMode.value = 'D';
		if (f.intIDX.value =='')
		{
			alert("삭제할 배송업체의 고유값이 없습니다.");
			return false;
		}
		f.submit();
	}
	
}

function dfchgok(idx){
	var f = document.frm_update;
	if (confirm("해당 택배사를 기본배송업체로 등록하시겠습니까?")) {
		f.intIDX.value = idx;
		if (f.intIDX.value =='')
		{
			alert("삭제할 배송업체의 고유값이 없습니다.");
			return false;
		}
		f.action = 'dtod_df_ok.asp';
		f.submit();
	}
	
}


function useChg(idx){
	var f = document.frm_update;
	if (confirm("노출상태를 변경하시겠습니까?")) {
		f.intIDX.value = idx;
		f.iMode.value = 'U';
		if (f.intIDX.value =='')
		{
			alert("삭제할 배송업체의 고유값이 없습니다.");
			return false;
		}
		f.submit();
	}
	
}

function sortUp(idx){
	var f = document.frm_update;
	f.intIDX.value = idx;
	f.iMode.value = 'S';
	f.SORT_TYPE.value = 'UP';
	if (f.intIDX.value =='')
	{
		alert("정렬할 배송업체의 고유값이 없습니다.");
		return false;
	}
	f.submit();
	
}

function sortDown(idx){
	var f = document.frm_update;
	f.intIDX.value = idx;
	f.iMode.value = 'S';
	f.SORT_TYPE.value = 'DW';
	if (f.intIDX.value =='')
	{
		alert("정렬할 배송업체의 고유값이 없습니다.");
		return false;
	}
	f.submit();
	
}



//-->



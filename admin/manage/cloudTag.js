function delThis(idx) {

	var f = document.mfrm;

	if (confirm('삭제 하시겠습니까?\n\n삭제 후 복구할 수 없습니다.'))
	{
		f.intIDX.value = idx;
		f.mode.value = 'DELETE';
		f.submit();
	}

}


function chgView(idx,values) {

	var f = document.mfrm;

	if (confirm('노출상태를 변경하시겠습니까?'))
	{
		f.intIDX.value = idx;
		f.value1.value = values;
		f.mode.value = 'chgView';
		f.submit();
	}

}
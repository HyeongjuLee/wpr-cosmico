/*한글*/

function SelectAll(){
	var f = document.rFrm;
	if(f.allChk.checked){
		if (typeof f.chkCalcB.length == "undefined") {
			f.chkCalcB.checked = true;
		}
		else {
			for (i=0, len=f.chkCalcB.length; i<len; i++) {
				f.chkCalcB[i].checked = true;
			}
		}
	} else {
		if (typeof f.chkCalcB.length == "undefined") {
			f.chkCalcB.checked = false;
		}
		else {
			for (i=0, len=f.chkCalcB.length; i<len; i++) {
				f.chkCalcB[i].checked = false;
			}
		}
	}
}


function chkCalc(f) {
	if ($("form[name=rFrm] input[name=chkCalcB]:checked").length == 0)
	{
		alert("하나 이상 선택하셔야합니다");
		return false;
	}

	if (f.calcDate.value =='')
	{
		alert("정산하신 일자를 선택해주세요");
		f.calcDate.focus();
		return false;
	}


}
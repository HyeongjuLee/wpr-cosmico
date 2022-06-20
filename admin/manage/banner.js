function chkImg(f) {


		if (f.strImg.value == "") {
			alert("이미지를 선택해주세요.");
			f.strImg.focus();
			return false;
		} else {
			//if (!checkFileName(f.strImg)) return false;
			if (!checkFileExt(f.strImg, "jpg,gif,png", "이미지(jpg, gif,png) 파일만 선택해 주세요.")) return false;
		}


		if (f.strLink.value == '')
		{
			alert("검색어/링크 주소를 반드시 넣어주셔야합니다.");
			f.strLink.focus();
			return false;
		}


}

function submitThisLine(intIDX,mode,values) {
	var f = document.mfrm;


	if (confirm("변경하시겠습니까?"))
	{
		f.intIDX.value = intIDX;
		f.mode.value = mode;
		f.values.value = values;
		f.submit();
	}

}

function modifyThisLine(inputID,inputID2,intIDX,mode) {
	var f = document.mfrm;
	var vals = document.getElementById(inputID).value;
	var vals2 = document.getElementById(inputID2).value;

	if (confirm("변경하시겠습니까?"))
	{

		f.intIDX.value = intIDX;
		f.mode.value = mode;
		f.values.value = vals;
		f.values2.value = vals2;
		f.submit();
	}

}


function insertThisValue(item) {
	
	var f = document.jfrm;

	var objOption = item.options[item.selectedIndex];
	var value = objOption.value;
	var thisattr = objOption.getAttribute('thisattr');

	if (thisattr != "")	{
		f.isType.value = thisattr;
	} else {
		f.isType.value = "";	
	}
}

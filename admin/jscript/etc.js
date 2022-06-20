function frmChk() {
	var f = document.indexFrm;

	
	if (f.intLocation.value=="")
	{
		alert("필수값(위치)이 없습니다. 등록메뉴를 다시 클릭해주세요.");
		document.location.href='index_flash_ins.asp';
		return;
	}
	if (f.strPic.value=="")
	{
		alert("이미지를 선택하셔야합니다.");
		return;
	}
	if (f.intWidth.value=="")
	{
		alert("이미지 사이즈(가로)가 비어있습니다. 등록메뉴를 다시 클릭해주세요.");
		document.location.href='index_flash_ins.asp';
		return;
	}
	if (f.intHeight.value=="")
	{
		alert("이미지 사이즈(세로)가 비어있습니다. 등록메뉴를 다시 클릭해주세요.");
		document.location.href='index_flash_ins.asp';
		return;
	}
	if (f.intX.value=="")
	{
		alert("이미지의 좌표(가로)가 비어있습니다. 등록메뉴를 다시 클릭해주세요.");
		document.location.href='index_flash_ins.asp';
		return;
	}
	if (f.intY.value=="")
	{
		alert("이미지의 좌표(세로)가 비어있습니다. 등록메뉴를 다시 클릭해주세요.");
		document.location.href='index_flash_ins.asp';
		return;
	}

	f.submit();
}

function delConfirm(idx) {
	var f = document.delFrm;

	if (confirm("해당 이미지를 삭제하시겠습니까? ")) {
		f.intIDX.value = idx;
		f.submit();

	}

}

function frmChks() {
	var f = document.indexFrm;

	if (f.intIDX.value=="")
	{
		alert("필수값이 없습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}
	
	if (f.intLocation.value=="")
	{
		alert("필수값(위치)이 없습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}
	if (f.strPicOri.value=="")
	{
		alert("기존 이미지가 로딩되지 못했습니다.새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;

	}
	if (f.intWidth.value=="")
	{
		alert("이미지 사이즈(가로)가 비어있습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}
	if (f.intHeight.value=="")
	{
		alert("이미지 사이즈(세로)가 비어있습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}
	if (f.intX.value=="")
	{
		alert("이미지의 좌표(가로)가 비어있습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}
	if (f.intY.value=="")
	{
		alert("이미지의 좌표(세로)가 비어있습니다. 새로고침 후 수정버튼을 다시 클릭해주세요.");
		history.back();
		return;
	}

	f.submit();
}



function frmChkG() {
	var f = document.indexFrm;

	if (f.strPic.value=="")
	{
		alert("이미지를 선택하셔야합니다.");
		return;
	}


	f.submit();
}
function frmChkGM() {
	var f = document.indexFrm;


	f.action = "gallery_modOk.asp";
	f.submit();
}
function frmChkGD() {
	var f = document.indexFrm;

	if (confirm("삭제하시겠습니까??")) {
		f.action = "gallery_del.asp";
		f.submit();
	}
}




function chkPopupRegist(f) {

	if (f.popTitle.value == '')
	{
		alert("팝업타이틀을 입력해주세요. 팝업타이틀은 브라우저 제목으로 사용됩니다.");
		f.popTitle.focus();
		return false;
	}
	if (f.imgName.value == '')
	{
		alert("팝업이미지를 선택해주세요.");
		return false;
	}
	if (f.marginTop.value == '')
	{
		alert("팝업창이 열릴 위치(상단)을 PX(픽셀) 단위로 입력해주세요.");
		f.marginTop.focus();
		return false;
	}
	if (f.marginLeft.value == '')
	{
		alert("팝업창이 열릴 위치(좌측)을 PX(픽셀) 단위로 입력해주세요.");
		f.marginLeft.focus();
		return false;
	}
	if (f.popKind.value == '')
	{
		alert("팝업의 종류를 선택해주세요.");
		f.popKind.focus();
		return false;
	}


/*
	if (f.popKind.value == 'L')
	{
		if (f.linkType.value == '')
		{
			alert("팝업의 종류가 링크용팝업으로 설정되었습니다. 링크를 적용하실 윈도우(창)을 선택해주세요.");
			f.linkType.focus();
			return false;
		}
		if (f.linkUrl.value == '')
		{
			alert("팝업의 종류가 링크용팝업으로 설정되었습니다. 링크주소를 입력해주세요.");
			f.linkUrl.focus();
			return false;
		}
	}
*/



}


function chgLinkSelect() {
	var f = document.frms

	if (f.popKind.value == 'P' || f.popKind.value == '')
	{
		f.linkType.value='';
		f.linkType.disabled = true;
		f.linkType.style.backgroundColor = '#eee'

		f.linkUrl.value='';
		f.linkUrl.disabled = true;
		f.linkUrl.style.backgroundColor = '#eee'
	}
	if (f.popKind.value == 'L')
	{
		f.linkType.value='';
		f.linkType.disabled = false;
		f.linkType.style.backgroundColor = '#fff'

		f.linkUrl.value='';
		f.linkUrl.disabled = false;
		f.linkUrl.style.backgroundColor = '#fff'
	}



}



function counsel02Conf(idn){
	var f = document.frm;
	var msg = "해당 상담내용의 상태를 변경하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = "CHG";
		if (f.intIDX.value == "")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel02Handler.asp";
		f.submit();
	}

}

function counsel02Del(idn){
	var f = document.frm;
	var msg = "해당 상담내용을 삭제하시겠습니까? 삭제후 복구할 수 없습니다.";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = "DELETE";
		if (f.intIDX.value == "")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel02Handler.asp";
		f.submit();
	}
}

function counsel01Conf(idn){
	var f = document.frm;
	var msg = "해당 상담내용의 상태를 변경하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = "CHG";
		if (f.intIDX.value == "")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel01Handler.asp";
		f.submit();
	}

}

function counsel01Del(idn){
	var f = document.frm;
	var msg = "해당 상담내용을 삭제하시겠습니까? 삭제후 복구할 수 없습니다.";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = "DELETE";
		if (f.intIDX.value == "")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel01Handler.asp";
		f.submit();
	}
}



function counsel03View(idn) {

	var f = document.frm;
	f.intIDX.value = idn;
	if (f.intIDX.value == "")
	{
		alert("값이 옳바르게 전송되지 않았습니다.");
		return;
	}
	f.action = "counsel03View.asp";
	f.submit();
}




function replyChg() {
	var f = document.frm;
	var msg = "답변체크를 하시겠습니까?";
	if(confirm(msg)){
		f.mode.value = "CHG";
		if (f.intIDX.value == "" || f.mode.value=="")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel03Handler.asp";
		f.submit();
	}
}


function goList(idn) {
	var f = document.frm;
		f.intIDX.value = idn;
		f.action = "counsel03.asp";
		f.submit();
}


function counsel03Del(idn){
	var f = document.frm;
	var msg = "해당 상담내용을 삭제하시겠습니까? 삭제후 복구할 수 없습니다.";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = "DELETE";
		if (f.intIDX.value == "")
		{
			alert("값이 옳바르게 전송되지 않았습니다.");
			return;
		}
		f.action = "counsel03Handler.asp";
		f.submit();
	}
}


function phoneQnaView(idn){
	var f = document.frm;
	f.intIDX.value = idn;
	f.action = "phoneQnaView.asp";
	f.submit();

}
function chgReplyCont() {
	if (document.getElementById('chgReply').style.display == "block")
	{
		document.getElementById('chgReply').style.display = "none";
		document.getElementById('chgReplyBtn').style.display = "none";

	} else {
		document.getElementById('chgReply').style.display = "block"
		document.getElementById('chgReplyBtn').style.display = "inline-block";
	}

}


function delQna(idn) {
	var f = document.frm;
	var msg = "해당 상담내용을 삭제하시겠습니까? 삭제후 복구할 수 없습니다.";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = 'DELETE';
		f.action = "phoneQnaHandler.asp";
		f.submit();
	}
}

function goQnaList() {
	var f = document.frm;

	f.action = "phoneQna.asp";
	f.submit();

}

function updateQna(idn) {
	var f = document.frm;
	var msg = "해당 상담내용 입력(수정) 하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = 'UPDATE';
		f.contents.value = document.getElementById('answer').value;
		f.action = "phoneQnaHandler.asp";
		f.submit();
	}
}


function chgStatus(idn) {
	var f = document.frm;
	var msg = "해당 리뷰의 상태값을 변경 하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = 'STATUS';
		f.action = "phoneReviewHandler.asp";
		f.submit();
	}
}

function delReview(idn) {
	var f = document.frm;
	var msg = "해당 리뷰를 삭제 하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idn;
		f.mode.value = 'DELETE';
		f.action = "phoneReviewHandler.asp";
		f.submit();
	}
}

<!--

function thisfrm(f) {
	if (f.dtod.disabled == true || f.dtodDate.disabled == true || f.dtodnum.disabled == true)
	{
		alert("배송정보를 입력할 수 없습니다.\n배송중비중인 상품이 아닙니다.");
		return false;
	} else {
		if (f.dtod.value == "date")
			{
				if (f.dtodDate.value=="")
				{
					alert("배송일자만 입력하실 때는 배송일자를 반드시 입력해야합니다.\n입력형식은 2010-10-20 형식으로 입력하셔야 합니다.");
					f.dtodDate.focus();
					return false;
				}
			} else {
				if (f.dtod.value=="")
				{
					alert("배송업체를 선택해주세요.");
					f.dtod.focus();
					return false;

				}
				if (f.dtodnum.value=="")
				{
					alert("배송정보를 기입해주세요.");
					f.dtodnum.focus();
					return false;

				}

			}
	}
	f.target = 'hidden';
	f.action='chg_dtod.asp';
	f.submit();
/*
if (f.dtod.value == "date")
	{
		if (f.dtodDate.value=="")
		{
			alert("배송일자만 입력하실 때는 배송일자를 반드시 입력해야합니다.\n입력형식은 2010-10-20 형식으로 입력하셔야 합니다.");
			f.dtodDate.focus();
			return false;
		}
	} else {
		if (f.dtod.value=="")
		{
			alert("배송업체를 선택해주세요.");
			f.dtod.focus();
			return false;

		}
		if (f.dtodnum.value=="")
		{
			alert("배송정보를 기입해주세요.");
			f.dtodnum.focus();
			return false;

		}

	}
	*/
}

function goCancelBtn(uidx) {

	openPopup("chgCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}
function goCancelUBtn(uidx) {

	openPopup("chgUCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}

function go101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 입금을 확인하셨습니까?? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go101';
		f.submit();

	}
}

function go102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 배송을 하셨습니까? \n\n확인을 누르시면 해당 주문을 배송완료(거래완료)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go102';
		f.submit();

	}
}
function go103Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 거래완료상태로 변경하시겠습니까?")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go103';
		f.submit();

	}
}


function goCancelBtn(uidx) {

	openPopup("chgCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}

function back100Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 신규주문(입금확인전) 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 신규주문(입금확인전) 상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back100';
		f.submit();

	}
}
function back101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 입금확인 상태로 롤백하시겠습니까? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back101';
		f.submit();

	}
}


function back102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 배송완료 상태로 롤백 하시겠습니까? \n\n확인을 누르시면 해당 주문을 배송완료(배송중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back102';
		f.submit();

	}
}



function backc100Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 신규주문상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문은 신규주문(입금확인전)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc100';
		f.submit();

	}
}
function backc101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 입금확인 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc101';
		f.submit();

	}
}
function backc102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 배송완료 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 배송완료(배송중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc102';
		f.submit();

	}
}

//-->


var pf;

function init() {
	pf = document.frmConfirm;
	//pf.ORDERNO.value= getTimeStamp();
}

function fnSubmit() {
	//alert(document.charset);
	f = document.frmConfirm;

//alert(f.gopaymethod.value);

	document.getElementById("frmConfirm").acceptCharset = "UTF-8";

	if(trim(f.ORDERNO.value) == "" || getByteLen(f.ORDERNO.value) > 50) {
		alert("주문번호 (ORDERNO) 를 입력해주세요. (최대:50byte, 현재:" + getByteLen(f.ORDERNO.value) + ")");
		return false;
	}
	//상품구분
	if(trim(f.PRODUCTTYPE.value) == "" || getByteLen(f.PRODUCTTYPE.value) > 2) {
		alert("상품구분 (PRODUCTTYPE) 를 입력해주세요. (최대:2byte, 현재:" + getByteLen(f.PRODUCTTYPE.value) + ")");
		return false;
	}
	//과금유형
	if(trim(f.BILLTYPE.value) == "" || getByteLen(f.BILLTYPE.value) > 2) {
		alert("과금유형 (BILLTYPE) 를 입력해주세요. (최대:2byte, 현재:" + getByteLen(f.BILLTYPE.value) + ")");
		return false;
	}
	//결제금액
	if(trim(f.AMOUNT.value) == "" || getByteLen(f.AMOUNT.value) > 10) {
		alert("결제금액 (AMOUNT) 를 입력해주세요. (최대:10byte, 현재:" + getByteLen(f.AMOUNT.value) + ")");
		return false;

	}
	if (f.gAgreement.checked == false)
	{
		alert("정보제공에 동의하셔야합니다.");
		f.gAgreement.focus();
		return false;
	}
	if(f.PRODUCTNAME.value == "")  // 필수항목 체크 (상품명, 상품가격)
	{
		alert("상품명이 빠졌습니다. 필수항목입니다.");
		return false;
	}
	if (f.infoType.value == 'N')
	{
		if (chkEmpty(f.takeName))
		{
			alert("받는분 성함이 비어있습니다");
			f.takeName.focus();
			return false;
		}

		//if (chkEmpty(f.takeMob1) || chkEmpty(f.takeMob2) || chkEmpty(f.takeMob3))
		if (chkEmpty(f.takeMobile))
		{
			alert("휴대폰 연락처가 비어있습니다");
			f.takeMobile.focus();
			return false;
		} else {
			f.TELNO1.value = f.takeTel.value;
			f.TELNO2.value = f.takeMobile.value;
			//f.TELNO1.value = f.takeTel1.value +"-"+ f.takeTel2.value +"-"+ f.takeTel3.value;
			//f.TELNO2.value = f.takeMob1.value +"-"+ f.takeMob2.value +"-"+ f.takeMob3.value;
		}
		//f.EMAIL.value = f.strEmail.value;

		if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2)) {
			alert("주문자 주소가 비어있습니다");
			f.takeZip.focus();
			return false;
		}


	}


	if (f.gAgreement.checked == false)
	{
		alert("정보제공에 동의하셔야합니다.");
		f.gAgreement.focus();
		return false;
	}

	if (typeof(f.v_SellCode) != "undefined")
	{
		if (f.v_SellCode.value == '')
		{
			alert("CS회원의 경우 CS연동상품을 구입시 구매종류를 선택하셔야합니다.");
			f.v_SellCode.focus();
			return false;
		}
	}
	if (typeof(f.SalesCenter) != "undefined")
	{
		if (f.SalesCenter.value == '')
		{
			alert("CS회원의 경우 CS연동상품을 구입시 판매센터를 선택하셔야합니다.");
			f.SalesCenter.focus();
			return false;
		}
	}


	//alert(f.gopaymethod.value);
	//return false;

	if (f.gopaymethod.value == 'inBank')
	{
		if ($("input[name=bankidx]:checked").length == 0)
		{
			alert("온라인 입금시 결제 은행을 선택해주셔야합니다.");
			return false;
		}
		if (f.bankingName.value == '')
		{
			alert("온라인 입금시 입금자명을 입력해 주셔야합니다.");
			f.bankingName.focus();
			return false;
		}
		if (f.memo1.value =='')
		{
			alert("온라인 입금시 입금예정일을 입력하셔야합니다.");
			f.memo1.focus();
			return false;
		}

		f.target = "_self";
		document.charset = "UTF-8";
		f.action = "/PG/inbank_Result_Mobile.asp";
		f.submit();
	}





	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card')
	{
	//alert(f.gopaymethod.value);
	//return false;

		var valData = ""
		// 데이터 스플릿을 위해 특수문자 제거
		//f.strName.value = f.strName.value.replaceAll(':','')

		valData += f.takeName.value.replaceAll('☞','');
		valData += "☞"+f.takeTel1.value.replaceAll('☞','')+"-"+f.takeTel2.value.replaceAll('☞','')+"-"+f.takeTel3.value.replaceAll('☞','');
		valData += "☞"+f.takeZip.value.replaceAll('☞','');
		valData += "☞"+f.takeADDR1.value.replaceAll('☞','');
		valData += "☞"+f.takeADDR2.value.replaceAll('☞','');

		valData += "☞"+f.totalPrice.value.replaceAll('☞','');
		valData += "☞"+f.totalDelivery.value.replaceAll('☞','');
		valData += "☞"+f.totalOptionPrice.value.replaceAll('☞','');
		valData += "☞"+f.totalPoint.value.replaceAll('☞','');
		valData += "☞"+f.orderMemo.value.replaceAll('☞','');


		valData += "☞"+f.input_mode.value.replaceAll('☞','');
		valData += "☞"+f.strOption.value.replaceAll('☞','');
		valData += "☞"+f.totalVotePoint.value.replaceAll('☞','');
		valData += "☞"+f.cuidx.value.replaceAll('☞','');
		valData += "☞"+f.gopaymethod.value.replaceAll('☞','');

		valData += "☞"+f.useCmoney.value.replaceAll('☞','');
		valData += "☞"+f.totalOptionPrice2.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_ID.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_ID1.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_ID2.value.replaceAll('☞','');

		valData += "☞"+f.Daou_MEMBER_WEBID.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_NAME.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_LEVEL.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_TYPE.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_STYPE.value.replaceAll('☞','');

		valData += "☞"+f.isSpecialSell.value.replaceAll('☞','');
		valData += "☞"+f.CSGoodCnt.value.replaceAll('☞','');
		valData += "☞"+f.v_SellCode.value.replaceAll('☞','');
		valData += "☞"+f.SalesCenter.value.replaceAll('☞','');
		valData += "☞"+f.infoType.value.replaceAll('☞','');

		//valData += "☞"+f.DtoD.value.replaceAll('☞','');
		if (f.Daou_MEMBER_STYPE.value == "0")
		{
			valData += "☞"+$("input[name=DtoD]:checked").val();
		} else {
			valData += "☞"+f.DtoD.value.replaceAll('☞','');
		}

		if (f.input_mode.value == 'direct')
		{
			valData += "☞"+f.ea.value.replaceAll('☞','');
		} else {
			valData += "☞0";
		}
		valData += "☞"+f.takeMob1.value.replaceAll('☞','')+"-"+f.takeMob2.value.replaceAll('☞','')+"-"+f.takeMob3.value.replaceAll('☞','');




		f.RESERVEDSTRING.value = valData;
		f.RESERVEDINDEX1.value = f.OrdNo.value;
		f.RESERVEDINDEX2.value = f.USERID.value;
		//alert(getByteLen(f.RESERVEDSTRING.value));

		//document.charset = "euc-kr";
		//alert(document.charset);
			var fileName;
			fileName = "https://ssl.daoupay.com/m/creditCard_ssl/DaouCreditCardMng.jsp";
			document.charset = "euc-kr";
			document.getElementById("frmConfirm").acceptCharset = "euc-kr";

			DAOUPAY = window.open("", "DAOUPAY", "width=469,height=507");
			DAOUPAY.focus();

			f.target = "DAOUPAY";
			f.action = fileName;
			f.method = "post";
			//alert(f.method);
			f.submit();
		//document.charset = "utf-8";
	}






}

function chgPay(str){
	var f = document.frmConfirm;
	f.gopaymethod.value = str;
	switch (str)
	{
		case "inBank" : {
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"block"});
			break;
		}
		case "Card" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"block"});
			break;
		}

	}

}

function fnCheck() {

	var frm = document.frmConfirm;

	//주문번호
	if(trim(frm.ORDERNO.value) == "" || getByteLen(frm.ORDERNO.value) > 50) {
		alert("주문번호 (ORDERNO) 를 입력해주세요. (최대:50byte, 현재:" + getByteLen(frm.ORDERNO.value) + ")");
		return;
	}
	//상품구분
	if(trim(frm.PRODUCTTYPE.value) == "" || getByteLen(frm.PRODUCTTYPE.value) > 2) {
		alert("상품구분 (PRODUCTTYPE) 를 입력해주세요. (최대:2byte, 현재:" + getByteLen(frm.PRODUCTTYPE.value) + ")");
		return;
	}
	//과금유형
	if(trim(frm.BILLTYPE.value) == "" || getByteLen(frm.BILLTYPE.value) > 2) {
		alert("과금유형 (BILLTYPE) 를 입력해주세요. (최대:2byte, 현재:" + getByteLen(frm.BILLTYPE.value) + ")");
		return;
	}
	//결제금액
	if(trim(frm.AMOUNT.value) == "" || getByteLen(frm.AMOUNT.value) > 10) {
		alert("결제금액 (AMOUNT) 를 입력해주세요. (최대:10byte, 현재:" + getByteLen(frm.AMOUNT.value) + ")");
		return;

	}
	/********************  필수 입력 체크 끝  ***/
}


function trim(txt) {
	while (txt.indexOf(' ') >= 0) {
		txt = txt.replace(' ','');
	}
	return txt;
}

function getTimeStamp() {
	var d = new Date();
	var month = d.getMonth() + 1;
	var date = d.getDate();
	var hour = d.getHours();
	var minute = d.getMinutes();
	var second = d.getSeconds();

	month = (month < 10 ? "0" : "") + month;
	date = (date < 10 ? "0" : "") + date;
	hour = (hour < 10 ? "0" : "") + hour;
	minute = (minute < 10 ? "0" : "") + minute;
	second = (second < 10 ? "0" : "") + second;

	var s = d.getFullYear() + month + date + hour + minute + second;

	return s;
}

function getByteLen(p_val) {
	var onechar;
	var tcount = 0;

	for(i = 0; i < p_val.length; i++) {
		onechar = p_val.charAt(i);
		if(escape(onechar).length > 4)
			tcount += 2;
		else if(onechar != '\r')
			tcount++;
	}
	return tcount;
}

function fnNumCheck() {
	if(event.keyCode >= 48 && event.keyCode <= 57)
		event.returnValue = true;
	else
		event.returnValue = false;
}








// 결제금액 계산
function calcSettlePrice() {
	var f = document.frm;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

	f.Amt.value = settlePrice;
	document.getElementById("showSettlePrice").innerHTML = formatComma(settlePrice);
}


// # 적립금 사용 : 시작 ######################################################################
function changeUseCmoney(item) {
	var f = document.frm;

	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);

	if (ownCmoney < cmoneyUseLimit) {
		alert("적립금 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.");
		item.checked = false;
	}
	else if (ownCmoney < cmoneyUseMin) {
		alert("적립금은 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.");
		item.checked = false;
	}

	if (item.checked) {
		f.useCmoney.disabled = false;
		f.useCmoney.style.backgroundColor = "#FFFFFF";
	}
	else {
		f.useCmoney.value = "";
		f.useCmoney.style.backgroundColor = "#F0F0F0";
		f.useCmoney.disabled = true;

		resetUseCmoney();
	}

	calcSettlePrice();
}

function checkUseCmoney(item){
	var f = document.frm;
	var msg;

	if (!f.isUseCmoney.checked){
		item.value = "";
		alert("적립금 사용을 먼저 체크해주세요.");
		return false;
	}

	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;

	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);

	if (useCmoney <= 0) {
		msg = "사용할 적립금을 입력해 주세요.";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = "적립금 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney < cmoneyUseMin) {
		msg = "적립금은 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney > cmoneyUseMax) {
		msg = "적립금은 최대 "+formatComma(cmoneyUseMax)+" 원 이하까지 사용가능합니다.";
	}
	else if (useCmoney > ownCmoney) {
		msg = "보유 하신 적립금보다 많은 금액을 입력하셨습니다.";
	}
	else if (useCmoney > settlePrice) {
		msg = "결제금액보다 많이 입력하셨습니다.";
	}
	else {
		isUseCmoney = true;
	}

	if (isUseCmoney) {
		document.getElementById("showTotalCmoney").innerHTML = "-"+formatComma(useCmoney);
	}
	else {
		alert(msg);
		item.value = "0";

		resetUseCmoney();
	}

	calcSettlePrice();
}

function resetUseCmoney() {
	var f = document.frm;

	document.getElementById("showTotalCmoney").innerHTML = "0";
}
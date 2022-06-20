//마이오피스 본인 직하선 구매
var pf;

function init() {
	pf = document.frmConfirm
	//pf.ORDERNO.value= getTimeStamp();
}

function fnSubmit() {
	//alert(document.charset);
	f = document.frmConfirm;

//alert(f.gopaymethod.value);



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

	if(f.PRODUCTNAME.value == "")  // 필수항목 체크 (상품명, 상품가격)
	{
		alert("상품명이 빠졌습니다. 필수항목입니다.");
		return false;
	}


	if (chkEmpty(f.cuidx)) {
		alert("주문상품 정보가 올바르지 않습니다.");
		return false;
	}
	//추가!!
	if (chkEmpty(f.DownMemID1) || chkEmpty(f.DownMemID2))
	{
		alert("매출등록시킬 하선회원 아이디가 입력되지 않았습니다.\n\n이전페이지로 돌아갑니다.");
		history.go(-1);  
		return false;
	}
	
	if (chkEmpty(f.takeName)) {
		alert("주문자 성함이 비어있습니다");
		f.takeName.focus();
		return false;
	}
	if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
	{
		alert("주문자 주소가 비어있습니다");
		f.takeZip.focus();
		return false;
	}
	if (chkEmpty(f.strEmail)) {
		alert("이메일 주소를 입력해 주세요.");
		f.strEmail.focus();
		return false;
	} else {
		if (!checkEmail(f.strEmail.value)) {
			alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
			f.strEmail.focus();
			return false;
		} else {
			f.EMAIL.value = f.strEmail.value;
		}
	}
	if (chkEmpty(f.takeMob1) || chkEmpty(f.takeMob2) || chkEmpty(f.takeMob3))
	{
		alert("주문자 연락처가 비어있습니다");
		f.takeMob1.focus();
		return false;
	} else {
		f.TELNO1.value = f.takeMob1.value +"-"+ f.takeMob2.value +"-"+ f.takeMob3.value;
	}

	if (chkEmpty(f.takeTel1) || chkEmpty(f.takeTel2) || chkEmpty(f.takeTel3)) {
		alert("받는분의 연락처가 비어있습니다");
		f.takeTel1.focus();
		return false;
	} else {
		f.TELNO2.value = f.takeTel1.value+"-"+f.takeTel2.value+"-"+f.takeTel3.value;
	}
	if (chkEmpty(f.v_SellCode)) {
		alert("구매종류를 선택해주세요.DAOU_CS2");
		f.v_SellCode.focus();
		return false;
	}

	if (f.gopaymethod.value == '')
	{
		alert("결제할 방식을 선택해주세요.DAOU_CS2");
		return false;
	}
	//alert(f.gopaymethod.value);
	//return false;

	if (f.gopaymethod.value == 'inBank')
	{
			if (f.C_codeName.value =='')
			{
				alert("무통장입금 방식의 경우 입금은행을 선택하셔야합니다.");
				f.C_codeName.focus();
				return false;
			}
			if (f.C_NAME2.value =='')
			{
				alert("무통장입금 방식의 경우 입금자 이름을 입력하셔야합니다.");
				f.C_NAME2.focus();
				return false;
			}
			if (f.memo1.value =='')
			{
				alert("무통장입금 방식의 경우 입금예정일을 입력하셔야합니다.");
				f.memo1.focus();
				return false;
			}
		f.target = "_self";
		document.charset = "UTF-8";
		f.action = "/PG/inbank_Result_cs_down.asp";			//하선 소비자 구매 처리페이지
	}


	if (f.gopaymethod.value == 'Card')
	{
		var valData = ""
		// 데이터 스플릿을 위해 특수문자 제거
		//f.strName.value = f.strName.value.replaceAll(':','')

		valData += f.takeName.value.replaceAll('☞','');

		valData += "☞"+f.mbid1.value.replaceAll('☞','');
		valData += "☞"+f.mbid2.value.replaceAll('☞','');
		valData += "☞"+f.takeTel1.value.replaceAll('☞','')+"-"+f.takeTel2.value.replaceAll('☞','')+"-"+f.takeTel3.value.replaceAll('☞','');
		valData += "☞"+f.takeMob1.value.replaceAll('☞','')+"-"+f.takeMob2.value.replaceAll('☞','')+"-"+f.takeMob3.value.replaceAll('☞','');
		valData += "☞"+f.strEmail.value.replaceAll('☞','');

		valData += "☞"+f.takeZip.value.replaceAll('☞','');
		valData += "☞"+f.takeADDR1.value.replaceAll('☞','');
		valData += "☞"+f.takeADDR2.value.replaceAll('☞','');
		valData += "☞"+f.totalPrice.value.replaceAll('☞','');
		valData += "☞"+f.totalDelivery.value.replaceAll('☞','');		//10

		valData += "☞"+f.totalOptionPrice.value.replaceAll('☞','');
		valData += "☞"+f.totalPoint.value.replaceAll('☞','');
		valData += "☞"+f.strOption.value.replaceAll('☞','');
		valData += "☞"+f.totalVotePoint.value.replaceAll('☞','');
		valData += "☞"+f.cuidx.value.replaceAll('☞','');				//'카트 idx

		valData += "☞"+f.gopaymethod.value.replaceAll('☞','');
		valData += "☞"+f.v_SellCode.value.replaceAll('☞','');
		valData += "☞"+f.isDownOrder.value.replaceAll('☞','');		//18	본인구매 F(하선구매 T)

		/*

		valData += "||"+f.strName.value;
		valData += "||"+f.strName.value;
		*/


		//f.RESERVEDSTRING.value = encodeURIComponent(valData);
		//alert(encodeURIComponent("BC%C4%AB%B5%E5"));
		f.RESERVEDSTRING.value = valData;
		f.RESERVEDINDEX1.value = f.OrdNo.value;				//주문번호
		f.RESERVEDINDEX2.value = f.OIDX.value;				//OIDX
		//alert(getByteLen(f.RESERVEDSTRING.value));

		document.charset = "euc-kr";
		//alert(document.charset);
			var fileName;
			fileName = "https://ssl.daoupay.com/creditCard/DaouCreditCardMng.jsp";
		//	fileName = "https://ssltest.daoupay.com/creditCard/DaouCreditCardMng.jsp";

			DAOUPAY = window.open("", "DAOUPAY", "width=469,height=507");
			DAOUPAY.focus();

			pf.target = "DAOUPAY";
			pf.action = fileName;
			pf.method = "post";
		//	pf.submit();
		//document.charset = "utf-8";
	}






}


function payKindSelect(str){
	var f = document.frmConfirm;
	f.gopaymethod.value = str;
		if (str == 'inBank') {
			document.getElementById("inBankInfo").style.display = ""
		}else{
			document.getElementById("inBankInfo").style.display = "none"
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


function openzip(target) {
	openPopup("/common/pop_Zipcode.asp?target="+target, "Zipcode", 100, 100, "left=200, top=200");
}

// 받는분 정보 복사
function infoCopy(item) {
	var f = document.frmConfirm;

	if (item.checked) {
		f.takeName.value = f.strName.value;
		f.takeTel1.value = f.strTel1.value;
		f.takeTel2.value = f.strTel2.value;
		f.takeTel3.value = f.strTel3.value;
		f.takeMob1.value = f.strMob1.value;
		f.takeMob2.value = f.strMob2.value;
		f.takeMob3.value = f.strMob3.value;
		f.takeZip.value = f.strZip.value;
		f.takeADDR1.value = f.strADDR1.value;
		f.takeADDR2.value = f.strADDR2.value;
	}
	else {
		f.takeName.value = '';
		f.takeTel1.value = '';
		f.takeTel2.value = '';
		f.takeTel3.value = '';
		f.takeMob1.value = '';
		f.takeMob2.value = '';
		f.takeMob3.value = '';
		f.takeZip.value = '';
		f.takeADDR1.value = '';
		f.takeADDR2.value = '';
	}
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
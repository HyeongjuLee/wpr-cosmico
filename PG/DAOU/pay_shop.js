//SHOP 쇼핑몰구매
var pf;
var pointTXT = "마일리지";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;

function init() {
	pf = document.frmConfirm
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
	if(f.PRODUCTNAME.value == "")  // 필수항목 체크 (상품명, 상품가격)
	{
		alert("상품명이 빠졌습니다. 필수항목입니다.");
		return false;
	}
	if (chkEmpty(f.strName))
	{
		alert("주문자 성함이 비어있습니다1");
		f.strName.focus();
		return false;
	}

	//if (chkEmpty(f.strMob1) || chkEmpty(f.strMob2) || chkEmpty(f.strMob3))
	if (chkEmpty(f.strMobile))
	{
		alert("주문자 핸드폰번호(연락처)가 비어있습니다");
		f.strMobile.focus();
		return false;
	} else {
		f.TELNO1.value = f.strMobile.value;
		//f.TELNO1.value = f.strMob1.value +"-"+ f.strMob2.value +"-"+ f.strMob3.value;
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

	if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2)) {
		alert("주문자 주소가 비어있습니다");
		f.strZip.focus();
		return false;
	}
	//표준완성형 한글체크
	if (checkkorText2350(f.strADDR1.value)) {
		f.strADDR1.focus();
		return false;
	}
	if (checkkorText2350(f.strADDR2.value)) {
		f.strADDR2.focus();
		return false;
	}


	if (chkEmpty(f.takeName)) {
		alert("받는분의 성함이 비어있습니다.");
		f.takeName.focus();
		return false;
	}
	//if (chkEmpty(f.takeMob1) || chkEmpty(f.takeMob2) || chkEmpty(f.takeMob3)) {
	if (chkEmpty(f.takeMobile)) {
		alert("받는분의 핸드폰번호(연락처)가 비어있습니다");
		f.takeMobile.focus();
		return false;
	} else {
		f.TELNO2.value = f.takeMobile.value;
		//f.TELNO2.value = f.takeMob1.value+"-"+f.takeMob2.value+"-"+f.takeMob3.value;
	}

	if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
	{
		alert("받는분의 주소가 비어있습니다");
		f.takeZip.focus();
		return false;
	}
	//표준완성형 한글체크
	if (checkkorText2350(f.takeADDR1.value)) {
		f.takeADDR1.focus();
		return false;
	}
	if (checkkorText2350(f.takeADDR2.value)) {
		f.takeADDR2.focus();
		return false;
	}
	if (f.orderMemo.value != "")
	{
		if (checkkorText2350(f.orderMemo.value)) {
			f.orderMemo.focus();
			return false;
		}
	}

	//alert(f.gopaymethod.value);
	//return false;

	//CS연동상품선택시
	if (f.Daou_MEMBER_STYPE.value == "0" || f.Daou_MEMBER_STYPE.value == "1")	//CS판매원 ,스피나 소비자 추가
	{
		if (f.v_SellCode.value == '')
		{
			alert("구매종류를 선택하셔야합니다.");
			f.v_SellCode.focus();
			return false;
		}
		if (f.DtoD.value == '')
		{
			alert("수령방식을 선택해주세요");
			f.DtoD.focus();
			return false;
		}
		/*
		if (f.SalesCenter.value == '')
		{
			alert("CS회원의 경우 CS연동상품을 구입시 판매센터를 선택하셔야합니다.");
			f.SalesCenter.focus();
			return false;
		}
		*/

	}


	if (f.gopaymethod.value == '')
	{
		alert("결제할 방식을 선택해주세요..");
		return false;
	}

	if (f.gopaymethod.value == 'inBank')
	{
		//마일리지단독결제취소후 무통장선택시 체크
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			return false;
		}

		if ($("input[name=bankidx]:checked").length == 0)
		{
			alert("온라인 입금시 결제 은행을 선택해주셔야합니다.1");
			//f.bankidx.focus();
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
		f.action = "/PG/inBank_Result.asp";
		document.getElementById("frmConfirm").acceptCharset = "utf-8";

	}

	if (f.gAgreement.checked == false)
	{
		alert("정보제공에 동의하셔야합니다 .");
		f.gAgreement.focus();
		return false;
	}

	//▣마일리지 단독 결제▣
	if (f.gopaymethod.value == 'point')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		f.useCmoney.value = formatComma(orgSettlePrice);
		var thisTimer
		checkUseCmoney();
		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			document.charset = "UTF-8";

			if (confirm(pointTXT + " 단독결제를 진행하시겠습니까?")) {
				f.action = "/PG/point_Result.asp";
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')
	{
	//alert(f.gopaymethod.value);
	//return false;

		var valData = ""
		// 데이터 스플릿을 위해 특수문자 제거
		//f.strName.value = f.strName.value.replaceAll(':','')

		if (f.totalPrice.value < 1000){
			var msg;

			if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card'){
				msg ="카드";
			} else if (f.gopaymethod.value == 'vBank'){
				msg = "가상계좌";
			} else if (f.gopaymethod.value == 'dBank'){
				msg = "실시간계좌이체";
			}
			alert(msg+" 결제시 결제금액이 최소 1000원 이상이어야 합니다!!");
			f.useCmoney.value = 0;
			calcSettlePrice();
			return false;
		}

		valData	+= f.strName.value.replaceAll('☞','');

		//valData += "☞"+f.strTel1.value.replaceAll('☞','')+"-"+f.strTel2.value.replaceAll('☞','')+"-"+f.strTel3.value.replaceAll('☞','');
		//valData += "☞"+f.strMob1.value.replaceAll('☞','')+"-"+f.strMob2.value.replaceAll('☞','')+"-"+f.strMob3.value.replaceAll('☞','');
		valData += "☞"+f.strTel.value.replaceAll('☞','');
		valData += "☞"+f.strMobile.value.replaceAll('☞','');
		valData += "☞"+f.strEmail.value.replaceAll('☞','');
		valData += "☞"+f.strZip.value.replaceAll('☞','');
		valData += "☞"+f.strADDR1.value.replaceAll('☞','');
		valData += "☞"+f.strADDR2.value.replaceAll('☞','');

		valData += "☞"+f.takeName.value.replaceAll('☞','');
		//valData += "☞"+f.takeTel1.value.replaceAll('☞','')+"-"+f.takeTel2.value.replaceAll('☞','')+"-"+f.takeTel3.value.replaceAll('☞','');
		//valData += "☞"+f.takeMob1.value.replaceAll('☞','')+"-"+f.takeMob2.value.replaceAll('☞','')+"-"+f.takeMob3.value.replaceAll('☞','');
		valData += "☞"+f.takeTel.value.replaceAll('☞','');
		valData += "☞"+f.takeMobile.value.replaceAll('☞','');
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

		valData += "☞"+stripComma(f.useCmoney.value).replaceAll('☞','');
		valData += "☞"+f.totalOptionPrice2.value.replaceAll('☞','');

		//CS연동회원변수
		valData += "☞"+f.Daou_MEMBER_ID.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_ID1.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_ID2.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_WEBID.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_NAME.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_LEVEL.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_TYPE.value.replaceAll('☞','');
		valData += "☞"+f.Daou_MEMBER_STYPE.value.replaceAll('☞','');			//Sell_Mem_TF
		valData += "☞"+f.Daou_MEMBER_NATIONCODE.value.replaceAll('☞','');		//Daou_MEMBER_NATIONCODE

		valData += "☞"+f.isSpecialSell.value.replaceAll('☞','');
		valData += "☞"+f.CSGoodCnt.value.replaceAll('☞','');
		valData += "☞"+f.v_SellCode.value.replaceAll('☞','');
		valData += "☞"+f.SalesCenter.value.replaceAll('☞','');				//판매센터
		valData += "☞"+f.DtoD.value.replaceAll('☞','');

		if (f.input_mode.value == 'direct')
		{
			valData += "☞"+f.ea.value.replaceAll('☞','');
		} else {
			valData += "☞0";
		}





		//f.RESERVEDSTRING.value = encodeURIComponent(valData);
		//alert(encodeURIComponent("BC%C4%AB%B5%E5"));
		f.RESERVEDSTRING.value = valData;						//예약항목
		//f.RESERVEDINDEX1.value = f.OrdNo.value;					//주문번호
		f.RESERVEDINDEX1.value = 'SHOP';						//▣주문페이지 (SHOP)
		f.RESERVEDINDEX2.value = f.USERID.value;				//DK_MEMBER_ID
		//alert(getByteLen(f.RESERVEDSTRING.value));

		document.charset = "euc-kr";
		document.getElementById("frmConfirm").acceptCharset = "euc-kr";
		//alert(document.charset);

			var fileName;

			if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' ) {
				//alert(3);
				fileName = "https://ssl.daoupay.com/creditCard/DaouCreditCardMng.jsp";				//실결제
				//fileName = "https://ssltest.daoupay.com/creditCard/DaouCreditCardMng.jsp";
				DAOUPAY = window.open("", "DAOUPAY", "width=469,height=507");
			//	alert(22);
			} else if (f.gopaymethod.value == 'vBank'){
				fileName = "http://ssl.daoupay.com/vaccount/DaouVaccountMng.jsp";
				DAOUPAY = window.open("", "DAOUPAY", "width=473,height=538");

			} else if (f.gopaymethod.value == 'dBank') {
				fileName = "http://ssl.daoupay.com/bank/DaouBankMng.jsp";
				DAOUPAY = window.open("", "DAOUPAY", "width=473,height=480");

				//document.charset = form.acceptCharset;
				//return false;
			}
			//DAOUPAY = window.open("", "DAOUPAY", "width=469,height=507");
			DAOUPAY.focus();

			pf.target = "DAOUPAY";
			pf.action = fileName;
			pf.method = "post";
		//	pf.submit();
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
			f.CPID.value = f.CPID_CARD.value;
			f.PRODUCTTYPE.value = '2';
			break;
		}
		case "point" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "vBank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			f.CPID.value = f.CPID_VBANK.value;
			f.PRODUCTTYPE.value = '1';		//상품구분 - 다우페이와 계약시 지정(가맹점정보와 다우페이 내부정보가 일치해야함)
			break;
		}
		case "dBank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			f.CPID.value = f.CPID_DBANK.value;
			f.PRODUCTTYPE.value = '2';		//1:디지털, 2:실물
			break;
		}
		//default :{
		//}
	}

}

//카드종류구분
function chgCardKind(str){
	var f = document.frmConfirm;
	switch (str)
	{
		case "P" : {						//일반신용
			$("#CardKind01").css({"display":"block"});
			$("#CardKind02").css({"display":"none"});
			//$("#CardKind03").css({"display":"none"});
			f.CorporateNumber.value = '';
			//f.ssh1.value = '';
			//f.ssh2.value = '';
			break;
		}
		case "C" : {
			$("#CardKind01").css({"display":"none"});
			$("#CardKind02").css({"display":"block"});
			//$("#CardKind03").css({"display":"none"});
			f.birthYY.value = '';
			f.birthMM.value = '';
			f.birthDD.value = '';
			//f.ssh1.value = '';
			//f.ssh2.value = '';
			break;
		}
		case "I" : {						//일반신용
			$("#CardKind01").css({"display":"block"});
			$("#CardKind02").css({"display":"none"});
			//$("#CardKind03").css({"display":"none"});
			f.CorporateNumber.value = '';
			//f.ssh1.value = '';
			//f.ssh2.value = '';
			break;
		}
		/*
		case "I" : {									//DAOU API 수기결제
			$("#CardKind01").css({"display":"none"});
			$("#CardKind02").css({"display":"none"});
			$("#CardKind03").css({"display":"block"});
			f.birthYY.value = '';
			f.birthMM.value = '';
			f.birthDD.value = '';
			f.CorporateNumber.value = '';
			break;
		}
		*/
		//default :{
		//}
	}

}

function chgDelivery(DtoD) {
	var price = $("input[name=ori_price]").val() * 1;
	var deliFee = $("input[name=ori_delivery]").val() * 1;
	var useCmoney = $("input[name=useCmoney]").val() * 1;
	if (DtoD == 'F')
	{
		$("input[name=totalPrice]").val((price - deliFee) * 1);
		$("input[name=AMOUNT]").val((price - deliFee) * 1);			//다우결제금액
		$("input[name=totalDelivery]").val(0);
		$("#priTXT").html("<strong>직접수령 : 0</strong> 원");
		$("#LastAreaID, #payArea").text(formatComma((price - deliFee) * 1));
		$("#DeliveryAreaID").text(formatComma((price - deliFee) * 0));
		$("input[name=useCmoney]").val(0);							//마일리지초기화
		//calcSettlePrice();
	} else {
		$("input[name=totalPrice]").val(price);
		$("input[name=AMOUNT]").val(price);							//다우결제금액
		$("input[name=totalDelivery]").val(deliFee);
		$("#priTXT").html("<strong>"+formatComma(deliFee)+"</strong> 원");
		$("#LastAreaID, #payArea").text(formatComma(price));
		$("#DeliveryAreaID").text(formatComma(deliFee));

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
		f.takeTel.value = f.strTel.value;
		f.takeMobile.value = f.strMobile.value;
		f.takeZip.value = f.strZip.value;
		f.takeADDR1.value = f.strADDR1.value;
		f.takeADDR2.value = f.strADDR2.value;
	}
	else {
		f.takeName.value = '';
		f.takeTel.value = '';
		f.takeMobile.value = '';
		f.takeZip.value = '';
		f.takeADDR1.value = '';
		f.takeADDR2.value = '';
	}
}



// # 적립금 사용 : 시작 ######################################################################
function checkUseCmoney(item){
	var f = document.frmConfirm;
	var msg;

//alert(f.ownCmoney.value);

/*
	if (!f.isUseCmoney.checked){
		item.value = "";
		alert("적립금 사용을 먼저 체크해주세요.");
		return false;
	}
*/
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	//alert(useCmoney);

	if (useCmoney <= 0) {
		msg = "사용할 "+ pointTXT +"를 입력해 주세요.";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
	}
	else if (useCmoney < cmoneyUseMin) {
		msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
	}
/*
	else if (useCmoney > cmoneyUseMax) {
		msg = "적립금은 최대 "+formatComma(cmoneyUseMax)+" 원 이하까지 사용가능합니다.";
	}
*/
	//▣카드결제시 카드결제최소금액 체크▣
	else if ((useCmoney > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
		msg = "카드/가상계좌 결제시 결제금액이 최소 1000원 이상이어야 합니다.";
		//msg = "적립금은 최대 "+formatComma(cmoneyUseMax-50)+" 원 이하까지 사용가능합니다.";
	}
	else if (useCmoney > ownCmoney) {
		msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.";
	}
	else if (useCmoney > settlePrice) {
		msg = "결제금액보다 많이 입력하셨습니다.";
	}
	else {
		isUseCmoney = true;
	}
/*
	if (isUseCmoney) {
		document.getElementById("showTotalCmoney").innerHTML = "-"+formatComma(useCmoney);
	}
	else {
		alert(msg);
		item.value = "0";

		resetUseCmoney();
	}
	calcSettlePrice();
*/

	if (isUseCmoney) {
		calcSettlePrice();
		ThisMileage = true;
	}
	else {
		alert(msg);
		f.useCmoney.value = 0;
		calcSettlePrice();
		ThisMileage = false;
		return false;
	}

}


// 결제금액 계산
function calcSettlePrice() {
	var f = document.frmConfirm;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var ori_delivery = parseInt(f.ori_delivery.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

	//직접수령
	if (f.DtoD.value == "F") {
		settlePrice = settlePrice - ori_delivery;
	}

//	f.Amt.value = settlePrice;
//	document.getElementById("showSettlePrice").innerHTML = formatComma(settlePrice);
	f.totalPrice.value = settlePrice;
	f.AMOUNT.value = settlePrice;

	document.getElementById("LastAreaID").innerHTML = formatComma(settlePrice);
	document.getElementById("payArea").innerHTML = formatComma(settlePrice);
	//document.getElementById("PointAreaID").innerHTML = formatComma(useCmoney);
	document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}




function resetUseCmoney() {
	var f = document.frmConfirm;

	document.getElementById("showTotalCmoney").innerHTML = "0";
}
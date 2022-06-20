//마이오피스 본인 구매
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

	document.getElementById("frmConfirm").acceptCharset = "utf-8";


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
	if (chkEmpty(f.takeName)) {
		//alert("받는분의 성함이 비어있습니다11");
		alert("订购人姓名为空。");
		f.takeName.focus();
		return false;
	}

	if ($("input[name=totalPrice]").val() > 0)	{
		alert('총 결제금액보다 입력한 포인트금액이 부족합니다.\n\n포인트를 정확하게 입력해주세요.')
		f.useCmoney.focus();
		return false;
	}

	//택배수령일경우만 체크
	if ($("input[name=DtoD]:checked").val() != 'F')	{
		if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
		{
			//alert("받는분의 주소가 비어있습니다2");
			alert("收货人地址为空。");
			f.takeZip.focus();
			return false;
		}
		if (chkEmpty(f.strEmail)) {
		//	alert("이메일 주소를 입력해 주세요.");
		//	alert("电子邮箱请输入地址。");
		//	f.strEmail.focus();
		//	return false;
		} else {
			if (!checkEmail(f.strEmail.value)) {
				//alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
				alert("电子邮箱地址格式错误，请输入正确的电子邮箱地址。");
				f.strEmail.focus();
				return false;
			} else {
				f.EMAIL.value = f.strEmail.value;
			}
		}
		//if (chkEmpty(f.takeMob1) || chkEmpty(f.takeMob2) || chkEmpty(f.takeMob3))
		if (chkEmpty(f.takeMob))
		{
			//alert("주문자 연락처가 비어있습니다1");
			alert("订购人联系方式为空。");
			f.takeMob.focus();
			return false;
		} else {
			f.TELNO1.value = f.takeMob.value;
			//f.TELNO1.value = f.takeMob1.value +"-"+ f.takeMob2.value +"-"+ f.takeMob3.value;
		}

		//if (chkEmpty(f.takeTel1) || chkEmpty(f.takeTel2) || chkEmpty(f.takeTel3)) {
		if (chkEmpty(f.takeTel)) {
			//alert("받는분의 연락처가 비어있습니다");
			//alert("收货人联系方式为空。");
			//f.takeTel.focus();
			//return false;
		} else {
			f.takeTel.focus();
			//f.TELNO2.value = f.takeTel1.value+"-"+f.takeTel2.value+"-"+f.takeTel3.value;
		}
	}

	if (chkEmpty(f.v_SellCode)) {
		//alert("구매종류를 선택해주세요.CS");
		alert("请选择购买类型。");
		f.v_SellCode.focus();
		return false;
	}

	if (f.gopaymethod.value == '')
	{
		//alert("결제할 방식을 선택해주세요.CS");
		alert("请选择结算类型。");
		return false;
	}
	//alert(f.gopaymethod.value);
	//return false;

	if (f.gopaymethod.value == 'inBank')
	{		
		//마일리지단독결제취소후 무통장선택시 체크
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			calcSettlePrice();
			return false;
		}
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
		document.getElementById("frmConfirm").acceptCharset = "utf-8";

		f.action = "/PG/inBank_Result_cs.asp";
	}

	if (f.gopaymethod.value == 'sCard')
	{
		f.target = "_self";
		document.charset = "UTF-8";		

		if (confirm("카드분할결제를 진행하시겠습니까?")) {
			f.action = "/PG/cardResult_split.asp";
		} else {
			return false;
		}
	}
	//사용자비번
	if (chkEmpty(f.UserPassWord)) {
		alert("请输入密码。-USER");
		f.UserPassWord.focus();
		return false;
	}

	//▣마일리지 단독 결제▣
	if (f.gopaymethod.value == 'point')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		//수령방식
		var oriDelivery = parseInt(f.ori_delivery.value, 10);
		if ($("input[name=DtoD]:checked").val() == 'F')	{
			orgSettlePrice = orgSettlePrice - oriDelivery;
		}else{
			orgSettlePrice = orgSettlePrice;	
		}

		//f.useCmoney.value = formatComma(orgSettlePrice);
		checkUseCmoney();

		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			document.charset = "UTF-8";			

			if (confirm(pointTXT + " 단독결제를 진행하시겠습니까?")) {
				f.action = "/PG/point_Result_cs.asp";
			} else {
				return false;
			}
		} else {
			return false;
		}
	}


	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')
	{
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

		valData += f.takeName.value.replaceAll('☞','');

		valData += "☞"+f.mbid1.value.replaceAll('☞','');
		valData += "☞"+f.mbid2.value.replaceAll('☞','');
		valData += "☞"+f.takeTel.value.replaceAll('☞','');
		valData += "☞"+f.takeMob.value.replaceAll('☞','');
		//valData += "☞"+f.takeTel1.value.replaceAll('☞','')+"-"+f.takeTel2.value.replaceAll('☞','')+"-"+f.takeTel3.value.replaceAll('☞','');
		//valData += "☞"+f.takeMob1.value.replaceAll('☞','')+"-"+f.takeMob2.value.replaceAll('☞','')+"-"+f.takeMob3.value.replaceAll('☞','');
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
		valData += "☞"+stripComma(f.useCmoney.value).replaceAll('☞','');
		valData += "☞"+f.isDownOrder.value.replaceAll('☞','');		//	본인구매 F(하선구매 T)
		valData += "☞"+ $("input[name=DtoD]:checked").val();			//수령방식 택배/현장  O (j쿼리)


		/*

		valData += "||"+f.strName.value;
		valData += "||"+f.strName.value;
		*/


		//f.RESERVEDSTRING.value = encodeURIComponent(valData);
		//alert(encodeURIComponent("BC%C4%AB%B5%E5"));
		f.RESERVEDSTRING.value = valData;
		f.RESERVEDINDEX1.value = 'MYOFFICE';				//▣주문페이지 (MYOFFICE)
	//	f.RESERVEDINDEX1.value = f.OrdNo.value;				//주문번호
		f.RESERVEDINDEX2.value = f.OIDX.value;				//OIDX
		//alert(getByteLen(f.RESERVEDSTRING.value));


		document.charset = "euc-kr";
		document.getElementById("frmConfirm").acceptCharset = "euc-kr";
		//alert(document.charset);
			var fileName;

			if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' ) {
				//fileName = "https://ssl.daoupay.com/creditCard/DaouCreditCardMng.jsp";
				fileName = "https://ssltest.daoupay.com/creditCard/DaouCreditCardMng.jsp";
				DAOUPAY = window.open("", "DAOUPAY", "width=469,height=507");

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
//결제방식에따른 필수값 구분처리: 실시간계좌이체(2015-09-03)
function payKindSelect(str){
	var f = document.frmConfirm;
	f.gopaymethod.value = str;
	switch (str)
	{
		case "inBank" : {
			$("#inBankInfo").css({"display":""});
			break;
		}
		case "Card" : {
			$("#inBankInfo").css({"display":"none"});
			f.CPID.value	= f.CPID_CARD.value;
			f.HOMEURL.value = f.HOMEURL_CARD.value;
			f.PRODUCTTYPE.value = '2';
			break;
		}
		case "vBank" : {
			$("#inBankInfo").css({"display":"none"});
			f.CPID.value	= f.CPID_VBANK.value;
			f.HOMEURL.value = f.HOMEURL_VBANK.value;
			f.PRODUCTTYPE.value = '1';		//상품구분 - 다우페이와 계약시 지정(가맹점정보와 다우페이 내부정보가 일치해야함)			
			break;
		}
		case "dBank" : {
			$("#inBankInfo").css({"display":"none"});
			f.CPID.value	= f.CPID_DBANK.value;
			f.HOMEURL.value = f.HOMEURL_CARD.value;
			f.PRODUCTTYPE.value = '2';		//1:디지털, 2:실물			
			break;
		}
		case "point" : {
			$("#inBankInfo").css({"display":"none"});
			break;
		}
//		default :{
//			$("#inBankInfo").css({"display":"none"});	
//		}
	}
}


	//수령방식
	$(document).ready(function() {
		$("input[name=DtoD]").click(function(){
			//alert($("input[name=DtoD]:checked").val());
			var str		= $("input[name=DtoD]:checked").val();
			var price	= $("input[name=ori_price]").val() * 1;
			var deliFee = $("input[name=ori_delivery]").val() * 1;

			if (str == 'F') {												//현장수령
				$("input[name=totalPrice]").val((price - deliFee) * 1);
				$("input[name=AMOUNT]").val((price - deliFee) * 1);			//다우 결제금액
				$("input[name=totalDelivery]").val(0);
				$("#delTXT").text('현장수령으로 배송비 미부과');
				$("#priTXT").text(0);	
				document.getElementById("totalTXT").innerHTML = formatComma((price - deliFee) * 1);		//결제금액
				document.getElementById("lastTXT").innerHTML = formatComma((price - deliFee) * 1);		//최종결제금액
				//$("#lastTXT").text((price - deliFee) * 1);									//최종결제금액
				$("input[name=useCmoney]").val(0);							//마일리지 초기화
				$("#DtoD_toggle").css({"display":"none"});					//배송정보 안보임
			} else {
				$("input[name=totalPrice]").val(price);
				$("input[name=AMOUNT]").val(price);							//다우 결제금액
				$("input[name=totalDelivery]").val(deliFee);
				$("#delTXT").text($("#oriTXT1").text());
				$("#priTXT").text($("#oriTXT2").text());
				$("#totalTXT").text($("#oriTXT3").text());					//결제금액
				$("#lastTXT").text($("#oriTXT3").text());					//최종결제금액
				$("input[name=useCmoney]").val(0);							//마일리지 초기화
				$("#DtoD_toggle").css({"display":"table-row"});
			}
		});
	});



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


//마일리지 금액 입력시 체크이벤트
function checkUseCmoney(item){
	var f = document.frmConfirm;
	var msg;
	//alert(f.ownCmoney.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoneyA = parseInt(f.ownCmoneyA.value, 10);				//마일리지A
	var ownCmoney  = parseInt(f.ownCmoney.value, 10);				//마일리지B
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	//수령방식
	var oriDelivery = parseInt(f.ori_delivery.value, 10);
	if ($("input[name=DtoD]:checked").val() == 'F')	{
		orgSettlePrice = orgSettlePrice - oriDelivery;
	}else{
		orgSettlePrice = orgSettlePrice;	
	}
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoneyA = (chkEmpty(f.useCmoneyA)) ? 0 : parseInt(stripComma(f.useCmoneyA.value), 10);
	var useCmoney  = (chkEmpty(f.useCmoney)) ? 0  : parseInt(stripComma(f.useCmoney.value), 10);
	//alert(useCmoney);

	var ownCmoneyTot = (ownCmoneyA + ownCmoney)
	var useCmoneyTOT = (useCmoneyA + useCmoney)

	//마일리지A
	if (ownCmoneyTot <= 0) {
		msg = "사용할 "+ pointTXT +"를 입력해 주세요Tot.";
	}
	else if (ownCmoneyTot < cmoneyUseLimit) {
		msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.Tot";
	}
	else if (ownCmoneyTot < cmoneyUseMin) {
		msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.Tot";
	}
/*	
	//마일리지B
	if (useCmoney <= 0) {
		msg = "사용할 "+ pointTXT +"를 입력해 주세요.B";
	}
	else if (ownCmoney < cmoneyUseLimit) {
		msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.B";
	}
	else if (useCmoney < cmoneyUseMin) {
		msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.B";
	}
*/
/*
	else if (useCmoney > cmoneyUseMax) {
		msg = "적립금은 최대 "+formatComma(cmoneyUseMax)+" 원 이하까지 사용가능합니다.";
	}
*/
	//▣카드결제시 카드결제최소금액 체크▣
	else if ((useCmoney > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
		msg = "카드/가상계좌/실시간계좌이체 결제시 결제금액이 최소 1000원 이상이어야 합니다.";
		//msg = "적립금은 최대 "+formatComma(cmoneyUseMax-50)+" 원 이하까지 사용가능합니다.";
	}	
	else if (useCmoneyA > ownCmoneyA) {
		msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.A";
	}
	else if (useCmoney > ownCmoney) {
		msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.B";
	}
	else if (useCmoneyA > settlePrice) {					//settlePrice : 최초결제금액
		msg = "결제금액보다 많이 입력하셨습니다.A";
	}
	else if (useCmoney > settlePrice) {
		msg = "결제금액보다 많이 입력하셨습니다.B";
	}
	else if (useCmoneyTOT > settlePrice) {		
		msg = "결제금액보다 많이 입력하셨습니다.TOT";
	}
	else {
		isUseCmoney = true;
	}
	if (isUseCmoney) {
		calcSettlePrice();
		ThisMileage = true;
	}
	else {
		alert(msg);
		f.useCmoneyA.value = 0;		//A
		f.useCmoney.value = 0;		//B
		calcSettlePrice();
		ThisMileage = false;
		return false;
	}

}


// 결제금액 계산
function calcSettlePrice() {
	var f = document.frmConfirm;
	var totalCouponDiscountPrice, useCmoney, remainCmoney;
	var useCmoneyA;
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	//수령방식
	var oriDelivery = parseInt(f.ori_delivery.value, 10);
	if ($("input[name=DtoD]:checked").val() == 'F')	{
		orgSettlePrice = orgSettlePrice - oriDelivery;
	}else{
		orgSettlePrice = orgSettlePrice;	
	}
	var ownCmoneyA = parseInt(f.ownCmoneyA.value, 10);
	var ownCmoney  = parseInt(f.ownCmoney.value, 10);

	if (f.useCmoneyA) {
		useCmoneyA = (f.useCmoneyA.disabled || chkEmpty(f.useCmoneyA)) ? 0 : parseInt(stripComma(f.useCmoneyA.value), 10);
	}
	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}

	var useCmoneyTOT = (useCmoneyA + useCmoney)

	var settlePrice  = orgSettlePrice - useCmoneyTOT;
	//var remainCmoney = ownCmoney - useCmoney;



//	f.Amt.value = settlePrice;
	f.totalPrice.value = settlePrice;
	f.AMOUNT.value = settlePrice;
	document.getElementById("lastTXT").innerHTML = formatComma(settlePrice);	//최종 결제금
	document.getElementById("lastTXT2").innerHTML = formatComma(useCmoneyTOT);	//최종 포인트사용
	//$("#LastArea").text(formatComma(settlePrice));
	//document.getElementById("RemainArea").innerHTML = formatComma(remainCmoney);		//마일리지 잔액
	//document.getElementById("payArea").innerHTML = formatComma(settlePrice);
	//document.getElementById("PointArea").innerHTML = formatComma(useCmoney);
	//document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}



<script type="text/javascript">
<!--

//SHOP 쇼핑몰구매
var pf;
var pointTXT = "<%=SHOP_POINT%>";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;

var pointTXT2 = "<%=SHOP_POINT2%>";		//GNG
var ThisMileage2;
ThisMileage2 = false;

function loadings() {
	$("#loadingPro").show();
}


var doubleSubmit
doubleSubmit = false;


$(document).ready(function() {
	$('form input').keydown(function() {
		if (event.keyCode === 13) {
			event.preventDefault();
		}
	});

});


function orderSubmit(f) {

	//var f = document.payForm;
	//doubleSubmit 체크
	if (!doubleSubmit) {		//false가 아닐때
		//alert(doubleSubmit+"-a");
		doubleSubmit = true;
		//alert(doubleSubmit+"-b");
	} else {
		//alert(doubleSubmit+"-c");
		loadings();
		$("input[type=submit]").attr("disabled",true);
		//alert("결제처리가 진행중입니다. 잠시 기다려주세요.");
		alert("Payment processing is in progress. Please wait a moment.");
		return false;
	}

	if (f.useCmoney.value == "")
	{
		f.useCmoney.value = 0;
	}

	if (f.useCmoney.value != "0")
	{
		checkUseCmoney();
	}
	if (f.useCmoney2.value == "")
	{
		f.useCmoney2.value = 0;
	}

	if (f.useCmoney2.value != "0")
	{
		checkUseCmoney2();
	}

	if (chkEmpty(f.strName))
	{
		alert("<%=LNG_CS_PG_PAY_JS07%>");
		f.strName.focus();
		doubleSubmit = false;
		return false;
	}

	if (chkEmpty(f.strMobile)) {
		alert("<%=LNG_CS_PG_PAY_JS11%>");
		f.strMobile.focus();
		doubleSubmit = false;
		return false;
	}
	/*
	if (chkEmpty(f.strTel)) {
		alert("주문자 연락처가 비어있습니다");
		f.strTel.focus();
		doubleSubmit = false;
		return false;
	}
	*/
	if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2)) {
		alert("<%=LNG_CS_PG_PAY_JS_ORDER_ADDRESS%>");
		f.strZip.focus();
		doubleSubmit = false;
		return false;
	}

	if (chkEmpty(f.strEmail)) {
		alert("<%=LNG_CS_PG_PAY_JS09%>");
		f.strEmail.focus();
		doubleSubmit = false;
		return false;
	} else {
		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_CS_PG_PAY_JS10%>");
			f.strEmail.focus();
			doubleSubmit = false;
			return false;
		}
	}

	if (chkEmpty(f.takeName)) {
		alert("<%=LNG_CS_PG_PAY_JS_REC_NAME%>");
		f.takeName.focus();
		doubleSubmit = false;
		return false;
	}
	/*
	if (chkEmpty(f.takeTel)) {
		alert("받는분의 연락처가 비어있습니다");
		f.takeTel1.focus();
		doubleSubmit = false;
		return false;
	}
	*/
	if (chkEmpty(f.takeMobile)) {
		alert("<%=LNG_CS_PG_PAY_JS12%>");
		f.takeMobile.focus();
		doubleSubmit = false;
		return false;
	}

	if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
	{
		alert("<%=LNG_CS_PG_PAY_JS08%>");
		f.takeZip.focus();
		doubleSubmit = false;
		return false;
	}

	//CS연동상품선택시
	if (f.isComSell.value == 'T') {
		if (f.v_SellCode.value == '')
		{
			alert("<%=LNG_CS_PG_PAY_JS13%>");
			f.v_SellCode.focus();
			doubleSubmit = false;
			return false;
		}
	}
	if (f.gopaymethod.value == '')
	{
		alert("<%=LNG_CS_PG_PAY_JS14%>");
		doubleSubmit = false;
		return false;
	}

	if (f.gAgreement.checked == false)
	{
		alert("<%=LNG_CS_PG_PAY_JS23%>");
		f.gAgreement.focus();
		doubleSubmit = false;
		return false;
	}

	//▣ 무통장 + 마일리지/포인트결제 불가
	if (f.gopaymethod.value == 'inBank' && parseInt(f.useCmoney.value, 10) > 0){
		alert("무통장 결제시 C포인트를 사용할 수 없습니다  ");
		f.useCmoney.value = 0;
		calcSettlePrice();
		doubleSubmit = false;
		return false;
	}
	//▣ 무통장 + SP포인트결제 불가
	if (f.gopaymethod.value == 'inBank' && parseInt(f.useCmoney2.value, 10) > 0){
		alert("무통장 결제시 S포인트를 사용할 수 없습니다  ");
		f.useCmoney2.value = 0;
		calcSettlePrice();
		doubleSubmit = false;
		return false;
	}



	if (f.gopaymethod.value == 'inBank')
	{
		//마일리지단독결제취소후 무통장선택시 체크
		if (f.totalPrice.value < 1)	{
			alert(pointTXT + "사용금액을 확인해주세요.")
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			calcSettlePrice();
			doubleSubmit = false;
			return false;
		}
		if ($("input[name=bankidx]:checked").length == 0)
		{
			alert("<%=LNG_CS_PG_PAY_JS15%>");
			//f.bankidx.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.bankingName.value == '')
		{
			alert("<%=LNG_CS_PG_PAY_JS16%>");
			f.bankingName.focus();
			doubleSubmit = false;
			return false;
		}
		if (f.memo1.value =='')
		{
			alert("<%=LNG_CS_PG_PAY_JS19%>");
			f.memo1.focus();
			doubleSubmit = false;
			return false;
		}
		loadings();
		$("input[type=submit]").attr("disabled",true);			//double submit check
		f.target = "_self";
		f.action = "/PG/inBank_Result.asp";
		/*
		if (confirm("결제를 진행하시겠습니까?")) {
			loadings();
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.target = "_self";
			f.action = "/PG/inBank_Result.asp";
		} else {
			doubleSubmit = false;
			return false;
		}
		*/
	}

	//▣CP 결제▣
	if (f.gopaymethod.value == 'point')
	{

		var	ownCmoney = (f.ownCmoney.disabled || chkEmpty(f.ownCmoney)) ? 0 : parseInt(stripComma(f.ownCmoney.value), 10);
		var	ownCmoney2 = (f.ownCmoney2.disabled || chkEmpty(f.ownCmoney2)) ? 0 : parseInt(stripComma(f.ownCmoney2.value), 10);
		var	TOTAL_SP_POINTUSE_MAX = (f.TOTAL_SP_POINTUSE_MAX.disabled || chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);

		var	useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
		var useCmoney2 = (f.useCmoney2.disabled || chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

		if (ownCmoney < 1)				//CP 없음!!!
		{
			alert( pointTXT2+"가 없습니다!");
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			checkUseCmoney();
			doubleSubmit = false;
			return false;
		}

		//if (f.orgSettlePrice.value > f.ownCmoney.value)							//C포인트가 결제금액보다 부족할 시
		if (orgSettlePrice > ownCmoney)												//C포인트가 결제금액보다 부족할 시
		{
			f.useCmoney.value = (f.ownCmoney.value);								//C포인트 입력

			//if (f.orgSettlePrice.value - f.ownCmoney.value> f.TOTAL_SP_POINTUSE_MAX.value) { //결제가능SP포인트 부족
			if (orgSettlePrice - ownCmoney> TOTAL_SP_POINTUSE_MAX) {							//결제가능SP포인트 부족
				if (f.TOTAL_SP_POINTUSE_MAX.value > 0 ) {
					//alert("결제가능한 "+pointTXT2+"가 부족합니다!!");
					alert("<%=LNG_JS_SHORT_OF_POINT%> - "+pointTXT2);
				} else {
					//alert("결제가능한 "+pointTXT+"가 부족합니다!");
					alert("<%=LNG_JS_SHORT_OF_POINT%> - "+pointTXT);
				}
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				checkUseCmoney();
				doubleSubmit = false;
				return false;
			}

			if (ownCmoney2 < orgSettlePrice - ownCmoney)				//SP포인트 부족
			{
				alert("<%=LNG_JS_SHORT_OF_POINT%>");
				//alert("포인트가 부족합니다");
				////alert(pointTXT2+"가 부족합니다");
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				checkUseCmoney();
				doubleSubmit = false;
				return false;
			}

			if (orgSettlePrice - useCmoney2 < ownCmoney)
			{
				f.useCmoney.value = (orgSettlePrice - useCmoney2);		//C포인트 + (SP포인트 일부) 결제시 [useCmoney 사용값]
			} else {

				if (orgSettlePrice > ownCmoney + useCmoney2)
				{
					//alert(orgSettlePrice);
					//alert(ownCmoney + useCmoney2);
					if (orgSettlePrice > ownCmoney) {
						//alert("입력된"+pointTXT+"가 부족합니다\n"+pointTXT2+"값이 변경됩니다.\n("+formatComma(orgSettlePrice-ownCmoney)+")");
						alert("<%=LNG_JS_SHORT_OF_POINT_N_CHANGE%>\n("+formatComma(orgSettlePrice-ownCmoney)+")");
					}
					f.useCmoney2.value = (f.orgSettlePrice.value - f.ownCmoney.value);		//SP포인트 입력
					doubleSubmit = false;
					return false;
				}

			}
			checkUseCmoney();

		}else{
			f.useCmoney.value = (orgSettlePrice - useCmoney2);		//C포인트 + (SP포인트 일부) 결제시 [useCmoney 사용값]
			checkUseCmoney();
		}

		if (ThisMileage)
		{
			f.useCmoney.value = stripComma(f.useCmoney.value);
			f.target = "_self";
			document.charset = "UTF-8";

			//if (confirm(pointTXT + " 결제를 진행하시겠습니까?")) {
			if (confirm("<%=LNG_MYOFFICE_ORDER_03%> - "+pointTXT)) {
				loadings();
				$("input[type=submit]").attr("disabled",true);			//double submit check
				f.target = "_self";
				f.action = "/PG/point_Result.asp";
			} else {
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				calcSettlePrice();
				doubleSubmit = false;
				return false;
			}

		} else {
			doubleSubmit = false;
			return false;
		}
	}

	//▣SP 단독 결제▣
	if (f.gopaymethod.value == 'point2')
	{
		var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
		f.useCmoney2.value = formatComma(orgSettlePrice);
		checkUseCmoney();
		if (ThisMileage2)
		{
			f.useCmoney2.value = stripComma(f.useCmoney2.value);

			//if (confirm(pointTXT2 + " 결제를 진행하시겠습니까?")) {
			if (confirm("<%=LNG_MYOFFICE_ORDER_03%> - "+pointTXT2)) {
				loadings();
				$("input[type=submit]").attr("disabled",true);			//double submit check
				f.target = "_self";
				f.action = "/PG/point2_Result.asp";
			} else {
				f.useCmoney.value = 0;
				f.useCmoney2.value = 0;
				calcSettlePrice();
				doubleSubmit = false;
				return false;
			}
		} else {
			doubleSubmit = false;
			return false;
		}
	}


	if (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'Bank')
	{


	}


}

function chgPay(str){
	var f = document.payForm;
	f.gopaymethod.value = str;
	////f.PayMethod.value	= str.toUpperCase();			//NICEPAY

	console.log(str);
	switch (str)
	{
		case "inBank" : {
			$("#CardInfo").css({"display":"none"});
			$("#BankInfo").css({"display":"block"});
			break;
		}
		case "Card" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "point" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "point2" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "inCash" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "vBank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});
			break;
		}
		case "Bank" : {
			$("#BankInfo").css({"display":"none"});
			$("#CardInfo").css({"display":"none"});

			break;
		}
		//default :{
		//}
	}

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
	var f = document.payForm;

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
//C포인트사용  useCmoney
function checkUseCmoney(item){
	var f = document.payForm;
	var msg = '';
	//alert(f.ownCmoney.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney = parseInt(f.ownCmoney.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney = false;
	var useCmoney = (chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	var useCmoney2 = (chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);		//SP point
	var TOTAL_SP_POINTUSE_MAX = (chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);		// 최대 SP사용가능 금액 (애니페이)

	//alert(useCmoney + useCmoney2);
	//alert(TOTAL_SP_POINTUSE_MAX);

	if (useCmoney > 0) {

		if (ownCmoney < cmoneyUseLimit) {
			msg = pointTXT +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney < cmoneyUseMin) {
			msg = pointTXT +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
		}
		//▣카드결제시 카드결제최소금액 체크▣
		if ((useCmoney + useCmoney2 > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
			msg = "카드/가상계좌 결제시 결제금액이 최소 1000원 이상이어야 합니다!";
		}
		if (useCmoney > ownCmoney) {
			//msg = "보유 하신 "+ pointTXT +"보다 많은 금액을 입력하셨습니다.";
			msg = "<%=LNG_JS_POINT_EXCEEDED%>";
		}
		if (useCmoney > settlePrice) {
			//msg = "결제금액보다 많이 입력하셨습니다.";
			msg = "<%=LNG_CS_PG_PAY_JS33%>";
		}
		/*
		if ((useCmoney + useCmoney2) + TOTAL_SP_POINTUSE_MAX > settlePrice) {				//마일리지 + 포인트 최종합계금액과 비교!

			msg = "포인트 단독결제시 마일리지는 사용할 수 없습니다.";
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			calcSettlePrice();
		}
		*/

		if (msg == ''){
			isUseCmoney = true;
		}
		if (isUseCmoney) {
			calcSettlePrice();
			ThisMileage = true;
		} else {
			alert(msg);
			f.useCmoney.value = 0;
			calcSettlePrice();
			ThisMileage = false;
			return false;
		}

	}

}



//S포인트사용  useCmoney2
function checkUseCmoney2(item){
	var f = document.payForm;
	var msg2 = '';
	 //alert(f.ownCmoney2.value);
	var cmoneyUseLimit = parseInt(f.cmoneyUseLimit.value, 10);
	var cmoneyUseMin = parseInt(f.cmoneyUseMin.value, 10);
	var cmoneyUseMax = parseInt(f.cmoneyUseMax.value, 10);
	var ownCmoney2 = parseInt(f.ownCmoney2.value, 10);
	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var settlePrice = orgSettlePrice;
	var isUseCmoney2 = false;
	var useCmoney2 = (chkEmpty(f.useCmoney2)) ? 0 : parseInt(stripComma(f.useCmoney2.value), 10);
	var TOTAL_SP_POINTUSE_MAX = (chkEmpty(f.TOTAL_SP_POINTUSE_MAX)) ? 0 : parseInt(stripComma(f.TOTAL_SP_POINTUSE_MAX.value), 10);		// 최대 SP사용가능 금액 (애니페이)

	//alert(TOTAL_SP_POINTUSE_MAX+useCmoney2);
	//alert(settlePrice);

	if (useCmoney2 > 0) {

		if (ownCmoney2 < cmoneyUseLimit) {
			msg2 = pointTXT2 +" 사용 금액은 "+formatComma(cmoneyUseLimit)+" 원 이상부터 사용 가능합니다.";
		}
		if (useCmoney2 < cmoneyUseMin) {
			msg2 = pointTXT2 +"는 최소 "+formatComma(cmoneyUseMin)+" 원 이상부터 사용 가능합니다.";
		}
		//▣카드결제시 카드결제최소금액 체크▣
		if ((useCmoney2  > cmoneyUseMax) && (f.gopaymethod.value == 'card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
			msg2 = "카드/가상계좌/실시간계좌이체 결제시 결제금액이 최소 1000원 이상이어야 합니다!!!";
		}
		if (useCmoney2 > ownCmoney2) {
			//msg2 = "보유 하신 "+ pointTXT2 +"보다 많은 금액을 입력하셨습니다.";
			msg2 = "<%=LNG_JS_POINT2_EXCEEDED%>";
		}
		if (useCmoney2 > TOTAL_SP_POINTUSE_MAX) {
			//msg2 = "결제가능한 SP포인트보다 많이 입력하셨습니다!\n(최대 "+formatComma(TOTAL_SP_POINTUSE_MAX)+ " 포인트)";
			msg2 = "<%=LNG_JS_POINT2_EXCEEDED%>!!";
		}
		if (useCmoney2 > settlePrice) {
			//msg2 = "결제금액보다 많이 입력하셨습니다.";
			msg2 = "<%=LNG_CS_PG_PAY_JS33%>";
		}
		/*
		if ((useCmoney2 + useCmoney) > settlePrice) {				//마일리지 + 포인트 최종합계금액과 비교!
			//msg2 = "결제금액보다 많이 입력하셨습니다.!!";
			msg2 = "포인트 단독결제시 마일리지는 사용할 수 없습니다.";	//메이저스트 포인트 단독결제만 가능(2017-02-22)
			f.useCmoney.value = 0;
			f.useCmoney2.value = 0;
			calcSettlePrice();
		}
		*/
		if (msg2 == ''){
			isUseCmoney2 = true;
		}
		if (isUseCmoney2) {
			calcSettlePrice();
			ThisMileage2 = true;
		}else {
			alert(msg2);
			f.useCmoney2.value = 0;
			calcSettlePrice();
			ThisMileage2 = false;
			return false;
		}

	}

}



//국가별 소수점자리수
var pSpace = 0;
<%Select Case UCase(strNationCode)%>
<%	Case "KR"%>
		pSpace = 0;
<%	Case Else%>
		pSpace = 2;
<%End Select%>
var NumberFormatter = new Intl.NumberFormat('en-US', {
	minimumFractionDigits: pSpace,
	maximumFractionDigits: pSpace
});

// 결제금액 계산
function calcSettlePrice() {
	var f = document.payForm;
	var totalCouponDiscountPrice, useCmoney, useCmoney2;;

	//var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);
	var orgSettlePrice = parseFloat(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseFloat(stripComma(f.useCmoney.value), 10);
	}
	//SP포인트
	if (f.useCmoney2) {
		useCmoney2 = (f.useCmoney2.disabled || chkEmpty(f.useCmoney2)) ? 0 : parseFloat(stripComma(f.useCmoney2.value), 10);
	}

	//var settlePrice = orgSettlePrice - useCmoney;
	var settlePrice = orgSettlePrice - (useCmoney + useCmoney2);	// - (C포인트 + SP포인트)

	f.totalPrice.value = settlePrice;
////f.Amt.value		   = settlePrice;			//NICEPAY 결제금

	//document.getElementById("LastAreaID").innerHTML = formatComma(settlePrice);
	document.getElementById("LastAreaID").innerHTML = NumberFormatter.format(settlePrice);
	document.getElementById("payArea").innerHTML = NumberFormatter.format(settlePrice);
	document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
	document.getElementById("viewPoint2").innerHTML = NumberFormatter.format(useCmoney2);


	var ownCmoney = parseFloat(f.ownCmoney.value, 10);
	if (f.ownCmoney) {
		ownCmoney = (f.ownCmoney.disabled || chkEmpty(f.ownCmoney)) ? 0 : parseFloat(stripComma(f.ownCmoney.value), 10);
	}

	//alert(ownCmoney);
	//var AP_POINT = $("input[name=totalPrice]").val();
	//$("#pointTXT").text(formatComma(settlePrice)+' AP사용');	//C포인트 사용금액 표기


}



function openzip_jp2EN(target) {
	openPopup("/common/pop_ZipCode_JP2EN.asp?target="+target, "Zipcodes", 100, 100, "left=200, top=200");		//일본주소(영문)
}



// -->
</script>
//SHOP 쇼핑몰구매
var pointTXT = "마일리지";		//마일리지,포인트
var ThisMileage;
ThisMileage = false;

var doubleSubmit
doubleSubmit = false;


$(document).ready(function() {
	$('form input').keydown(function() {
		if (event.keyCode === 13) {
			event.preventDefault();
		}
	});

});


function loadings() {
	var loadingBar = $("#loadingPro");
	var loadProg = $("#loadProg");
	var dHeight = $(document).height();
	var wHeight = $(window).height();
	var sHeight = $(document).scrollTop();
	//alert(dHeight);
	//alert(sHeight);
	//alert(wHeight);
	loadingBar.css("height",dHeight+"px");
	loadProg.css({"top":(wHeight/2)-150+"px","left":"50%","margin-left":"-80px"});

	loadingBar.toggle();
}



//##### FIRSTDATA 1-S #####

//	return false;  =>  return;

	var payflag = "S";									//C:클라이언트 결제(javascript 결제 처리), S:서버 결제(ASPX 결제 처리)(Default)
	var popflag = "L";									//P:팝업창 호출 결제, L:Layer 팝업 호출 결제(Default)
	var keyData = "6aMoJujE34XnL9gvUqdKGMqs9GzYaNo6";	//가맹점 배포 PASSKEY 입력

	//주문번호, 주문시간 자동 생성 처리
	function initValue(){
		document.fdpay.MxIssueDate.value = date_data();
		//document.fdpay.MxIssueNO.value = document.fdpay.MxID.value + date_data();		//가맹점 사용 주문번호로 변경
	}

	//현재 시간 생성 처리(YYYYMMDDHHMMSS)
	function date_data() {
		var time = new Date();
		var year = time.getFullYear() + "";
		var month = time.getMonth() + 1;
		var date = time.getDate();
		var hour = time.getHours();
		var min = time.getMinutes();
		var sec = time.getSeconds();
		if (month < 10) {
			month = "0" + month;
		}
		if (date < 10) {
			date = "0" + date;  
		}
		if (hour < 10) {
			hour = "0" + hour;
		}
		if (min < 10) {
			min = "0" + min;
		}
		if (sec < 10) {
			sec = "0" + sec;
		}
		return year + month + date + hour + min + sec;
	}

	//결제 창 호출 요청 전문 생성 처리
	function makePayData(){

		var mxid = document.fdpay.MxID.value;
		var mxissueno = document.fdpay.MxIssueNO.value;
		var amount = document.fdpay.Amount.value;

		//HASH DATA 생성!!
		var callhash = Sha256.hash(mxid + mxissueno + amount + keyData).toUpperCase();

		var temp = "";

		try{ temp += "MxID=" + document.fdpay.MxID.value + "|"; }catch (e) { temp += "MxID=|"; }
		try{ temp += "MxIssueNO=" + document.fdpay.MxIssueNO.value + "|"; }catch (e) { temp += "MxIssueNO=|"; }
		try{ temp += "MxIssueDate=" + document.fdpay.MxIssueDate.value + "|"; }catch (e) { temp += "MxIssueDate=|"; }
		try{ temp += "CcProdDesc=" + document.fdpay.CcProdDesc.value + "|"; }catch (e) { temp += "CcProdDesc=|"; }
		try{ temp += "Amount=" + document.fdpay.Amount.value + "|"; }catch (e) { temp += "Amount=|"; }
		try{ temp += "rtnUrl=" + document.fdpay.rtnUrl.value + "|"; }catch (e) { temp += "rtnUrl=|"; }
		try{ temp += "ItemInfo=" + document.fdpay.ItemInfo.value + "|"; }catch (e) { temp += "ItemInfo=|"; }
		try{ temp += "connectionType=" + document.fdpay.connectionType.value + "|"; }catch (e) { temp += "connectionType=|"; }
		try{ temp += "URL=" + document.fdpay.URL.value + "|"; }catch (e) { temp += "URL=|"; }
		try{ temp += "DBPATH=" + document.fdpay.DBPATH.value + "|"; }catch (e) { temp += "DBPATH=|"; }
		try{ temp += "Currency=" + document.fdpay.Currency.value + "|"; }catch (e) { temp += "Currency=|"; }
		try{ temp += "SelectPayment=" + document.fdpay.SelectPayment.value + "|"; }catch (e) { temp += "SelectPayment=|"; }
		try{ temp += "Tmode=" + document.fdpay.Tmode.value + "|"; }catch (e) { temp += "Tmode=|"; }
		try{ temp += "LangType=" + document.fdpay.LangType.value + "|"; }catch (e) { temp += "LangType=|"; }
		try{ temp += "BillType=" + document.fdpay.BillType.value + "|"; }catch (e) { temp += "BillType=|"; }
		try{ temp += "CardSelect=" + document.fdpay.CardSelect.value + "|"; }catch (e) { temp += "CardSelect=|"; }
		try{ temp += "escrowYn=" + document.fdpay.escrowYn.value + "|"; }catch (e) { temp += "escrowYn=|"; }
		try{ temp += "cashYn=" + document.fdpay.cashYn.value + "|"; }catch (e) { temp += "cashYn=|"; }
		try{ temp += "CcNameOnCard=" + document.fdpay.CcNameOnCard.value + "|"; }catch (e) { temp += "CcNameOnCard=|"; }
		try{ temp += "PhoneNO=" + document.fdpay.PhoneNO.value + "|"; }catch (e) { temp += "PhoneNO=|"; }
		try{ temp += "Email=" + document.fdpay.Email.value + "|"; }catch (e) { temp += "Email=|"; }
		try{ temp += "SupportDate=" + document.fdpay.SupportDate.value + "|"; }catch (e) { temp += "SupportDate=|"; }
		try{ temp += "EncodeType=" + document.fdpay.EncodeType.value + "|"; }catch (e) { temp += "EncodeType=|"; }

		temp += "CallHash=" + callhash + "|"; //CallHash DATA 추가!!

		document.fdpay.PAYDATA.value = temp;

	}
//##### FIRSTDATA 1-E #####



	function orderSubmit() {

		var f = document.fdpay;

		//doubleSubmit 체크
		if (!doubleSubmit) {		//false가 아닐때
			//alert(doubleSubmit+"-a");
			doubleSubmit = true;
			//alert(doubleSubmit+"-b");
		} else {					//true
			//alert(doubleSubmit+"-c");
			alert("결제처리가 진행중입니다. 잠시 기다려주세요.");
			return;
		}

		if (f.useCmoney.value == "")
		{
			f.useCmoney.value = 0;
		}

		if (f.useCmoney.value != "0")
		{
			checkUseCmoney();
		}

		if (chkEmpty(f.strName))
		{
			alert("주문자 성함이 비어있습니다");
			f.strName.focus();
			doubleSubmit = false;
			return;
		}

		if (chkEmpty(f.strMobile)) {
			alert("주문자의 휴대폰번호가 비어있습니다");
			f.strMobile.focus();
			doubleSubmit = false;
			return;
		}

		//if (chkEmpty(f.strTel)) {
		//	alert("주문자 연락처가 비어있습니다");
		//	f.strTel.focus();
		//	doubleSubmit = false;
		//	return;
		//}

		if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1) || chkEmpty(f.strADDR2)) {
			alert("주문자 주소가 비어있습니다");
			f.strZip.focus();
			doubleSubmit = false;
			return;
		}

		if (chkEmpty(f.strEmail)) {
			alert("이메일 주소를 입력해 주세요.");
			f.strEmail.focus();
			doubleSubmit = false;
			return;
		} else {
			if (!checkEmail(f.strEmail.value)) {
				alert("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.");
				f.strEmail.focus();
				doubleSubmit = false;
				return;
			}
		}

		if (chkEmpty(f.takeName)) {
			alert("받는분의 성함이 비어있습니다.");
			f.takeName.focus();
			doubleSubmit = false;
			return;
		}

		//if (chkEmpty(f.takeTel)) {
		//	alert("받는분의 연락처가 비어있습니다");
		//	f.takeTel1.focus();
		//	doubleSubmit = false;
		//	return;
		//}

		if (chkEmpty(f.takeMobile)) {
			alert("받는분의 연락처가 비어있습니다");
			f.takeMobile.focus();
			doubleSubmit = false;
			return;
		}

		if (chkEmpty(f.takeZip) || chkEmpty(f.takeADDR1) || chkEmpty(f.takeADDR2))
		{
			alert("받는분의 주소가 비어있습니다");
			f.takeZip.focus();
			doubleSubmit = false;
			return;
		}

		//CS연동상품선택시
		if (f.isComSell.value == 'T') {
			if (f.v_SellCode.value == '')
			{
				alert("구매종류를 선택해주세요.");
				f.v_SellCode.focus();
				doubleSubmit = false;
				return;
			}
		}

		if (f.gopaymethod.value == '')
		{
			alert("결제할 방식을 선택해주세요.");
			doubleSubmit = false;
			return;
		}

		if (f.gAgreement.checked == false)
		{
			alert("정보제공에 동의하셔야합니다 .");
			f.gAgreement.focus();
			doubleSubmit = false;
			return;
		}

		if (f.gopaymethod.value == 'inBank')
		{
			//마일리지단독결제취소후 무통장선택시 체크
			if (f.totalPrice.value < 1)	{
				alert(pointTXT + " 사용금액을 확인해주세요!\n\n전액 포인트로만 결제할 경우\n결제수단을 [포인트 단독결제] 로 변경한 후 진행해주세요.")
				f.useCmoney.value = 0;
				calcSettlePrice();
				doubleSubmit = false;
				return;
			}
			if ($("input[name=bankidx]:checked").length == 0)
			{
				alert("온라인 입금시 결제 은행을 선택해주셔야합니다.1");
				//f.bankidx.focus();
				doubleSubmit = false;
				return;
			}
			if (f.bankingName.value == '')
			{
				alert("온라인 입금시 입금자명을 입력해 주셔야합니다.");
				f.bankingName.focus();
				doubleSubmit = false;
				return;
			}
			if (f.memo1.value =='')
			{
				alert("온라인 입금시 입금예정일을 입력하셔야합니다.");
				f.memo1.focus();
				doubleSubmit = false;
				return;
			}
			loadings();
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.target = "_self";
			f.action = "/PG/inBank_Result.asp";

		}


		//▣포인트 단독 결제▣
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
				loadings();
				$("input[type=submit]").attr("disabled",true);			//double submit check
				f.target = "_self";
				f.action = "/PG/point_Result.asp";
				/*
				if (confirm(pointTXT + " 단독결제를 진행하시겠습니까?")) {
					loadings();
					$("input[type=submit]").attr("disabled",true);			//double submit check
					f.target = "_self";
					f.action = "/PG/point_Result.asp";
				} else {
					f.useCmoney.value = 0;
					calcSettlePrice();
					doubleSubmit = false;
					return;
				}
				*/
			} else {
				doubleSubmit = false;
				return;
			}
		}


		if (f.gopaymethod.value == 'Card')
		{
			//##### FIRSTDATA Card-S #####
			makePayData();	//FIRSTDATA 전문생성

			if(document.fdpay.PAYDATA.value == ""){
				alert("전문 생성 후 결제 요청해 주세요!!");

			}else{

				if(popflag == "P"){	//POPUP 호출 시
					window.open("pop.html","PAY_POP","width=560, height=602, scrollbars=1");
				}else{				//LAYER 호출 시
					FD_PAY_FRAME.location.href = "/PG/FIRSTDATA/layer.asp";	//FDK 결제 창 호출 페이지로 프레임 영역 변경
					layer_open('fdpayWin');						//"FD_PAY_FRAME" 프레임을 가지고 있는 DIV 영역의 ID를 입력(sample 이용 시 : id="fdpayWin")
				}
			}			
			//##### FIRSTDATA Card-E #####
		}




	}



//##### FIRSTDATA 2-S #####
	//레이어 팝업 호출 시 처리
	function layer_open(el){

		wrapWindowByMask();			//레이어 팝업 활성화 시 하단 MASKING 처리를 위한 함수

		var fdlayer = $('#' + el);	//레이어의 id를 fdlayer변수에 저장

		fdlayer.fadeIn();			//레이어 실행

		// 화면의 중앙에 레이어를 띄운다.
		fdlayer.css('margin-top', '-'+fdlayer.outerHeight()/2+'px');
		fdlayer.css('margin-left', '-'+fdlayer.outerWidth()/2+'px');

		fdlayer.find('a.closeBtn').click(function(e){

			fdlayer.fadeOut();			//'Close'버튼을 클릭하면 레이어가 사라진다.

			e.preventDefault();

			document.getElementById("mask").style.display = "none";	//레이어 팝업 비활성화 시 하단 MASKING 표시 해제

			FD_PAY_FRAME.location.href = "/PG/FIRSTDATA/blank.html";				//빈 페이지로 프레임 영역 변경

		});
	}

	//레이어 팝업 하단 영역 마스킹 처리(레이어 팝업 호출 시 사용)
	function wrapWindowByMask(){

		//화면의 높이와 너비를 구한다.
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();

		//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
		$('#mask').css({'width':maskWidth,'height':maskHeight});

		//애니메이션 효과
		$('#mask').fadeIn(1000);
		$('#mask').fadeTo("slow",0.6);
	}

	//결제 창 결과 return 처리
	function result(rtncode, rtnmsg, fdtid){
		//alert(rtncode +'d');
		//레이어 팝업으로 호출한 경우만 처리
		if(popflag != "P"){

			FD_PAY_FRAME.location.href = "/PG/FIRSTDATA/blank.html";					//결제창 결과 수신 시 빈 페이지로 프레임 영역 변경

			document.getElementById("fdpayWin").style.display = "none";	//결제창 결과 수신 시 프레임 영역 표시 해제
			document.getElementById("mask").style.display = "none";		//결제창 결과 수신 시 하단 MASKING 표시 해제
		}

		if(rtncode == "0000"){											////인증성공 0000
		//alert(rtncode);
		//alert(payflag);
			var mxid = document.fdpay.MxID.value;
			var mxissueno = document.fdpay.MxIssueNO.value;

			if(payflag == "C"){	//클라이언트 결제 시	////사용하지마 XXXXX

			}else{				//서버 결제 시
				document.fdpay.MxID.value = mxid;
				document.fdpay.MxIssueNO.value = mxissueno;
				document.fdpay.FDTid.value = fdtid;

				document.fdpay.action = "/PG/FIRSTDATA/CardResult.asp";		//DB처리페지
				document.fdpay.submit();
			}

		}else{
			alert("인증실패["+rtncode+"("+rtnmsg+")]");
		}
	}
//##### FIRSTDATA 2-E #####


	function chgPay(str){
		//var f = document.orderFrm;
		var f = document.fdpay;
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
			case "point" : {
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
			case "dBank" : {
				$("#BankInfo").css({"display":"none"});
				$("#CardInfo").css({"display":"none"});

				break;
			}
			//default :{
			//}
		}

	}






// 받는분 정보 복사
function infoCopy(item) {
	//var f = document.orderFrm;
	var f = document.fdpay;

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
	//var f = document.orderFrm;
	var f = document.fdpay;
	var msg;

//alert(f.ownCmoney.value);

/*
	if (!f.isUseCmoney.checked){
		item.value = "";
		alert("적립금 사용을 먼저 체크해주세요.");
		return;
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
	else if ((useCmoney > cmoneyUseMax) && (f.gopaymethod.value == 'Card' || f.gopaymethod.value == 'vBank' || f.gopaymethod.value == 'dBank')) {
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
		return;
	}

}


// 결제금액 계산
function calcSettlePrice() {
	//var f = document.orderFrm;
	var f = document.fdpay;
	var totalCouponDiscountPrice, useCmoney;

	var orgSettlePrice = parseInt(f.orgSettlePrice.value, 10);

	if (f.useCmoney) {
		useCmoney = (f.useCmoney.disabled || chkEmpty(f.useCmoney)) ? 0 : parseInt(stripComma(f.useCmoney.value), 10);
	}
	var settlePrice = orgSettlePrice - useCmoney;

//	f.Amt.value = settlePrice;
//	document.getElementById("showSettlePrice").innerHTML = formatComma(settlePrice);
	f.totalPrice.value = settlePrice;
	//f.AMOUNT.value = settlePrice;
	document.getElementById("LastArea").innerHTML = formatComma(settlePrice);
	document.getElementById("payArea").innerHTML = formatComma(settlePrice);
	document.getElementById("PointArea").innerHTML = formatComma(useCmoney);
	document.getElementById("viewPoint").innerHTML = formatComma(useCmoney);
}




function resetUseCmoney() {
	//var f = document.orderFrm;
	var f = document.fdpay;

	document.getElementById("showTotalCmoney").innerHTML = "0";
}
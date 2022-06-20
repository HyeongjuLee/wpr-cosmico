
	$(document).ready(function() {
		fnRecvModify();
		fnCardModify();
	});


	//CMS 상품 삭제
	function delThis(idx) {
		var m = document.mfrm;

		if (confirm('삭제 하시겠습니까?\n\n삭제 후 복구할 수 없습니다.'))
		{
			m.mode.value = 'DELETE_G';
			m.intIDX.value		= idx;			//arr_Salesitemindex
			m.submit();
		}
	}


	//등록된 제품 변경
	function modTable(idx){
		$("#ItemCount_"+idx).css("display", "block");
		$("#viewItemCount_"+idx).css("display", "none");

		$("#ItemCode_"+idx).css("display", "block");
		$("#viewItemCode_"+idx).css("display", "none");
	}


	/* 배송정보 변경 체크 S */
	function fnRecvModify(){
		var recvChk = $("input[name=recvInfoChgChk]").prop("checked") ? "T" : "F";

		if (recvChk == "T"){
			$(".autoTable_i1 input[type=text]").not(".notchgCss").removeClass("readonly").removeAttr("disabled readonly");
			$("#pop_postcode").css("display", "");
		} else {
			$(".autoTable_i1 input[type=text]").not(".notchgCss").addClass("readonly").attr({"disabled":"disabled","readonly":"readonly"});
			$("#pop_postcode").css("display", "none");
		}
	}
	/* 배송정보 변경 체크 E */

	/* 카드변경시 변경 체크 S */
	function fnCardModify(){
		var infoChk = $("input[name=cardInfoChgChk]").prop("checked") ? "T" : "F";

		if (infoChk == "T") {
			$("#btn_Auth").css("display", "");
			$(".autoTable_i2 input[type=text], .autoTable_i2 select, .autoTable_i2 input[type=password]").removeClass("readonly").removeAttr("disabled readonly");
		} else {
			$("#btn_Auth").css("display", "none");
			$(".autoTable_i2 input[type=text], .autoTable_i2 select, .autoTable_i2 input[type=password]").addClass("readonly").attr({"disabled":"disabled","readonly":"readonly"});
			$("#cardCheckSpan input[type=text]").not("#cardCheck").val('');
			$("#cardCheck").val('F');
			$(".dtexton").remove();
		}
	}
	/* 카드변경시 변경 체크 S */


	//팝업(iframe)인증
	function fnCardModify_02(){
		var infoChk = $("input[name=cardInfoChgChk]").prop("checked") ? "T" : "F";

		if (infoChk == "T") {
			$("#tr_cardAuth").css("display", "");
		} else {
			$("#tr_cardAuth").css("display", "none");
		}
	}


	var doubleSubmit = false;
	function fnSubmit(){
		//doubleSubmit 체크
		if (!doubleSubmit) {
			doubleSubmit = true;
		} else {
			alert("처리중입니다. 잠시 기다려주세요.");
			return false;
		}

		var oIDX = $("input[name=oIDX]").val();

		var recvChk = $("input[name=recvInfoChgChk]").prop("checked") ? "T" : "F";

		var strName = $("input[name=strName]").val();
		var strZip = $("input[name=strZip]").val();
		var strADDR1 = $("input[name=strADDR1]").val();
		var strADDR2 = $("input[name=strADDR2]").val();
		var strMobile = $("input[name=strMobile]").val();
		var strTel = $("input[name=strTel]").val();

		var A_ProcDay = $("input[name=A_ProcDay]").val();
		var Ori_A_ProcDay = $("input[name=Ori_A_ProcDay]").val();

		var INFO_CHANGE_TF = $("input[name=INFO_CHANGE_TF]").val();
		if (INFO_CHANGE_TF != "T")	{
			alert("결제 예정일 2일 전까지 수정 할 수 있습니다.");
			doubleSubmit = false;
			return false;
		}

		if (recvChk == "T"){
			if (strName == "" || $.trim(strName) == ""){
				alert("수취인명을 입력 해 주세요.");
				$("input[name=strName]").focus();
				doubleSubmit = false;
				return false;
			}

			if (strZip == "" || $.trim(strZip) == ""){
				alert("우편번호 검색 후 주소를 입력 해 주세요.");
				$("input[name=strADDR1]").focus();
				$("#pop_postcode").click();
				doubleSubmit = false;
				return false;
			}

			if (strADDR1 == "" || $.trim(strADDR1) == ""){
				alert("우편번호 검색 후 주소를 입력 해 주세요.");
				$("input[name=strADDR1]").focus();
				$("#pop_postcode").click();
				doubleSubmit = false;
				return false;
			}
			if (strADDR2 == "" || $.trim(strADDR2) == ""){
				alert("상세주소를 입력 해 주세요.");
				$("input[name=strADDR2]").focus();
				doubleSubmit = false;
				return false;
			}

			if (strMobile == "" || $.trim(strMobile) == ""){
				alert("연락처 1을 입력 해 주세요.");
				$("input[name=strMobile]").focus();
				doubleSubmit = false;
				return false;
			}
		}


		var cardInfoChgChk = $("input[name=cardInfoChgChk]").prop("checked")?"T":"F";
		/*
		var A_Month_Date = $("select[name=A_Month_Date] option:selected").val();
		var Ori_A_Month_Date = $("input[name=Ori_A_Month_Date]").val();
		*/
		var A_AutoCnt = $("select[name=A_AutoCnt] option:selected").val();
		var Ori_A_AutoCnt = $("input[name=Ori_A_AutoCnt]").val();

		/*
		if (A_Month_Date == "") {
			alert("정기결제 기준일자를 선택 해 주세요.");
			doubleSubmit = false;
			return false;
		}
		*/

		if (A_AutoCnt == "") {
			alert("정기결제 주기를 선택 해 주세요.");
			doubleSubmit = false;
			return false;
		}

		if (cardInfoChgChk == "T") {

			var cardCheck = $("input[name=cardCheck]").val();

			var A_CardType = $("select[name=A_CardType] option:selected").val();
			var A_CardCode = $("select[name=A_CardCode] option:selected").val();
			var A_CardNumber1 = $("#A_CardNumber1").val();
			var A_CardNumber2 = $("#A_CardNumber2").val();
			var A_CardNumber3 = $("#A_CardNumber3").val();
			var A_CardNumber4 = $("#A_CardNumber4").val();
			var A_CardNumber = A_CardNumber1 + A_CardNumber2 + A_CardNumber3 + A_CardNumber4;
			var A_Period1 = $("select[name=A_Period1] option:selected").val();
			var A_Period2 = $("select[name=A_Period2] option:selected").val();
			var A_Card_Name_Number = $("input[name=A_Card_Name_Number]").val();
			var A_Birth = $("input[name=A_Birth]").val();
			var A_CardPhoneNum = $("input[name=A_CardPhoneNum]").val();

			var chkA_Card_Dongle = $("input[name=chkA_Card_Dongle]").val();
			var chkA_Card_DongleIDX = $("input[name=chkA_Card_DongleIDX]").val();		//idx

			var chkA_CardType = $("input[name=chkA_CardType]").val();
			var chkA_CardCode = $("input[name=chkA_CardCode]").val();

			var chkA_CardNumber = $("input[name=chkA_CardNumber]").val();
			var chkA_Period1 = $("input[name=chkA_Period1]").val();
			var chkA_Period2 = $("input[name=chkA_Period2]").val();
			var chkA_Card_Name_Number = $("input[name=chkA_Card_Name_Number]").val();
			var chkA_Birth = $("input[name=chkA_Birth]").val();
			var chkA_Birth = $("input[name=chkA_Birth]").val();
			var chkA_CardPhoneNum = $("input[name=chkA_CardPhoneNum]").val();

			if (cardCheck == "F"){
				alert("카드정보 변경시 카드인증은 필수입니다.");
				doubleSubmit = false;
				return false;
			}

			if ($("#KEYIN_CARDAUTH_TF").val() == "T")
			{
				if (A_CardType != chkA_CardType) {
					alert2("인증받은 카드구분과 선택된 카드구분이 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardCode != chkA_CardCode) {
					alert2("인증받은 카드사와 입력된 카드사가 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardNumber != chkA_CardNumber) {
					alert2("인증받은 카드번호와 입력된 카드번호가 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if ((A_Period1 != chkA_Period1) || (A_Period2 != chkA_Period2)) {
					alert2("인증받은 유효기간과 입력된 유효기간이 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_Card_Name_Number != chkA_Card_Name_Number) {
					alert2("인증받은 소유자명과 입력된 소유자명이 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_Birth != chkA_Birth) {
					alert2("인증받은 생년월일(사업자번호)과 입력된 생년월일이 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardPhoneNum != chkA_CardPhoneNum) {
					alert2("인증받은 휴대폰번호와 입력된 휴대폰번호가 다릅니다.","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}

			}

		}

		var indexArray = [];
		var countArray = [];
		var itemArray = [];
		var uptArray = [];

		$(".innerTable .regItemCount").each(function(){
			var conutVal = $(this).val().replace(/[^0-9]/g,"");
			if (conutVal == ""){
				countArray.push(0);
			} else {
				countArray.push(conutVal);
			}
		});

		$(".innerTable .selItemIndex").each(function(){
			//console.log((this).val());
			indexArray.push($(this).val());
		});

		$(".innerTable .selItemCode").each(function(){
			itemArray.push($(this).text());
		});

		$(".innerTable select[name=ItemCode]").each(function(){
			uptArray.push($(this).css("display") == "none" ? "F" : "T");
		});

		if (countArray.length < 1) {
			alert("정기결제 상품은 1개 이상 있어야 합니다.");
			doubleSubmit = false;
			return false;
		}

		for (var i=0;i<countArray.length;i++){
			if ((parseInt(countArray[i]) < 1 || itemArray[i] == "") && uptArray[i] == "T") {
				alert("정기결제 상품 목록 중 "+(i+1)+"번째 상품의 수량 또는 상품명을 입력해 주세요.");
				doubleSubmit = false;
				return false;
			}
		}

		if (countArray.length > 1) {
			for (var i=0;i<itemArray.length;i++){
				for (var j=(i+1);j<itemArray.length;j++){
					if (itemArray[i] == itemArray[j]) {
						alert("중복 등록된 상품이 있습니다. 확인 바랍니다["+(i+1)+"번째 / "+(j+1)+"번째]");
						doubleSubmit = false;
						return false;
					}
				}
			}
		}

		var jsonData = {
			"oIDX" : oIDX,

			"recvChk" : recvChk,
			"strName" : strName,
			"strZip" : strZip,
			"strADDR1" : strADDR1,
			"strADDR2" : strADDR2,
			"strMobile" : strMobile,
			"strTel" : strTel,

			"A_ProcDay" : A_ProcDay,
			"Ori_A_ProcDay" : Ori_A_ProcDay,
			/*
			"A_Month_Date" : A_Month_Date,
			"Ori_A_Month_Date" : Ori_A_Month_Date,
			*/
			"A_AutoCnt" : A_AutoCnt,
			"Ori_A_AutoCnt" : Ori_A_AutoCnt,
			"cardInfoChk" : cardInfoChgChk,

			"chkA_Card_Dongle" : chkA_Card_Dongle,
			"chkA_Card_DongleIDX" : chkA_Card_DongleIDX,		//idx

			"A_CardCode" : A_CardCode,
			"A_CardNumber" : A_CardNumber,
			"A_Period1" : A_Period1,
			"A_Period2" : A_Period2,
			"A_Card_Name_Number" : A_Card_Name_Number,
			"A_Birth" : A_Birth,

			"indexArray" : JSON.stringify(indexArray),
			"countArray" : JSON.stringify(countArray),
			"itemArray" : JSON.stringify(itemArray),
			"uptArray" : JSON.stringify(uptArray),

			"INFO_CHANGE_TF" : INFO_CHANGE_TF
		};

		$.ajax({
			type: "POST"
			,url: "ajax_order_CMS_mod.asp"
			,data : jsonData
			,success:function(data) {
				retData = JSON.parse(data);
				if (retData.result == "success") {
					alert(retData.message);
					location.reload();
				} else {
					doubleSubmit = false;
					alert(retData.message);
				}
			}
			,error:function(data) {
				doubleSubmit = false;
				alert(retData.message);
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});

	}

	function fnCancel(){
		var oIDX = $("input[name=oIDX]").val();
		var INFO_CHANGE_TF = $("input[name=INFO_CHANGE_TF]").val();
		if (INFO_CHANGE_TF != "T")	{
			alert("결제 예정일 2일 전까지 수정 할 수 있습니다.");
			return false;
		}

		var askYn = confirm("정기결제를 취소하시겠습니까?");

		if (askYn) {
			$.ajax({
				type: "POST"
				,url: "ajax_order_CMS_del.asp"
				,data : {
					 "oIDX" : oIDX
					,"INFO_CHANGE_TF" : INFO_CHANGE_TF
				}
				,success:function(data) {
					retData = JSON.parse(data);
					if (retData.result == "success") {
						alert(retData.message);
						location.href="order_list_CMS.asp";
					} else {
						alert(retData.message);
					}
				}
				,error:function(data) {
					alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});
		}
	}



	/*
	function paramSet(paykey, cardNumb, cardIssureCode, cardPurchaserCode)
	{
		document.cfrm.payKey.value	= paykey;
		document.cfrm.cardNumb.value	= cardNumb;
		document.cfrm.cardIssureCode.value	= cardIssureCode;
		document.cfrm.cardPurchaserCode.value	= cardPurchaserCode;
		//추가
		document.cfrm.chkA_Card_Dongle.value	= paykey;
		document.cfrm.cardCheck.value	= "T";
		$("#cardCheck").text("정상 인증처리 되었습니다")
		//PRINT "<span style=""color:blue;font-weight:bold"">정상 인증처리 되었습니다.</span>"

	}
	*/

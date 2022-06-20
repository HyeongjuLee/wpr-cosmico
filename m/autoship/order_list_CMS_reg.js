
	var doubleSubmit = false;
	function fnSubmit(){
		//doubleSubmit 체크
		if (!doubleSubmit) {
			doubleSubmit = true;
		} else {
			alert("처리중입니다. 잠시 기다려주세요.");
			return false;
		}

		var autoship_agree = $("#autoship_agree").prop("checked")?"T":"F";
		var strName = $("input[name=strName]").val();
		var strZip = $("#strZipDaum").val();
		var strADDR1 = $("#strADDR1Daum").val();
		var strADDR2 = $("#strADDR2Daum").val();
		var strMobile = $("input[name=strMobile]").val();
		var strTel = $("input[name=strTel]").val();

		var cardCheck = $("input[name=cardCheck]").val();

		var A_CardType = $("select[name=A_CardType] option:selected").val();
		var A_CardCode = $("select[name=A_CardCode] option:selected").val();
		var A_CardNumber1 = $("#A_CardNumber1").val();
		var A_CardNumber2 = $("#A_CardNumber2").val();
		var A_CardNumber3 = $("#A_CardNumber3").val();
		var A_CardNumber4 = $("#A_CardNumber4").val();
		var A_CardNumber = A_CardNumber1+A_CardNumber2+A_CardNumber3+A_CardNumber4;
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
		var chkA_CardPhoneNum = $("input[name=chkA_CardPhoneNum]").val();

		var A_Start_Date = $("input[name=A_Start_Date]").val();
		var A_AutoCnt = $("select[name=A_AutoCnt] option:selected").val();
		var A_ETC = $("input[name=A_ETC]").val();

		if (autoship_agree == "F"){
			alert("정기결제 정보제공에 동의하셔야합니다.");
			$("#autoship_agree").focus();
			doubleSubmit = false;
			return false;
		}

		if (strName == "" || $.trim(strName) == ""){
			alert("수취인명을 입력 해 주세요.");
			$("input[name=strName]").focus();
			doubleSubmit = false;
			return false;
		}

		if (strZip == "" || strADDR1 == ""){
			alert("주소를 정확하게 입력 해 주세요.");
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

		if (cardCheck == "F"){
			alert("카드인증은 필수입니다.");

			$('html, body').animate({scrollTop : $("#CARD_INFO").offset().top-80}, 100);
			doubleSubmit = false;
			return false;
		}

		let PGCOMPANY = $("input[name=PGCOMPANY]").val();

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

		if (A_Start_Date == "") {
			alert("희망 정기결제 시작일을 입력 해 주세요.1");
			$("input[name=A_Start_Date]").focus();
			getCenterDatepicker();
			doubleSubmit = false;
			return false;
		}

		if (A_AutoCnt == "") {
			alert("적용개월을 선택 해 주세요.");
			$("input[name=A_AutoCnt]").focus();
			doubleSubmit = false;
			return false;
		}

		var indexArray = [];
		var countArray = [];
		var itemArray = [];

		$(".innerTable .regItemCount").each(function(){
			var conutVal = $(this).val().replace(/[^0-9]/g,"");
			if (conutVal == ""){
				countArray.push(0);
			} else {
				countArray.push(conutVal);
			}
		});

		$(".innerTable .selItemIndex").each(function(){
			indexArray.push($(this).val());
		});

		$(".innerTable .selItemCode").each(function(){
			itemArray.push($(this).text());
		});

		if (countArray.length < 1) {
			alert("정기결제 상품은 1개 이상 있어야 합니다.");
			doubleSubmit = false;
			return false;
		}

		for (var i=0;i<countArray.length;i++){
			if ((parseInt(countArray[i]) < 1 || itemArray[i] == "")) {
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
			"strName" : strName,
			"strZip" : strZip,
			"strADDR1" : strADDR1,
			"strADDR2" : strADDR2,
			"strMobile" : strMobile,
			"strTel" : strTel,

			"cardCheck"			: cardCheck,										//add
			"chkA_Card_Dongle" : chkA_Card_Dongle,
			"chkA_Card_DongleIDX" : chkA_Card_DongleIDX,		//idx

			"A_CardCode" : A_CardCode,
			"A_CardNumber" : A_CardNumber,
			"A_Period1" : A_Period1,
			"A_Period2" : A_Period2,
			"A_Card_Name_Number" : A_Card_Name_Number,
			"A_Birth" : A_Birth,

			"chkA_Card_Dongle" : chkA_Card_Dongle,
			"A_Start_Date" : A_Start_Date,
			"A_AutoCnt" : A_AutoCnt,
			//"A_ETC" : A_ETC,

			"indexArray" : JSON.stringify(indexArray),
			"countArray" : JSON.stringify(countArray),
			"itemArray" : JSON.stringify(itemArray)
		};

		var askYn = confirm("등록하시겠습니까?");

		if (askYn) {
			$("#loadingsA").css("display","block");

			$.ajax({
				type: "POST"
				,url: "ajax_order_CMS_reg.asp"
				,data : jsonData
				,success:function(data) {
					retData = JSON.parse(data);
					if (retData.result == "success") {
						alert(retData.message);
						location.href="order_list_CMS.asp";
					} else {
						doubleSubmit = false;
						alert(retData.message);
					}
					$("#loadingsA").css("display","none");

				}
				,error:function(data) {
					doubleSubmit = false;
					alert(retData.message);
					alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
					$("#loadingsA").css("display","none");
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
	}
	*/


	$(document).ready(function() {
		fnRecvModify();
		fnCardModify();
	});

	//CMS 상품 삭제
	function delThis(idx) {
		var m = document.mfrm;

		if (confirm('<%=LNG_AUTOSHIP_CMS_JS_01%>\n\n<%=LNG_AUTOSHIP_CMS_JS_02%>'))
		{
			m.mode.value = 'DELETE_G';
			m.intIDX.value		= idx;			//arr_Salesitemindex
			m.submit();
		}
	}


	//등록된 제품 변경
	function modTable(idx){
		var innerTable = $(".innerTable tbody");
		var tr = innerTable.children().eq((idx-1));
		var td = tr.children();

		td.eq(1).find("input[name=regItemCount]").css("display", "block");
		td.eq(1).find(".viewCount").css("display", "none");
		td.eq(2).find("select[name=regItemCode]").css("display", "block");
		td.eq(2).find(".viewItemName").css("display", "none");
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


	//팝업인증
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
			alert("<%=LNG_TEXT_PROCESSING%>");
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
			alert("<%=LNG_AUTOSHIP_CMS_AJAX_09%>");
			doubleSubmit = false;
			return false;
		}

		if (recvChk == "T"){
			if (strName == "" || $.trim(strName) == ""){
				alert("<%LNG_AUTOSHIP_CMS_JS_03=%>");
				$("input[name=strName]").focus();
				doubleSubmit = false;
				return false;
			}

			if (strZip == "" || $.trim(strZip) == ""){
				alert("<%=LNG_AUTOSHIP_CMS_JS_04%>");
				$("input[name=strADDR1]").focus();
				$("#pop_postcode").click();
				doubleSubmit = false;
				return false;
			}

			if (strADDR1 == "" || $.trim(strADDR1) == ""){
				alert("<%=LNG_AUTOSHIP_CMS_JS_04%>");
				$("input[name=strADDR1]").focus();
				$("#pop_postcode").click();
				doubleSubmit = false;
				return false;
			}
			if (strADDR2 == "" || $.trim(strADDR2) == ""){
				alert("<%=LNG_JS_ADDRESS2%>");
				$("input[name=strADDR2]").focus();
				doubleSubmit = false;
				return false;
			}

			if (strMobile == "" || $.trim(strMobile) == ""){
				alert("<%=LNG_AUTOSHIP_CMS_JS_05%>");
				$("input[name=strMobile]").focus();
				doubleSubmit = false;
				return false;
			}
		}


		var cardInfoChk = $("input[name=cardInfoChgChk]").prop("checked")?"T":"F";
		/*
		var A_Month_Date = $("select[name=A_Month_Date] option:selected").val();
		var Ori_A_Month_Date = $("input[name=Ori_A_Month_Date]").val();
		*/
		var A_AutoCnt = $("select[name=A_AutoCnt] option:selected").val();
		var Ori_A_AutoCnt = $("input[name=Ori_A_AutoCnt]").val();
		var totalPrice = $("#totalPrice").text().replace(/[^0-9]/g,"");
		/*
		if (A_Month_Date == "") {
			alert("정기결제 기준일자를 선택 해 주세요.");
			doubleSubmit = false;
			return false;
		}
		*/

		if (A_AutoCnt == "") {
			alert("<%=LNG_AUTOSHIP_CMS_JS_06%>");
			doubleSubmit = false;
			return false;
		}

		if (cardInfoChk == "T"){

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
			var chkA_CardPhoneNum = $("input[name=chkA_CardPhoneNum]").val();

			if (cardCheck == "F"){
				alert("<%=LNG_AUTOSHIP_CMS_JS_07%>");
				doubleSubmit = false;
				return false;
			}

			let PGCOMPANY = $("input[name=PGCOMPANY]").val();

			if ($("#KEYIN_CARDAUTH_TF").val() == "T")
			{
				if (A_CardType != chkA_CardType) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_CARD_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardCode != chkA_CardCode) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_CODE_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardNumber != chkA_CardNumber) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_NUMBER_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if ((A_Period1 != chkA_Period1) || (A_Period2 != chkA_Period2)) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_DATE_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_Card_Name_Number != chkA_Card_Name_Number) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_NAME_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_Birth != chkA_Birth) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_BIRTH_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}
				if (A_CardPhoneNum != chkA_CardPhoneNum) {
					alert2("<%=LNG_AUTOSHIP_CMS_JS_MOBILE_TYPE%>","#cardCheckSpan","F");
					doubleSubmit = false;
					return false;
				}

			}

		}

		var itemTable = $(".innerTable tbody tr");
		var itemUptArray = [];
		var itemIdxArray = [];
		var itemCountArray = [];
		var itemCodeArray = [];

		itemTable.each(function(){
			var add = $(this).hasClass("cloneTr")?"T":"F";
			var td = $(this).children();
			var itemIdx = td.eq(0).text();
			var itemCount = td.eq(1).find("input[name=regItemCount]").val();
			var itemCode = td.eq(2).find("select[name=regItemCode] option:selected").val();

			var itemUpt = td.eq(2).find("select[name=regItemCode]").css("display") == "none"?"F":"T";

			itemIdxArray.push(itemIdx);
			itemCountArray.push(itemCount);
			itemCodeArray.push(itemCode);
			itemUptArray.push(itemUpt);
		});





		if (itemIdxArray.length < 1) {
			alert("<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_01%>");
			doubleSubmit = false;
			return false;
		}

		for (var i=0;i<itemCountArray.length;i++){
			if ((parseInt(itemCountArray[i]) < 1 || itemCodeArray[i] == "") && itemUptArray[i] == "T") {
				alert("<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_02%>"+(i+1)+"<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_03%>");
				doubleSubmit = false;
				return false;
			}
		}

		if (itemCountArray.length > 1) {
			for (var i=0;i<itemCodeArray.length;i++){
				for (var j=(i+1);j<itemCodeArray.length;j++){
					if (itemCodeArray[i] == itemCodeArray[j]) {
						alert("<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_04%> ["+(i+1)+"<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_05%> / "+(j+1)+"<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_05%>]");
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
			"cardInfoChk" : cardInfoChk,

			"chkA_Card_Dongle" : chkA_Card_Dongle,
			"chkA_Card_DongleIDX" : chkA_Card_DongleIDX,		//idx

			"A_CardCode" : A_CardCode,
			"A_CardNumber" : A_CardNumber,
			"A_Period1" : A_Period1,
			"A_Period2" : A_Period2,
			"A_Card_Name_Number" : A_Card_Name_Number,
			"A_Birth" : A_Birth,

			"totalPrice" : totalPrice,
			"itemIdxArray" : JSON.stringify(itemIdxArray),
			"itemCountArray" : JSON.stringify(itemCountArray),
			"itemCodeArray" : JSON.stringify(itemCodeArray),

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
				alert("<%=LNG_AJAX_ERROR_MSG%>"+data.status+" "+data.statusText+" "+data.responseText);
			}
		});

	}

	function fnCancel(){
		var oIDX 		   = $("input[name=oIDX]").val();
		var INFO_CHANGE_TF = $("input[name=INFO_CHANGE_TF]").val();
		if (INFO_CHANGE_TF != "T")	{
			alert("<%=LNG_AUTOSHIP_CMS_AJAX_09%>");
			return false;
		}

		var askYn = confirm("<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_06%>");

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
					alert("<%=LNG_AJAX_ERROR_MSG%>"+data.status+" "+data.statusText+" "+data.responseText);
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
		$("#cardCheck").text("<%=LNG_AUTOSHIP_CMS_JS_PRODUCT_07%>")
		//PRINT "<span style=""color:blue;font-weight:bold""><%=LNG_AUTOSHIP_CMS_JS_PRODUCT_07%></span>"

	}
	*/

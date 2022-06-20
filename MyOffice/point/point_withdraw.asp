<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strFuncClosePay.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	'포인트 출금
	PAGE_SETTING = "MYOFFICE"
	'INFO_MODE	 = "POINT1-4"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_CS_MEMBER()							'판매원만
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)

	'출금비번 등록 확인
	If CONFIG_SendPassWord = "" Then Call ALERTS(LNG_JS_MONEY_OUTPUT_PIN,"go",MOB_PATH&"/mypage/member_info.asp")

	If CONFIG_CPNO_OK = "F" Then
		If FN_CLOSEPAY_TOTAL(DK_MEMBER_ID1,DK_MEMBER_ID2) > 0 Then
			Call ALERTS("올바른 주민번호가 입력되지 않았습니다. \n\n주민번호는 마이페이지에서 입력가능합니다.","go",MOB_PATH&"/mypage/member_info.asp")
		Else
			Call ALERTS("발생한 수당이 없습니다. (출금 불가)","BACK","")
		End IF
	End If


	If CONFIG_BANKINFO = "F" Then
		''Call ALERTS("계좌번호가 등록되지 않은 경우 전환 신청을 할 수 없습니다.","back","")
		Call ALERTS("계좌번호 등록페이지로 이동합니다.","GO","/mypage/member_bankinfo_change.asp")
	End If

	mn = gRequestTF("mn", False)
	'마일리지123 분기 / 치환  =============================================S
	Select Case mn
		Case "1"		'mileage
			'Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT1-4"
			MILEAGE_TOTAL = MILEAGE_TOTAL										'사용가능 포인트
			transPointFEE = 0																'출금수수료
			WITHDRAW_UNIT = CONST_CS_WITHDRAW_UNIT					'출금액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_WITHDRAW_POINT	'최소출금액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)							'최대출금액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_WITHDRAW		'출금 수수료(율)
			orderNumBegin = "PW1_"
			GO_URL_QS = "?mn=1"

		Case "2"		'Bo
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT2-4"
			MILEAGE_TOTAL = MILEAGE2_TOTAL										'사용가능 포인트2
			transPointFEE = 0																	'출금수수료
			WITHDRAW_UNIT = CONST_CS_WITHDRAW_UNIT_2					'출금액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_WITHDRAW_POINT_2	'최소출금액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)								'최대출금액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_WITHDRAW_2		'출금 수수료(율)
			orderNumBegin = "PW2_"
			GO_URL_QS = "?mn=2"

		Case "3"		'Za
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT3-4"
			MILEAGE_TOTAL = MILEAGE3_TOTAL										'사용가능 포인트3
			transPointFEE = 0																	'출금수수료
			WITHDRAW_UNIT = CONST_CS_WITHDRAW_UNIT_3					'출금액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_WITHDRAW_POINT_3	'최소출금액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)								'최대출금액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_WITHDRAW_3		'출금 수수료(율)
			orderNumBegin = "PW3_"
			GO_URL_QS = "?mn=3"

		Case Else
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End Select

	If MILEAGE_TOTAL = "" Or WITHDRAW_UNIT = "" Or FEE_PERCENT = "" Or  MINIMUM_POINT = "" Then
		Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End If
	'마일리지123 분기 / 치환  =============================================E

	'▣전환금액조건값
	HJRSC_BTC_qoute			= 0
	BTC_QOUTE_1USD_INPUT	= 0
	btc_usd					= 0
	btc_usd_PERCENT			= 0

	'Call ResRW(MILEAGE_TOTAL,"MILEAGE_TOTAL")
%>
<%
	orderNum = Replace(makeOrderNo(),"MT",orderNumBegin)


	'▣ 주문번호 중복체크
	SQL_D = "SELECT COUNT(*) FROM [HJ_POINT_CHECK] WITH(NOLOCK) WHERE [OrderNum] = ?"
	arrParamsD = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum)_
	)
	orderNum_DCNT = Db.execRsData(SQL_D,DB_TEXT,arrParamsD,DB3)
	If orderNum_DCNT > 0 Then Call ALERTS("Please try again in a few minutes.(dcnt)","back","")


	'▣ TEMP주문 삭제 / 입력
	arrParams = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_

		Db.makeParam("@strUsePageName",adVarChar,adParamInput,50,Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")),_
		Db.makeParam("@GoogleOTPCheck",adChar,adParamInput,1,"F"),_
		Db.makeParam("@BTC_qoute",adDouble,adParamInput,16,HJRSC_BTC_qoute), _
		Db.makeParam("@BTC_QOUTE_1USD",adDouble,adParamInput,16,BTC_QOUTE_1USD_INPUT), _
		Db.makeParam("@FEE_PERCENT",adDouble,adParamInput,16,FEE_PERCENT), _
		Db.makeParam("@transPointTOTAL",adDouble,adParamInput,16,0), _
		Db.makeParam("@transPoint",adDouble,adParamInput,16,0), _
		Db.makeParam("@transPointFEE",adDouble,adParamInput,16,0), _
		Db.makeParam("@WITHDRAW_UNIT",adDouble,adParamInput,16,WITHDRAW_UNIT), _
		Db.makeParam("@MINIMUM_POINT",adDouble,adParamInput,16,MINIMUM_POINT), _
		Db.makeParam("@MAXIMUM_POINT",adDouble,adParamInput,16,MAXIMUM_POINT), _

		Db.makeParam("@BTC_qoute",adDouble,adParamInput,16,btc_usd), _
		Db.makeParam("@btc_usd_PERCENT",adDouble,adParamInput,16,btc_usd_PERCENT), _
		Db.makeParam("@TranBTC",adDouble,adParamInput,16,0), _

		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _

		Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_POINT_CHECK_INSERT",DB_PROC,arrParams,DB3)
	orderTempIDX = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	If OUTPUT_VALUE = "ERROR" Then Call ALERTS(LNG_CS_ORDERS_ALERT02,"back","")

%>
<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" type="text/css" href="/css/style_cs.css" /> -->
<link rel="stylesheet" type="text/css" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" type="text/css" href="/css/point.css?v0" />
<script type="text/javascript">

	var doubleSubmit
	doubleSubmit = false;


	$(document).ready(function() {
		$('form input').keydown(function() {
			if (event.keyCode === 13) {
				event.preventDefault();
			}
		});
	});

	function submitChk(f) {
		var f = document.cfrm;

		var pointTXT = "<%=SHOP_POINT%>";
		var Z = Number('1e' + 0); // 0자리(INT)

		if (!doubleSubmit) {
			doubleSubmit = true;
		} else {
			$("#loadingPro").show();
			$("input[type=submit]").attr("disabled",true);
			alert("processing is in progress. Please wait a moment.");
			return false;
		}

		 //google OTP
		<%If GOOGLE_OTP_USE_TF = "T" Then%>
			if (chkEmpty(f.Google_OTP)) {
				alert("<%=LNG_GOOGLE_OTP_NOT%>");
				f.googlePin.focus();
				doubleSubmit = false;
				return false;
			}
		<%End If %>

		if (chkEmpty(f.transPoint)) {
			alert("<%=LNG_CS_POINT_TRANSFER2CASH_JS01%>");
			f.transPoint.focus();
			doubleSubmit = false;
			return false;
		}

		<%If FEE_PERCENT > 0 Then%>
			if (f.pointCheckTF.value == 'F'){
				alert("<%=LNG_TEXT_POINT_CONFIRM%>");
				f.pointCheckTF.focus();
				doubleSubmit = false;
				return false;
			}
			if (f.transPoint.value != f.transPointChk.value){
				alert("<%=LNG_TEXT_POINT_CONFIRM_CHANGED%>");
				f.transPoint.focus();
				$("#pointCheckMsg").text("<%=LNG_TEXT_POINT_CONFIRM_CHANGED%>").addClass("red2");
				doubleSubmit = false;
				return false;
			}
		<%End If%>

		//console.log( (  (parseFloat(f.transPoint.value)*Z) + (parseFloat(f.transPointFEE.value)*Z) )  / Z );
		if ( parseFloat(<%=MILEAGE_TOTAL%>) < ( (parseFloat(stripComma(f.transPoint.value))*Z) + (parseFloat(stripComma(f.transPointFEE.value))*Z)) /Z )
		{
			alert("<%=LNG_CS_POINT_TRANSFER2CASH_JS02%>");
			f.transPoint.focus();
			doubleSubmit = false;
			return false;
		}

		if (parseFloat(stripComma(f.transPoint.value)) < parseFloat(<%=MINIMUM_POINT%>)) {
			alert("<%=LNG_MINIMUM_WITHDRAW_POINT%> - (<%=MINIMUM_POINT%>)");
			f.transPoint.value= <%=MINIMUM_POINT%>;
			f.transPoint.focus();
			doubleSubmit = false;
			return false;
		}

		if (chkEmpty(f.SendPassWord)) {
			alert("<%=LNG_JS_PASSWORD_TRANSFER%>");
			f.SendPassWord.focus();
			doubleSubmit = false;
			return false;
		}


		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			,async : false
			,url: "/mypage/ajax_member_outpin_confirm.asp"
			,data: {
				"SendPassWord_ori": f.SendPassWord.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);
				//alert(jsonData);
				if (json.result == "success")
				{
					$("#Money_Output_Pin_Check").html("");
					ajaxTF = "true";
				} else {
					$("#Money_Output_Pin_Check").html(json.message).addClass("red tweight").removeClass("blue");
					doubleSubmit = false;
					return false;
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});
		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}


		if (confirm("<%=LNG_CS_POINT_TRANSFER2CASH_JS04%>")) {
			$("#Money_Output_Pin_Check").html("");
			$("#loadingPro").show();
			<%If FEE_PERCENT < 1 Then%>
				point_check();
			<%End If%>
			$("input[type=submit]").attr("disabled",true);			//double submit check
			f.action = "point_withdraw_OK.asp";
			return true;
		}else{
			//f.reset();
			doubleSubmit = false;
			return false;
		}
	}

	$(document).ready(function() {
		<%If GOOGLE_OTP_USE_TF = "T" Then%>
		$("input[name=transPoint]").val('').attr('readonly',true).addClass("readonly");
		<%End IF%>
	});

	// 소수점 0자리 변환(<%=onLyKeysINT%> toCurrency_INT)
	function toCurrency_INT(obj) {
		if (obj.disabled) return false;
		let num = obj.value.stripspace();

		if (num == "") return false;
			num = num.replace(/[^0-9\,]/g,'')
		if (num == "."  ) {num = num.replace(".","")}
		if (num == "00"  ) {num = num.replace("00","0")}
		if (num >= 1 || num == "00" ) {num = removePreZero(num);}
		obj.value = formatComma(num,0);

		/*
			//입력값 실시간 계산
			let Z = Number('1e' + 0); // 자리수
			let numCal = stripComma( num );		//컴마제거
			let numCal_FeEE 	= numCal * 0.02;						//수수료
			//let numCal_FeEE 	= 0;									//이체수수료 없음
			let transPointTOTAL_TXT 	= ((numCal*Z) + (numCal_FeEE*Z) ) / Z;	//총 출금액
			$("#transPointFEE_TXT").text(CoinFormatter_INT.format(numCal_FeEE));		//출금수수료 txt
			$("input[name=transPointFEE]").val(numCal_FeEE.toFixed());		//출금수수료 input
			$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(transPointTOTAL_TXT));  	//총 출금액(수수료 포함)
		*/

		//ajax확인후 입력값 변동시 변경시 초기화
		if ($("input[name=transPoint]").val() != $("input[name=transPointChk]").val()){
			$("#transPointFEE_TXT").text(CoinFormatter_INT.format(0));  	//출금수수료 txt
			$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(0));  	//총 출금액(수수료 포함)
		}
	}

	//입력값 실시간 계산
	/*
	function checkFee(num) {
		if (num == "") return false;
		let Z = Number('1e' + 0); // 자리수
		let numCal = ( num );		//컴마제거
		let numCal_FeEE 	= numCal * 0.02;						//수수료
		//let numCal_FeEE 	= 0;									//이체수수료 없음
		let transPointTOTAL_TXT 	= ((numCal*Z) + (numCal_FeEE*Z) ) / Z;	//총 출금액

		$("#transPointFEE_TXT").text(CoinFormatter_INT.format(numCal_FeEE));		//출금수수료 txt
		$("input[name=transPointFEE]").val(numCal_FeEE.toFixed());		//출금수수료 input
		$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(transPointTOTAL_TXT));  	//총 출금액(수수료 포함)
	}
	*/

	<%If GOOGLE_OTP_USE_TF = "T" Then%>
		function fnGoogleOTPCheck(){
			var googlePin = $("#googlePin").val();

			if ($.trim(googlePin).length < 6) {
				alert("<%=LNG_VALIDATE_PIN_MSG%>");
				return false;
			}

			$.ajax({
				type: "POST",
				async : false,
				data : {
						"googlePin" : googlePin,
						"OIDX"		 : <%=orderTempIDX%>
				},
				url: "/mypage/google_otp_check.asp",
				success: function(jsonData) {
					var json = $.parseJSON(jsonData);
					if (json.result == "success") {
						alert("<%=LNG_GOOGLE_OTP_AUTH_OK%>");

						$("input[name=Google_OTP]").val('T');
						$("#googleAuth").empty();
						$("#googleAuth").append('<span style="color:blue;"><%=LNG_GOOGLE_OTP_AUTH_OK%></span>');
						$("#pointCheck").show();
						$("input[name=transPoint]").attr('readonly',false).removeClass("readonly");
						return false;
					} else {
						alert(json.resultMsg);

						$("input[name=transPoint]").attr('readonly',true).addClass("readonly");
						return false;
					}
				},
				error:function(jsonData) {
					alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
				}

			});
		}
	<%End IF%>

	//포인트체크 추가
	function point_check() {
		var f = document.cfrm;
		if (f.transPoint.value == '')
		{
			alert("<%=LNG_CS_POINT_TRANSFER_JS02%>");
			f.transPoint.focus();
			return false;
		}

		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_point_T2C_confirm.asp"
			,data: {
				"transPoint"	: f.transPoint.value,
				"OIDX"			: "<%=orderTempIDX%>",
				"OrderNum"		: "<%=OrderNum%>"
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success")
				{
					$("#pointCheckMsg").text("");
					$("#pointCheckTF").val("T");
					$("#transPointFEE_TXT").text(CoinFormatter_INT.format(json.resultData.transPointFEE));
					$("input[name=transPointFEE]").val($("#transPointFEE_TXT").text());
					//총 출금액(수수료 포함)
					$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(json.resultData.transPointTOTAL));
					$("#transPointChk").val($("input[name=transPoint]").val());  	//입력값 변동체크

				} else if (json.result == "minimum") {
					alert(json.message);
					$("#pointCheckMsg").text(json.message).addClass("red2");
					$("#pointCheckTF").val("F");
					$("#transPointFEE_TXT").text(CoinFormatter_INT.format(json.resultData.transPointFEE));
					$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(json.resultData.transPointTOTAL));
					$("input[name=transPoint]").val(CoinFormatter_INT.format(json.resultData.transPoint));
					//$("input[name=transPoint]").val((json.resultData.transPoint));

				} else {
					alert(json.message);
					$("#pointCheckMsg").text(json.message).addClass("red2");
					$("#pointCheckTF").val("F");
					$("#transPointFEE_TXT").text(CoinFormatter_INT.format(0));
					$("#transPointTOTAL_TXT").text(CoinFormatter_INT.format(0));
					$("input[name=transPoint]").val("").focus();
					//$("#MAXIMUM_POINT_TXT").show();
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});

	}


	//금액버튼
	function ptup100s(point) {
		var f = document.cfrm;

		if (f.transPoint.value == "") {
			$("input[name=transPoint]").val(0);
		}

		fpoint = parseInt(stripComma(f.transPoint.value));
		$("input[name=transPoint]").val(formatComma(fpoint + point));
		//checkFee(fpoint + point);
	}
	function ptdw100s(point) {
		var f = document.cfrm;

		if (f.transPoint.value == "") {
			$("input[name=transPoint]").val(0);
		}

		fpoint = parseInt(stripComma(f.transPoint.value));

		if ((fpoint - point) < parseInt(<%=MINIMUM_POINT%>,10)) {
			alert("<%=LNG_MINIMUM_WITHDRAW_POINT%> : <%=num2cur(CONST_CS_MINIMUM_WITHDRAW_POINT)%>");
			$("input[name=transPoint]").val(formatComma(<%=MINIMUM_POINT%>));
			//checkFee(<%=MINIMUM_POINT%>);
		}else{
			$("input[name=transPoint]").val(formatComma(fpoint - point));
			//checkFee(fpoint - point);
		}
	}
	function ptReset(point) {
		var f = document.cfrm;
		$("input[name=transPoint]").val(formatComma(point));
	}

</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="loadingPro" >
	<div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div>
</div>
<div id="point" class="tableTrans">
	<form name="cfrm" method="post" action="point_withdraw_OK.asp" onsubmit="return submitChk(this);">
		<input type="hidden" name="Google_OTP" value="" readonly="readonly" />
		<input type="hidden" id="pointCheckTF" name="pointCheckTF" value="F" readonly="readonly" />
		<input type="hidden" id="transPointChk" name="transPointChk" value="0" readonly="readonly" />
		<input type="hidden" name="transPointFEE" value="0" readonly="readonly" />
		<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" readonly="readonly" />
		<input type="hidden" name="OrderNum" value="<%=OrderNum%>" readonly="readonly"  />

		<p class="titles"><%=LNG_CS_POINT_TRANSFER_TEXT01%></p>
		<table <%=tableatt%> class="total">
			<colgroup>
				<col width="180" />
				<col width="300" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr class="line">
					<th><%=LNG_TEXT_POINT_AVAILABLE_POINT%><!-- <%=LNG_TEXT_POINT%> --></th>
					<td class="price blue2 "><%=num2Cur(MILEAGE_TOTAL)%></td>
					<td></td>
				</tr>
				<tr>
					<th><%=LNG_MINIMUM_WITHDRAW_POINT%></th>
					<td class="price green"><%=num2Cur(MINIMUM_POINT)%></td>
					<td>
						<span class="price red2"><%=LNG_MINIMUM_WITHDRAW_POINT_ALERT%></span>
					</td>
				</tr>
				<tr id="MAXIMUM_POINT_TXT" style="display:none;" >
					<th><%=LNG_MAXIMUM_WITHDRAW_POINT%></th>
					<td class="price red2"><%=num2Cur(MAXIMUM_POINT)%></td>
					<td></td>
				</tr>
				<tr>
					<th>계좌정보</th>
					<td colspan="1">
						<%
							SQL = "SELECT [bankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [ncode] = ?"
							arrParams = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,10,CONFIG_bankcode) _
							)
							DKRS_bankName = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
						%>
						[<%=DKRS_bankName%>] <br /><%=DKRS_bankaccnt%>  [<%=FN_HR_Decrypt(CONFIG_bankaccnt)%>] : <%=CONFIG_bankowner%>
					</td>
					<td>
						<input type="button" class="button" onclick="location.href='/mypage/member_bankinfo_change.asp'" value="<%=LNG_CS_CART_BTN04%>"/>
					</td>
				</tr>

			</tbody>
		</table>
		<%
			If CDbl(MILEAGE_TOTAL) < (CDbl(MINIMUM_POINT) + CDbl(transPointFEE)) Then
				'불가
		%>
		<%Else %>
			<p class="titles"><%=LNG_CS_POINT_TRANSFER2CASH_TEXT05%></p>
			<table <%=tableatt%> class="width100">
				<%
					If Cdbl(MILEAGE_TOTAL) < Cdbl(MINIMUM_POINT) Then
						MIN_POINT = MILEAGE_TOTAL
					Else
						MIN_POINT = MINIMUM_POINT
					End If
				%>
				<%
					DISPLAY_NONE = ""
					If GOOGLE_OTP_USE_TF = "T" Then
					DISPLAY_NONE= "display: none;"
				%>
				<tr>
					<th><%=LNG_GOOGLE_OTP%>&nbsp;<%=starText%></th>
					<td colspan="3" id="googleAuth">
						<div class="inputs">
							<input type="password" name="googlePin" class="input_text" style="width:188px;" maxlength="6" id="googlePin" />
							<input type="button" class="button green" value="<%=LNG_GOOGLE_OTP_CHECK%>" onclick="fnGoogleOTPCheck();" />
						</div>
					</td>
				</tr>
				<%End If%>
				<tr>
					<th><%=LNG_CS_POINT_TRANSFER2CASH_TEXT06%> <%=starText%></th>
					<td colspan="2">
						<input type="text" class="input_text tright" name="transPoint" style="width: 188px;" maxlength="20" value="<%=num2cur(MINIMUM_POINT)%>"  <%=onLyKeysINT%> />
						<%If 1=1 Then%>
							<div class="buttons">
								<button type="button" class="button icon-cancel" onclick="ptReset(<%=MINIMUM_POINT%>)"></button>
								<button type="button" class="button icon-plus-2" onclick="ptup100s(1000);">1,000</a></button>
								<button type="button" class="button icon-plus-2" onclick="ptup100s(10000);">10,000</a></button>
								<button type="button" class="button icon-plus-2" onclick="ptup100s(50000);">50,000</a></button>
							</div>
						<%End If%>
						<%If FEE_PERCENT > 0 Then%>
							<span id="pointCheck" style="<%=DISPLAY_NONE%>">
								<input type="button" class="button green" value="<%=LNG_TEXT_CONFIRM%>" onclick="point_check();" />
								<span class="summary" id="pointCheckMsg"></span>
							</span>
						<%End If%>
					</td>
				</tr>
				<%
					DISPLAY_NONE2 = ""
					If FEE_PERCENT = 0 Then
						DISPLAY_NONE2= "display: none;"
					End If
				%>
				<tr style="<%=DISPLAY_NONE2%>">
					<th><%=LNG_TEXT_POINT_TRANSPOINTFEE%></th>
					<td class="price red2" id="transPointFEE_TXT" style="width: 100px;"><%=num2Cur(transPointFEE)%></td>
					<td><span class=""></span></td>
				</tr>
				<tr style="<%=DISPLAY_NONE2%>">
					<th>
						<%=LNG_CS_POINT_TRANSFER2CASH_TEXT07%>
						<!-- <br />( + <%=LNG_TEXT_POINT_TRANSPOINTFEE%>) -->
					</th>
					<td class="priceTotal red2" id="transPointTOTAL_TXT"><%=num2Cur(transPointFEE)%></td>
					<td>
						<!-- <span>※<%=LNG_CS_POINT_TRANSFER2CASH_TEXT06%> + <%=LNG_TEXT_POINT_TRANSPOINTFEE%></span>
						<span class="red2"><%=LNG_TRANS_POINTFEE_TEXT03%> (<%=CONST_CS_FEE_PERCENT*100%>%)</span> -->
					</td>
				</tr>
				<tr>
					<!-- <th><%=LNG_TEXT_PASSWORD_TRANSFER%>&nbsp;<%=starText%></th> -->
					<th><%=LNG_MONEY_OUTPUT_PIN%>&nbsp;<%=starText%></th>
					<td colspan="3">
						<input type="password" class="input_text" style="width:188px;" name="SendPassWord" maxlength="20" size="24" />
						<span id="Money_Output_Pin_Check"></span>
					</td>
				</tr>
			</table>
		<%End If%>


		<div class="btnZone">
		<%If CDbl(MILEAGE_TOTAL) < (CDbl(MINIMUM_POINT) + CDbl(transPointFEE)) Then%>
			<input type="button" class="cancel" onclick="javascript:alert('<%=LNG_CS_POINT_TRANSFER2CASH_JS05%>\n※<%=LNG_MINIMUM_WITHDRAW_POINT%> : <%=num2cur(CONST_CS_MINIMUM_WITHDRAW_POINT)%>');" value="<%=LNG_CS_GOODSLIST_BTN04%>"/>

		<%ElseIf CDbl(MINIMUM_POINT) <= 0 Then%>
			<input type="button" class="red" onclick="javascript:alert('<%=LNG_JS_MINIMUM_POINT_CHECK%>');" value="<%=LNG_CS_GOODSLIST_BTN04%>"/>

		<%Else%>

			<input type="submit" class="promise" value="<%=LNG_MYOFFICE_POINT_03%>" />

		<%End If%>
		</div>

	</form>
</div>

<!--#include virtual = "/_include/copyright.asp"-->

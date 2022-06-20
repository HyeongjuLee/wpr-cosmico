<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	'포인트 이체
	PAGE_SETTING = "MYOFFICE"
	'INFO_MODE	 = "POINT1-3"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_CS_MEMBER()							'판매원만
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)

	'이체(보안)비번 등록 확인
''	If CONFIG_SendPassWord = "" Then Call ALERTS(LNG_JS_MONEY_OUTPUT_PIN,"go",MOB_PATH&"/mypage/member_info.asp")

	mn = gRequestTF("mn", False)
	'마일리지123 분기 / 치환  =============================================S
	Select Case mn
		Case "1"		'mileage
			INFO_MODE	 = "POINT1-3"
			MILEAGE_TOTAL = MILEAGE_TOTAL									'사용가능 포인트
			transPointFEE = 0															'이체수수료
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)						'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS		'이체 수수료(율)
			orderNumBegin = "PT1_"

		Case "2"		'Bo
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT2-3"
			MILEAGE_TOTAL = MILEAGE2_TOTAL									'사용가능 포인트2
			transPointFEE = 0																'이체수수료
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT_2						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT_2	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)							'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS_2		'이체 수수료(율)
			orderNumBegin = "PT2_"

		Case "3"		'Za
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			INFO_MODE	 = "POINT3-3"
			MILEAGE_TOTAL = MILEAGE3_TOTAL									'사용가능 포인트3
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT_3						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT_3	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)							'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS_3		'이체 수수료(율)
			orderNumBegin = "PT3_"

		Case Else
			Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End Select

	If MILEAGE_TOTAL = "" Or TRANS_UNIT = "" Or FEE_PERCENT = "" Or  MINIMUM_POINT = "" Then
		Call Alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End If
	'마일리지123 분기 / 치환  =============================================E

	'▣이체금액조건값
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
		Db.makeParam("@WITHDRAW_UNIT",adDouble,adParamInput,16,TRANS_UNIT), _
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
<link rel="stylesheet" type="text/css" href="/css/point.css?" />
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

		if (chkEmpty(f.targetName) || chkEmpty(f.NominID1) || chkEmpty(f.NominID2) || f.NominChk.value == 'F') {
			alert("<%=LNG_CS_POINT_TRANSFER_JS01%>");
			f.targetName.focus();
			doubleSubmit = false;
			return false;
		}

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

		if ( parseFloat(<%=MILEAGE_TOTAL%>) < ( (parseFloat(stripComma(f.transPoint.value))*Z) + (parseFloat(stripComma(f.transPointFEE.value))*Z)) /Z )
		{
			alert("<%=LNG_CS_POINT_TRANSFER_JS03%>");
			f.transPoint.focus();
			doubleSubmit = false;
			return false;
		}

		if (parseFloat(stripComma(f.transPoint.value)) < parseFloat(<%=MINIMUM_POINT%>)) {
			alert("<%=LNG_MINIMUM_TRANS_POINT%> - (<%=MINIMUM_POINT%>)");
			f.transPoint.value= <%=MINIMUM_POINT%>;
			f.transPoint.focus();
			doubleSubmit = false;
			return false;
		}

		if (f.NominID1.value == '<%=DK_MEMBER_ID1%>' && f.NominID2.value == '<%=DK_MEMBER_ID2%>') {
			alert("<%=LNG_CS_POINT_TRANSFER_JS05%>");
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


		if (confirm("<%=LNG_CS_POINT_TRANSFER_JS06%>")) {
			$("#Money_Output_Pin_Check").html("");
			$("#loadingPro").show();
			<%If FEE_PERCENT < 1 Then%>
				point_check();
			<%End If%>
			$("input[type=submit]").attr("disabled",true);
			f.action = "point_transfer_OK.asp";
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
		$("input[name=targetName]").val('');
	});


	//소수점 0자리 변환(<%=onLyKeysINT%> toCurrency_INT)
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

		//ajax확인후 입력값 변동시 초기화
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
			,url: "/common/ajax_point_TR_confirm.asp"
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
			alert("<%=LNG_MINIMUM_WITHDRAW_POINT%> : <%=num2cur(CONST_CS_MINIMUM_TRANS_POINT)%>");
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
		checkFee(point);
	}

</script>
</head>
<body>

<!--#include virtual = "/_include/header.asp"-->
<div id="loadingPro" >
	<div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div>
</div>
<div id="point" class="tableTrans">
	<form name="cfrm" method="post" action="point_transfer_OK.asp" onsubmit="return submitChk(this);">
		<input type="hidden" name="NominID1" value="" readonly="readonly" />
		<input type="hidden" name="NominID2" value="" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="" readonly="readonly" />
		<input type="hidden" name="NominChk" value="F" readonly="readonly" />

		<input type="hidden" name="Google_OTP" value="" readonly="readonly" />
		<input type="hidden" id="pointCheckTF" name="pointCheckTF" value="F" readonly="readonly" />
		<input type="hidden" id="transPointChk" name="transPointChk" value="0" readonly="readonly" />
		<input type="hidden" name="transPointFEE" value="0" readonly="readonly" />
		<input type="hidden" name="OIDX" value="<%=orderTempIDX%>" readonly="readonly" />
		<input type="hidden" name="OrderNum" value="<%=OrderNum%>" readonly="readonly"  />

		<p class="titles"><%=LNG_CS_POINT_TRANSFER_TEXT01%></p>
		<table <%=tableatt%> class="total">
			<colgroup>
				<col width="200" />
				<col width="200" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<th><%=LNG_TEXT_POINT_AVAILABLE_POINT%></th>
					<td class="price blue2 "><%=num2Cur(MILEAGE_TOTAL)%></td>
					<td></td>
				</tr><tr>
					<th><%=LNG_TEXT_POINT_MINIMUM%></th>
					<td class="price green"><%=num2Cur(MINIMUM_POINT)%></td>
					<td>
						<span class="price red2"><%=LNG_MINIMUM_TRANS_POINT_ALERT%></span>
					</td>
				</tr>
			</tbody>
		</table>
		<%
			If CDbl(MILEAGE_TOTAL) < (CDbl(MINIMUM_POINT) + CDbl(transPointFEE)) Then
				'불가
		%>
		<%Else %>
			<p class="titles padtop"><%=LNG_TEXT_POINT_POINT_TRANSFER%></p>
			<table <%=tableatt%> class="point_transfer">
				<%
					If Cdbl(MILEAGE_TOTAL) < Cdbl(MINIMUM_POINT) Then
						MIN_POINT = MILEAGE_TOTAL
					Else
						MIN_POINT = MINIMUM_POINT
					End If

					DISPLAY_NONE = ""
					If GOOGLE_OTP_USE_TF = "T" Then
						DISPLAY_NONE= "display: none;"
				%>
				<tr>
					<th><%=LNG_GOOGLE_OTP%>&nbsp;<%=starText%></th>
					<td colspan="2" id="googleAuth">
						<input type="password" name="googlePin" class="input_text" style="width:188px;" maxlength="6" id="googlePin" />
						<input type="button" class="button" value="<%=LNG_GOOGLE_OTP_CHECK%>" onclick="fnGoogleOTPCheck();" />
					</td>
				</tr>
				<%End If %>
				<tr>
					<th><%=LNG_TEXT_POINT_MEBERS_TO_TRANSFER%> <%=starText%></th>
					<td colspan="2" class="tleft">
						<input type="text" name="targetName" class="input_text" style="width: 188px;" maxlength="12" readonly="readonly" />
						<a name="modal" id="popMember" class="button" href="pop_memberSearch.asp" title="<%=LNG_STRFUNCDATA_TEXT05%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
					</td>
				</tr>
				<tr>
					<th><%=LNG_TEXT_POINT_POINT_TO_TRANSFER%> <%=starText%></th>
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
						<%=LNG_TEXT_POINT_TRANSPOINT_TOTAL%>
						<!-- <br />( + <%=LNG_TEXT_POINT_TRANSPOINTFEE%>) -->
					</th>
					<td class="price Total red2" ><span id="transPointTOTAL_TXT" ><%=num2Cur(transPointFEE)%></span></td>
					<td><span><!-- ※<%=LNG_CS_POINT_TRANSFER2CASH_TEXT06%> + <%=LNG_TEXT_POINT_TRANSPOINTFEE%> --></span></td>
				</tr>
				<tr>
					<!-- <th><%=LNG_TEXT_PASSWORD_TRANSFER%>&nbsp;<%=starText%></th> -->
					<th><%=LNG_MONEY_OUTPUT_PIN%>&nbsp;<%=starText%></th>
					<td colspan="2">
						<input type="password" class="input_text" style="width:188px;" name="SendPassWord" maxlength="20" size="24" />
						<span id="Money_Output_Pin_Check"></span>
					</td>
				</tr>
			</table>
		<%End If%>

		<div class="btnZone">
		<%If CDbl(MILEAGE_TOTAL) < (CDbl(MINIMUM_POINT) + CDbl(transPointFEE)) Then%>
			<input type="button" class="cancel" onclick="javascript:alert('<%=LNG_CS_POINT_TRANSFER_JS07%>');"
			value="<%=LNG_CS_GOODSLIST_BTN04%>"/>

		<%ElseIf CDbl(MINIMUM_POINT) <= 0 Then%>
			<input type="button" class="red" onclick="javascript:alert('<%=LNG_JS_MINIMUM_POINT_CHECK%>');" value="<%=LNG_CS_GOODSLIST_BTN04%>"/>

		<%Else%>

			<input type="submit" class="promise" value="<%=LNG_TEXT_POINT_TRANSFER%>" />

		<%End If%>
		</div>

	</form>
</div>

<!--#include virtual="/_include/modal_config.asp" -->
<!--#include virtual = "/_include/copyright.asp"-->

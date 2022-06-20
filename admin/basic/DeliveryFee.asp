<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG7-2"








%>
<link rel="stylesheet" href="e_exchange.css" />
<link rel="stylesheet" href="/admin/css/delivery.css" />
<script type="text/javascript" language="javascript">
<!--
	function frmCheck(f){
		var msg = "등록하시겠습니까?";

		var thisResult = 0;
		$("#exchange input[name=DeliveryFee]").each(function() {
			if ($.trim($(this).val()) == '') {
				var thisTitle = $(this).attr("title");
				alert("배송비 중 " +thisTitle + " 항목에 빈값이 존재합니다.");
				$(this).focus();
				thisResult = 1;
				return false;
			}
		});
		if (thisResult == 1) {return false;}

		thisResult = 0;
		$("#exchange input[name=DeliveryFeeLimit]").each(function() {
			if ($.trim($(this).val()) == '') {
				var thisTitle = $(this).attr("title");
				alert("무료배송조건 중 " +thisTitle + " 항목에 빈값이 존재합니다.");
				$(this).focus();
				thisResult = 1;
				return false;
			}
		});
		if (thisResult == 1) {return false;}


		if(confirm(msg)){
			return true;
		} else {
			return false;
		}
	}



//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="exchange">
	<%
		Set DKRS = Db.execRs("DKSP_SITE_NATION_BASE_CURRENCY",DB_PROC,Nothing,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_strNationCode			= DKRS("strNationCode")
			DKRS_strNationName			= DKRS("strNationName")
			DKRS_isUse					= DKRS("isUse")
			DKRS_intSort				= DKRS("intSort")
			DKRS_strCurrency			= DKRS("strCurrency")
			DKRS_strCurrencyISO			= DKRS("strCurrencyISO")
			DKRS_intCurrencyNum			= DKRS("intCurrencyNum")
			DKRS_isBaseCurrency			= DKRS("isBaseCurrency")
			DKRS_intCurExchange			= DKRS("intCurExchange")
			DKRS_isPaySelf				= DKRS("isPaySelf")
			DKRS_intDeliveryFee			= DKRS("intDeliveryFee")
			DKRS_intDeliveryFeeLimit	= DKRS("intDeliveryFeeLimit")
			DKRS_strNationNameEn		= DKRS("strNationNameEn")
		Else
			DKRS_strCurrency			= "원"
			DKRS_strCurrencyISO			= "KRW"
		End If
		Call closeRS(DKRS)
	%>
	<!-- <p class="baseCurrencyInfo">- 현재 기준 통화는 '<%=DKRS_strNationName%>'(으)로 통화표기는 <%=DKRS_strCurrencyISO%>(<%=DKRS_strCurrency%>) 입니다</p> -->
	<!-- <p class="baseCurrencyInfo">- <%=LNG_ADMIN_CURRENT_BASE_CURRENCY_NATION%> : <span class="red"><%=DKRS_strNationNameEn%></span></p>
	<p class="baseCurrencyInfo">- <%=LNG_ADMIN_CURRENT_BASE_CURRENCY%> : <span class="red"><%=DKRS_strCurrencyISO%>(<%=DKRS_strCurrency%>)</span></p> -->
	<form name="frm" method="post" action="DeliveryFee_handler.asp" onsubmit="return frmCheck(this)">
		<table <%=tableatt%> class="width100">
			<col width="250" />
			<!-- <col width="190" /> -->
			<col width="400" />
			<col width="*" />
			<tr>
				<th>국가명</th>
				<!-- <th><%=LNG_CS_ORDERS_DELIVERY_PRICE%><br /><%=LNG_ADMIN_BILLING_CURRENCY%></th> -->
				<th>배송비</th>
				<th>무료배송 금액</th>
			</tr>
			<%

				arrList = Db.execRsList("DKSP_SITE_NATION_LIST",DB_PROC,Nothing,listLen,Nothing)
				If IsArray(arrList) Then
					For	i = 0 To listLen
						arrList_strNationCode		= arrList(0,i)
						arrList_strNationName		= arrList(1,i)
						arrList_isUse				= arrList(2,i)
						arrList_intSort				= arrList(3,i)
						arrList_strCurrency			= arrList(4,i)
						arrList_strCurrencyISO		= arrList(5,i)
						arrList_intCurrencyNum		= arrList(6,i)
						arrList_isBaseCurrency		= arrList(7,i)
						arrList_intCurExchange		= arrList(8,i)
						arrList_isPaySelf			= arrList(9,i)
						arrList_intDeliveryFee		= arrList(10,i)
						arrList_intDeliveryFeeLimit	= arrList(11,i)
						arrList_strNationName_En	= arrList(12,i)

						If arrList_isPaySelf = "F" Then
							printDeliveryType	= "<span class=""text_blue"">"&LNG_ADMIN_BASE_CURRENCY&"</span>"	'기준통화
							printCurrency		= DKRS_strCurrency
							printCurrencyISO	= DKRS_strCurrencyISO
						Else
							printDeliveryType = LNG_ADMIN_LOCAL_CURRENCY											'"자국통화"
							printCurrency		= arrList_strCurrency
							printCurrencyISO	= arrList_strCurrencyISO
						End If

						printBaseCurrency = ""
						If arrList_isBaseCurrency = "T" Then
							printBaseCurrency = "<span class=""text_red"">("&LNG_ADMIN_BASE_CURRENCY&")</span>"
						End If


						If UCase(arrList_strNationCode) = "KR" Then
							printCurrencyISO = DKRS_strCurrencyISO
						End If
			%>
				<tr>
					<td class="tweight"><%=arrList_strNationName_En%><%=printBaseCurrency%><input type="hidden" name="NationCode" value="<%=arrList_strNationCode%>" /></td>
					<!-- <td class="tweight tcenter"><%=printDeliveryType%></td> -->
					<td>
						<input type="text" name="DeliveryFee" class="input_text" style="width:120px;" title="<%=arrList_strNationName_En%>" value="<%=arrList_intDeliveryFee%>" <%=onlyKeys%> /> <%=printCurrencyISO%>
						<%If UCase(arrList_strNationCode) = "KR" Then%>
							&nbsp;&nbsp;(<%=num2cur(arrList_intDeliveryFee * arrList_intCurExchange) &" "& arrList_strCurrencyISO%>)
						<%End If%>
						<input type="hidden" name="ori_DeliveryFee" value="<%=arrList_intDeliveryFee%>" readonly="readonly" />
					</td>
					<td>
						<input type="text" name="DeliveryFeeLimit" class="input_text" style="width:150px;" title="<%=arrList_strNationName_En%>" value="<%=arrList_intDeliveryFeeLimit%>" <%=onlyKeys%>  />
						<%=printCurrencyISO%>
						<%If UCase(arrList_strNationCode) = "KR" Then%>
							&nbsp;&nbsp;(<%=num2cur(arrList_intDeliveryFeeLimit * arrList_intCurExchange) &" "& arrList_strCurrencyISO%>)
						<%End If%>
						<input type="hidden" name="ori_DeliveryFeeLimit" value="<%=arrList_intDeliveryFeeLimit%>" readonly="readonly"  />
					</td>
			<%
					Next
				End If
			%>
		</table>
		<div class="caution" style="margin-top:10px;">
			<ul>
				<li>무료배송조건을 0, 배송비를 0으로 지정하면 무료배송이 됩니다</li>
				<li>If you specify 0 for Free Shippung Terms and 0 for Delivery Price, it will be free shipping</li>
			</ul>
		</div>
		<div class="btn_area tcenter width100">
			<!-- <input type="submit" class="input_submit_b design1" value="저장" /> -->
			<div class="btn_area"><input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" /></div>
		</div>
	</form>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->

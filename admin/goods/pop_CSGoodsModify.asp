<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
'jQuery Modal Dialog방식변경

' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 825
		popHeight = 350

	ncode = Request("ncode")
	strNationCode = Request("nc")

	Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)


	arrParams = Array(_
		Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(strNationCode)), _
		Db.makeParam("@ncode",adVarChar,adParamInput,30,ncode)_
	)
	arrList = Db.execRsList("HJPA_GOODS_LIST_4MODIFY_GLOBAL",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("HJPA_GOODS_LIST_4MODIFY",DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)

%>
<link rel="stylesheet" href="/admin/css/popStyle.css" />
<script type="text/javascript">

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
	//console.log(	(NumberFormatter.format(2500)) );

	function selectValue(values,valueN,price,price2,selltype,esvatprice,price6) {
		parent.document.gform.CSGoodsCode.value = values;
		//opener.document.getElementById('csGoodsName').innerHTML = 'CS상품명 : <strong>' + valueN + '</strong> ,구매종류 : <strong>' + selltype + '</strong>';
		parent.document.gform.GoodsName.value	  = valueN;		//상품명
		parent.document.gform.GoodsCustomer.value = NumberFormatter.format(price);		//소비자가
		parent.document.gform.intPriceNot.value   = NumberFormatter.format(price2);		//회원가
		parent.document.gform.GoodsCost.value	  = NumberFormatter.format(esvatprice);	//공급가
		parent.$("#modal_view").dialog("close");
		self.close();
	}

</script>
</head>
<body>
<div id="popAll1" style="border:1px solid #fff; ">
	<div id="CSGoodsSearch" style="margin-top:30px;" >
		<table <%=tableatt%> style="width: 820px;">
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
			<thead>
				<tr>
					<th>상품코드</th>
					<th>상품명</th>
					<th>소비자가</th>
					<th>회원가</th>
					<th>공급가</th>
					<th><%=CS_PV%></th>
					<th><%=CS_PV2%></th>
					<!-- <th>구매종류</th> -->
					<th>선택</th>
				</tr>
			</thead>
			<tbody>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen
							arr_ncode					= arrList(0,i)
							arr_name					= arrList(1,i)
							arr_price					= arrList(2,i)	'소비자가
							arr_price2					= arrList(3,i)	'회원가
							arr_price4					= arrList(4,i)	'PV
							arr_P_code					= arrList(5,i)
							arr_Except_Sell_VAT_Price	= arrList(6,i)	'공급가
							arr_price5					= arrList(7,i)
							arr_SELLTYPE				= arrList(8,i)	'구매종류
							arr_Na_Code					= arrList(9,i)	'국가코드

							'상품정보 변경 체크
							arrParams = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_ncode) _
							)
							Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
							If Not DKRS.BOF And Not DKRS.EOF Then
								arr_ncode					= DKRS("ncode")
								'arr_name					= DKRS("name")
								arr_price					= DKRS("price1")
								arr_price2					= DKRS("price2")
								arr_price4					= DKRS("price4")
								arr_price5					= DKRS("price5")
								arr_price6					= DKRS("price6")
								arr_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
							Else
								arr_ncode					= arr_ncode
								arr_name					= arr_name
								arr_price					= arr_price
								arr_price2					= arr_price2
								arr_price4					= arr_price4
								arr_price5					= arr_price5
								arr_price6					= arr_price6
								arr_Except_Sell_VAT_Price	= arr_Except_Sell_VAT_Price
							End If

							PRINT TABS(3)&"	<tr>"
							PRINT TABS(3)&"		<td>"&arr_ncode&"</td>"
							'PRINT TABS(3)&"		<td>"&arr_Na_Code&"</td>"
							PRINT TABS(3)&"		<td class=""tleft"">"&arr_name&"</td>"
							PRINT TABS(3)&"		<td class=""tright"">"&num2CurAdmin(arr_price,strNationCode)&" "&Chg_CurrencyISO&"</td>"
							PRINT TABS(3)&"		<td class=""tright"">"&num2CurAdmin(arr_price2,strNationCode)&" "&Chg_CurrencyISO&"</td>"
							PRINT TABS(3)&"		<td class=""tright"">"&num2CurAdmin(arr_Except_Sell_VAT_Price,strNationCode)&" "&Chg_CurrencyISO&"</td>"
							PRINT TABS(3)&"		<td class=""tright"">"&num2curINT(arr_price4)&" "&CS_PV&"</span></td>"
							PRINT TABS(3)&"		<td class=""tright"">"&num2curINT(arr_price5)&" "&CS_PV2&"</span></td>"
							'PRINT TABS(3)&"		<td>"&arr_SELLTYPE&"</td>"
							PRINT TABS(3)&"		<td><a class=""a_submit design1"" onclick=""selectValue('"&arr_ncode&"','"&arr_name&"','"&arr_price&"','"&arr_price2&"','"&arr_SELLTYPE&"','"&arr_Except_Sell_VAT_Price&"','"&arr_price6&"');"" >선택</a></td>"
							PRINT TABS(3)&"	<tr>"
						Next
					Else
						PRINT TABS(3)&"	<tr>"
						PRINT TABS(3)&"		<td colspan=""8"" class=""notData"">일치하는 CS상품이 존재하지 않거나 판매중지된 상품입니다.</td>"
						PRINT TABS(3)&"	<tr>"
					End If

				%>
			</tbody>
		</table>
		<div class="pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	</div>
<!-- 	<div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
	</div> -->
</div>


<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>

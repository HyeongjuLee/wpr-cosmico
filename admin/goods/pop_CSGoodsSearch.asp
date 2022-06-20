<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
'jQuery Modal Dialog방식변경

' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 824
		popHeight = 600

	strNationCode = Request("nc")
	Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)

	Dim SEARCHSTR,SEARCHTERM,PAGE,PAGESIZE
		PAGESIZE	= 20
		PAGE		= Request("PAGE")
		SEARCHTERM	= Request("SEARCHTERM")
		SEARCHSTR	= Request("SEARCHSTR")

		If PAGE = "" Then PAGE = 1
		If SEARCHTERM = "" Or SEARCHSTR = "" Then
			SEARCHTERM = ""
			SEARCHSTR = ""
		End If


	If SEARCHSTR = "" Then
		NOTDATA_TXT = "검색어를 입력해주세요"
		isTrue = False
	Else
		NOTDATA_TXT = "검색어로 검색된 상품이 없습니다."
		isTrue = True

		arrParams = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
			Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
			Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_

			Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
		)
		arrList = Db.execRsList("DKSP_GOODS_LIST",DB_PROC,arrParams,listLen,DB3)
		'arrList = Db.execRsList("DKSP_GOODS_LIST_SELLCODE",DB_PROC,arrParams,listLen,DB3)
		'arrList = Db.execRsList("DKPA_GOODS_LIST",DB_PROC,arrParams,listLen,DB3)
		All_Count = arrParams(UBound(arrParams))(4)

'	print SEARCHTERM
'	print SEARCHSTR

		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


	End If

	If SEARCHTERM = "" Then SEARCHTERM = "name"


%>
<link rel="stylesheet" href="/admin/css/popStyle.css" />
<style type="text/css">
</style>

<script type="text/javascript">

	function chkSfrm(f) {
		if (f.SEARCHTERM.value == '')
		{
			alert("검색조건을 입력해주세요");
			return false;
		}
		if (f.SEARCHSTR.value == '')
		{
			alert("검색어를 입력해주세요");
			f.SEARCHSTR.focus();
			return false;
		}
	}

	//국가별 소수점자리수
	let pSpace = 0;
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

	function selectValue(values,valueN,price,price2,esvatprice) {
		parent.document.gform.CSGoodsCode.value = values;
		//parent.document.getElementById('csGoodsName').innerHTML = 'CS상품명 : <strong>' + valueN + '</strong>';
		parent.document.gform.GoodsName.value	  = valueN;		//상품명
		parent.document.gform.GoodsCustomer.value = NumberFormatter.format(price);		//소비자가
		parent.document.gform.intPriceNot.value   = NumberFormatter.format(price2);		//회원가
		parent.document.gform.GoodsCost.value	  = NumberFormatter.format(esvatprice);	//공급가
		parent.$("#modal_view").dialog("close");
		//self.close();
	}

</script>
</head>
<body onload="document.sfrm.SEARCHSTR.focus();">
<div id="popAll1">
	<div id="CSGoodsSearch">
		<div class="clear" style="float:left; padding:10px 0px;">
			<form name="sfrm" action="" method="post" onsubmit="return chkSfrm(this)">
				<select name="SEARCHTERM"  class="select">
					<option value="">조건선택</option>
					<option value="nCode"	<%=isSelect(SEARCHTERM,"nCode")%>>상품코드로</option>
					<option value="name"	<%=isSelect(SEARCHTERM,"name")%>>상품명으로</option>
				</select>&nbsp;
				<input type="text" name="SEARCHSTR" class="input_text"value="<%=SEARCHSTR%>" />
				<input type="submit" class="input_submit design3" value="검색" />
			</form>
		</div>
		<div class="fleft" style="height: 480px; overflow-y: auto;">
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
						If isTrue Then
							If IsArray(arrList) Then
								For i = 0 To listLen
									arr_ncode					= arrList(1,i)
									arr_name					= arrList(2,i)
									arr_price					= arrList(3,i)	'소비자가
									arr_price2					= arrList(4,i)	'회원가
									arr_price4					= arrList(5,i)	'PV
									arr_P_code					= arrList(6,i)
									arr_Except_Sell_VAT_Price	= arrList(7,i)	'공급가
									arr_price5					= arrList(8,i)
									arr_SellCode				= arrList(7,i)
									arr_SELLTYPE				= arrList(9,i)	'구매종류
									arr_Na_Code					= arrList(10,i)	'국가코드

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
										arr_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
									Else
										arr_ncode					= arr_ncode
										arr_name					= arr_name
										arr_price					= arr_price
										arr_price2					= arr_price2
										arr_price4					= arr_price4
										arr_price5					= arr_price5
										arr_Except_Sell_VAT_Price	= arr_Except_Sell_VAT_Price
									End If

									'CS연동상품 쇼핑몰 기등록여부확인(다국어)
									SQL = "SELECT COUNT(*) FROM [DK_GOODS] WITH(NOLOCK) WHERE [isCSGoods] = 'T' AND [DelTF] = 'F' AND [CSGoodsCode] = ? AND [strNationCode] = ? "
									arrParams1 = Array(_
										Db.makeParam("@CSGoodsCode",adVarChar,adParamInput,20,arr_ncode) ,_
										Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode) _
									)
									REG_GOODS_CNT = Db.execRsData(SQL,DB_TEXT,arrParams1,Nothing)

									PRINT TABS(3)&"	<tr>"
									PRINT TABS(3)&"		<td>"&arr_ncode&"</td>"
									PRINT TABS(3)&"		<td class=""tleft"">"&arr_name&"</td>"
									PRINT TABS(3)&"		<td class=""tright"">"&num2curAdmin(arr_price,strNationCode)&" "&Chg_CurrencyISO&"</td>"
									PRINT TABS(3)&"		<td class=""tright"">"&num2curAdmin(arr_price2,strNationCode)&" "&Chg_CurrencyISO&"</td>"
									PRINT TABS(3)&"		<td class=""tright"">"&num2curAdmin(arr_Except_Sell_VAT_Price,strNationCode)&" "&Chg_CurrencyISO&"</td>"
									PRINT TABS(3)&"		<td class=""tright"">"&num2curINT(arr_price4)&" "&CS_PV&"</td>"
									PRINT TABS(3)&"		<td class=""tright"">"&num2curINT(arr_price5)&" "&CS_PV2&"</td>"
									'PRINT TABS(3)&"		<td>"&arr_SELLTYPE&"</td>"
									If REG_GOODS_CNT  > 0 Then
										PRINT TABS(3)&"		<td><a href=""javascript:alert('이미 쇼핑몰에 등록된 CS상품입니다.');""><span class=""red"">기등록</span></a></td>"
									ELSE
										PRINT TABS(3)&"	<td><a class=""a_submit design1"" onclick=""selectValue('"&arr_ncode&"','"&arr_name&"','"&arr_price&"','"&arr_price2&"','"&arr_Except_Sell_VAT_Price&"');"" >등록</a></td>"
									End If
									PRINT TABS(3)&"	<tr>"
								Next
							Else
								PRINT TABS(3)&"	<tr>"
								PRINT TABS(3)&"		<td colspan=""8"" class=""notData"">"&NOTDATA_TXT&"</td>"
								PRINT TABS(3)&"	<tr>"
							End If
						Else
							PRINT TABS(3)&"	<tr>"
							PRINT TABS(3)&"		<td colspan=""8"" class=""notData"">"&NOTDATA_TXT&"</td>"
							PRINT TABS(3)&"	<tr>"
						End If
					%>
				</tbody>
			</table>
			<div class="pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
		</div>
	</div>
	<!-- <div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
	</div> -->
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
</form>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>

</body>
</html>

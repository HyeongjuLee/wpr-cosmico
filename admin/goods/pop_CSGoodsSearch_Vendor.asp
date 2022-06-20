<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 824
		popHeight = 600


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
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
			Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
			Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_

			Db.makeParam("@ALL_Count",adInteger,adParamOutput,0,0) _
		)
		arrList = Db.execRsList("DKPA_GOODS_LIST",DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="/css/select.css" />
<script type="text/javascript" src="/jscript/jcombox-1.0b.packed.js"></script>
<script type="text/javascript" src="/jscript/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/admin/jscript/phone.js"></script>
<script type="text/javascript" src="/jscript/jquery_alpha.js"></script>
<script type="text/javascript">
<!--
	$(function(){
		/* 기본 */
		$('.select').jcombox();

	});

/*	function chkSfrm(f) {
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
*/
	function selectValue(values,valueN,price,price2,esvatprice) {
		opener.document.gform.CSGoodsCode.value = values;
		//opener.document.getElementById('csGoodsName').innerHTML = 'CS상품명 : <strong>' + valueN + '</strong>';

		//opener.document.gform.GoodsName.value	  = valueN;		//상품명
		//opener.document.gform.GoodsCustomer.value = price;		//소비자가
		opener.document.gform.intPriceNot.value   = price2;		//회원가
		//opener.document.gform.GoodsCost.value	  = esvatprice;	//공급가
		self.close();
	}

	//-->
</script>
</head>
<body onload="document.sfrm.SEARCHSTR.focus();">
<div id="popAll1">
	<div class="top"><%=viewImg(IMG_POP&"/pop_CSGoodsSearch.gif",250,40,"")%></div>
	<div id="CSGoodsSearch">
		<div class="clear" style="float:left; padding:10px 0px;">
			<form name="sfrm" action="" method="post" onsubmit="return chkSfrm(this)">
				<select name="SEARCHTERM"  class="select">
					<option value="">조건선택</option>
					<option value="nCode"	<%=isSelect(SEARCHTERM,"nCode")%>>상품코드로</option>
					<option value="name"	<%=isSelect(SEARCHTERM,"name")%>>상품명으로</option>
				</select>&nbsp;
				<input type="text" name="SEARCHSTR" style="width:120px; border:1px solid #ccc; height:16px; vertical-align:top;" value="<%=SEARCHSTR%>" />
				<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vtop" />
			</form>
		</div>
		<table <%=tableatt%> style="width:800px;">
			<col width="80" />
			<col width="*" />
			<col width="90" />
			<col width="90" />
			<col width="90" />
			<col width="90" />
			<!-- <col width="80" /> -->
			<col width="90" />
			<thead>
			<tr>
				<th>상품코드</th>
				<th>상품명</th>
				<th>소비자가</th>
				<th>회원가</th>
				<th>공급가</th>
				<th>PV</th>
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
								arr_P_code					= arrList(6,i)	'P_code
								arr_Except_Sell_VAT_Price	= arrList(7,i)	'공급가
								arr_price9					= arrList(8,i)
								'arr_SellCode				= arrList(7,i)	'SellCode
								'arr_SELLTYPE				= arrList(8,i)	'구매종류

								'상품정보 변경 체크
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_ncode) _
								)
								Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									arr_ncode					= DKRS("ncode")
									arr_name					= DKRS("name")
									arr_price					= DKRS("price1")
									arr_price2					= DKRS("price2")
									arr_price4					= DKRS("price4")
									arr_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
									arr_price9					= DKRS("price9")
								Else
									arr_ncode					= arr_ncode
									arr_name					= arr_name
									arr_price					= arr_price
									arr_price2					= arr_price2
									arr_price4					= arr_price4
									arr_Except_Sell_VAT_Price	= arr_Except_Sell_VAT_Price
									arr_price9					= arr_price9
								End If

								'CS연동상품 쇼핑몰 기등록여부확인
								SQL = "SELECT COUNT(*) FROM [DK_GOODS] WHERE [isCSGoods] = 'T' AND [DelTF] = 'F' AND [CSGoodsCode] = ?"
								arrParams1 = Array(_
									Db.makeParam("@CSGoodsCode",adVarChar,adParamInput,20,arr_ncode) _
								)
								REG_GOODS_CNT = Db.execRsData(SQL,DB_TEXT,arrParams1,Nothing)

								PRINT TABS(3)&"	<tr>"
								PRINT TABS(3)&"		<td>"&arr_ncode&"</td>"
								PRINT TABS(3)&"		<td class=""tleft"">"&arr_name&"</td>"
								PRINT TABS(3)&"		<td class=""tright"">"&num2cur(arr_price9)&" 원</td>"
								PRINT TABS(3)&"		<td class=""tright"">"&num2cur(arr_price2)&" 원</td>"
								PRINT TABS(3)&"		<td class=""tright"">"&num2cur(arr_Except_Sell_VAT_Price)&" 원</td>"
								PRINT TABS(3)&"		<td class=""tright"">"&num2cur(arr_price4)&" PV</td>"
								'PRINT TABS(3)&"		<td>"&arr_SELLTYPE&"</td>"
								If REG_GOODS_CNT  > 0 Then
									PRINT TABS(3)&"		<td><a href=""javascript:alert('이미 쇼핑몰에 등록된 CS상품입니다.');""><span class=""red"">기등록상품</span></a></td>"
								ELSE
									PRINT TABS(3)&"		<td>"&aImgOpt("javascript:selectValue('"&arr_ncode&"','"&arr_name&"','"&arr_price9&"','"&arr_price2&"','"&arr_Except_Sell_VAT_Price&"');","",IMG_BTN&"/btn_gray_select.gif",45,22,"","")&"</td>"
								End If
								PRINT TABS(3)&"	<tr>"
							Next
						Else
							PRINT TABS(3)&"	<tr>"
							PRINT TABS(3)&"		<td colspan=""7"" class=""notData"">"&NOTDATA_TXT&"</td>"
							PRINT TABS(3)&"	<tr>"
						End If
					Else
						PRINT TABS(3)&"	<tr>"
						PRINT TABS(3)&"		<td colspan=""7"">"&NOTDATA_TXT&"</td>"
						PRINT TABS(3)&"	<tr>"
					End If
				%>
				<tr>
					<td colspan="7" style="padding:10px 0px;"><%Call pageList(PAGE,PAGECOUNT)%></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="bottom">
		<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
		<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>
	</div>
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

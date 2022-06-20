<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()


	Dim SEARCHTERM		:	SEARCHTERM = pRequestTF("SEARCHTERM",False)
	Dim SEARCHSTR		:	SEARCHSTR = pRequestTF("SEARCHSTR",False)
	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE			:	PAGE = pRequestTF("PAGE",False)
	Dim CATEGORYS1		:	CATEGORYS1 = pRequestTF("cate1",False)
	Dim CATEGORYS2		:	CATEGORYS2 = pRequestTF("cate2",False)

	If PAGESIZE = "" Then PAGESIZE = 20
	If PAGE = "" Then PAGE = 1
	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If

	Dim CATEGORYS
	If CATEGORYS1 <> "" Then CATEGORYS = CATEGORYS1
	If CATEGORYS2 <> "" Then CATEGORYS = CATEGORYS1&CATEGORYS2
	If CATEGORYS1 = "" Then	CATEGORYS = ""

	'더리코 02재구매매출(2017-03-31)
	arrParams = Array( _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@Category",adVarchar,adParamInput,20,CATEGORYS) , _
		Db.makeParam("@SellCode",adVarchar,adParamInput,10,"02") , _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	'arrList = Db.execRsList("DKP_GOODS_LIST_USE_CATEGORY",DB_PROC,arrParams,listLen,DB3)
	arrList = Db.execRsList("DKP_GOODS_LIST_USE_CATEGORY_SELLCODE",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript">
<!--
	function popCartGo(ncode) {
		openPopup("popCart.asp?code="+ncode, "popCartGo", 100, 100, "left=200, top=200");
	}

	$(document).ready(function(){
		$('#cate1')
		  .change(function(){
			chg_category();
		  })
		 .change();

	});


	function chg_category() {
		createRequest();
		var url = 'getCate2.asp';

		mode = "category2";
		cate = $('#cate1').val();

		postParams = "mode=" + mode;
		postParams += "&cate=" + cate;

		if (cate.length == 0)
		{
			$("#cate2").attr("disabled",true);
			$("#cate2").html("<option value=''><%=LNG_CS_GOODSLIST_JS01%></option>");
		} else {
			request.open("POST",url,true);
			request.onreadystatechange = function ChgContent() {
				if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
					if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
						var newContent = request.responseText;
						//var newContentSplit = newContent.split("||")
						//alert(newContent);
						//document.getElementById("select2nd").innerHTML = newContent;
						//$("#cate2 > option[value='<%=IN_CATE2%>']").attr("selected",true);
						$("#cate2").attr("disabled",false);
						$("#cate2").html(newContent);
						$("#cate2").val("<%=CATEGORYS2%>");

						//alert(document.getElementById("innerMask").innerHTML);
					} else {
						alert(request.responseText);
					}
				  }
				}
			request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
			request.send(postParams);
			return;
		}
	}

	//자기페이지 호출  //페이지사이즈 고침
	function submitSearch() {
		var f = document.searchform;
			f.action = "";
			f.submit();
	}

//-->
</script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" width="0" height="0" style="display:none;"></iframe>
<!-- <div id="buy" class="orderList">
	<form name="searchform" action="goodsList.asp" method="post">
		<table <%=tableatt%> class="userCWidth table1">
			<colgroup>
				<col width="190" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th>분류검색</th>
				<td><select id="cate1" name="cate1">
				<option value="">1차 카테고리</option>
				<%
					SQL = "SELECT [ItemCode],[ItemName],[recordid],[recordtime] FROM [tbl_MakeItemCode1]"
					Set DKRS_CATEGORY = Db.execRs(SQL,DB_TEXT,Nothing,DB3)
				%>
				<%If DKRS_CATEGORY.BOF Or DKRS_CATEGORY.EOF Then%>
					<option value="">카테고리를 우선 저장해주셔야합니다</option>
				<%Else%>
				<%	Do Until DKRS_CATEGORY.EOF %>
					<option value="<%=DKRS_CATEGORY(0)%>" <%=isSelect(CATEGORYS1,DKRS_CATEGORY(0))%>><%=DKRS_CATEGORY(1)%></option>
				<%	DKRS_CATEGORY.MoveNext %>
				<%	Loop
				  End If
				  Call closeRs(DKRS_CATEGORY)
				%>
				</select> <select id="cate2" name="cate2" disabled="disabled"><option value=""></option></select>
				</td>
			</tr><tr>
				<th>상품명</th>
				<td>
					<select name="SEARCHTERM">
						<option value="GoodsName" <%=isSelect(SEARCHTERM,"GoodsName")%>>상품명으로 검색</option>
						<option value="ncode" <%=isSelect(SEARCHTERM,"ncode")%>>상품코드로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" value="<%=searchstr%>" style="width:170px;" class="input_text" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vmiddle" style="padding-left:5px;"/>
					<a href="goodsList.asp"><img src="<%=IMG_BTN%>/search_reset.gif" class="vmiddle" alt="" /></a>
					<select name="PAGESIZE" onchange="submitSearch()" class="vmiddle">
						<option value="10" <%=isSelect(PAGESIZE,"10")%>>10건씩 보기</option>
						<option value="20" <%=isSelect(PAGESIZE,"20")%>>20건씩 보기</option>
						<option value="30" <%=isSelect(PAGESIZE,"30")%>>30건씩 보기</option>
						<option value="<%=ALL_COUNT%>" <%=isSelect(PAGESIZE,ALL_COUNT)%>>모든자료</option>
					</select>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
</div> -->

<p class="titles"><%=LNG_TEXT_LIST%></p>
<div id="buy" class="orderList">
	<table <%=tableatt%> class="userCWidth orderTable">
		<col width="70" />
		<col width="210" />
		<col width="100" />
		<col width="90" />
		<col width="90" />
		<col width="60" />
		<!-- <col width="90" /> -->
		<!-- <col width="70" /> -->
		<col width="70" />
		<tr>
			<th><%=LNG_TEXT_CSGOODS_CODE%></th>
			<th><%=LNG_TEXT_ITEM_NAME%></th>
			<th><%=LNG_TEXT_GOODS_SPECIFICATIONS%></th>
			<th><%=LNG_TEXT_CONSUMER_PRICE%></th>
			<th><%=LNG_TEXT_MEMBER_PRICE%></th>
			<!-- <th><%=LNG_TEXT_WHOLESALE_PRICE%></th> -->
			<!-- <th><%=LNG_TEXT_VAT%></th> --><%'다나요청 vat삭제(2016-04-21)%>
			<th><%=CS_PV%></th>
			<!-- <th><%=LNG_TEXT_SALES_TYPE%></th> -->
			<th><%=LNG_CS_GOODSLIST_TEXT20%></th>
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					arr_ncode					= arrList(1,i)
					arr_name					= arrList(2,i)
					arr_inspection				= arrList(3,i)
					arr_price					= arrList(4,i)
					arr_price2					= arrList(5,i)
					arr_price4					= arrList(6,i)
					arr_price6					= arrList(7,i)
					arr_Sell_VAT_Price			= arrList(8,i)
					arr_Except_Sell_VAT_Price	= arrList(9,i)
					arr_price5					= arrList(10,i)
					arr_SellCode				= arrList(11,i)
					'arr_SellTypeName			= arrList(12,i)

					'▣CS상품정보 변동정보 통합
					arrParams = Array(_
						Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_ncode) _
					)
					Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						arr_ncode					= DKRS("ncode")
						arr_name					= DKRS("name")
						arr_price					= DKRS("price")
						arr_price2					= DKRS("price2")
						arr_price4					= DKRS("price4")
						arr_price6					= DKRS("price6")
						arr_Sell_VAT_Price			= DKRS("Sell_VAT_Price")
						arr_Except_Sell_VAT_Price	= DKRS("Except_Sell_VAT_Price")
						arr_SellCode				= DKRS("SellCode")
						'arr_SellTypeName			= DKRS("SellTypeName")
					End If
					Call closeRs(DKRS)

					If arr_SellTypeName <> "" Then arr_SellTypeName = "("&arr_SellTypeName&")"

					PRINT tabs(1)&"	<tr class=""hovers"">"
					PRINT tabs(1)&"		<td class=""tcenter"">"&arr_ncode&"</td>"
					PRINT tabs(1)&"		<td style=""padding-left:5px;"" class=""tweight"">"&arr_name&arr_SellTypeName&"</td>"
					PRINT tabs(1)&"		<td style=""padding-left:5px;"">"&arr_inspection&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(arr_price)&" "&CS_CURC&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(arr_price2)&" "&CS_CURC&"</td>"
				'	PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(arr_Except_Sell_VAT_Price)&" "&CS_CURC&"</td>"
				'	PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(arr_Sell_VAT_Price)&" "&CS_CURC&"</td>"
					PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(arr_price4)&" "&CS_PV&"</td>"
				'	PRINT tabs(1)&"		<td class=""tcenter"">"&arr_SellTypeName&"</td>"

				'	If MEMBER_ORDER_CHK01_ALL > 0 Then		'회원매출체크 전체
				'		'PRINT tabs(1)&"<a href=""javascript:alert('회원매출은 1주문번호에 1개의 상품, 1개만 구매할 수 있습니다.');"">불가</a></span></td>"
				'		PRINT tabs(1)&"	<td class=""tcenter""><input type=""button"" class=""txtBtnC small cart"" style=""color:#909090;"" value="""&LNG_CS_GOODSLIST_BTN04&""" onclick=""javascript:alert('"&LNG_CS_GOODSLIST_TEXT01_CATA&"');""></td>"
				'	Else
				'		If arr_price2 < 1 Then
				'			PRINT tabs(1)&"	<td class=""tcenter""><input type=""button"" class=""txtBtnC small cart mline"" style=""color:#909090;"" value="""&LNG_CS_GOODSLIST_BTN05&""" onclick=""javascript:alert('"&LNG_CS_GOODSLIST_TEXT21&"');""></td>"
				'		Else
				'			PRINT tabs(1)&"	<td class=""tcenter""><input type=""button"" class=""txtBtnC small cart"" value="""&LNG_CS_GOODSLIST_BTN05&""" onclick=""location.href='orders_sellcode.asp?ncode="&arr_ncode&"'""></td>"
				'		End If
				'	End If

					If arr_price2 < 1 Then
						PRINT tabs(1)&"	<td class=""tcenter""><input type=""button"" class=""txtBtnC small cart mline"" style=""color:#909090;"" value="""&LNG_CS_GOODSLIST_BTN03&""" onclick=""javascript:alert('"&LNG_CS_GOODSLIST_TEXT21&"');""></td>"
					Else
						PRINT tabs(1)&"	<td class=""tcenter""><input type=""button"" class=""txtBtnC small cart"" value="""&LNG_CS_GOODSLIST_BTN03&""" onclick=""popCartGo('"&arr_ncode&"');""></td>"
					End If
					PRINT tabs(1)&"	</tr>"

				Next
			Else
				PRINT tabs(1)&"	<tr>"
				PRINT tabs(1)&"		<td colspan=""7"" class=""notData"">"&LNG_CS_GOODSLIST_TEXT22&"</td>"
				PRINT tabs(1)&"	</tr>"
			End If
		%>
	</table>
</div>

<div class="paging_area pagingNew userCWidth">

	<%Call pageListNew(PAGE,PAGECOUNT)%>
	<form name="frm" method="post" action="">
		<input type="hidden" name="ncode" value="<%=ncode%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="cate1" value="<%=cate1%>" />
		<input type="hidden" name="cate2" value="<%=cate2%>" />
	</form>
</div>

<!--#include virtual = "/_include/copyright.asp"-->

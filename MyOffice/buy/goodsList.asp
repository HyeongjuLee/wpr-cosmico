<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"

If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	'Response.Redirect "/myoffice/buy/goodsList_sellcode.asp"

	If MEMBER_ORDER_CHK > 1 Then Call ALERTS(LNG_JS_MEMBER_ORDER_CHK01,"back","")	'▣더화이트		'회원번호당 2회까지 구매가능


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

	arrParams = Array( _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@Category",adVarchar,adParamInput,20,CATEGORYS) , _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_GOODS_LIST_USE_CATEGORY",DB_PROC,arrParams,listLen,DB3)
'	arrList = Db.execRsList("DKP_GOODS_LIST_USE",DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="/myoffice/css/style_cs.css?v0" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript">

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



	function thisGoodsCart(nums) {
		//alert(nums);
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>'); return false;}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>'); return false;}

		if (eavalue < 1){
			alert('<%=LNG_CS_CART_JS08%>');
		} else {
			chg_cart(eavalue,idvalue,nums);
		}
	}
	function chg_cart(mode1,mode2,nums) {
		//console.log(nums);

		$.ajax({
			type: "POST"
			,url: "cart_ajax.asp"
			,data: {
				"modes"		: "regist",
				"eavalue"		: mode1,
				"idvalue"		: mode2
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				var json = $.parseJSON(data);
				//console.log(data);
				//console.log(json.result);
				//console.log(json.resultMsg);

				if (json.result == "error") {
					alert(json.resultMsg);
					$("#oxea"+nums).val("");
					return false;
				}

				if (json.thisGoodCartCnt > 0){
					$("#cartEA"+nums).text(json.thisGoodCartCnt);
				}

				if (confirm(json.resultMsg+"\n장바구니로 이동하시겠습니까?")) {
					location.href="/myoffice/buy/cart.asp"
					return;
				} else {
					return false;
				}
			}
			,error:function(data) {
				alert("ajax error");
			}
		});
	}

</script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" width="0" height="0" style="display:none;"></iframe>
<div id="buy" class="orderList">
	<form name="searchform" action="goodsList.asp" method="post">
		<div class="search_form">
			<article>
				<h6><%=LNG_CS_GOODSLIST_TEXT01%></h6>
				<div class="selects">
					<select id="cate1" name="cate1" class="input_select">
						<option value=""><%=LNG_CS_GOODSLIST_TEXT02%></option>
						<%
							SQL = "SELECT [ItemCode],[ItemName],[recordid],[recordtime] FROM [tbl_MakeItemCode1] WITH(NOLOCK)"
							Set DKRS_CATEGORY = Db.execRs(SQL,DB_TEXT,Nothing,DB3)
						%>
						<%If DKRS_CATEGORY.BOF Or DKRS_CATEGORY.EOF Then%>
							<option value=""><%=LNG_CS_GOODSLIST_TEXT03%></option>
						<%Else%>
						<%	Do Until DKRS_CATEGORY.EOF %>
							<option value="<%=DKRS_CATEGORY(0)%>" <%=isSelect(CATEGORYS1,DKRS_CATEGORY(0))%>><%=DKRS_CATEGORY(1)%></option>
						<%	DKRS_CATEGORY.MoveNext %>
						<%	Loop
							End If
							Call closeRs(DKRS_CATEGORY)
						%>
					</select>
					<select id="cate2" name="cate2" disabled="disabled" class="input_select"><option value=""></option></select>
				</div>
			</article>
			<article>
				<h6><%=LNG_TEXT_ITEM_NAME%></h6>
				<div class="select">
					<select name="SEARCHTERM" class="input_select">
						<option value="GoodsName" <%=isSelect(SEARCHTERM,"GoodsName")%>><%=LNG_CS_GOODSLIST_TEXT05%></option>
						<option value="ncode" <%=isSelect(SEARCHTERM,"ncode")%>><%=LNG_CS_GOODSLIST_TEXT06%></option>
					</select>
				</div>
				<div class="">
					<input type="text" name="SEARCHSTR" value="<%=searchstr%>" style="width:170px;" class="input_text" />
					<input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/>
					<input type="button" class="search_reset" value="<%=LNG_TEXT_INITIALIZATION%>" onclick="location.href='goodsList.asp';"/>
					<select name="PAGESIZE" onchange="submitSearch()" class="input_select">
						<option value="10" <%=isSelect(PAGESIZE,"10")%>><%=LNG_CS_GOODSLIST_TEXT07%></option>
						<option value="20" <%=isSelect(PAGESIZE,"20")%>><%=LNG_CS_GOODSLIST_TEXT08%></option>
						<option value="30" <%=isSelect(PAGESIZE,"30")%>><%=LNG_CS_GOODSLIST_TEXT09%></option>
						<option value="<%=ALL_COUNT%>" <%=isSelect(PAGESIZE,ALL_COUNT)%>><%=LNG_CS_GOODSLIST_TEXT10%></option>
					</select>
				</div>
			</article>
		</div>
	</form>
</div>
<p class="titles"><%=LNG_TEXT_LIST%></p>
<div id="buy" class="orderList">
	<table <%=tableatt%> class="width100 orderTable board">
		<col width="100" />
		<col width="400" />
		<col width="130" />
		<col width="200" />
		<col width="150" />
		<thead>
			<tr>
				<th><%=LNG_TEXT_CSGOODS_CODE%></th>
				<th><%=LNG_TEXT_ITEM_NAME%></th>
				<th><%=LNG_TEXT_GOODS_SPECIFICATIONS%></th>
				<!-- <th><%=LNG_TEXT_GOODS_SORT%></th> -->
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
				<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
			</tr>
		</thead>
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

					If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
						If DK_MEMBER_STYPE = "1" Then
							arr_price2 = arr_price
						End If
					End If

					If arr_SellTypeName <> "" Then arr_SellTypeName = "("&arr_SellTypeName&")"
		%>
		<%
					'THIS_GOOD_CART_CNT = 0
					'SQL ="SELECT ISNULL([EA],0) FROM [DK_CART] WITH(NOLOCK)	WHERE [MBID] = ? AND [MBID2] = ?	AND [NCODE] = ? "
					'arrParams = Array(_
					'	Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					'	Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
					'	Db.makeParam("@NCODE",adVarChar,adParamInput,20,arr_ncode)_
					')
					'THIS_GOOD_CART_CNT =  Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
		%>
					<tr class="hovers">
						<td class="tcenter"><%=arr_ncode%></td>
						<td style="" class="tweight tleft"><%=arr_name%><%=arr_SellTypeName%></td>
						<td class="tcenter"><%=arr_inspection%></td>
						<!-- <td class="tcenter"><%=arr_Goods_Sort_TXT%></td> -->
						<td class="inPrice Price">
							<%=spans(num2cur(arr_price2),"#222222","13","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","12","400")%>
							<%If DK_MEMBER_STYPE = "0" Then%>
							<br /><%=spans(num2curINT(arr_price4),"#ff3300","11","400")%><%=spans(""&CS_PV&"","#ff3300","10","400")%>
							<%End If%>
						</td>
						<td class="tcenter">
							<input type="text" name="ea" id="oxea<%=i%>" class="tcenter input_text" style="width:50px;" maxlength="2"  value="" <%=onlyKeys%> />
							<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arr_ncode%>" />
							<%If arr_price2 > 0 Then%>
								<input type="button" class="txtBtn s_modify radius3" onclick="thisGoodsCart('<%=i%>');" value="<%=LNG_CS_GOODSLIST_BTN03%>" />
							<%Else%>
								<input type="button" class="txtBtn s_modify radius3 mline" onclick="javascript:alert('<%=LNG_CS_GOODSLIST_TEXT21%>');" value="<%=LNG_CS_GOODSLIST_BTN03%>" />
							<%End If%>
							<!-- <span id="cartEA<%=i%>"><%=THIS_GOOD_CART_CNT%></span> -->
						</td>
					</tr>
		<%
				Next
			Else
		%>
					<tr>
						<td colspan="5" class="notData"><%=LNG_CS_GOODSLIST_TEXT22%></td>
					</tr>
		<%
			End If
		%>
	</table>
</div>
<div class="pagingArea pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>

<form name="frm" method="post" action="">
	<input type="hidden" name="ncode" value="<%=ncode%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="cate1" value="<%=cate1%>" />
	<input type="hidden" name="cate2" value="<%=cate2%>" />
</form>

<!--#include virtual = "/_include/copyright.asp"-->

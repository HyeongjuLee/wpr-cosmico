<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"

If webproIP <> "T" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	Dim SEARCHTERM		:	SEARCHTERM	= pRequestTF("SEARCHTERM",False)
	Dim SEARCHSTR		:	SEARCHSTR	= pRequestTF("SEARCHSTR",False)
	Dim PAGESIZE		:	PAGESIZE	= pRequestTF("PAGESIZE",False)
	Dim PAGE			:	PAGE		= pRequestTF("PAGE",False)
	Dim CATEGORYS1		:	CATEGORYS1	= pRequestTF("cate1",False)
	Dim CATEGORYS2		:	CATEGORYS2	= pRequestTF("cate2",False)

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
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<!-- <script type="text/javascript" src="goodslist.js"></script> -->
<script type="text/javascript">
	/* goodslist.js S*/
	function thisGoodsCart(nums) {
		//alert(nums);
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>'); return false;}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>'); return false;}

		if (eavalue < 1){
			//alert('수량값은 1 이상입니다.');
			alert('<%=LNG_CS_CART_JS08%>');
		} else {
			//chg_cart(eavalue,idvalue);
			chg_cart(eavalue,idvalue,nums);
		}
	}
	function chg_cart(mode1,mode2,nums) {
		//console.log(mode1);
		//console.log(mode2);
		//console.log(nums);

		$.ajax({
			type: "POST"
			,url: "cart_ajax.asp"
			,data: {
				  "modes"		: "regist"
				 ,"eavalue"		: mode1
				 ,"idvalue"		: mode2
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
					location.href="/m/buy/cart.asp"
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
	/* goodslist.js E*/


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
						$("#cate2").attr("disabled",false);
						$("#cate2").html(newContent);
						$("#cate2").val("<%=CATEGORYS2%>");
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

</script>
</head>
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_ORDER_01%></div>
<style type="text/css">
</style>
<div id="cart" class="cleft width100" style="margin-top:0px;">
	<form name="searchform" action="" method="post">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="*" />
				<col width="135" />
			</colgroup>
			<tbody>
			<tr>
				<td colspan="2">
					<select id="cate1" name="cate1">
					<option value=""><%=LNG_CS_GOODSLIST_TEXT02%></option>
					<%
						SQL = "SELECT [ItemCode],[ItemName],[recordid],[recordtime] FROM [tbl_MakeItemCode1]"
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
					</select> <select id="cate2" name="cate2" disabled="disabled"><option value=""></option></select>
				</td>
			</tr><tr>
				<td>
					<input type="hidden" name="SEARCHTERM" value="GoodsName" />
					<input type="text" name="SEARCHSTR" value="<%=searchstr%>" class="input_text width95a" placeholder="<%=LNG_TEXT_ITEM_NAME%>" />
				</td>
				<td class="tcenter">
					<input type="submit" class="txtBtn small3 radius3 tweight" value="<%=LNG_TEXT_SEARCH%>"/>
					<input type="button" class="txtBtn small3 radius3" value="<%=LNG_TEXT_INITIALIZATION%>" onclick="location.href='goodsList.asp';"/>
				</td>
			</tr>
			</tbody>
		</table>
	</form>

	<div class="cleft width100" style="margin-top:10px;">
		<table <%=tableatt%> class="width100 pays goodslist">
			<colgroup>
				<col width="" />
				<col width="110" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="1">[<%=LNG_TEXT_CSGOODS_CODE%>] <%=LNG_TEXT_ITEM_NAME%></th>
					<th rowspan="2"><%=LNG_SHOP_ORDER_DIRECT_TABLE_03%></th>
				</tr><tr>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_02%></th>
				</tr>
			</thead>
			<%
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
				'arrList = Db.execRsList("DKP_GOODS_LIST_USE_CATEGORY_GLOBAL",DB_PROC,arrParams,listLen,DB3)
				ALL_COUNT = arrParams(UBound(arrParams))(4)

				Dim PAGECOUNT,CNT
				PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
				IF CCur(PAGE) = 1 Then
					CNT = ALL_COUNT
				Else
					CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
				End If

				If IsArray(arrList) Then
					For i = 0 To listLen
						arr_ncode					= arrList(1,i)
						arr_name					= arrList(2,i)
						arr_inspection				= arrList(3,i)
						arr_price					= arrList(4,i)			'소비자가
						arr_price2					= arrList(5,i)			'대리점가
						arr_price4					= arrList(6,i)			'PV
						arr_price6					= arrList(7,i)
						arr_Sell_VAT_Price			= arrList(8,i)
						arr_Except_Sell_VAT_Price	= arrList(9,i)
						arr_Base_Cnt				= arrList(10,i)
						arr_SellCode				= arrList(11,i)			'구매종류
						'arr_SellTypeName			= arrList(12,i)			'구매종류이름

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

						THIS_GOOD_CART_CNT = 0
						SQL ="SELECT ISNULL([EA],0) FROM [DK_CART] WITH(NOLOCK)	WHERE [MBID] = ? AND [MBID2] = ? AND [NCODE] = ? "
						arrParams = Array(_
							Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
							Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
							Db.makeParam("@NCODE",adVarChar,adParamInput,20,arr_ncode)_
						)
						THIS_GOOD_CART_CNT =  Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

			%>
			<tbody>
				<tr class="hovers">
					<td colspan="1" class="title">
						<p class="">[<%=arr_ncode%>] <span class="title"><%=arr_name%></span><%=RS_SellTypeName%></p>
						<p class=""><%=arr_Goods_Sort_TXT%></p>
					</td>
					<td class="tcenter bot_line_c" rowspan="2">
						<input type="tel" name="ea" id="oxea<%=i%>" class="tcenter input_text vmiddle" style="width:50px;" maxlength="2"  value="" <%=onLyKeys%> />
						<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arr_ncode%>" />
						<%If arr_price2 > 0 Then%>
							<input type="button" class="txtBtn s_modify radius3" onclick="thisGoodsCart('<%=i%>');" value="<%=LNG_CS_GOODSLIST_BTN03%>" />
						<%Else%>
							<input type="button" class="txtBtn s_modify radius3 mline" onclick="javascript:alert('<%=LNG_CS_GOODSLIST_TEXT21%>');" value="<%=LNG_CS_GOODSLIST_BTN03%>" />
						<%End If%>
						<!-- <span id="cartEA<%=i%>"><%=THIS_GOOD_CART_CNT%></span> -->
					</td>
				</tr><tr>
					<td class="tright bot_line_c">
						<%=spans(num2cur(arr_price2),"#222222","11","400")%>&nbsp;<%=spans(""&Chg_currencyISO&"","#222222","11","400")%>
						<%If DK_MEMBER_STYPE = "0" Then%>
						<br /><%=spans(num2curINT(arr_price4),"#ff3300","10","400")%><%=spans(""&CS_PV&"","#ff3300","9","400")%>
						<%End If%>
					</td>
				</tr>
			</tbody>
			<%
					Next
				Else
					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td colspan=""4"" class=""notData"">"&LNG_CS_GOODSLIST_TEXT22&"</td>"
					PRINT tabs(1)&"	</tr>"
				End If
			%>
		</table>

		<div><input type="button" class="mBtn joinBtn jBtn1 tcenter" style="width:49%" onclick="location.href='cart.asp'" value="<%=LNG_CS_GOODSLIST_BTN_GOCART%>"/></div>

	</div>
</div>

<div class="pagingArea pagingMob5">
	<%Call pageListMob5(PAGE,PAGECOUNT)%>
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
<!--#include virtual = "/m/_include/copyright.asp"-->



<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "MY_BUY"

	Call FNC_ONLY_CS_MEMBER()

	Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")


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
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		//if (eavalue == '') { alert('수량값이 없습니다.');}
		//if (idvalue == '') { alert('상품코드값이 없습니다.');}
		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>');}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>');}

		if (eavalue < 1){
			//alert('수량값은 1 이상입니다.');
			alert('<%=LNG_CS_CART_JS08%>');
		} else {
			chg_cart(eavalue,idvalue);
		}
	}
	function chg_cart(mode1,mode2) {
		//console.log(mode1);		//F12 확인
		//console.log(mode2);
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
				alert(data);
				location.href="/m/buy/cart.asp"		//성공시 카트로 이동
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

	/* new ver */
	function chg_category() {
		//alert($('#cate1').val());
		cate = $('#cate1').val();

		if (cate.length == 0)
		{
			$("#cate2").html("<option value=''>"&LNG_CS_GOODSLIST_JS01&"</option>");
		} else {

			$.ajax({
				type: "POST"
				,url: "getCate2.asp"
				,data: {
					  "mode"		: "category2"
					 ,"cate"		: $('#cate1').val()
				}
				//,contentType: "application/json; charset=utf-8"
				,success: function(data) {
						$("#cate2").attr("disabled",false);
						$("#cate2").html(data);
						$("#cate2").val("<%=CATEGORYS2%>");
				}
				,error:function(data) {
					alert("ajax error :");
				}
			});
		}
	}

/*
	function chg_category() {

		createRequest();

		var url = 'getCate2.asp';
		mode = "category2";
		cate = $('#cate1').val();

		postParams = "mode=" + mode;
		postParams += "&cate=" + cate;

		if (cate.length == 0)
		{
			$("#cate2").html("<option value=''>상위 카테고리를 선택해주세요.</option>");
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
						//$("#cate2").prop("disabled", false);

						if (newContent == 'disabled')
						{
							$("#cate2").html("<option value=''>하위 카테고리가 없습니다.</option>");
						} else {
							$("#cate2").attr("disabled",false);
							$("#cate2").html(newContent);
							$("#cate2").val("<%=CATEGORYS2%>");
						}
						//alert(document.getElementById("innerMask").innerHTML);
					} else {
						alert("ajax error");
					}
				  }
				}
			request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
			request.send(postParams);
			return;
		}

	}
*/



</script>
</head>
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="b_title" class="cleft">
	<!-- <h3 class="fleft"><span class="h3color1">구매</span> <span class="h3color2">신청</span></h3> -->
	<h3 class="fleft"><span class="h3color1"><%=LNG_MYOFFICE_ORDER_01%></span></h3>
</div>
<style type="text/css">
	#cart td {background-color:#eeeeee;}
</style>
<!-- <div id="cart" class="cleft width100" style="margin-top:0px;">
	<form name="searchform" action="" method="post" data-ajax="false">
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
</div> -->
<div class="cleft width100" style="margin-top:10px;">
	<table <%=tableatt%> class="width100 pays goodslist">
		<thead>
			<tr>
				<th rowspan="2">[<%=LNG_TEXT_CSGOODS_CODE%>] <%=LNG_TEXT_ITEM_NAME%></th>
				<th style="width:110px;" ><%=LNG_TEXT_MEMBER_PRICE%></th>
				<th style="width:50px;" rowspan="3"><%=LNG_TEXT_ITEM_NUMBER%></th>
				<th style="width:50px;" rowspan="3"><%=LNG_CS_GOODSLIST_BTN03%></th>
			</tr><tr>
				<th><%=CS_PV%></th>
			</tr>
		</thead>
		<%
			'회원번호앞자리SK=한국회원=KR
		'	CS_NATION_CODE = DK_MEMBER_ID1
		'	If UCase(CS_NATION_CODE) = "SK" THEN
		'		CS_NATION_CODE = "KR"
		'	Else
		'		CS_NATION_CODE = CS_NATION_CODE
		'	End If
		'	CS_Na_Code = CS_NATION_CODE

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
			arrList = Db.execRsList("DKP_GOODS_LIST_USE_CATEGORY_SELLCODE",DB_PROC,arrParams,listLen,DB3)
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

		%>
		<tbody>
			<tr class="hovers">
				<!-- <td rowspan="2" class="">
					<p>[<%=arr_ncode%>] <strong><%=arr_name%></strong></p>
					<p class="blue2">[<%=arr_SellTypeName%>]</p>
				</td>
				<td class="tright tweight" style="color:red"><%=num2cur(arr_price2)%> <%=Chg_CurrencyISO%></td>
				<td rowspan="2" class="tcenter">1
					<input type="number" name="ea" id="oxea<%=i%>" min="1" max="100" class="input_text tcenter" style="width:40px;">
					<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arr_ncode%>" />
				</td>
				<%If arr_price2 < 1 Then%>
				<td rowspan="2" class="tcenter"><input type="button" class="txtBtnC small cart mline" style="color:#909090;" value="<%=LNG_CS_GOODSLIST_BTN03%>" onclick="javascript:alert('<%=LNG_CS_GOODSLIST_TEXT21%>');"></td>
				<%Else%>
				<%
					If MEMBER_ORDER_CHK01_ALL > 0 Then		'회원매출체크 전체
						PRINT tabs(1)&"		<td rowspan=""2"" class=""tcenter""><span class=""button medium vmiddle"">"
						'PRINT tabs(1)&"		<a href=""javascript:alert('회원매출은 1주문번호에 1개의 상품, 1개만 구매할 수 있습니다.');"">불가</a></span></td>"
						PRINT tabs(1)&"		<a href=""javascript:alert('"&LNG_CS_GOODSLIST_TEXT01_CATA&"');"">"&LNG_CS_GOODSLIST_BTN04&"</a></span></td>"
					Else
						If arr_price2 < 1 Then
							PRINT tabs(1)&"		<td rowspan=""2"" class=""tcenter""><span class=""button medium vmiddle"">"
							PRINT tabs(1)&"		<a href=""javascript:alert('"&LNG_CS_GOODSLIST_TEXT21&"');"">"&LNG_CS_GOODSLIST_BTN05&"</a></span></td>"
						Else
							PRINT tabs(1)&"		<td rowspan=""2"" class=""tcenter""><span class=""button medium vmiddle"">"
							PRINT tabs(1)&"		<a href=""orders_sellcode.asp?ncode="&arr_ncode&""">"&LNG_CS_GOODSLIST_BTN05&"</a></span></td>"
						End If
					End If
				%>
				<%End If%> -->

				<td rowspan="2" class="">
					<p>[<%=arr_ncode%>] <strong><%=arr_name%></strong></p>
					<!-- <p class="blue2">[<%=arr_SellTypeName%>]</p> -->
				</td>
				<td class="tright tweight" style="color:red"><%=num2cur(arr_price2)%> <%=Chg_CurrencyISO%></td>
				<td rowspan="2" class="">
					<input type="number" name="ea" id="oxea<%=i%>" min="1" max="100" class="input_text tcenter" style="width:40px;">
					<input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arr_ncode%>" />
				</td>
				<%If arr_price2 < 1 Then%>
				<td rowspan="2" class="tcenter"><input type="button" class="txtBtnC small cart mline" style="color:#909090;" value="<%=LNG_CS_GOODSLIST_BTN03%>" onclick="javascript:alert('<%=LNG_CS_GOODSLIST_TEXT21%>');"></td>
				<%Else%>
				<td rowspan="2" class="tcenter"><input type="button" class="txtBtnC small cart" value="<%=LNG_CS_GOODSLIST_BTN03%>" onclick="thisGoodsCart('<%=i%>');""></td>
				<%End If%>


			</tr><tr>
				<td class="tright tweight" style="color:blue"><%=num2cur(arr_price4)%> <%=CS_PV%></td>
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

	<!-- <div><input type="button" class="mBtn joinBtn jBtn1 tcenter" style="width:49%" onclick="location.href='cart.asp'" value="<%=LNG_CS_GOODSLIST_BTN_GOCART%>"/></div> -->

</div>

<div class="pagingArea pagingMob5n">
	<%Call pageListMob5n(PAGE,PAGECOUNT)%>
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



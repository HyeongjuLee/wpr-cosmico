<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-7"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)				'센타장전용

	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	'If (UCase(Lang) <> UCase(DK_MEMBER_NATIONCODE)) Then Call ALERTS("소속국가 상품만 구매할 수 있습니다.","back","")

	'Response.Redirect "/myoffice/buy/goodsList_dana.asp"

	mid1 = gRequestTF("mid1",True)
	mid2 = gRequestTF("mid2",True)

	'▣ 하선구매체크
	SQL1 = "SELECT ISNULL(COUNT([OrderNumber]),0) FROM [tbl_salesdetail]"
	SQL1 = SQL1 & " WHERE [mbid] = ? AND [mbid2] = ? "
	SQL1 = SQL1 & "		AND [ReturnTF] = 1 "		'정상판매
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mid1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,mid2) _
	)
	UNDER_MEMBER_ORDER_CHK = Db.execRsData(SQL1,DB_TEXT,arrParams,DB3)

	If UNDER_MEMBER_ORDER_CHK > 1 Then Call ALERTS(LNG_JS_MEMBER_ORDER_CHK01,"back","")	'▣더화이트


%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<script type="text/javascript">
<!--
	function SelectAlls() {
		var f = document.cartFrm;
		if (f.checklist.checked) {
			f.checklist.checked = false;
		} else {
			f.checklist.checked = true;
		}
		SelectAll();
	}


	function SelectAll(){
		var f = document.cartFrm;
		if(f.checklist.checked){
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = true;
			}
			else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					f.chkCart[i].checked = true;
				}
			}
		}
		else{
			if (typeof f.chkCart.length == "undefined") {
				f.chkCart.checked = false;
			}
			else {
				for (i=0, len=f.chkCart.length; i<len; i++) {
					f.chkCart[i].checked = false;
				}
			}
		}
	}

	function delAll() {
		var f= document.cartFrm;
		if (typeof f.nCode == "undefined"){
			//alert("삭제할 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS01%>");
			return;
		}

		f.checklist.checked = true;
		f.mode.value = "DELALL";
		f.target = "_self";
		f.action = "cart_4_DownHandler.asp";
		f.submit();
	}


	function selDEl() {
		var f = document.cartFrm
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.nCode;
		var objEa = f.ea;
		var selCnt = 0;

		if (typeof f.nCode == "undefined") {
			//alert("삭제할 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS01%>");
			return;
		}
		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) ++selCnt;
			}
		}

		if (selCnt == 0) {
			//alert("삭제하실 상품을 선택해 주세요.");
			alert("<%=LNG_CS_CART_JS02%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
			}
			else {
				objCart.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
				}
			}
		}

		f.mode.value = "SELDEL";
		f.target = "_self";
		f.action = "cart_4_DownHandler.asp";
		f.submit();
	}

	function selectOrder() {
		var f = document.cartFrm
		var i,len;
		var objCbList = f.chkCart;
		var objCart = f.nCode;
		var objEa = f.ea;
		var selCnt = 0;

		//CS상품 구매종류가 같은 상품만 넘김s
		if ($("input[name=chkCart]:checked").length == 0)
		{
			//alert("주문하실 상품을 선택해주세요!");
			alert("<%=LNG_CS_CART_JS03%>");
			return ;
		}

		var attrResult = [];									// 배열선언
		$("input[name=chkCart]:checked").each(function(){		// input name 이 chkCart 중 체크된 애들만 가져온다. (for 문과 같은 반복)
			var vs = $(this).attr("attrCode");					// vs 는 해당 값의 어트리뷰트중 attrCode 의 값
			if (vs != "")										// attrCode 가 빈값이 아니라면
			{
				if ($.inArray(vs,attrResult) == -1)				// 배열과 비교해서 기존에 없는 값인 경우
				{
					attrResult.push(vs);						// 배열에 저장
				}
			}

		});
		var attrReCount = attrResult.length;					// 배열의 갯수를 센다

		if (attrReCount > 1)									// 배열의 갯수가 1개 이상인 경우 (일반상품 제외vs에서 걸렀음)
		{
			//alert("구매종류가 다른 상품은 같이 구매할 수 없습니다.");
			alert("<%=LNG_CS_CART_JS04%>");
			return ;
		}
		//CS상품 구매종류가 같은 상품만 넘김e



		if (typeof objCart == "undefined") {
			//alert("주문하실 상품이 없습니다.");
			alert("<%=LNG_CS_CART_JS05%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) ++selCnt;
			}
		}

		if (selCnt == 0) {
			//alert("주문하실 상품을 선택해 주세요.");
			alert("<%=LNG_CS_CART_JS03%>");
			return;
		}

		if (typeof f.chkCart.length == "undefined") {
			if (f.chkCart.checked) {
				objCart.disabled = false;
			}
			else {
				objCart.disabled = true;
			}
		}
		else {
			for (i=0, len=f.chkCart.length; i<len; i++) {
				if (f.chkCart[i].checked) {
					objCart[i].disabled = false;
				}
				else {
					objCart[i].disabled = true;
				}
			}
		}

		f.target = "_self";
		//f.action = "orders.asp";
		<%IF WebproIP = "T"THEN%>
		f.action = "orders_4_downMember.asp";		//더화이트 하선결제
		<%ELSE%>
		f.action = "orders_4_downMember.asp";
		//f.action = "orders_point_under.asp";		//더화이트 하선포인트결제
		<%END IF%>

		f.submit();
	}

	//카트수량조정
	function thisGoodsCart(nums,modes) {
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('<%=LNG_CS_CART_JS06%>');}
		if (idvalue == '') { alert('<%=LNG_CS_CART_JS07%>');}
		if (eavalue == 0){
			alert('<%=LNG_CS_CART_JS08%>');
			eavalue = 1;
		}
		chg_cart(eavalue,idvalue,modes);
	}


	function chg_cart(mode1,mode2,mode3) {
		createRequest();
		var url = 'cart_4_downMember_ajax.asp';
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=" + mode3;
		postParams += "&mid1=" + '<%=mid1%>';		//하선회원
		postParams += "&mid2=" + '<%=mid2%>';		//하선회원

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;
					alert(newContent);
					document.location.reload();
				} else {
					alert(request.responseText);
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}
//-->
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="cart" class="orderList">
	<form name="cartFrm" method="post" action="">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="ea" />
		<input type="hidden" name="DownMemID1" value="<%=mid1%>" readonly="readonly" />
		<input type="hidden" name="DownMemID2" value="<%=mid2%>" readonly="readonly" />
		<input type="hidden" name="DownMemWebID" value="" readonly="readonly" />
		<input type="hidden" name="DownMemChk" value="F" readonly="readonly" />
		<input type="hidden" name="DownMemName" value="" readonly="readonly" />
		<table <%=tableatt%> class="userCWidth orderTable">
			<col width="40" />
			<col width="70" />
			<col width="230" />
			<!-- <col width="70" /> -->
			<col width="90" />
			<col width="90" />
			<col width="90" />
			<col width="100" />
			<thead>
				<tr>
					<th><input type="checkbox" name="checklist"  onClick="SelectAll()" /></th>
					<th><%=LNG_TEXT_CSGOODS_CODE%></th>
					<!-- <th><%=LNG_CS_CART_TEXT02%></th> -->
					<th><%=LNG_TEXT_ITEM_NAME%></th>
					<!-- <th><%=LNG_CS_CART_TEXT04%></th> -->
					<th><%=CS_PV%></th>
					<th><%=LNG_TEXT_MEMBER_PRICE%></th>
					<th><%=LNG_CS_CART_TEXT06%></th>
					<th><%=LNG_CS_CART_TEXT07%></th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="7" class="notBor">
						<!-- <%=viewImgStJs(IMG_BTN&"/cart_btn_selectAll.gif",70,22,"","","cp","onClick=""SelectAlls();""")%>
						<%=viewImgStJs(IMG_BTN&"/cart_btn_AllDel.gif",70,22,"","margin-left:4px;","cp","onclick=""delAll()""")%>
						<%=viewImgStJs(IMG_BTN&"/cart_btn_selectDel.gif",70,22,"","margin-left:4px;","cp","onclick=""selDEl();""")%> -->
						<input type="button" class="txtBtnC small gray radius3 bgf5" onclick="SelectAlls();" value="<%=LNG_CS_CART_BTN01%>"/>
						<input type="button" class="txtBtnC small gray radius3 bgf5" style="color:red;" onclick="delAll();" value="<%=LNG_CS_CART_BTN02%>" />
						<input type="button" class="txtBtnC small gray radius3 bgf5" style="color:#bd3e3e;" onclick="selDEl();" value="<%=LNG_CS_CART_BTN03%>"/>
					</td>
				</tr>
			</tfoot>
			<tbody>
			<%
				arrParams = Array(_
					Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
					Db.makeParam("@DOWN_MBID",adVarChar,adParamInput,20,mid1),_
					Db.makeParam("@DOWN_MBID2",adInteger,adParamInput,0,mid2)_
				)
				arrList = Db.execRsList("HJP_CART4DOWN_LIST",DB_PROC,arrParams,listLen,DB3)

				total_price_all = 0
				CheckPV = 0		'기준값(pv합산, 마지막4만달성 주문번호

				If IsArray(arrList) Then
					For i = 0 To listLen
						RS_ncode		= arrList(1,i)
						RS_name			= arrList(2,i)
						RS_price2		= arrList(3,i)
						RS_GoodUse		= arrList(4,i)
						RS_price4		= arrList(5,i)
						RS_ea			= arrList(7,i)
						RS_SellCode		= arrList(8,i)
						RS_price6		= arrList(9,i)
						'RS_SellTypeName	= arrList(10,i)

						'구매종류
						If RS_SellTypeName <> "" Then
							RS_SellTypeName = "<p span class=""blue2"">["&RS_SellTypeName&"]</p>"
						End If

						'상품가 변경내역 체크
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,RS_ncode) _
						)
						Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							RS_ncode		= DKRS("ncode")
							RS_price2		= DKRS("price2")	'회원가
							RS_price4		= DKRS("price4")
							RS_price5		= DKRS("price5")
							RS_price6		= DKRS("price6")	'지사가
						Else
							RS_ncode		= RS_ncode
							RS_price2		= RS_price2
							RS_price4		= RS_price4
							RS_price5		= RS_price5
							RS_price6		= RS_price6
						End If
						Call closeRs(DKRS)

						total_Price = RS_ea * RS_price2
						total_price_all	= total_price_all + (RS_ea * RS_price2)


						PRINT tabs(1)&"	<tr>"
						PRINT tabs(1)&"		<td class=""tcenter""><input type=""hidden"" name=""nCode"" value="""&arrList(0,i)&""" /><input type=""checkbox"" name=""chkCart"" value="""&arrList(0,i)&""" attrCode="""&RS_SellCode&""" /></td>"
						PRINT tabs(1)&"		<td class=""tcenter"">"&RS_ncode&"</td>"
					'	PRINT tabs(1)&"		<td class=""tcenter"">"&FnGoodsUse(RS_GoodUse)&"</td>"
						PRINT tabs(1)&"		<td style=""padding-left:5px;"">"&RS_name&RS_SellTypeName&"</td>"
					'	PRINT tabs(1)&"		<td class=""tcenter"">"&RS_SellTypeName&"</td>"
						PRINT tabs(1)&"		<td class=""inPrice"">"&num2cur(RS_price4)&" "&CS_PV&" </td>"
						PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(RS_price2)&" "&Chg_CurrencyISO&"</td>"
						PRINT tabs(1)&"		<td class=""tcenter"">"
						PRINT tabs(1)&"			<input type=""input"" name=""ea"" id=""oxea"&i&""" class=""tcenter input_text"" style=""width:30px;height:13px;"" value="&RS_ea&" "&numberOnly&" />"
						PRINT tabs(1)&"			<input type=""hidden"" name=""oxid"" id=""oxid"&i&""" value="&RS_ncode&" />"
						'PRINT tabs(1)&"			<img src=""/images/btn/btn_modify_small2.gif"" class=""vtop"" onclick=""thisGoodsCart('"&i&"','modify');"" />"
						PRINT tabs(1)&"			<input type=""button"" class=""txtBtn s_modify radius3"" onclick=""thisGoodsCart('"&i&"','modify');"" value="""&LNG_CS_CART_BTN04&""" />"
						PRINT tabs(1)&"		</td>"
						PRINT tabs(1)&"		<td class=""inPrice Price"">"&num2cur(total_Price)&" "&Chg_CurrencyISO&"</td>"
						PRINT tabs(1)&"	</tr>"
					Next
				Else
					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td colspan=""7"" class=""notData"">"&LNG_CS_CART_TEXT08&"</td>"
					PRINT tabs(1)&"	</tr>"
				End If
			%>
			</tbody>
			<!-- <tfoot>
				<td colspan="6" class="tright bg2 pR4" style="padding:10px 10px;"><%=LNG_CS_CART_TEXT09%></td>
				<td colspan="1" class="inPrice Price red tright bg2 pR4"><%=num2cur(total_price_all)%> "&Chg_CurrencyISO&"</td>
			</tfoot> -->
		</table>

		<p class="titles">收到销售额的 下线会员<!-- 매출받는 하선회원 --></p>
		<table <%=tableatt%> class="userCWidth2 meminfo">
			<col width="150" />
			<col width="*" />
			<tr>
				<th>收到销售额的 下线会员<!-- 매출받는 하선회원 --> <%=starText%></th>
				<td colspan="2" class="tweight">
					<%=mid1%>-<%=Fn_MBID2(mid2)%>
				</td>
			</tr>
		</table>

		<div class="pagingArea" style="width:870px;">
			<%
				'▣사용자(구매) 비번 체크(더화이트)
				SQL_PASS = "SELECT [UserPassWord] FROM [tbl_MemberInfo] WHERE [mbid] = ? AND [mbid2] = ?"
				arrParams = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs(SQL_PASS,DB_TEXT,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					RS_ORI_UserPassWord	= DKRS(0)
				Else
					Call ALERTS(LNG_CS_ORDERS_ALERT05&"DD","back","")
				End If
				Call closeRS(DKRS)

				'비밀번호 공백체크
				Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					If RS_ORI_UserPassWord	<> "" Then RS_ORI_UserPassWord	= objEncrypter.Decrypt(RS_ORI_UserPassWord)
				Set objEncrypter = Nothing
			%>
			<script type="text/javascript">
			<!--
				function goPasswordChg() {
					if (confirm("使用者的密码没有变更，是否需要进入密码变更页面")) {			//사용자비밀번호 변경이 이루어지지 않았습니다.\n\n패스워드 변경페이지로 이동하시겠습니까?
						document.location.href = "/myoffice/member/member_pass_change.asp";
						return true;
					}else{
						return false;
					}
				}
				// -->
			</script>



			<input type="button" class="txtBtnC medium blue shadow1 tshadow2 radius5" style="min-width:140px;" value="<%=LNG_CS_GOODSLIST_TEXT11%>" onclick="location.href='goodsList_4_downMember.asp?mid1=<%=mid1%>&mid2=<%=mid2%>'"/>
			<%If UNDER_MEMBER_ORDER_CHK > 1 Then		'1차주문은 지사장, 주문은 2번까지(두번째 주문은 본인 또는 지사장)%>
				<input type="button" class="txtBtnC medium red2 shadow1 tshadow2 radius5" style="min-width:140px;" value="<%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%>" onclick="javascript:alert('<%=LNG_JS_MEMBER_ORDER_CHK01%>');"/>
			<%Else%>
				<%'If (MILEAGE_TOTAL + MILEAGE_TOTAL_A) < 1 Then %>
				<%If (MILEAGE_TOTAL_A) < 1 Then %>
					<input type="button" class="txtBtnC medium red2 shadow1 tshadow2 radius5" style="min-width:140px;" value="<%=LNG_SHOP_DETAILVIEW_BTN_CANNOT%>" onclick="javascript:alert('<%=LNG_JS_NO_AVAILABLE_POINT%>');"/>
				<%Else%>

					<%If RS_ORI_UserPassWord = "" Then  '사용자(구매)비번 없을시%>
						<div class="pagingArea btn_area p100"><span class="button xLarge strong"><span class="check"></span><a onclick="goPasswordChg()">转账</a></span></div>
					<%Else%>
						<input type="button" class="txtBtnC medium red2 shadow1 tshadow2 radius5" style="min-width:140px;" value="<%=LNG_CS_CART_BTN05%>" onclick="javascript:selectOrder();"/>
					<%End If%>

				<%End If%>
			<%End If%>

		</div>
	</form>
</div>
<!--#include virtual = "/_include/copyright.asp"-->

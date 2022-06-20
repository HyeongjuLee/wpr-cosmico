<!--#include virtual = "/_lib/strFunc.asp"-->
<%


	ContainMode = "LEFT_T"

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	uidx = Trim(pRequestTF("uidx",True))
'	Call resRW(uidx,"삭제고유값")



	SQL = "SELECT * FROM [DK_CART] WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,uidx) _
	)
	Set DKRSS = Db.execRS(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRSS.BOF Or Not DKRSS.EOF Then
		GoodsIDX = DKRSS(4)
		strOption = DKRSS(5)
		orderEa = DKRSS(6)
	Else
		Call alerts("수정할 상품이 장바구니에서 삭제 되었거나 세션만료로 삭제되었습니다.","close","")
		Response.End
	End If

	Call closeRs(DKRSS)


	SQL = "SELECT * "
	SQL = SQL & " FROM [DK_GOODS] "
	SQL = SQL & " WHERE [intIDX] = ? AND [GoodsViewTF] = 'T' AND [delTF] = 'F' "
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,GoodsIDX) _
	)
	Set DKRSS = Db.execRS("DKP_CART_MODIFY",DB_PROC,arrParams,Nothing)
	If Not DKRSS.BOF Or Not DKRSS.EOF Then
		intIDX				= DKRSS("intIDX")
		GoodsName			= DKRSS("GoodsName")
		GoodsStockType		= DKRSS("GoodsStockType")
		GoodsStockNum		= DKRSS("GoodsStockNum")
		ImgB				= DKRSS("ImgThum")
		OptionVal			= DKRSS("OptionVal")
	Else
		Call alerts("상품번호가 존재하지 않습니다. 다시 한번 확인해주세요.","close","")
	End If
	Call CloseRS(DKRSS)

	If OptionVal = "T" Then
		SQL = "SELECT * FROM [DK_GOODS_OPTION] WHERE [GoodsIDX] = ? AND [isUse] = 'T' ORDER BY [SORT] ASC"
		arrParams = Array(_
			Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,GoodsIDX) _
		)
		arrListOpt = Db.execRsList(SQL,DB_TEXT,arrParams,COUNTS,Nothing)
	Else
		COUNTS = -1
	End If
	' TD 높이 산출


	popWidth = 400
	td_height = 30
	popHeight = 300
	If COUNTS > 0 Then
		td_height = td_height + ((COUNTS+1)*10)
		popHeight = popHeight + ((COUNTS+1)*30)
	End If
'	print td_height

%>

<!--#include virtual = "/_include/document.asp"-->
<style type="text/css">
	.tit {width:400px;clear:both; float:left;background:url(/images/pop/pop_title_bg.gif) 0 0 repeat-x;}
	.Goods {clear:both;float:left;}
	.imgs {height:70px; width:70px; border:1px solid #ccc;}
	.subject {float:left; margin-left:10px;}
	.Goods .bor1 td {border-bottom:1px dotted #ccc; line-height:160%;}
	.Goods .none td {border:0px;}
	.input_text {border:1px solid #ccc; height:16px; padding-top:2px;}
</style>

<script type="text/javascript">
<!--
	function ea_ups() {
		var fs = document.frm;
		var gea = parseInt(fs.ea.value,10);
		if (gea > 0)
		{
			fs.ea.value = gea + 1;
		}
	}
	function ea_downs() {
		var fs = document.frm;
		var gea = parseInt(fs.ea.value,10);
		if (gea <= 1)
		{
			alert("1보다 작은 수량을 입력하실 수 없습니다.");
		}
		else {
			fs.ea.value = gea - 1;
		}
	}
	function check_frm(method){
		var f = document.frm;
		var i, len;
		<%if GoodsStockType = "S" then%>
			alert("품절된 상품입니다");
			return false;
		<%end if%>
		<%if GoodsStockType = "N" and GoodsStockNum = 0 then%>
			alert("재고가 없는 상품입니다");
			return false;
		<%end if%>
		<%if GoodsStockType = "N" and GoodsStockNum <> 0 then%>
			if (f.ea.value > <%=GoodsStockNum%>)
			{
				alert("주문수량이 재고 수량보다 많습니다.");
				f.ea.focus();
				return false;
			}
		<%end if%>

		if (chkEmpty(f.ea)||f.ea.value=="0")
		{
			alert("제품 주문수량을 입력해주세요.")
			f.ea.focus();
			return false;
		}
		<%if OptionVal = "T" then%>
			var objOption = f.goodsOption;
			var optionCnt = parseInt(f.optCount.value, 10);
			if (optionCnt == 1) {
				if (chkEmpty(objOption)) {
					alert(objOption.getAttribute('title')+"은 필수선택 옵션입니다.\n옵션을 선택해 주세요.");
					objOption.focus();
					return false;
				}
			} else {
				for (i=0, len=objOption.length; i<len; i++) {
					if (chkEmpty(objOption[i])) {
						alert(objOption[i].getAttribute('title')+"은 필수선택 옵션입니다.\n옵션을 선택해 주세요.");
						objOption[i].focus();
						return false;
					}
				}
			}
		<%end if%>
	eval(method+"();");
	}


	// 장바구니담기
	function cart() {
		var f = document.frm;

		f.mode.value = "MODIFY";
		f.target = "_self";
		f.action = "/shop/cartOk.asp";
		f.submit();
	}

//-->
</script>
</head>
<body>
<%
'	Call ResRW(GoodsIDX,"상품값")
'	Call ResRW(strOption,"옵션")
'	Call ResRW(orderEa,"수량")

%>
<form name="frm" method="post">
<input type="hidden" name="mode">
<input type="hidden" name="uidx" value="<%=uidx%>" />
<div class="tit"><img src="<%=IMG_POP%>/pop_cartMod.gif" width="250" height="40" alt="주문내용수정" /></div>
<div class="Goods">
	<table <%=tableatt%> style="table-layout:fixed;">
		<colgroup>
			<col style="width:100px;" />
			<col style="width:300px;" />
		</colgroup>
		<tr class="bor1">
			<td align="center" height="80" ><div class="imgs"><img src="<%=VIR_PATH("goods/thum")%>/<%=ImgB%>" /></div></td>
			<td align="left"><strong><%=GoodsName%></strong></td>
		</tr><tr class="bor1">
			<td align="center" height="<%=td_height%>"  style="font-weight:bold;">현재옵션</td>
			<td><%
			If strOption = "" Then
				print "옵션이 없는 상품입니다."
			Else
				If IsNull(strOption) Then
					strOptionNull = ""
					arrOriOpt = Split(strOptionNull,",")
				Else
					arrOriOpt = Split(strOption,",")
				End If
				For a = 0 To UBound(arrOriOpt)
					arrOriOpt_depth2 = Split(Trim(arrOriOpt(a)),"\")
					print "<img src='"&IMG_SHOP&"/circle_darkblue.gif' width='4' height='4' alt='아이콘' align='absmiddle' /> "&Trim(arrOriOpt_depth2(0)) &" ("&num2cur(Trim(arrOriOpt_depth2(1))) &")<br />"
				Next
			End If



			%></td>
		</tr><tr class="bor1">
			<td align="center" style="font-weight:bold;">옵션변경</td>
			<td height="<%=td_height%>">
			<%If IsArray(arrListOpt) Then%>
				<table <%=tableatt%>>
				<%
							For i = 0 To COUNTS
							optionTitle = Trim(arrListOpt(2,i))
							optionItem = Trim(arrListOpt(3,i))
							arrOptItem = Split(optionItem,"\")
				%>
									<tr class="none">
										<td><img src="<%=IMG_SHOP%>/circle_darkblue.gif" width="4" height="4" alt="아이콘" /></td>
										<td align="left">&nbsp;<%=optionTitle%></td>
										<td width="10" align="center"><img src="<%=img_goods%>/alt_h_line.gif" width="2" height="11" alt="라인구분" /></td>
										<td class="point" height="20">
											<select name="goodsOption" title="<%=optionTitle%>">
												<option value=''>선택하세요</option>
												<option value=''>----------</option>
												<%
													For j = 0 To UBound(arrOptItem)


														optionTxt = Trim(arrOptItem(j))
														optionPay = 0
														arrOptionTxt = Split(optionTxt,":")
														optionTxt = Trim(arrOptionTxt(0))

														If UBound(arrOptionTxt) = 1 Then
															optPrice = Int(arrOptionTxt(1))
															If optPrice > 0 Then
																optionTxts = optionTxt &" (+"& num2cur(Int(optPrice)) &")"
															ElseIf optPrice < 0 Then
																optionTxts = optionTxt &" (-"& num2cur(Int(optPrice)) &")"
															ElseIf optPrice = 0 Then
																optionTxts = optionTxt
															End If
														End If
														optValue = optionTitle & ":" & optionTxt & "\" &optPrice
														print "<option value="&optValue&">"&optionTxts&"</option>"
													Next
												%>
											</select>
										</td>
									</tr>
				<%Next%>
				</table>
<%Else%>
변경할 수 있는 옵션이 없습니다.
<%End If%><input type="hidden" name="optCount" value="<%=COUNTS+1%>" />
			</td>
		</tr><tr class="bor1">
			<td height="<%=td_height%>" align="center" style="font-weight:bold;">수량변경</td>
			<td><input type="text" name="ea" class="input_text" style="width:50px;" value="<%=orderEa%>" /> ea</td>
		</tr><tr>
			<td colspan="2" align="center" height="40"><img
	src="<%=IMG_SHOP%>/btn_cart_pop_submit.gif" width="72" height="22" alt="주문변경" onclick="check_frm('cart')" class="cp" /><img
	src="<%=IMG_SHOP%>/btn_cart_pop_cancel.gif" width="67" height="22" alt="변경취소" class="cp" style="margin-left:5px;" onclick="self.close();" /></td>
		</tr>
	</table>
</div>
</form>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>
<%
Set DB = Nothing
%>

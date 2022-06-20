<!--#include virtual="/_lib/strFunc.asp" -->
<%
Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")


	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)


	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MYPAGE"
		ptshop = ""
	End If

	'PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 2

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	cart_id = DK_MEMBER_ID
	cart_method = "MEMBER"


	Dim PAGE			:	PAGE = Request("PAGE")
	PAGESIZE = 20
	If PAGE = "" Then	PAGE = 1


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="/css/mypage.css" />
<link rel="stylesheet" href="wish_list.css" />
<script type="text/javascript" language="javascript">
<!--
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

function cart_del(uidx){
	var f = document.cartFrm;

	f.mode.value = "DEL";
	f.uidx.value = uidx;
	f.target = "_self";
	f.action = "wishok.asp<%=ptshop%>";
	f.submit();


}


function allOrders(f) {
	if (typeof f.cuidx == "undefined") {
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS02%>");
		return false;
	}

	f.target = "_self";
	f.action = "/shop/order.asp";
}


function selectOrder() {
	var f = document.cartFrm
	var i,len;
	var objCbList = f.chkCart;
	var objCart = f.cuidx;
	var objEa = f.ea;
	var selCnt = 0;

if (typeof objCart == "undefined") {
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS02%>");
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
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS03%>");
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
	f.mode.value = "CART";
	f.target = "_self";
	f.action = "/mypage/wishok.asp<%=ptshop%>";
	f.submit();
}


function delAll() {
	var f= document.cartFrm;
	if (typeof f.cuidx == "undefined") return;

	f.mode.value = "DELALL";
	f.target = "_self";
	f.action = "wishok.asp<%=ptshop%>";
	f.submit();
}

function selDEl() {
	var f = document.cartFrm
	var i,len;
	var objCbList = f.chkCart;
	var objCart = f.cuidx;
	var objEa = f.ea;
	var selCnt = 0;

	if (typeof f.cuidx == "undefined") {
		alert("<%=LNG_SHOP_ORDER_WISHLIST_JS04%>");
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
	f.action = "wishok.asp<%=ptshop%>";
	f.submit();
}





//-->
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--'include virtual = "/_include/sub_title.asp"-->

<!-- <div id="subTitle" class="width100">
	<div class="fleft maps_title"><img src="<%=IMG_MYPAGE%>/tit_wishlist.png" alt="" /></div>
	<div class="fright maps_navi">HOME > 마이페이지 > <span class="tweight last_navi">위시리스트</span></div>
</div> -->
<div id="cart">
	<form name="cartFrm" method="post" onsubmit="return allOrders(this);">
	<input type="hidden" name="mode" />
	<input type="hidden" name="uidx" />
	<input type="hidden" name="ea" />
	<div class="cart_list">
		<table <%=tableatt%> class="userCWidth2" >
			<colgroup>
				<col width="30" />
				<col width="90" />
				<col width="*" />
				<col width="85" />
				<col width="50" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checklist"  onClick="SelectAll()" /></th>
					<th></th>
					<th><%=LNG_SHOP_ORDER_DIRECT_TABLE_01%></th>
					<th><%=LNG_SHOP_COMMON_TXT_06%></th>
					<th></th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="6">
						<input type="button" class="txtBtnC small gray" onclick="delAll();" value="<%=LNG_SHOP_CART_TXT_04%>"/>
						<input type="button" class="txtBtnC small gray" onclick="javascript:selDEl();" value="<%=LNG_SHOP_CART_TXT_05%>"/>
						<!-- <img src="<%=IMG_MYPAGE%>/btn_cart_all_del.gif" width="67" height="22" alt="전체삭제" onclick="delAll();" <%=s_cursor%> /><a href="javascript:selDEl();">
						<img src="<%=IMG_MYPAGE%>/btn_cart_sel_del.gif" width="67" height="22" alt="선택삭제" /></a> -->
					</td>
				</tr>
			</tfoot>
			<tbody>
			<%
				arrParams = Array(_
					Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
					Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE), _
					Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE), _
					Db.makeParam("@ALL_COUNT",adInteger,adParamOutPut,4,0) _
				)
				arrList = Db.execRsList("DKP_WISHLIST_E",DB_PROC,arrParams,listLen,Nothing)
			'	arrList = Db.execRsList("DKP_WISHLIST",DB_PROC,arrParams,listLen,Nothing)
				ALL_COUNT = arrParams(Ubound(arrParams))(4)

				Dim PAGECOUNT,CNT
				PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
				IF CCur(PAGE) = 1 Then
					CNT = ALL_COUNT
				Else
					CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
				End If

				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX				= arrList(1,i)
						arrList_goodsIDX			= arrList(2,i)
						arrList_Category			= arrList(3,i)
						arrList_DelTF				= arrList(4,i)
						arrList_GoodsName			= arrList(5,i)
						arrList_GoodsComment		= arrList(6,i)

						arrList_GoodsViewTF			= arrList(7,i)
						arrList_flagBest			= arrList(8,i)
						arrList_flagNew				= arrList(9,i)
						arrList_FlagVote			= arrList(10,i)
						arrList_strShopID			= arrList(11,i)

						arrList_ImgThum				= arrList(12,i)
						arrList_isViewMemberNot		= arrList(13,i)
						arrList_isViewMemberAuth	= arrList(14,i)
						arrList_isViewMemberDeal	= arrList(15,i)
						arrList_isViewMemberVIP		= arrList(16,i)

						arrList_intPriceNot			= arrList(17,i)
						arrList_intPriceAuth		= arrList(18,i)
						arrList_intPriceDeal		= arrList(19,i)
						arrList_intPriceVIP			= arrList(20,i)

						arrList_intPointNot 		= arrList(21,i)
						arrList_intPointAuth		= arrList(22,i)
						arrList_intPointDeal		= arrList(23,i)
						arrList_intPointVIP 		= arrList(24,i)
						arrList_isImgType 			= arrList(25,i)

						arrList_imgList				= arrList(26,i)
						arrList_isCSGoods			= arrList(27,i)
						arrList_CSGoodsCode			= arrList(28,i)
						arrList_GoodsDeliveryType	= arrList(29,i)
						arrList_GoodsDeliveryFee	= arrList(30,i)

						arrList_GoodsStockType		= arrList(31,i)
						arrList_GoodsStockNum		= arrList(32,i)

						arrList_GoodsCustomer		= arrList(33,i)		'소비자가
						gView = "F"

						Select Case DK_MEMBER_LEVEL
							Case 0,1 '비회원, 일반회원
								arrList_GoodsPrice = arrList_intPriceNot
								arrList_GoodsPoint = arrList_intPointNot
								If arrList_isViewMemberNot = "T" Then gView = "T"
							Case 2 '인증회원
								arrList_GoodsPrice = arrList_intPriceAuth
								arrList_GoodsPoint = arrList_intPointAuth
								If arrList_isViewMemberNot = "T" Then gView = "T"
							Case 3 '딜러회원
								arrList_GoodsPrice = arrList_intPriceDeal
								arrList_GoodsPoint = arrList_intPointDeal
								If arrList_isViewMemberNot = "T" Then gView = "T"
							Case 4,5 'VIP 회원
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								If arrList_isViewMemberNot = "T" Then gView = "T"
							Case 9,10,11
								arrList_GoodsPrice = arrList_intPriceVIP
								arrList_GoodsPoint = arrList_intPointVIP
								gView = "T"
						End Select

						'▣스피나 소비자 가격(2017-05-16)
					'	If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
					'		arrList_GoodsPrice = arrList_GoodsCustomer
					'	End If

						If arrList_isImgType = "S" Then
							imgPath = VIR_PATH("goods/thum")&"/"&backword(arrList_ImgThum)
							imgWidth = 0
							imgHeight = 0
							Call ImgInfo(imgPath,imgWidth,imgHeight,"")
							imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
							'viewImg(imgPath,imgWidth,imgHeight,"")


						Else
							imgPath = backword(arrList_ImgThum)
							imgWidth = upImgWidths_Thum
							imgHeight = upImgHeight_Thum
							imgPaddingH = (upImgHeight_Thum - imgHeight) / 2
						End If


			'▣소비자 가격, 쇼핑몰가/CS가 비교 & 소비자 = 소비자가 구매 (2017-10-25~2017-11-08)
			If DK_MEMBER_STYPE = "1" And arrList_isCSGoods = "T" Then
				arrList_GoodsPrice = arrList_GoodsCustomer
			End If

						arr_CS_price4 = 0
						arr_CS_SELLCODE		= ""
						arr_CS_SellTypeName = ""
						If arrList_isCSGoods = "T" And DK_MEMBER_STYPE = "0" Then
							'▣CS상품정보 변동정보 통합
							arrParams = Array(_
								Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
								Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
							)
							Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
							'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
							If Not DKRS.BOF And Not DKRS.EOF Then
								arr_CS_ncode		= DKRS("ncode")
								arr_CS_price2		= DKRS("price2")
								arr_CS_price4		= DKRS("price4")
								arr_CS_price5		= DKRS("price5")
								arr_CS_price6		= DKRS("price6")
								arr_CS_SellCode		= DKRS("SellCode")
								arr_CS_SellTypeName	= DKRS("SellTypeName")
								If arr_CS_SellTypeName <> "" Then
								arr_CS_SellTypeName = "<span class=""tweight blue2"">구매종류 : </span><span class=""green tweight"">"&arr_CS_SellTypeName&"</span>"
								End If
							End If
							Call closeRs(DKRS)
						End If

			%>
				<tr>
					<td class="tcenter"><input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" /><input type="checkbox" name="chkCart" value="<%=arrList_intIDX%>" /></td>
					<%If arrList_DelTF = "T" Then%>
						<td colspan="3"><%=LNG_SHOP_ORDER_WISHLIST_TEXT03%></td>
					<%Else%>
						<%If arrList_GoodsViewTF = "T" Then%>
							<td><div class="imgs"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div></td>
							<td align="left" style="line-height:18px;">
								<a href="/shop/detailView.asp?gidx=<%=arrList_goodsIDX%>"><strong><%=backword(arrList_GoodsName)%></strong></a><br />
								<span style='font-size:8pt;color:#9e9e9e;'><%=backword(arrList_GoodsComment)%></span>
							</td>
							<td class="tcenter" style="line-height:18px;">
								<%=spans(FormatNumber(arrList_GoodsPrice,0)&" "&Chg_CurrencyISO&"","#FF6600","","bold")%><br />
								<span class="f8pt">+ <%=LNG_SHOP_ORDER_FINISH_10%></span><br />
								<%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(arrList_GoodsPoint)%> <%=Chg_CurrencyISO%>

							</td>
						<%Else%>
							<td colspan="3"><%=LNG_SHOP_DETAILVIEW_01%></td>
						<%End If%>

					<%End If%>

					<td class="tcenter">
						<span class="button small"><span class="delete" style="width:4px;"></span><a onclick="cart_del('<%=arrList_intIDX%>')"><%=LNG_BTN_DELETE%></a></span>
						<!-- <img src="<%=IMG_MYPAGE%>/btn_del_small.gif" alt="삭제" onclick="cart_del('<%=arrList_intIDX%>')" class="cp" /> -->
					</td>
				</tr>
			<%
						Next
					Else
			%>
				<tr>
					<td colspan="5" align="center" height="80"><%=LNG_SHOP_ORDER_WISHLIST_TEXT04%></td>
				</tr>
			<%
				End If
			%>
			</tbody>
		</table>
	</div>
	<div class="cart_select" style="margin-top:40px;height:80px;width:1200px;">
		<span><input type="button" class="txtBtnC large red2" onclick="javascript:selectOrder();" value="<%=LNG_SHOP_CART_TXT_06%>"/></span>
		<span class="pL10"><input type="button" class="txtBtnC large gray" style="width:130px;" onclick="location.href='/shop/index.asp';" value="<%=LNG_SHOP_CART_TXT_07%>"/></span>
	</div>
	<!-- <div class="cart_select">
		<a href="javascript:selectOrder();"><img src="<%=IMG_SHOP%>/btn_cart_order.gif" width="124" height="40" alt="주문하기" /></a>
		<img src="<%=IMG_SHOP%>/btn_cart_shopping.gif"  width="124" height="40" alt="쇼핑계속하기" onclick="location.href='/shop/index.asp'" />
	</div> -->




<!--#include virtual="/_include/copyright.asp" -->

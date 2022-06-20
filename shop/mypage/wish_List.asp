<!--#include virtual="/_lib/strFunc.asp" -->
<%
	Response.Redirect "/mypage/wish_list.asp"


	PAGE_SETTING = "SHOP"
	SHOP_MYPAGE	="T"

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
	f.action = "wishok.asp";
	f.submit();


}


function allOrders(f) {
	if (typeof f.cuidx == "undefined") {
		alert("장바구니에 담으실 상품이 없습니다.");
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
		alert("장바구니에 담으실 상품이 없습니다.");
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
		alert("장바구니에 담을 상품을 선택해 주세요.");
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
	f.action = "/mypage/wishok.asp";
	f.submit();
}


function delAll() {
	var f= document.cartFrm;
	if (typeof f.cuidx == "undefined") return;

	f.mode.value = "DELALL";
	f.target = "_self";
	f.action = "wishok.asp";
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
		alert("위시리스트가 비어있습니다.");
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
		alert("삭제하실 상품을 선택해 주세요.");
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
	f.action = "wishok.asp";
	f.submit();
}





//-->
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="subTitle" class="" style="margin-left:20px;">
	<div class="fleft maps_title"><img src="<%=IMG_MYPAGE%>/tit_wishlist.png" alt="" /></div>
	<div class="fright maps_navi">SHOP > 마이페이지 > <span class="tweight last_navi">위시리스트</span></div>
</div>

<div id="cart">
	<form name="cartFrm" method="post" onsubmit="return allOrders(this);">
	<input type="hidden" name="mode" />
	<input type="hidden" name="uidx" />
	<input type="hidden" name="ea" />
	<div class="cart_list">
		<table <%=tableatt%> style="width:800px;margin-left:20px;">
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
					<th>상품정보</th>
					<th>판매가</th>
					<th></th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td colspan="6"><img
					src="<%=IMG_MYPAGE%>/btn_cart_all_del.gif" width="67" height="22" alt="전체삭제" onclick="delAll();" <%=s_cursor%> /><a href="javascript:selDEl();"><img
					src="<%=IMG_MYPAGE%>/btn_cart_sel_del.gif" width="67" height="22" alt="선택삭제" /></a></td>
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
			%>
				<tr>
					<td class="tcenter"><input type="hidden" name="cuidx" value="<%=arrList_intIDX%>" /><input type="checkbox" name="chkCart" value="<%=arrList_intIDX%>" /></td>
					<%If arrList_DelTF = "T" Then%>
						<td colspan="3">삭제된 상품입니다.</td>
					<%Else%>
						<%If arrList_GoodsViewTF = "T" Then%>
							<td><div class="imgs"><%=viewImg(imgPath,imgWidth,imgHeight,"")%></div></td>
							<td align="left" style="line-height:18px;">
								<a href="/shop/detailView.asp?gidx=<%=arrList_goodsIDX%>"><strong><%=backword(arrList_GoodsName)%></strong></a><br />
								<span style='font-size:8pt;color:#9e9e9e;'><%=backword(arrList_GoodsComment)%></span>
							</td>
							<td class="tcenter" style="line-height:18px;">
								<%=spans(FormatNumber(arrList_GoodsPrice,0)&" 원","#FF6600","","bold")%><br />
								<span class="f8pt">+ 옵션가</span><br />
								<%=viewImgSt(IMG_SHOP&"/icon_point_green.gif",13,15,"","","vmiddle")%>&nbsp;<%=num2cur(arrList_GoodsPoint)%> 원

							</td>
						<%Else%>
							<td colspan="3">판매중지 된 상품입니다.</td>
						<%End If%>

					<%End If%>

					<td class="tcenter"><img
					src="<%=IMG_MYPAGE%>/btn_del_small.gif" alt="삭제" onclick="cart_del('<%=arrList_intIDX%>')" class="cp" /></td>
				</tr>
			<%
						Next
					Else
			%>
				<tr>
					<td colspan="5" align="center" height="80">위시리스트에 담긴 상품이 없습니다.</td>
				</tr>
			<%
				End If
			%>
			</tbody>
		</table>
	</div>
	<div class="cart_select"><a href="javascript:selectOrder();"><img
		src="<%=IMG_MYPAGE%>/btn_cart_order.gif" width="100" height="49" alt="주문하기" /></a><img
		src="<%=IMG_MYPAGE%>/btn_cart_shopping.gif"  width="100" height="49" alt="쇼핑계속하기" onclick="location.href='/index.asp'" /></div>
	</div>


<!--#include virtual="/_include/copyright.asp" -->

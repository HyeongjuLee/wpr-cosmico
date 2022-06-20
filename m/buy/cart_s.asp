<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"
	Call ONLY_MEMBER2()

	If Not (nowCurPoint > 3 And (LASTMONTH_MAINTAIN = 1 Or LASTMONTH_SALES_OK = "T")) Then Call ALERTS("우대주문 페이지 입니다.접근권한이 없습니다.","back","")
'	If nowCurPoint < 4 OR LASTMONTH_MAINTAIN <> 1 Then Call ALERTS("우대주문 페이지 입니다.접근권한이 없습니다.","go","cart.asp")

%>
<!--#include virtual = "/_inc/document.asp"-->
<!--#include virtual = "/_inc/jqueryload.asp"-->
<script type="text/javascript" src="/js/ajax.js"></script>
<script type="text/javascript" src="cart.js"></script>
</head>
<body  onunload="">
<!--#include virtual = "/_inc/header.asp"-->
<!--#include virtual = "/_inc/sub_header.asp"-->
<div id="b_title" class="cleft">
	<h3 class="fleft"><span class="h3color1">장바구니</span> <span class="h3color2">(우대가)</span></h3>
</div>
<div id="cart" class="cleft width100" style="margin-top:10px;">
	<table <%=tableatt%> class="width100">
		<thead>
			<tr>
				<th rowspan="2">[상품코드] 상품명</th>
				<th style="width:110px;" >우대가</th>
				<th style="width:100px;" rowspan="2">수량</th>
			</tr><tr>
				<th>BV</th>
			</tr>
		</thead>
		<%
			If nowCurPoint > 3 And (LASTMONTH_MAINTAIN = 1 Or LASTMONTH_SALES_OK = "T") THEN			
'			If nowCurPoint > 3 And LASTMONTH_MAINTAIN = 1 Then
			
				arrParams = Array(_
					Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
				)
				arrList = Db.execRsList("DKP_CART_LIST2_S",DB_PROC,arrParams,listLen,DB3)

				total_price = 0
				THIS_GOODS_PATTERN	= 0
				If IsArray(arrList) Then
					For i = 0 To listLen
						
						arrList_NCODE				= arrList(1,i)
						arrList_NAME				= arrList(2,i)
						arrList_PRICE2				= arrList(3,i)
						arrList_price4				= arrList(5,i)
						arrList_ea					= arrList(7,i)
						arrList_price1				= arrList(8,i)			'우대가
						arrList_price8				= arrList(9,i)			'우대BV

						'상품가 변경내역 체크
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_NCODE) _
						)
						Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
						If Not DKRS.BOF And Not DKRS.EOF Then
							arrList_NCODE	= DKRS("ncode")
							arrList_NAME	= DKRS("name")
							arrList_PRICE2	= DKRS("price2")
							arrList_price4	= DKRS("price4")
							arrList_price1	= DKRS("price1")				'우대가
							arrList_price8	= DKRS("price8")				'우대BV
						Else
							arrList_NCODE	= arrList_NCODE	
							arrList_NAME	= arrList_NAME	
							arrList_PRICE2	= arrList_PRICE2
							arrList_price4	= arrList_price4
							arrList_price1	= arrList_price1
							arrList_price8	= arrList_price8
						End If

						
						total_Price		= total_Price + (arrList(7,i) * arrList_price1 )

			%>
			<tbody>
				<tr class="hovers">
					<td rowspan="2" class="font_14px">[<%=arrList_NCODE%>] <strong><%=arrList_NAME%></strong></td>
					<td class="tright tweight font_14px" style="color:green"><%=num2cur(arrList_price1)%> 원</td>
					<td class=""><input type="number" name="ea" id="oxea<%=i%>" min="1" max="100" required class="tcenter" value="<%=arrList_ea%>" /><input type="hidden" name="oxid" id="oxid<%=i%>" value="<%=arrList_NCODE%>" /></td>
				</tr><tr>
					<td class="tright tweight font_14px" style="color:#5b71e6;"><%=num2cur(arrList_price8)%> BV</td>
					<td class="tcenter"><img src="<%=IMG%>/chg_ea.png" width="40" onclick="thisGoodsCart('<%=i%>','modify');" /> <img src="<%=IMG%>/cart_del.png" width="40" onclick="thisGoodsCart('<%=i%>','delete');" /></td>				
				</tr>
			</tbody>
			<%
					Next
				Else
					PRINT tabs(1)&"	<tr>"
					PRINT tabs(1)&"		<td colspan=""3"" class=""tcenter notData"">장바구니에 등록된 상품이 없습니다.</td>"
					PRINT tabs(1)&"	</tr>"
				End If



			End if
		%>
		<tfoot>
			<td class="th tweight tcenter font_14px" style="padding:10px 0px;">결제금액합계</td>
			<td colspan="2" class="th tweight tright font_14px" style="color:green;"><%=num2cur(total_Price)%> 원</td>
		</tfoot>
	</table>


	<%If arrList_NCODE <> "" Then%>
		<div class="width100"><a data-role="button" href="cart.asp" data-ajax="false" data-theme="w">회원가로  주문을  변경합니다</a></div>
		<div class="width100"><a data-role="button" href="orders.asp" data-ajax="false" data-theme="e">우 대 가 주 문 하 기</a></div>
		<%If getUserIp="112.154.152.238" Then %>
			<div class="width100"><a data-role="button" href="ordersPhone.asp" data-ajax="false" data-theme="e">핸드폰결제로 주문하기</a></div>		
		<%End If%>
		<div class="in_content alertM">
			<ul>
				<li>&#8226; <span class="lightBlue">핸드폰결제의 경우</span> 브라우저별로 설정 - 팝업차단을 먼저 해제한 후에 진행하셔야 합니다.</li>
				<li>&#8226; 브라우저별 팝업차단 해제의 경우는 핸드폰 또는 추가브라우저에 따라 상이합니다.</li>
			</ul>
		</div>
	<%Else%>	
		<div class="width100"><a data-role="button" href="goods_list.asp" data-ajax="false" data-theme="e">판매상품목록보기</a></div>
	<%End If%>



</div>
<!--#include virtual = "/_inc/copyright.asp"-->
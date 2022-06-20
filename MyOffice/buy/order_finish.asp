<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-4"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()

	orderNumber = request("orderNumber")

'	orderNumber = "14042800000007"

	If orderNumber = "" Then Call alerts("주문정보가 옳바르지 않습니다.","go","order_list.asp")

	SQL3 = "SELECT * FROM [VB_tbl_SalesDetail] WHERE [orderNumber] = ? AND [mbid] = ? AND [mbid2] = ?"
	arrParams = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,50,orderNumber), _
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRSS = Db.execRs(SQL3,DB_TEXT,arrParams,DB3)
	If Not DKRSS.BOF And Not DKRSS.EOF Then
	Else
		Call alerts("접근 권한이 없습니다.","go","order_list.asp")
	End If
	Call closeRS(DKRSS)

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="cart" class="orderList">
	<table <%=tableatt%> class="userCWidth orderTable">
		<col width="70" />
		<col width="250" />
		<col width="95" />
		<col width="95" />
		<col width="55" />
		<col width="95" />
		<col width="120" />
		<thead>
		<tr>
			<th>상품코드</th>
			<th>상품명</th>
			<th>회원가</th>
			<th>PV</th>
			<th>수량</th>
			<th>총 PV</th>
			<th>총 금액</th>
		</tr>
		</thead>
		<tbody>
		<%
			arrParams1 = Array(_
				Db.makeParam("@orderNum",adVarChar,adParamInput,50,orderNumber)_
			)
			arrList1 = Db.execRsList("DKP_VBANK_ORDER_DETAIL",DB_PROC,arrParams1,listLen1,DB3)

			If IsArray(arrList1) Then
				For j = 0 To listLen1
					arrList_name			= arrList1(1,j)
					arrList_price			= arrList1(2,j)
					arrList_ItemPrice		= arrList1(3,j)
					arrList_ItemPV			= arrList1(4,j)
					arrList_ItemCount		= arrList1(5,j)
					arrList_ItemTotalPrice  = arrList1(6,j)
					arrList_ItemTotalPV		= arrList1(7,j)
					arrList_ItemCode		= arrList1(8,j)

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList_ItemCode&"</td>"
					PRINT TABS(1) & "		<td style=""padding-left:5px;"">"&arrList_name&"</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_price)&" 원</td>"
					PRINT TABS(1) & "		<td class=""inPrice Price"">"&num2cur(arrList_ItemPV)&" PV</td>"
					PRINT TABS(1) & "		<td class=""inPrice"">"&num2cur(arrList_ItemCount)&" 개</td>"
					PRINT TABS(1) & "		<td class=""inPrice Price"">"&num2cur(arrList_ItemTotalPV)&" PV</td>"
					PRINT TABS(1) & "		<td class=""inPrice Price"">"&num2cur(arrList_ItemTotalPrice)&" 원</td>"
					PRINT TABS(1) & "	</tr>"

					SELF_PRICE = 0
					SELF_PV = 0

					SELF_PRICE  = arrList_ItemTotalPrice
					SELF_PV		= arrList_ItemTotalPV

					TOTAL_PRICE	= TOTAL_PRICE + SELF_PRICE
					TOTAL_PV	= TOTAL_PV + SELF_PV
				Next

			Else
				PRINT TABS(1) & "	<tr>"
				PRINT TABS(1) & "		<td colspan=""7"" class=""tcenter"">주문할 상품 중 판매가 중지되었거나 삭제되는 등의 오류가 발생하였습니다.</td>"
				PRINT TABS(1) & "	</tr>"
			End If

			%>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="6" class="tweight tright bg2 pR4">구매 총 PV</td>
				<td class="inPrice tPrice"><%=num2cur(TOTAL_PV)%> PV</td>
			</tr><tr>
				<td colspan="6" class="tweight tright bg2 pR4">구매 총 금액</td>
				<td class="inPrice tPrice"><%=num2cur(TOTAL_PRICE)%> 원</td>
			</tr>
			<%	'▣ 배송비처리
				If TOTAL_PRICE < 50000 Then
					DELIVERY_PRICE = 2500
					DELIVERY_TXT = "※ 5만원 이하 구매로 배송료가 부과됩니다."
				Else
					DELIVERY_PRICE = 0
					DELIVERY_TXT = "※ 5만원 이상 구매로 무료배송처리 됩니다."
				End If

				LAST_PRICE = TOTAL_PRICE + DELIVERY_PRICE
			%>

			<tr>
				<td colspan="6" class="tweight tright bg2 pR4"><%=DELIVERY_TXT%></td>
				<td class="inPrice tPrice"><%=num2cur(DELIVERY_PRICE)%> 원</td>		<!-- style.css -->
			</tr>
			<tr>
				<td colspan="6" class="tweight tright bg2 pR4">최종 결제 금액</td>
				<td class="inPrice tPrice"><%=num2cur(LAST_PRICE)%> 원</td>
			</tr>
		</tfoot>
	</table>

	<p class="titles">배송(주문자)정보</p>

	<%
		SQL = "SELECT TOP(1) [Get_Name1],[Get_ZipCode],[Get_Address1],[Get_Address2],[Get_Tel1],[Get_Tel2]"
		SQL = SQL & "FROM [VB_tbl_sales_Rece] WHERE [orderNumber] = ?"
		arrParams = Array(_
			Db.makeParam("@orderNum",adVarChar,adParamInput,50,orderNumber)_
		)
		Set DKRSS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
		If Not DKRSS.BOF And Not DKRSS.EOF Then
			RS_Get_Name1		= DKRSS("Get_Name1")
			RS_Get_ZipCode		= DKRSS("Get_ZipCode")
			RS_Get_Address1		= DKRSS("Get_Address1")
			RS_Get_Address2		= DKRSS("Get_Address2")
			RS_Get_Tel1			= DKRSS("Get_Tel1")
			RS_Get_Tel2			= DKRSS("Get_Tel2")
		Else
		'	Call alerts("자료가 존재하지 않습니다.","back","")
		End If
		Call closeRS(DKRSS)
	%>
	<table <%=tableatt%> class="userCWidth meminfo">
		<colgroup>
			<col width="150" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<th>이름(수령인)</th>
				<td><%=RS_Get_Name1%></td>
			</tr><tr class="line">
				<th>주소</th>
				<td>(<%=RS_Get_ZipCode%>) <%=RS_Get_Address1%><%=RS_Get_Address2%></td>
			</tr><tr>
				<th>휴대폰번호</th>
				<td><%=RS_Get_Tel2%></td>
			</tr><tr>
				<th>전화번호</th>
				<td><%=RS_Get_Tel1%></td>
			</tr>
		</tbody>
	</table>
	<%
		SQL2 = "SELECT [OrderNumber],[C_TF],[C_Code],[C_CodeName],[C_Name1],[C_Name2],[C_Number1],[C_Price1],[C_Price2],[C_AppDate1],[C_AppDate2],[C_Etc]"
		SQL2 = SQL2 & "FROM [VB_tbl_sales_cacu] WHERE [orderNumber] = ?"
		arrParams2 = Array(_
			Db.makeParam("@orderNum",adVarChar,adParamInput,50,orderNumber)_
		)
		Set DKRSS = Db.execRs(SQL2,DB_TEXT,arrParams2,DB3)
		If Not DKRSS.BOF And Not DKRSS.EOF Then
			RS_C_Code		= DKRSS("C_Code")
			RS_C_CodeName	= DKRSS("C_CodeName")
			RS_C_Name1		= DKRSS("C_Name1")
			RS_C_Name2		= DKRSS("C_Name2")
			RS_C_Number1	= DKRSS("C_Number1")
			RS_C_Price1		= DKRSS("C_Price1")
			RS_C_Price2		= DKRSS("C_Price2")
			RS_C_AppDate1	= DKRSS("C_AppDate1")
			RS_C_AppDate2	= DKRSS("C_AppDate2")
			RS_C_Etc		= DKRSS("C_Etc")

			RS_C_Etc_CUT = Split(RS_C_Etc,"/")
			V_BANK_CODE	  = RS_C_Etc_CUT(1)	'입금은행코드
			V_ORDERNUMBER = RS_C_Etc_CUT(4)	'주문번호
		Else
		'	Call alerts("자료가 존재하지 않습니다.","back","")
		End If
		Call closeRS(DKRSS)



	%>
	<p class="titles">가상계좌 결제정보</p>
	<table <%=tableatt%> class="userCWidth meminfo">
		<colgroup>
			<col width="150" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<th>주문번호</th>
				<td class="tweight"><%=V_ORDERNUMBER%></td>
			</tr><tr class="line">
				<th>결제사</th>
				<td><%=PGCOM%> (<a href="https://inicis.com" target="_blank">http://inicis.com</a>)</td>
			</tr><tr>
				<th>입금자명</th>
				<td class="tweight blue2" style="font-size:16px;"><%=RS_C_Name2%></td>
			</tr><tr>
				<th>입금은행</th>
				<td class="tweight blue2" style="font-size:16px;"><%=FN_INICIS_BANKCODE_VIEW(V_BANK_CODE)%></td>
			</tr><tr>
				<th>입금계좌</th>
				<td class="tweight" style="color:green;font-size:16px;"><%=RS_C_Number1%></td>
			</tr><tr>
				<th>입금액</th>
				<td class="tweight blue2" style="font-size:16px;"><%=num2cur(LAST_PRICE)%> 원</td>
			</tr><tr>
				<th>입금기한</th>
				<td class="tweight red" style="font-size:16px;"><%=date8to10(RS_C_AppDate1)%></td>
			</tr>
		</tbody>
	</table>
</div>
<div class="pagingArea tweight blue2" style="background-color:#ffff99;font-size:16px;">입금기한 내에 입금은행계좌로 입금해주시면 정상 승인처리됩니다. </div>
<div class="pagingArea"><%=aImgSt("goodsList.asp",IMG_BTN&"/go_shopping.png",160,32,"","","")%></div>


<!--#include virtual = "/_include/copyright.asp"-->

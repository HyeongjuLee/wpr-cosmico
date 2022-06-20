<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "VENDOR"
	INFO_MODE = "VENDOR2-1"


	Dim PAGE			:	PAGE = pRequestTF("PAGE",False)						: If PAGE = "" Then PAGE = 1
	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)				: If PAGESIZE = "" Then PAGESIZE = 20
	Dim sf_strShopID	:	sf_strShopID = pRequestTF("sf_strShopID",False)		: If sf_strShopID = "" Then sf_strShopID = ""
	Dim sf_isCalcTF		:	sf_isCalcTF = pRequestTF("sf_isCalcTF",False)		: If sf_isCalcTF = "" Then sf_isCalcTF = ""
	Dim sf_isGabogo		:	sf_isGabogo = pRequestTF("sf_isGabogo",False)		: If sf_isGabogo = "" Then sf_isGabogo = ""
	Dim sf_calcDate		:	sf_calcDate = pRequestTF("sf_calcDate",False)		: If sf_calcDate = "" Then sf_calcDate = ""
	Dim sf_OrderNum		:	sf_OrderNum = pRequestTF("sf_OrderNum",False)		: If sf_OrderNum = "" Then sf_OrderNum = ""
	Dim sf_GoodsName	:	sf_GoodsName = pRequestTF("sf_GoodsName",False)		: If sf_GoodsName = "" Then sf_GoodsName = ""




	'strShopID = ""

	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE), _

		Db.makeParam("@strShopID",adVarChar,adParamInput,30,sf_strShopID), _
		Db.makeParam("@isCalcTF",adChar,adParamInput,1,sf_isCalcTF), _
		Db.makeParam("@isGabogo",adChar,adParamInput,1,sf_isGabogo), _

		Db.makeParam("@sf_calcDate",adVarChar,adParamInput,10,sf_calcDate), _
		Db.makeParam("@sf_OrderNum",adVarChar,adParamInput,20,sf_OrderNum), _
		Db.makeParam("@sf_GoodsName",adVarWChar,adParamInput,100,sf_GoodsName), _


		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _


	)
	arrList = Db.execRsList("DKPA_CALC_LIST",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(Ubound(arrParams))(4)

'print CATEGORYS
'		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If



%>
<script type="text/javascript" src="calc.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>

<link rel="stylesheet" href="calc.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
	<p class="titles">검색조건</p>
	<div id="calc_search">
		<form name="searchform" action="calc_list.asp" method="post">
			<table <%=tableatt%> class="goodSearch">
				<colgroup>
					<col width="190" />
					<col width="310" />
					<col width="190" />
					<col width="310" />
				</colgroup>
				<tbody>
					<tr>
						<th>벤더 아이디</th>
						<td colspan="3">
							<input type="text" name="sf_strShopID" value="<%=sf_strShopID%>" class="input_text" />
							<label><input type="checkbox" name="sf_isGabogo" value="T" class="input_check" <%=isChecked(sf_isGabogo,"T")%> /> 메인벤더(회사) 아이디를 제외하고 검색 (벤더만 출력)</label>
						</td>
					</tr><tr>
						<th>정산조건</th>
						<td>
							<label><input type="radio" name="sf_isCalcTF" value="" class="input_check"  <%=isChecked(sf_isCalcTF,"")%> /> 전체</label>
							<label style="margin-left:11px;"><input type="radio" name="sf_isCalcTF" value="T" class="input_check"  <%=isChecked(sf_isCalcTF,"T")%> /> 정산완료만</label>
							<label style="margin-left:11px;"><input type="radio" name="sf_isCalcTF" value="F" class="input_check"  <%=isChecked(sf_isCalcTF,"F")%> /> 미정산내역만</label>
						</td>
						<th>정산일</th>
						<td><input type="text" name="sf_calcDate" value="<%=sf_calcDate%>"  class="input_text readonly font_verdana tcenter" style="width:120px;" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /></td>
					</tr><tr>
						<th>주문번호</th>
						<td><input type="text" name="sf_OrderNum" value="<%=sf_OrderNum%>" class="input_text" /></td>
						<th>상품명</th>
						<td><input type="text" name="sf_GoodsName" value="<%=sf_GoodsName%>" class="input_text" /></td>
					</tr><tr>
						<td colspan="4" class="tcenter">
							<span class="button medium strong icon"><span class="check"></span><input type="submit" value="검색" /></span>
							<span class="button medium strong icon"><span class="refresh"></span><a href="calc_list.asp">초기화</a></span>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>

	<p class="titles">정산체크</p>
	<form name="rFrm" action="calc_handler.asp" method="post" onsubmit="return chkCalc(this)">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="sf_strShopID" value="<%=sf_strShopID%>" />
		<input type="hidden" name="sf_isCalcTF" value="<%=sf_isCalcTF%>" />
		<input type="hidden" name="sf_isGabogo" value="<%=sf_isGabogo%>" />
		<input type="hidden" name="sf_calcDate" value="<%=sf_calcDate%>" />
		<input type="hidden" name="sf_OrderNum" value="<%=sf_OrderNum%>" />
		<input type="hidden" name="sf_GoodsName" value="<%=sf_GoodsName%>" />
		<div id="calc_select">
			<table <%=tableatt%> class="goodList width100">
				<col width="190" />
				<col width="*" />
				<tr>
					<th>전체선택</th>
					<td><label class="cp"><input type="checkbox" name="allChk" value="T" onclick="SelectAll();" class="input_check" />현재 페이지 주문내역 전체선택</label></td>
				</tr><tr>
					<th>정산일자</th>
					<td>
						<input type="text" name="calcDate" value=""  class="input_text readonly font_verdana tcenter" style="width:120px;" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
						<span class="button medium strong icon"><span class="check"></span><input type="submit" value="입력" /></span>
					</td>
				</tr>
			</table>
		</div>


	<p class="titles">리스트</p>
	<div id="calc_list">
		<table <%=tableatt%> class="goodList width100">
			<colgroup>
				<col width="40" />
				<col width="80" />
				<col width="150" />
				<col width="90" />
				<col width="100" />
				<col width="180" />
				<col width="120" />
				<col width="40" />
				<col width="105" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th>선택</th>
					<th>정산여부<br />정산일</th>
					<th>주문일자<br >구매확정일</th>
					<th>벤더명</th>
					<th>주문번호<br />상태정보</th>
					<th>상품명</th>
					<th>공급가<br />옵션공급가</th>
					<th>수량</th>
					<th>주문금액<br />배송비</th>
					<th>정산비용</th>
				</tr>
			</thead>
			<tbody>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen
							arrList_status100Date			= arrList(1,i)
							arrList_strShopID				= arrList(2,i)
							arrList_OrderNum				= arrList(3,i)
							arrList_status_B				= arrList(4,i)
							arrList_status103Date			= arrList(5,i)

							arrList_GoodsPrice				= arrList(6,i)
							arrList_GoodsOptionPrice		= arrList(7,i)
							arrList_OrderEa					= arrList(8,i)
							arrList_GoodsCost				= arrList(9,i)


							arrList_GoodsDeliveryType		= arrList(11,i)
							arrList_GoodsDeliveryFeeType	= arrList(12,i)
							arrList_GoodsDeliveryFee		= arrList(13,i)
							arrList_GoodsDeliveryLimit		= arrList(14,i)
							arrList_sumGoodsPrice			= arrList(15,i)

							arrList_GoodsName				= arrList(16,i)
							arrList_strOption				= arrList(17,i)
							arrList_isCalcTF				= arrList(18,i)
							arrList_CalcDate				= arrList(19,i)
							arrList_intIDX					= arrList(20,i)

							arrList_goodsOPTcost					= arrList(21,i)


							If arrList_status103Date = "" Or IsNull(arrList_status103Date) Then
								arrList_status103Date = "-"
							Else
								arrList_status103Date = arrList_status103Date
							End If
							If arrList_isCalcTF = "T" Then
								arrList_CalcDate = arrList_CalcDate
							Else
								arrList_CalcDate = ""
							End If

						arrList_strOption_s = ""
				%>
				<tr>
					<td class="tcenter"><%If arrList_isCalcTF = "F" Then%><input type="checkbox" name="chkCalcB" value="<%=arrList_intIDX%>" /><%End If%></td>
					<td class="tcenter"><%=TFVIEWER(arrList_isCalcTF,"CALC")%><br /><%=cutDate(arrList_CalcDate,2)%></td>
					<td class="tcenter"><%=arrList_status100Date%><br /><%=arrList_status103Date%></td>
					<td class="tcenter"><%=arrList_strShopID%></td>
					<td class="tcenter"><%=arrList_OrderNum%><br /><%=CallState(arrList_status_B)%></td>
					<td class="tleft"><%=arrList_GoodsNaMe%><br /><span style="font-size:11px;color:#777;">
						<%
							arrList_strOption_s = Split(arrList_strOption,",")
							arrList_strOption_u = Ubound(arrList_strOption_s)

							For j = 0 To arrList_strOption_u
								print arrList_strOption_s(j)&"<br />"
							Next



						%></span></td>
					<td class="tright"><%=num2cur(arrList_GoodsCost)%>원/개<br />
						<%=num2cur(arrList_goodsOPTcost)%>원/개
						</td>
					<td class="tcenter"><%=num2cur(arrList_OrderEa)%></td>
					<td class="tright">
					<%
						TOTAL_PRICE = (arrList_GoodsPrice + arrList_GoodsOptionPrice) * arrList_OrderEa
						'PRINT num2cur(arrList_GoodsPrice)
						'PRINT num2cur(arrList_GoodsOptionPrice)
						'PRINT num2cur(arrList_OrderEa)
						PRINT num2cur(TOTAL_PRICE) & "원<br />"

						If arrList_GoodsDeliveryFeeType = "선결제" Then
							If arrList_sumGoodsPrice > arrList_GoodsDeliveryLimit Then
								PRINT "조건부무료"
								deliPrice = 0
							Else
								PRINT num2cur(arrList_GoodsDeliveryFee) & "원<br />"
								deliPrice = arrList_GoodsDeliveryFee
							End If

						Else
							PRINT arrList_GoodsDeliveryFeeType
							deliPrice = 0
						End If

					%>
					</td>
					<td class="tright tweight red">
					<%
						TOTAL_COST = (arrList_GoodsCost + arrList_goodsOPTcost) * arrList_OrderEa + deliPrice
						PRINT num2cur(TOTAL_COST) & "원"
					%>
					</td>
				</tr>
				<%Next%><%End If%>

			</tbody>
		</table>
	</div>
	<div class="btn_area"><%Call pageList(PAGE,PAGECOUNT)%></div>
</form>



<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="sf_strShopID" value="<%=sf_strShopID%>" />
	<input type="hidden" name="sf_isCalcTF" value="<%=sf_isCalcTF%>" />
	<input type="hidden" name="sf_isGabogo" value="<%=sf_isGabogo%>" />
	<input type="hidden" name="sf_calcDate" value="<%=sf_calcDate%>" />
	<input type="hidden" name="sf_OrderNum" value="<%=sf_OrderNum%>" />
	<input type="hidden" name="sf_GoodsName" value="<%=sf_GoodsName%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->

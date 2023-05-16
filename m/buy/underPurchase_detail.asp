<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include file="underPurchaseFunc.asp" -->
<%
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)



	MBID1	 = Request("MBID1")
	MBID2	 = Request("MBID2")
	SDATE	 = Request("SDATE")
	EDATE	 = Request("EDATE")

	SELLCODE = Request("SELLCODE")
	sLvl = Request("sLvl")

	PAGE	 = Request("PAGE")
	viewID	 = Request("viewID")
	AJAX_URL = Request("AJAX_URL")

	underType = Right(PreviousURL,1)
	Select Case LCase(underType)
		Case "v"
			UNDER_PURCHASE_LIST_PROC = "HJP_VOTER_PURCHASE_LIST_DETAIL"
			LNG_NO_UNDER_PURCHASE_TEXT = LNG_CS_VOTERPURCHASE_DETAIL_TEXT14
		Case "s"
			UNDER_PURCHASE_LIST_PROC = "HJP_SAVE_PURCHASE_LIST_DETAIL"
			LNG_NO_UNDER_PURCHASE_TEXT = LNG_CS_SPONSPURCHASE_DETAIL_TEXT14
		Case Else
			Response.End
	End Select

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 10

	If IS_LIMIT_LEVEL Then	'대수제한
		sLvl = CS_LIMIT_LEVEL
	End IF

	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,MBID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,4,MBID2),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@SellCode",adVarChar,adParamInput,10,SELLCODE),_
		Db.makeParam("@sLvl",adChar,adParamInput,3,sLvl),_

		Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE),_
		Db.makeParam("@ALL_Count",adInteger,adParamOutput,4,0)_
	)
	arrList = Db.execRsList(UNDER_PURCHASE_LIST_PROC,DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
	<table <%=tableatt%> class="innerTableVote width100">
		<col width="70"/>
		<col width="70"/>
		<col width="" />
		<col width="" />
		<thead>
			<tr>
				<th><%=LNG_TEXT_SALES_DATE%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_TEXT_SALES_PRICE%></th>
				<th rowspan="2"><%=LNG_TEXT_SALES_TYPE%></th>
			</tr>
			<tr>
				<th><%=LNG_TEXT_EXCHANGE%>/<%=LNG_TEXT_RETURN%></th>
				<th class="dv_cell2"><%=LNG_TEXT_NAME%></th>
				<th class="dv_cell2"><%=CS_PV%></span></th>
			</tr>
		</thead>
		<%
			SELLDATE  = ""
			SELLDATE2 = ""
			selldate_bd	  = ""
			If IsArray(arrList) Then
				For i = 0 To listLen
					arr_mbid			= arrList(1,i)
					arr_SellDate		= arrList(2,i)
					arr_mbid2			= arrList(3,i)
					arr_M_name			= arrList(4,i)
					arr_ReturnTF		= arrList(5,i)
					arr_TotalPrice		= arrList(6,i)
					arr_TotalPV			= arrList(7,i)
					arr_SellTypeName	= arrList(8,i)
					arr_InputCash		= arrList(9,i)
					arr_InputCard		= arrList(10,i)
					arr_InputPassbook	= arrList(11,i)
					arr_TotalInputPrice	= arrList(12,i)
					arr_OrderNumber		= arrList(13,i)
					arr_Sell_Mem_TF		= arrList(14,i)
					arr_TotalCV			= arrList(15,i)
					arr_Re_ReturnTF		= arrList(16,i)						'취소/반품 상태코드
					arr_Re_BaseOrderNumber		= arrList(17,i)		'원 주문번호
					arr_Re_SellDate		= arrList(18,i)						'반품주문 : 원 주문의 판매일자로 치환
					arr_RecordTime		= arrList(19,i)
					arr_SellCode		= arrList(20,i)
					arr_lvl		= arrList(21,i)

					'정상주문 이후 반품, 교환, 취소 여부
					mline= ""
					Re_CANCEL_STATUS= ""
					If arr_ReturnTF = "1" And arr_Re_ReturnTF > 1 Then
						Re_CANCEL_STATUS = "("&FN_CANCEL_STATUS(arr_Re_ReturnTF)&")"
						mline= "mline"
					End If

					If arr_TotalPrice < 0 Then
						trc = " class=""trc"""
						arr_SellDate = "<span>"&(arr_SellDate)&"</span>"
					Else
						trc = " "
						arr_SellDate = ""
					End If

					'판매일자
					SELLDATE = arr_Re_SellDate
					If SELLDATE <> SELLDATE2 Then
						SELLDATE = (arr_Re_SellDate)
						d_style = "selldate-bd-top"
					Else
						SELLDATE  = ""
						d_style = ""
					End If

					SELLDATE2 = arr_Re_SellDate

		%>
		<tr <%=trc%> >
			<td class="tcenter"><%=SELLDATE%></td>
			<td class="tcenter"><%=arr_mbid%>-<%=Fn_MBID2(arr_mbid2)%></td>
			<td class="tright price bd1"><span class="<%=mline%>"><%=num2cur(arr_TotalPrice)%></span>
			<td class="tcenter" rowspan="2"><%=arr_SellTypeName%></td>
		</tr>
		<tr>
			<td><%=arr_SellDate%></td>
			<td class="tcenter dv_cell2"><%=arr_M_name%><!-- (<%=FN_SELL_MEM_TF(arr_Sell_Mem_TF)%>) --></td>
			<td class="tright dv_cell2"><%=num2cur(arr_TotalPV)%></td>
		</tr>
		<%
				Next
		%>
	</table>
	<div class="pagingArea pagingNew3 underdetail"><%Call pageList_underPurchaseMob5N(PAGE,PAGECOUNT,MBID1,MBID2,SDATE,EDATE,SELLCODE,sLvl,viewID,AJAX_URL)%></div>
		<%
			Else
		%>
		<tr>
			<td colspan="7" class="tcenter tweight bd1" style="height:100px;"><%=LNG_NO_UNDER_PURCHASE_TEXT%></td>
		</tr>
	</table>
		<%
			End If
		%>

<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include file="payFunc.asp" --> 	<%'←sticky-wrap (css + jquery) %>
<%

	MODES = Request("MODES")
	EDATE = Request("EDATE")
	PAGE = Request("PAGE")
	viewID = Request("viewID")
	AJAX_URL = Request("AJAX_URL")

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 8


	SORTORDER1 = MODES



	PROCEDURE_NAME = "DKPS_CS_PRICE01_DETAIL_NEW"

	Select Case MODES
		Case "1"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_1
		Case "2"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_2
		Case "3"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_3
		Case "4"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_4
		Case "5"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_5
		Case "6"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_6
		Case "7"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_7
		Case "8"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_8
		Case "9"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS01_9
	End Select

	' print EDATE
	' print SORTORDER1

	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@SORTORDER1",adVarChar,adParamInput,10,SORTORDER1),_
		Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE),_
		Db.makeParam("@ALL_Count",adInteger,adParamOutput,4,0)_
	)
	arrList = Db.execRsList(PROCEDURE_NAME,DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<p class="titles tleft"><%=TABLE_TITLE%></p>
<div class="width100 sticky-wrap">
	<table <%=tableatt%> class="inTable2 width100">
		<thead>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_PAY_PRICE%></th>
				<th><%=LNG_TEXT_LEVEL%></th>
				<th><%=LNG_TEXT_LINE%></th>
			</tr>
		</thead>
		<tbody>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_ROWNUM			= arrList(0,i)
					arrList_RequestMbid			= arrList(1,i)
					arrList_RequestMbid2			= arrList(2,i)
					arrList_RequestName				= arrList(3,i)
					arrList_DownPV		= arrList(4,i)
					arrList_LevelCnt			= arrList(5,i)
					arrList_LineCnt			= arrList(6,i)
					arrList_GivePay			= arrList(7,i)
		%>
			<tr>
				<td class="index"><%=arrList_ROWNUM%></td>
				<td><%=arrList_RequestMbid%>-<%=arrList_RequestMbid2%></td>
				<td class="name"><%=arrList_RequestName%></td>
				<td class="tright amount"><%=num2cur(arrList_DownPV)%></td>
				<td><%=arrList_LevelCnt%></td>
				<td><%=arrList_LineCnt%></td>
			</tr>
		<%
				Next
			Else
		%>
			<tr>
				<td colspan="6" class="nodata"><p><%=LNG_TEXT_NO_DATA%></p></td>
			</tr>
		<%
			End If
		%>
		</tbody>
	</table>
</div>
<%If IsArray(arrList) Then %>
	<div class="pay_paging pagingNew3"><%Call pageList_pay(PAGE,PAGECOUNT,MODES,EDATE,viewID,AJAX_URL)%></div>
<%End If%>

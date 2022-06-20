<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include file="payFunc.asp" -->
<%

	MODES = Request("MODES")
	EDATE = Request("EDATE")
	PAGE = Request("PAGE")
	viewID = Request("viewID")
	AJAX_URL = Request("AJAX_URL")


	TABLE_TITLE = LNG_TEXT_TOTAL_SALES_OF_UNDER_MEMBER

' print DK_MEMBER_ID1
' print DK_MEMBER_ID2
' print EDATE
' print SORTORDER1


	SQL = ""
	SQL = SQL & "Select Cur_PV_1, Cur_PV_2 ,Be_PV_1, Be_PV_2 ,Sum_PV_1, Sum_PV_2 ,Ded_1, Ded_2 ,Fresh_1, Fresh_2 ,Regtime, '', '' "
	SQL = SQL & " From  tbl_ClosePay_02_Mod (nolock) "
	SQL = SQL & "  Where Mbid = ? "
	SQL = SQL & "  And Mbid2 = ? "
	SQL = SQL & "  And ToEndDate = ? "

	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_Cur_PV_1	 = DKRS("Cur_PV_1")
		DKRS_Cur_PV_2	 = DKRS("Cur_PV_2")
		DKRS_Be_PV_1	 = DKRS("Be_PV_1")
		DKRS_Be_PV_2	 = DKRS("Be_PV_2")
		DKRS_Sum_PV_1	 = DKRS("Sum_PV_1")
		DKRS_Sum_PV_2	 = DKRS("Sum_PV_2")
		DKRS_Ded_1		 = DKRS("Ded_1")
		DKRS_Ded_2		 = DKRS("Ded_2")
		DKRS_Fresh_1	 = DKRS("Fresh_1")
		DKRS_Fresh_2	 = DKRS("Fresh_2")
		DKRS_Regtime	 = DKRS("Regtime")
	Else
		DKRS_Cur_PV_1	 = 0
		DKRS_Cur_PV_2	 = 0
		DKRS_Be_PV_1	 = 0
		DKRS_Be_PV_2	 = 0
		DKRS_Sum_PV_1	 = 0
		DKRS_Sum_PV_2	 = 0
		DKRS_Ded_1		 = 0
		DKRS_Ded_2		 = 0
		DKRS_Fresh_1	 = 0
		DKRS_Fresh_2	 = 0
		DKRS_Regtime	 = ""
	End If

%>

<div class="pay_inDivWrap width100">
	<table <%=tableatt%> class="inTable2 width100">
		<colgroup>
			<col width="<%=colwidth1%>" />
			<col width="<%=colwidth2%>" />
			<col width="<%=colwidth3%>" />

		</colgroup>
		<tr>
			<th class="title" colspan="3"><%=TABLE_TITLE%></th>
		</tr><tr>
			<th class="title"></th>
			<th class="title"><%=LNG_TEXT_PAY_LINE1%></th>
			<th class="title"><%=LNG_TEXT_PAY_LINE2%></th>
		</tr><tr>
			<th class="title"><%=LNG_TEXT_PAY_PREVIOUS%></th>
			<td class="f12"><%=num2cur(DKRS_Be_PV_1)%></td>
			<td class="f12"><%=num2cur(DKRS_Be_PV_2)%></td>
		</tr><tr>
			<th class="title"><%=LNG_TEXT_PAY_DEADLINE%></th>
			<td class="f12"><%=num2cur(DKRS_Cur_PV_1)%></td>
			<td class="f12"><%=num2cur(DKRS_Cur_PV_2)%></td>
		</tr><tr>
			<th class="title"><%=LNG_TEXT_PAY_DEDUCTIONS%></th>
			<td class="f12"><%=num2cur(DKRS_Ded_1)%></td>
			<td class="f12"><%=num2cur(DKRS_Ded_2)%></td>
		</tr><tr>
			<th class="title"><%=LNG_TEXT_PAY_BALANCE%></th>
			<td class="f12"><%=num2cur(DKRS_Fresh_1)%></td>
			<td class="f12"><%=num2cur(DKRS_Fresh_2)%></td>
		</tr><tr>
			<th class="title"><%=LNG_TEXT_PAY_CARRIED_FORWARD%></th>
			<td class="f12"><%=num2cur(DKRS_Sum_PV_1)%></td>
			<td class="f12"><%=num2cur(DKRS_Sum_PV_2)%></td>
		</tr>
	</table>


</div>
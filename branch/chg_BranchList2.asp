<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%><%

	Session.CodePage = 65001
	Response.CharSet = "utf-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	BranchCode = gRequestTF("code",False)


	If BranchCode = "" Then BranchCode = "000"
	Dim SEARCHSTR, PAGE, PAGESIZE
		SEARCHSTR = gRequestTF("searchs",False)
		PAGE = gRequestTF("page",False)
		PAGESIZE = 10

	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
' ===================================================================


' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _

		Db.makeParam("@cateCode",adVarChar,adParamInput,20,BranchCode), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_BRANCH2_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


%>
			<table <%=tableatt%> class="userCWidth2">
				<col width="150" />
				<col width="140" />
				<col width="300" />
				<col width="130" />
				<tr>
					<th>지역</th>
					<th>로드샵명</th>
					<th>연락처/주소</th>
					<th>보기</th>
				</tr>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen

				%>
				<tr>
					<td rowspan="2"><%=arrList(2,i)%></td>
					<td rowspan="2"><%=arrList(3,i)%></td>
					<td><%=arrList(8,i)%></td>
					<td rowspan="2"><%=aImg("javascript:popBranch2('"&arrList(1,i)&"')","./images/btn_branchView.jpg",83,40,"")%></td>
				</tr><tr>
					<td><%=arrList(5,i)%>&nbsp;<%=arrList(6,i)%></td>
				</tr>

				<%
						Next
					Else
				%>
				<tr>
					<td colspan="4" class="notData">해당 지역에 등록된 로드샵이 없습니다</td>
				</tr>
				<%
					End If
				%>
			</table>
			<div class="pageArea2"><%Call pageList3(page,PAGECOUNT,BranchCode,"","")%></div>

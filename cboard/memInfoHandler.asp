<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%



	idx = pRequestTF("idx",True)
	mode = pRequestTF("MODE",True)


	If DK_MEMBER_TYPE <> "ADMIN" Then
%>

<table <%=tableatt%> class="ajaxMemInfo">
	<tr>
		<td class="notData">관리자 전용메뉴입니다.</td>
	</tr>
</table>
<%
		RESPONSE.End
	End If

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,idx), _
		Db.makeParam("@MODE",adVarChar,adParamInput,10,mode), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,10,DK_MEMBER_ID), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_NBOARD_HANDLER",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "GUEST"	: Call ALERTS("손님그룹(GUEST)은 차단할 수 없습니다.","GO","/hiddens.asp")
		Case "ADMIN"	: Call ALERTS("관리자그룹(ADMIN)은 차단할 수 없습니다.","GO","/hiddens.asp")
		Case "OPERATOR" : Call ALERTS("오퍼레이터그룹(OPERATOR)은 차단할 수 없습니다.","GO","/hiddens.asp")
		Case "FINISH"	: Call ALERTS("정상처리되었습니다..","GO","/hiddens.asp")
		Case "ERROR"	: Call ALERTS("에러가 발생하였습니다. 지속적인 에러 발생시 개발팀에 문의해주세요","GO","/hiddens.asp")
		Case Else		: Call ALERTS("예외값이 발생하였습니다.지속적인 에러 발생시 개발팀에 문의해주세요.","GO","/hiddens.asp")
	End Select




%>

<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	idx = gRequestTF("idx",True)


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


'	print idx


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,idx) _
	)
	Set DKRS = Db.execRs("DKP_NBOARD_MEMINFO",DB_PROC,arrParams,Nothing)


	isDataTrue = "F"
	If Not DKRS.BOF And Not DKRS.EOF Then
		isDataTrue = "T"
		DKRS_intIDX			= DKRS("intIDX")
		DKRS_strUserID		= DKRS("strUserID")
		DKRS_HostIP			= DKRS("HostIP")
	End If
%>
<table <%=tableatt%> class="ajaxMemInfo">
<%If isDataTrue = "T" Then%>
	<col width="60" />
	<col width="" />
	<col width="40" />
	<tr>
		<td class="th tcenter">작성자</td>
		<td class="con"><%=DKRS_strUserID%></td>
		<td class="tcenter">[<a href="javascript:idBlock(<%=idx%>);">차단</a>]</td>
	</tr><tr>
		<td class="th tcenter">IP</td>
		<td class="con"><%=DKRS_HostIP%></td>
		<td class="tcenter">[<a href="javascript:ipBlock(<%=idx%>);">차단</a>]</td>
	</tr><tr>
		<td class="tcenter" colspan="3"></td>
	</tr>
<%Else%>
	<tr>
		<td class="notData">삭제된 게시물입니다.</td>
	</tr>
<%End If%>
</table>

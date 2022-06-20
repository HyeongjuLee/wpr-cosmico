<!--#include virtual = "/_lib/strFunc.asp"-->
<%

'	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"



	cate1 = Request("cate1")
	cate2 = Request("cate2")



'	print CATEGORY
'	PRINT cate1
'	PRINT cate2


	SQL = "SELECT [strCateCode],[strCateNameKor] FROM [DK_CATEGORY]"
	SQL = SQL & " WHERE [strCateParent] = ? AND [intCateDepth] = ?"
	SQL = SQL & " AND [isView] = 'T'"
	SQL = SQL & " ORDER BY [intCateSort] ASC"


	arrParams = Array(_
		Db.makeParam("@strCateParent",adVarChar,adParamInput,20,cate1), _
		Db.makeParam("@intCateDepth",adInteger,adParamInput,4,2) _
	)
	arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)


	If IsArray(arrList) Then
%>
	<select id="cate2" name="cate2" class="select20">
		<option value="">선택해주세요</option>
<%		For i = 0 To listLen%>
		<option value="<%=arrList(0,i)%>"><%=arrList(1,i)%></option>
<%		Next%>
	</select>
<%	Else%>
	<select id="cate2" name="cate2" class="select20" disabled="disabled">
		<option value="">하위 메뉴가 없음</option>
	</select>

<%
	End If


%>
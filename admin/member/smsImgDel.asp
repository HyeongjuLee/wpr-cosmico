<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"

	If DK_MEMBER_TYPE <> "ADMIN" Then
		PRINT "{""result"" : ""error"", ""resultMsg"" : ""권한이 없습니다. 다시 로그인 후 이용 바랍니다.""}"
		Response.End
	End If

	'smsContent = Request.Form("smsContent")
	strCate = Request.Form("strCate")
	strImg = Request.Form("strImg")

	isJsonPage = "T"
%>
<!--#include file = "smsCONFIG.asp"-->
<%

	'파일삭제
	If strImg <> "" Then
		Call sbDeleteFiles(REAL_PATH("MMS_O")&"\"&backword(strImg))
		Call sbDeleteFiles(REAL_PATH("MMS_T")&"\"&backword(strImg))
	End If

	SELECT_SQL = " SELECT * FROM DK_SMS_CONTENT WHERE delTF = 'F' AND strCate = ? "
	arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
	Set DKRS = Db.execRs(SELECT_SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.EOF And Not DKRS.BOF Then
		'strImg  r공백처리
		UPDATE_SQL = " UPDATE DK_SMS_CONTENT SET [strImg] = '' WHERE delTF = 'F' "
		UPDATE_SQL = UPDATE_SQL & " AND strCate = ? "
		arrParams = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
		Call Db.exec(UPDATE_SQL,DB_TEXT,arrParams,DB3)
	End If
	Call CloseRS(DKRS)


	PRINT "{""result"" : ""success"", ""resultMsg"" : ""처리되었습니다.""}"
	Response.End
%>

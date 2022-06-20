<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp"-->
<%
'한글 깨짐방지

	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"

	If DK_MEMBER_TYPE <> "ADMIN" Then
		PRINT "{""result"" : ""error"", ""resultMsg"" : ""권한이 없습니다. 다시 로그인 후 이용 바랍니다.""}"
		Response.End
	End If

	SELECT_SQL = " SELECT smsContent FROM DK_SMS_CONTENT WHERE delTF = 'F' "
	Set DKRS = Db.execRs(SELECT_SQL,DB_TEXT,Nothing,DB3)

	If Not DKRS.EOF And Not DKRS.BOF Then '데이터 있으면 기존 꺼 삭제 후 INSERT
		smsContent = DKRS("smsContent")
	Else
		smsContent = ""
	End If

	PRINT "{""result"" : ""success"", ""resultMsg"" : """&smsContent&"""}"
	Response.End
%>

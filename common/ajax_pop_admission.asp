<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'상품입점신청

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strMobile	= pRequestTF_JSON("strMobile",True)
	strEmail = pRequestTF_JSON("strEmail",True)
	strSubject = pRequestTF_JSON("strSubject",True)
	strContent = pRequestTF_JSON("strContent",True)


	emailTitle = LNG_BOTTOM_GOODS &"-"& strSubject

	emailContent = ""
	emailContent = emailContent & "<p> 연락처 : "&strMobile&"</p>"
	emailContent = emailContent & "<p> 이메일 : "&strEmail&"</p>"
	emailContent = emailContent & "<p> 제목 : "&strSubject&"</p>"
	emailContent = emailContent & "<p><br />"&strContent&"</p>"

	'CALL SendMail(SMTP_SENDUSERNAME, emailTitle, emailContent)
	Message =  LNG_BOTTOM_GOODS&"\n" & SendMail(SMTP_SENDUSERNAME, emailTitle, emailContent)

	PRINT "{""result"":""success"", ""message"":"""&Message&"""}"
	Response.End

%>

<%
	Dim svrsoft
	
	svrsoft = Request.ServerVariables("server_software")
%>
[1. SERVER INFO]</br>
SERVER_SOFTWARE [<%=svrsoft%>]</br>
[2. URL TEST]</br>
<%
	Dim fdktesturl, fdkrealurl, testoutdata

	fdktesturl = "https://testicfs.firstdatacorp.co.kr/main.do"		'FDK URL(TEST)
%>
TLS/SSL CONNECT TEST START</br>
TLS/SSL CONNECT TEST SITE URL [<%=fdktesturl%>]</br>
<%
	testoutdata = sendHttps(fdktesturl)
%>
TLS/SSL CONNECT TEST RESULT[<%=testoutdata%>]</br>
TLS/SSL CONNECT TEST END</br>
<%
Function sendHttps(sUrl)

		Dim xmlHttp, dataStream, reqData, resData

		reqData = "test"

		Set xmlHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
		xmlHttp.SetClientCertificate("LOCAL_MACHINE\My\MyCertificate")
		xmlHttp.open "POST", sUrl, FALSE
		xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		xmlHttp.send reqData
	
	
		resData = Cstr( xmlHttp.responseText )
		
		Set xmlHttp = nothing

		If Instr(resData,"First Data") <> 0 Then
			resData = "SUCCESS"
		End If

		sendHttps = resData
End Function
%>
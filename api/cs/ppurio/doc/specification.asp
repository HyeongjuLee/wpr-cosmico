<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'https://www.metac21g.com/api/cs/ppurio/doc/specification

	ORIGINAL_URL = Request.ServerVariables("HTTP_X_ORIGINAL_URL")

	'확장자의 '.' 없는 형태만 OK
	If InStr(ORIGINAL_URL,".") > 0 Then
		Response.Status = "404 page not found"
		Response.End
	End If

	Response.Redirect "https://documenter.getpostman.com/view/6370513/UyrGCaN5"		'메타21base 2022-05-02 ~ 2022-05-03
%>

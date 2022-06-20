<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Response.Cookies("mobileCheck") = "OK"
	'Response.redirect(HTTPS&"://"&"www."&MAIN_DOMAIN)
	Response.redirect(HTTPS&"://"&MAIN_DOMAIN)
%>

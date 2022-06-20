<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual="/PG/NICEPAY/NICEPAY_FUNCTION.ASP"-->
<!--#include virtual="/_lib/MD5.asp" -->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	'나이스페이 금액 변동시 처리
	Amt		= pRequestTF("Amt",True)
	EdiDate = pRequestTF("EdiDate",True)

	'[Webpro] MD5 SHA256
	Set XTEncrypt = new XTclsEncrypt
		hashString  =  XTEncrypt.SHA256(EdiDate & NICE_merchantID & Amt & NICE_merchantKey)
	Set XTEncrypt = nothing
	'[Webpro] MD5 SHA256


	PRINT  hashString


	'PRINT "<br /><input type=""hidden "" name=""EncryptData""  value="""&Left(hashString,100)&""" readonly=""readonly"" />"

	Response.End
%>

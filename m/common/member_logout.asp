<!--#include virtual="/_lib/strFunc.asp" -->
<%
	Response.Expires = -1
	BackUrl = Request.ServerVariables("HTTP_REFERER")


	If isCOOKIES_TYPE_LOGIN = "T" Then		'COOKIE방식

		'쿠키 초기화
		Response.Cookies(COOKIES_NAME).path = "/"
		Response.Cookies(COOKIES_NAME)("DKMEMBERID") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERNAME") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERLEVEL") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERTYPE") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERID1") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERID2") = ""
		Response.Cookies(COOKIES_NAME)("DKMEMBERWEBID") = ""
		Response.Cookies(COOKIES_NAME)("DKBUSINESSCNT") = ""
		Response.Cookies(COOKIES_NAME)("DKCSMEMTYPE") = ""
		Response.Cookies(COOKIES_NAME)("DKCSNATIONCODE") = ""
		Response.Cookies(COOKIES_NAME)("DK_MEMBER_VOTER_ID") = ""

		Response.Cookies(COOKIES_NAME)("DKMEMBERLNGCODE") = ""
		'Response.Cookies(COOKIES_NAME).Domain = "."&SITEURL

	Else	'SESSION방식

		'세션 초기화
		SESSION("DK_MEMBER_ID")			= Null
		SESSION("DK_MEMBER_NAME")		= Null
		SESSION("DK_MEMBER_LEVEL")		= Null
		SESSION("DK_MEMBER_TYPE")		= Null
		SESSION("DK_MEMBER_ID1")		= Null
		SESSION("DK_MEMBER_ID2")		= Null
		SESSION("DK_MEMBER_WEBID")		= Null
		SESSION("DK_BUSINESS_CNT")		= Null
		SESSION("DK_MEMBER_STYPE")		= Null
		SESSION("DK_MEMBER_NATIONCODE")	= Null
		SESSION("DK_MEMBER_VOTER_ID")	= Null

		SESSION("DK_MEMBER_DOMAIN")		= Null
	End If






	'변수 초기화
		DK_MEMBER_ID	 = ""
		DK_MEMBER_NAME	 =  ""
		DK_MEMBER_LEVEL	 =  ""
		DK_MEMBER_TYPE	 =  ""
		DK_MEMBER_ID1	 =  ""
		DK_MEMBER_ID2	 =  ""
		DK_MEMBER_WEBID	 =  ""
		DK_BUSINESS_CNT  =  ""
		DK_MEMBER_STYPE  =  ""
		DK_MEMBER_NATIONCODE = ""
		DK_MEMBER_VOTER_ID = ""

		DK_MEMBER_LNG_CODE = ""

		'Response.Cookies("ILOVEKT") = ""
		'Response.Cookies("ilove").Domain = ".ilovekt.co.kr"
		'Response.Cookies("ilove")("DKMEMBERID") = ""
		'Response.Cookies("ilove")("DKMEMBERNAME") = ""
		'Response.Cookies("ilove")("DKMEMBERLEVEL") = ""
		'Response.Cookies("ilove")("DKMEMBERTYPE") = ""
		'Response.Cookies("ilove")("DKMEMBERDOMAIN") = ""




	If BackUrl = "" Then
		'Response.Redirect "/index.asp"
		Call alerts(LNG_MEMBER_LOGOUT_ALERT01,"go","/m/index.asp")
	Else
		'Response.Redirect "/index.asp"
		Call alerts(LNG_MEMBER_LOGOUT_ALERT01,"go","/m/index.asp")
	End If

	Response.End


%>

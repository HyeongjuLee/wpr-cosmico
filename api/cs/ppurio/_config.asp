<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
	'If webproIP <> "T" Then Call WRONG_ACCESS()

	ORIGINAL_URL = Request.ServerVariables("HTTP_X_ORIGINAL_URL")

	'확장자의 '.' 없는 형태만 OK
	'/api/cs/ppurio/join.asp			NO
	'/api/cs/ppurio/join.somthing	NO
	'/api/cs/ppurio/join					OK
	If InStr(ORIGINAL_URL,".") > 0 Then
		Response.Status = "404 page not found"
		Response.End
	End If


	'### API 형식 설정 ###
	SET_REQUEST_METHOD				= "POST"
	'SET_CONTENT_TYPE					= "application/json"
	SET_CONTENT_TYPE					= "application/x-www-form-urlencoded"
	'SET_CONTENT_TYPE_CHARSET	= "charset=utf-8"

	'SET_APIKEY = LCase(SHA256_Encrypt(BASE64_Encrypt("")))			'뿌리오  API key
	'SET_APIKEY = LCase(SHA256_Encrypt(("")))										'뿌리오  API key

	'### API Basic Infos ###
	REQUEST_METHOD					= Replace(Request.ServerVariables("REQUEST_METHOD")," ","")
	CHEADER_CONTENT_TYPE		= Replace(Request.ServerVariables("HTTP_CONTENT_TYPE")," ","")
	CHEADER_AUTHORIZATION		= Replace(Request.ServerVariables("HTTP_AUTHORIZATION")," ","")
	CHEADER_CONTENT					= Replace(Request.ServerVariables("HTTP_CONTENT")," ","")
	CHEADER_ACCEPT_LANGUAGE	= Replace(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")," ","")
	CHEADER_CHARSET					= Replace(Request.ServerVariables("HTTP_CHARSET")," ","")
	CHEADER_HTTP_APIKEY			= Replace(Request.ServerVariables("HTTP_APIKEY")," ","")
	CHEADER_HTTP_APIKEY			= Replace(Request.ServerVariables("HTTP_APIKEY")," ","")				'HTTP_ = HEADER_

	'HA ~ HE 로 시작하는 헤더변수 에러발생(예약어???)  	'0x800A0401 문장의 끝이 필요합니다
	'HG ~이후로는 정상처리 O

	'400 에러 체크
	'REQUEST_METHOD and Header 정보
	If UCase(SET_REQUEST_METHOD) <> UCase(REQUEST_METHOD) Then
		Response.Status = "'400' Bad Request"		'Status 강제로 0으로 만들어주기!!
		'PRINT "{""result"" : ""error"", ""resultmsg"" : ""different request method""}" : Response.End
	End If
	If InStr(LCase(CHEADER_CONTENT_TYPE), SET_CONTENT_TYPE) = 0 Then
		Response.Status = "'400' Bad Request"
		'PRINT "{""result"" : ""error"", ""resultmsg"" : ""wrong Content-Type""}" : Response.End
	End If
	'If InStr(LCase(CHEADER_CONTENT_TYPE), SET_CONTENT_TYPE_CHARSET) = 0 Then
	'	Response.Status = "'400' Bad Request"
	'	PRINT "{""result"" : ""error"", ""resultmsg"" : ""wrong Content-Type charset""}" : Response.End
	'End If

	'If CHEADER_HTTP_APIKEY <> SET_APIKEY Then
	'	PRINT "{""result"" : ""error"", ""resultmsg"" : ""invalid key""}" : Response.End
	'End If

%>
<%
'	'********* CS TEST 설정	'테스트 완료 후 주석처리!!!!!  *********
'		PPURIO_MODE = "TEST"		'slave account
'		'PPURIO_MODE = "REAL"		'master account
'		Select Case PPURIO_MODE
'			Case "TEST"
'				PPURIO_URL = "https://dev-api.bizppurio.com"
'				PPURIO_ID = "metac21g_dev"
'				PPURIO_base64 = PPURIO_ID&":metac21g!com"
'			Case "REAL"
'				PPURIO_URL = "https://api.bizppurio.com"
'				PPURIO_ID = "metac21g"
'				PPURIO_base64 = PPURIO_ID&":metac21g.com"
'			Case Else
'		End Select
'		MSG_strComName	= PPURIO_ID					'문자전송ID()
'
'	'********* CS TEST 설정	'테스트 완료 후 주석처리!!!!!  *********
%>

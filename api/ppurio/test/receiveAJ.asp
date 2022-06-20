<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	'API JSON 응답 테스트

	'### API 형식 설정 ###
	SET_REQUEST_METHOD				= "POST"
	SET_CONTENT_TYPE					= "application/json"												' "application/json"  "application/x-www-form-urlencoded"
	'SET_CONTENT_TYPE					= "application/x-www-form-urlencoded"					' "application/json"  "application/x-www-form-urlencoded"
	SET_CONTENT_TYPE_CHARSET	= "charset=utf-8"		' "charset=utf-8"		""


	ORIGINAL_URL = Request.ServerVariables("HTTP_X_ORIGINAL_URL")
	'print ORIGINAL_URL

	'확장자의 '.' 없는 형태만 OK
	If InStr(ORIGINAL_URL,".") > 0 Then
		'/api/ppurio/test/receiveAJ.asp

		'Response.Status = "404"
		Response.Status = "500"
		Response.End
	End If

	'/api/ppurio/test/receiveAJ
	'OK



%>
<%
	'### API Basic Infos ###
	'For Each strKey In Request.ServerVariables
	'	Response.write "" & strKey & vbCrLf
	'	Response.write " = " & Request.ServerVariables(strKey) & vbCrLf &"<br />"
	'Next
	REQUEST_METHOD					= Replace(Request.ServerVariables("REQUEST_METHOD")," ","")				'POST
	CHEADER_CONTENT_TYPE		= Replace(Request.ServerVariables("HTTP_CONTENT_TYPE")," ","")		'.setRequestHeader "Content-Type"			application/json; charset=utf-8
	CHEADER_AUTHORIZATION		= Replace(Request.ServerVariables("HTTP_AUTHORIZATION")," ","")		'.setRequestHeader "Authorization"
	CHEADER_CONTENT					= Replace(Request.ServerVariables("HTTP_CONTENT")," ","")					'.setRequestHeader "Content"
	CHEADER_ACCEPT_LANGUAGE	= Replace(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")," ","")	'.setRequestHeader "Accept-Language"
	CHEADER_CHARSET					= Replace(Request.ServerVariables("HTTP_CHARSET")," ","")					'.setRequestHeader "CharSet"


	'https://www.l2go.co.kr/API/regMember.asp 헤더값 테스트
	'AuthTime = Request.ServerVariables("HTTP_AuthTime")
	'AuthToken = Request.ServerVariables("HTTP_AuthToken")
	'print AuthTime
	'print AuthToken

	'400 에러 체크
	'REQUEST_METHOD and Header 정보
	If UCase(SET_REQUEST_METHOD) <> UCase(REQUEST_METHOD) Then
		'Response.Status = "400"
		Response.Status = "'400' Bad Request"		'Status 강제로 0으로 만들어주기!!
		PRINT "{""result"":""error"",""code"":""2000"",""description"":""different request method""}" : Response.End
	End If
	If InStr(LCase(CHEADER_CONTENT_TYPE), SET_CONTENT_TYPE) = 0 Then
		Response.Status = "'400' Bad Request"
		PRINT	"{""result"":""error"",""code"":""2001"",""description"":""wrong Content-Type""}" : Response.End
	End If
	If InStr(LCase(CHEADER_CONTENT_TYPE), SET_CONTENT_TYPE_CHARSET) = 0 Then
		Response.Status = "'400' Bad Request"
		PRINT	"{""result"":""error"",""code"":""2002"",""description"":""wrong Content-Type charset""}" : Response.End
	End If
%>
<%

	Select Case LCase(SET_CONTENT_TYPE)

		Case "application/x-www-form-urlencoded"
			r_account	= Request.form("account")
			r_type		= Request.form("refkey")
			r_type		= Request.form("type")
			r_from		= Request.form("from")
			r_content_sms_message = Request.form("message")

			tMessageResponse =  "{""result"":""success"""",""code"":1000,""description"":""success"",""refkey"":"""&r_content_sms_message&"""}"

		Case "application/json"

			If Request.TotalBytes > 0 Then
				Dim lngBytesCount, jsonText
				lngBytesCount = Request.TotalBytes

				jsonText = BytesToStr(Request.BinaryRead(lngBytesCount))
				Response.Clear

				'Response.end

				'Response.write jsonText  ' --> 결과물 : "{"user_id":"testid"}"
				Dim json_message : Set json_message = JSON.parse(join(array(jsonText)))


				On Error Resume Next
					CardLogss = "/API/ppurio/receiveResult"
					Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
					Dim LogPath : LogPath = Server.MapPath (CardLogss&"/rA_") & Replace(Date(),"-","") & ".log"
					Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

					Sfile.WriteLine chr(13)
					Sfile.WriteLine "Date			: "	& now()
					Sfile.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
					Sfile.WriteLine "=== Order Info ============================="
					Sfile.WriteLine "jsonText	: " & jsonText
					Sfile.WriteLine "json_message.account	: " & json_message.account
					Sfile.WriteLine "json_message.refkey	: " & json_message.refkey
					Sfile.WriteLine "============================================="

					Sfile.Close
					Set Fso= Nothing
					Set objError= Nothing
				On Error GoTo 0

				On Error Resume Next  ' try
					'결과 코드
					r_account	= json_message.account
					r_refkey	= json_message.refkey
					r_type	= json_message.type
					r_from	= json_message.from
					r_content_sms_message	= json_message.content.sms.message

					If Err.Number = 0 Then  ' catch
						'Response.write r_content  ' --> 결과물 : "{"user_id":"testid"}"

						Dim JsonObj
						Set JsonObj = jsObject()

						If r_account = "appJson_dev" Then
							'JsonObj("code") = "1000"
							'JsonObj("description") = "success"
							'JsonObj("refkey") = Err.Number
							'JsonObj("messagekey") = "220413091751212sms031717meta1UiK"
							'tMessageResponse = toJSON(JsonObj)

							tMessageResponse = "{""result"":""success"",""code"":1000,""description"":""success""}"
						Else
							tMessageResponse = "{""result"":""error"",""code"":2222,""description"":""error2222""}"
						End If
					Else
							tMessageResponse = "{""result"":""error"",""code"":"""&Err.Number&""",""description"":""error""}"
					End If



				On Error GoTo 0
			Else
				Response.Status = "'400' Bad Request"		'Status 강제로 0으로 만들어주기!!
				PRINT "{""result"":""error"",""code"":""9999"",""description"":""No Json Text""}" : Response.End
			End if

	End Select

	Response.Write tMessageResponse
	Response.End


%>
<%
	Function BytesToStr(bytes)
		Dim Stream
		Set Stream = Server.CreateObject("Adodb.Stream")
		Stream.Type = 1 'adTypeBinary
		Stream.Open
		Stream.Write bytes
		Stream.Position = 0
		Stream.Type = 2 'adTypeText
		Stream.Charset = "UTF-8"
		BytesToStr = Stream.ReadText
		Stream.Close
		Set Stream = Nothing
	End Function
%>

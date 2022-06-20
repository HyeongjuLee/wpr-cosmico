<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	'Json 형식!!!!	가독성
	If webproIP <> "T" Then Call WRONG_ACCESS()

	'Session.CodePage = 65001
	'Response.CharSet = "UTF-8"

	'https://www.metac21g.com//API\ppurio\sample\send1.asp
	'https://www.base64encode.org/

	'	/v1/token 			POST 인증 토 큰 을 발급 을 요청하는 기능입니다
	'	/v3/message 		POST 메시지 전송을 요청하는 기능입니다
	'	/v1/file 				POST MMS 발송에 사용될 이미지 파일을 업로드하는 기능입니다
	'	/v2/report 			POST 전송 결과 재 요청하는 기능입니다

	'https://metac21global.w-pro.kr/api/ppurio/test/send1.asp

	'https://dev-api.bizppurio.com/v1/token
	'https://dev-api.bizppurio.com/v3/message
	'https://dev-api.bizppurio.com/v1/file
	'https://dev-api.bizppurio.com/v2/report

	PPURIO_MODE = "TEST"
	'PPURIO_MODE = "REAL"

	'Slave	metac21
	'Slave	metac21test
	'Slave	metac21g_dev

	'로컬에서는 XXX 		'127.0.0.1 400 {"code":3010,"description":"ip blocking in bizppurio"} ERRRR			등록된 접속허용 아이피 아님
	Select Case PPURIO_MODE
		Case "TEST"
			PPURIO_URL = "https://dev-api.bizppurio.com"
		'	PPURIO_ID = "metac21"
		'	base64 = PPURIO_ID&":metac21g.com"
			PPURIO_ID = "metac21g_dev"
			base64 = PPURIO_ID&":metac21g!com"
		Case "REAL"
			PPURIO_URL = "https://api.bizppurio.com"
			PPURIO_ID = "metac21g"
			base64 = PPURIO_ID&":metac21g.com"
		Case Else
			'Call WRONG_ACCESS()
	End Select

	PPURIO_TOKEN_URL = PPURIO_URL&"/v1/token"
	PPURIO_MESSAGE_URL = PPURIO_URL&"/v3/message"
	PPURIO_FILE_URL = PPURIO_URL&"/v1/file"
	PPURIO_REPORT_URL = PPURIO_URL&"/v2/report"

	PPURIO_BASE64_AUTH = BASE64_Encrypt(base64)

	Call ResRW(PPURIO_MODE,"PPURIO_MODE")
	Call ResRW(base64,"base64")
	Call ResRW2(PPURIO_BASE64_AUTH,"PPURIO_BASE64_AUTH")

	'# /v1/token 			POST 인증 토 큰 을 발급 을 요청하는 기능입니다 ############################## S
	'# https://dev-api.bizppurio.com/v1/token
		PPURIO_TOCKEN_AUTH = "Basic "&PPURIO_BASE64_AUTH
		Call ResRW(PPURIO_TOKEN_URL,"PPURIO_TOKEN_URL")
		Call ResRW(PPURIO_TOCKEN_AUTH,"PPURIO_TOCKEN_AUTH")

		Set pToken = Server.CreateObject("Msxml2.ServerXMLHTTP")
			'Request
			pToken.open "POST", PPURIO_TOKEN_URL, False
			pToken.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
			pToken.setRequestHeader "Authorization", PPURIO_TOCKEN_AUTH
			pToken.send ("")
			'Response
			pTokenResponse = pToken.responseText
			pTokenStatus = pToken.status

			Call ResRW(pTokenResponse,"pTokenResponse")
			Call ResRW2(pTokenStatus,"pTokenStatus")
		Set pToken = Nothing	'개체 소멸

		Dim json_token : Set json_token = JSON.parse(join(array(pTokenResponse)))

		Select Case pTokenStatus
			Case "200"
				r_accesstoken	= json_token.accesstoken		'인증 토큰
				r_type	= json_token.type			'Bearer
				r_expired	= json_token.expired	'type

				'Call ResRW(r_accesstoken,"r_accesstoken")
				'Call ResRW(r_type,"r_type")
				'Call ResRW(r_expired,"r_expired")

			Case Else
				r_code	= json_token.code		'결과 코드
				r_description	= json_token.description		'디스크립션

				Call ResRW(r_code,"r_code")
				Call ResRW(r_description,"r_description")
		End Select
	'# /v1/token 			POST 인증 토 큰 을 발급 을 요청하는 기능입니다 ############################## E

		PPURIO_MESSAGE_type = request("t")
		Select Case LCase(PPURIO_MESSAGE_type)
			Case "sms","lms","mms","at","ft","rcs"
			'Case Else Call WRONG_ACCESS()
		End Select
		'PPURIO_MESSAGE_type = "sms"		' sms, lms, mms, at(알림톡), ft(친구톡), rcs
		PPURIO_MESSAGE_from = "15998807"		' 발신 번호
		PPURIO_MESSAGE_to = "01082860240"		' 수신 번호
		PPURIO_MESSAGE_conutry = ""		' 국가 코드 * ● 국제 메시지 발송 참조
		PPURIO_MESSAGE_refkey = "test1234"		' 고객사에서 부여한 키

		Dim jsonBody : jsonBody = ""
		Dim jsonContent : jsonContent = ""

		PPURIO_MESSAGE_type = LCase(PPURIO_MESSAGE_type)
		Select Case PPURIO_MESSAGE_type
			Case "sms"		'5page
				'PPURIO_MESSAGE_content_message = "content_message content_message content_message content_message content_message content_message"		' 메시지 데이터 * ● CONTENT 참조
				PPURIO_MESSAGE_content_message = "가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나"		' 메시지 데이터 * ● CONTENT 참조
				If calcStringLenByte(PPURIO_MESSAGE_content_message) > 90 Then	'message 최대 90byte
					PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 90-2)
				End If
				print calcStringLenByte(PPURIO_MESSAGE_content_message)
				print PPURIO_MESSAGE_content_message

				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""""
				jsonContent = jsonContent& "	}"

			Case "lms"		'6page
				PPURIO_MESSAGE_content_subject = "subjectis"
				PPURIO_MESSAGE_content_message = "가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마 가나다라마2 가나다라마"		' 메시지 데이터 * ● CONTENT 참조

				If calcStringLenByte(PPURIO_MESSAGE_content_subject) > 64 Then	'subject 최대 64byte
					PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_subject, 64-2)
				End If
				If calcStringLenByte(PPURIO_MESSAGE_content_message) > 2000 Then	'message 최대 2000byte
					PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 2000-2)
				End If

				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""subject"": """&PPURIO_MESSAGE_content_subject&""","
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""""
				jsonContent = jsonContent& "	}"

			Case "mms"		'6-7page
				PPURIO_MESSAGE_content_subject = "subjectis mms"
				PPURIO_MESSAGE_content_message = "content_message"		' 메시지 데이터 * ● CONTENT 참조

				If calcStringLenByte(PPURIO_MESSAGE_content_subject) > 64 Then	'subject 최대 64byte
					PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_subject, 64-2)
				End If
				If calcStringLenByte(PPURIO_MESSAGE_content_message) > 2000 Then	'message 최대 2000byte
					PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 2000-2)
				End If

				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""subject"": """&PPURIO_MESSAGE_content_subject&""","
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""","
				jsonContent = jsonContent& "		""file"": ["
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""type"": ""IMG"","
				jsonContent = jsonContent& "				""key"": ""1585011852_DD7482861185100000001.jpg"""
				jsonContent = jsonContent& "			},"
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""type"": ""IMG"","
				jsonContent = jsonContent& "				""key"": ""1585011852_DD7482861185100000002.jpg"""
				jsonContent = jsonContent& "			},"
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""type"": ""IMG"","
				jsonContent = jsonContent& "				""key"": ""1585011852_DD7482861185100000003.jpg"""
				jsonContent = jsonContent& "			}"
				jsonContent = jsonContent& "		]"
				jsonContent = jsonContent& "	}"

			Case "at"	'알림톡		'10page
				PPURIO_MESSAGE_senderkey = "12345"		'발신 프로필 키 40
				PPURIO_MESSAGE_templatecode = "template"		'템플릿 코드 32
				PPURIO_MESSAGE_content_message = "알림톡 + 버튼(WL)"		' 메시지 데이터 * ● CONTENT 참조
				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
				jsonContent = jsonContent& "		""templatecode"": """&PPURIO_MESSAGE_templatecode&""","
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""","
				jsonContent = jsonContent& "		""button"": ["
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""name"": ""웹 링크 버튼"","
				jsonContent = jsonContent& "				""type"": ""WL"","
				jsonContent = jsonContent& "				""url_pc"": ""http://www.bizppurio.com"","
				jsonContent = jsonContent& "				""url_mobile"": ""http://www.bizppurio.com"""
				jsonContent = jsonContent& "			}"
				jsonContent = jsonContent& "		]"
				jsonContent = jsonContent& "	}"

			Case "ai"	'알림톡 이미지		'11page
				PPURIO_MESSAGE_senderkey = "12345"		'발신 프로필 키 40
				PPURIO_MESSAGE_templatecode = "template"		'템플릿 코드 32
				PPURIO_MESSAGE_content_message = "알림톡 이미지"		' 메시지 데이터 * ● CONTENT 참조
				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
				jsonContent = jsonContent& "		""templatecode"": """&PPURIO_MESSAGE_templatecode&""","
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""""
				jsonContent = jsonContent& "	}"

			Case "ft"	'친구톡		'10page
				PPURIO_MESSAGE_senderkey = "12345"		'발신 프로필 키 40
				PPURIO_MESSAGE_content_message = "친구톡+버튼+이미지"		' 메시지 데이터 * ● CONTENT 참조
				jsonContent = jsonContent& "	"""&PPURIO_MESSAGE_type&""": {"
				jsonContent = jsonContent& "		""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
				jsonContent = jsonContent& "		""adflag"": ""Y"","
				jsonContent = jsonContent& "		""message"": """&PPURIO_MESSAGE_content_message&""","
				jsonContent = jsonContent& "		""button"": ["
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""name"": ""1234567890123456789"","
				jsonContent = jsonContent& "				""type"": ""WL"","
				jsonContent = jsonContent& "				""url_pc"": ""http://www.bizppurio.com"","
				jsonContent = jsonContent& "				""url_mobile"": ""http://www.bizppurio.com"""
				jsonContent = jsonContent& "			},"
				jsonContent = jsonContent& "			{"
				jsonContent = jsonContent& "				""name"": ""1234567890123456789"","
				jsonContent = jsonContent& "				""type"": ""WL"","
				jsonContent = jsonContent& "				""url_pc"": ""http://www.bizppurio.com"","
				jsonContent = jsonContent& "				""url_mobile"": ""http://www.bizppurio.com"""
				jsonContent = jsonContent& "			}"
				jsonContent = jsonContent& "		],"
				jsonContent = jsonContent& "		""image"": {"
				jsonContent = jsonContent& "			""img_url"": ""url"","
				jsonContent = jsonContent& "			""imglink"": ""http//message.com"""
				jsonContent = jsonContent& "		}"
				jsonContent = jsonContent& "	}"

		End Select
		jsonContent = FN_NoTabNSpace(jsonContent)

		jsonBody = jsonBody& "{"
		jsonBody = jsonBody& "	""account"": """&PPURIO_ID&""","
		jsonBody = jsonBody& "	""refkey"": """&PPURIO_MESSAGE_refkey&""","
		jsonBody = jsonBody& "	""type"": """&PPURIO_MESSAGE_type&""","
		jsonBody = jsonBody& "	""from"": """&PPURIO_MESSAGE_from&""","
		jsonBody = jsonBody& "	""to"": """&PPURIO_MESSAGE_to&""","
		'jsonBody = jsonBody& "	""country"": """&PPURIO_MESSAGE_conutry&""","
		jsonBody = jsonBody& "	""content"": {"
		jsonBody = jsonBody& 				jsonContent
		jsonBody = jsonBody& "	}"
		jsonBody = jsonBody& "}"
		jsonBody = FN_NoTabNSpace(jsonBody)

		'Call ResRW(jsonBody,"jsonBody")
		'Call ResRW(jsonContent,"jsonContent")


	If pTokenStatus = "200" And r_accesstoken <> "" Then
	'# /v3/message 			POST 인증 토 큰 을 발급 을 요청하는 기능입니다 ############################## S
	'# https://dev-api.bizppurio.com/v3/message

		PPURIO_MESSAGE_AUTH = r_type&" "&r_accesstoken

		Call ResRW(PPURIO_MESSAGE_URL,"PPURIO_MESSAGE_URL")
		Call ResRW(PPURIO_MESSAGE_AUTH,"PPURIO_MESSAGE_AUTH")
		'jsonBody =	"{""account"":""metac21g_dev"",""refkey"":""test1234"",""type"":""sms"",""from"":""0215998800"",""to"":""01012341234"",""content"":{""sms"":{""message"":""content_message""}}}"
		Call ResRW(jsonBody,"message body")


		Set pMessage = Server.CreateObject("Msxml2.ServerXMLHTTP")

			pMessage.open "POST", PPURIO_MESSAGE_URL, False
			pMessage.setRequestHeader "Content-Type", "application/json; charset=utf-8"			'PPURIO Header  Content-Type application/json; charset=utf-8 !!!
			pMessage.setRequestHeader "Authorization", PPURIO_MESSAGE_AUTH
			'pMessage.send toJSON(jsonBody)
			pMessage.send (jsonBody)

			pMessageResponse = pMessage.responseText
			pMessageStatus = pMessage.status

			Call ResRW(pMessageResponse,"pMessageResponse")
			Call ResRW2(pMessageStatus,"pMessageStatus")

		Set pMessage = Nothing	'개체 소멸

		Dim json_message : Set json_message = JSON.parse(join(array(pMessageResponse)))

		'19page
		Select Case pMessageStatus
			Case "200"
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지
				r_messagekey	= json_message.messagekey		'메시지 키 * 고객 문의 및 리포트 재 요청 기준 키
				r_refkey	= json_message.refkey		'고객사에서 부여한 키

				Call ResRW(r_code,"r_code")
				Call ResRW(r_description,"r_description")
				Call ResRW(r_messagekey,"r_messagekey")
				Call ResRW(r_refkey,"r_refkey")

			Case Else
				'ALERT_MSG = "ErrorCode : "&pMessageStatus&""
				'	Sfile2.WriteLine "---ERROR2------------------------------------"
				'	Sfile2.WriteLine "ALERT_MSG	: " & ALERT_MSG
				'	Sfile2.WriteLine "---------------------------------------------"
				'Call ALERTS(Replace(ALERT_MSG,"&#10;",""),"GO",GO_BACK_ADDR)
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지

				'Call ResRW(r_code,"r_code")
				'Call ResRW(r_description,"r_description")
		End Select

	'# /v1/token 			POST 인증 토 큰 을 발급 을 요청하는 기능입니다 ############################## E
	End If

%>
<%

%>
<%
	' *****************************************************************************
	'	Function name	: FN_NoTabNSpace
	'	Description		: Tab, Space 제거
	' *****************************************************************************
	Function FN_NoTabNSpace(str)
		 value = str
		 value = Replace(value, Chr(9), "")		'tab
		 value = Replace(value, Chr(32), "")	'space
		 FN_NoTabNSpace = value
	End Function

%>
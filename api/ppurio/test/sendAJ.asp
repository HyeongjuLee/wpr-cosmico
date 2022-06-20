<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	If webproIP <> "T" Then Call WRONG_ACCESS()

		'API JSON 전송 테스트


		Authorization = "ABCDEFG123"
		T_MESSAGE_URL = "https://www.metac21g.com/API/ppurio/test/receiveAJ.asp"
		'T_MESSAGE_URL = "https://www.l2go.co.kr/API/regMember.asp"

		jsonBody =	"{""account"":""appJson_dev"",""refkey"":""test1234"",""type"":""sms"",""from"":""0215998800"",""to"":""01012341234"",""content"":{""sms"":{""message"":""content_message""}}}"

		'application/x-www-form-urlencoded
		'	jsonBody = ""
		'	jsonBody = "account=appJson_dev"
		'	jsonBody = jsonBody & "&refkey=test12342222"
		'	jsonBody = jsonBody & "&type=sms"
		'	jsonBody = jsonBody & "&from=0215998800"
		'	jsonBody = jsonBody & "&message=content_message"

		Call ResRW(T_MESSAGE_URL,"T_MESSAGE_URL")
		Call ResRW(Authorization,"Authorization")
		Call ResRW(jsonBody,"message body")


		Set tMessage = Server.CreateObject("Msxml2.ServerXMLHTTP")

			tMessage.open "POST", T_MESSAGE_URL, False
			tMessage.setRequestHeader "Content-Type", "application/json; charset=utf-8"			'PPURIO Header  Content-Type application/json; charset=utf-8 !!!
			'tMessage.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"			'PPURIO Header  Content-Type application/json; charset=utf-8 !!!
			tMessage.setRequestHeader "Authorization", Authorization		'요청한 머리글을 찾을 수 없습니다.

			tMessage.setRequestHeader "AuthTime", "AuthTime_headerINFO"		'HTTP_AuthTime
			tMessage.setRequestHeader "AuthToken", "AuthToken_headerINFO"		'HTTP_AuthTime

			'tMessage.setRequestHeader "Accept-Language","UTF-8"
			'tMessage.setRequestHeader "CharSet", "UTF-8"
			'tMessage.setRequestHeader "Content", "text/html;charset=UTF-8"

			'tMessage.send toJSON(jsonBody)
			tMessage.send (jsonBody)

			tMessageResponse = tMessage.responseText
			tMessageStatus = tMessage.status

			If tMessageStatus = 0 Then tMessageStatus = "400"

			Call ResRW(tMessageResponse,"tMessageResponse")
			Call ResRW2(tMessageStatus,"tMessageStatus")

		Set tMessage = Nothing	'개체 소멸

		'Response.End
		On Error Resume Next
		Dim json_message : Set json_message = JSON.parse(join(array(tMessageResponse)))

		'19page
		Select Case tMessageStatus
			Case "200"
				r_result	= json_message.result		'결과 코드
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지
				r_messagekey	= json_message.messagekey		'메시지 키 * 고객 문의 및 리포트 재 요청 기준 키
				r_refkey	= json_message.refkey		'고객사에서 부여한 키

				Call ResRW(r_result,"r_result")
				Call ResRW(r_code,"r_code")
				Call ResRW(r_description,"r_description")
				Call ResRW(r_messagekey,"r_messagekey")
				Call ResRW(r_refkey,"r_refkey")

			Case "400"		'강제 Bad Request
				r_result	= json_message.result		'결과 코드
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지

				Call ResRW(r_result,"r_result")
				Call ResRW(r_code,"r_code")
				Call ResRW(r_description,"r_description")

			Case Else
				r_result	= json_message.result		'결과 코드
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지

				Call ResRW(r_code,"r_code")
				Call ResRW(r_description,"r_description")
		End Select
		On Error goto 0
%>

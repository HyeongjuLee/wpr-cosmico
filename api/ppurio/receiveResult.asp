<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
	'### ppurio receive Result(application/json) ###
	' 전송 결과 전달 : URL PUSH 방식
	' 전송 결과는 고객사에서 사전에 등록 요청한 URL 로 PUSH 방식으로 전달합니다 (ppurio → 등록된 URL)
	' bizppurio@daou.co.kr 메일요청 : URL, 계정ID
	' /API/ppurio/receiveResult.asp
	' 수신확인 설정
	'		Biz Lounge > 모듈연동 환경설정
	'		리포트 수신 값을 '예(전송결과를 고객서버로 전송')
	'		수정 안되는 경우(잘못된 요청 에러 발생 시) 뿌리오 개발팀에 수정요청 해야함!
	'
	' metac21g 2022-04-14 ~
	'	/API/ppurio/receiveResult.asp

	If Request.TotalBytes > 0 Then
		Dim lngBytesCount, jsonText
		lngBytesCount = Request.TotalBytes

		jsonText = BytesToStr(Request.BinaryRead(lngBytesCount))
		'jsonText = BinaryToText (Request.BinaryRead(lngBytesCount),"UTF-8")
		'sResponse = binarytotext (oXmlhttp1.responseBody,"UTF-8")
		Response.Clear

		Dim json_result : Set json_result = JSON.parse(join(array(jsonText)))

		REQUEST_METHOD					= Replace(Request.ServerVariables("REQUEST_METHOD")," ","")				'POST
		CHEADER_CONTENT_TYPE		= Replace(Request.ServerVariables("HTTP_CONTENT_TYPE")," ","")		'.setRequestHeader "Content-Type"			application/json; charset=utf-8
		CHEADER_AUTHORIZATION		= Replace(Request.ServerVariables("HTTP_AUTHORIZATION")," ","")		'.setRequestHeader "Authorization"

		On Error Resume Next
			CardLogss = "/API/ppurio/receiveResult"
			Dim Fso : Set Fso = CreateObject("Scripting.FileSystemObject")
			Dim LogPath : LogPath = Server.MapPath (CardLogss&"/rr_") & Replace(Date(),"-","") & ".log"
			Dim Sfile : Set Sfile = Fso.OpenTextFile(LogPath,8,true)

			Sfile.WriteLine chr(13)
			Sfile.WriteLine "Date	: "	& now()
			Sfile.WriteLine "Domain	: "	& Request.ServerVariables("HTTP_HOST")
			Sfile.WriteLine "==== ppurio receive Result ==================="
			'Sfile.WriteLine "REQUEST_METHOD	: " & REQUEST_METHOD
			'Sfile.WriteLine "CHEADER_CONTENT_TYPE	: " & CHEADER_CONTENT_TYPE
			Sfile.WriteLine "jsonText	: " & jsonText
			Sfile.WriteLine "=============================================="

			Sfile.Close
			Set Fso= Nothing
			Set objError= Nothing

			'결과 코드

			'기본
			'{"DEVICE":"SMS","CMSGID":"220414115950389sms021853meta4a63","MSGID":"0414me_SL3951730519000020481","PHONE":"01082860240","MEDIA":"SMS","UNIXTIME":"1649905190","RESULT":"4100","USERDATA":"","WAPINFO":"LGT"}

			'재전송
			'{"DEVICE":"AT","CMSGID":"220428133747010#at269328meta5oja","MSGID":"0428me_DD2037332066603108417","PHONE":"01045610123","MEDIA":"KAT","UNIXTIME":"1651120667","RESULT":"7318","USERDATA":"","WAPINFO":"KTF","TELRES":"6600","TELTIME":"1651120675","RETRY_FLAG":"S","RESEND_FLAG":"M"}

			r_DEVICE		= Replace(json_result.DEVICE," ","")			'메시지 유형
			r_CMSGID		= Replace(json_result.CMSGID," ","")			'메시지 키(* 고객 문의 및 리포트 재 요청 기준 키)
			r_MSGID			= Replace(json_result.MSGID," ","")				'비즈뿌리오 메시지 키
			r_PHONE			= Replace(json_result.PHONE," ","")				'수신 번호
			r_MEDIA			= Replace(json_result.MEDIA," ","")				'실제 발송된 메시지 상세 유형 * MEDIA 유형
			r_UNIXTIME	= Replace(json_result.UNIXTIME," ","")		'발송 시간
			r_RESULT		= Replace(json_result.RESULT," ","")			'이통사 카카오 RCS 결과 코드 * 9 . 전송 결과 코드 참조
			r_USERDATA	= Replace(json_result.USERDATA," ","")		'정산용 부서 코드
			r_WAPINFO		= Replace(json_result.WAPINFO," ","")			'이통사 카카오 정보 * SKT/KTF/LGT/KAO

			'대체전송결과
			r_TELRES		= ""
			r_KAORES		= ""
			r_RCSRES		= ""
			If InStr(json_result,"TELRES") > 0 Then
				r_TELRES	= Replace(json_result.TELRES," ","")			'이통사 대체 전송 결과
			End If
			If InStr(json_result,"KAORES") > 0 Then
				r_KAORES	= Replace(json_result.KAORES," ","")			'카카오 대체 전송 결과
			End If
			If InStr(json_result,"RCSRES") > 0 Then
				r_RCSRES	= Replace(json_result.RCSRES," ","")			'RCS 대체 전송 결과
			End If


			If Err.Number = 0 Then  ' catch
				'slave ID 상에서 같은 조건에는 간헐적 ok 대부분 4420 6610 기타에러 발생함
				'mater ID 상에서는 결과값 전달 안되는 경우가 태반
				Select Case r_RESULT
					Case "4100","6600","7000"
						r_RESULT = "OK"
					Case Else
						r_RESULT = r_RESULT		'FAIL
				End Select

				'대체전송 결과코드치환
				Select Case r_TELRES
					Case "4100","6600"
						r_TELRES = "OK"
					Case Else
						r_TELRES = r_TELRES		'FAIL
				End Select
				If r_KAORES = "7000" Then r_KAORES = "OK"

				'▣ LOG 업데이트 receiveResult
				arrParamsL2 = Array(_
					Db.makeParam("@strType",adChar,adParamInput,3,r_DEVICE),_
					Db.makeParam("@messagekey",adVarChar,adParamInput,32,r_CMSGID),_
					Db.makeParam("@receiveResult",adVarChar,adParamInput,500,jsonText),_
					Db.makeParam("@r_RESULT",adChar,adParamInput,4,r_RESULT),_
					Db.makeParam("@r_TELRES",adChar,adParamInput,4,r_TELRES),_
					Db.makeParam("@r_KAORES",adChar,adParamInput,4,r_KAORES),_
					Db.makeParam("@r_RCSRES",adChar,adParamInput,4,r_RCSRES),_
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("HJP_PPURIO_LOG_RECEIVE_RESULT_UPDATE",DB_PROC,arrParamsL2,DB3)

			End If


		On Error GoTo 0
		Response.End

	End If

%>
<%

%>


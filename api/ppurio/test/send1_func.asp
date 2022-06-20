<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	If webproIP <> "T" Then Call WRONG_ACCESS()
	'뿌리오 문자모아 통합함수 테스트 페이지

	'/api/ppurio/test/send1_func.asp?cate=join

	Response.end

	'Dec_strEmail = "hjtime07@webpro.kr"
	'Dec_strEmail = "hjtime07@gmail.com"
	'MBID = "TE"
	'Mbid2 = 22
	'Call FnWelComeMail(Dec_strEmail, Mbid, Mbid2, "join", "")
	'Response.end

	'https://codebeautify.org/jsonviewer 	'2spaces

	strCate = gRequestTF("cate", True)

	Mbid = "KR"
	Mbid2 = "34326745"
	strCate = strCate		'"join"
	strType = "at"
	ordenuber="2022040500100006"
	'Call FN_GetMessageTemplate(Mbid, Mbid2, strCate, sendTel_Ref, strSubject_Ref, smsContent_Ref)
	'print sendTel_Ref
	'print strSubject_Ref
	'print smsContent_Ref
	'Response.end
	'sms, lms, mms 는 이 함수로
	'requestInfos = "safasdf123"
	'Call FN_MemMessage_Send(Mbid, Mbid2, "spwd" , requestInfos)		'spwd, pwd
	'Call FN_MemMessage_Send(Mbid, Mbid2, "join2", "")

	'카톡관련은 이 함수로
	strMobile = "01082860240"
	sendMsg = "안녕하세요 메타21 입니다. mms 이미지 테스트333 입니다.."	' 메시지 데이터 * ● CONTENT 참조
	sendTitle = "안녕하세요 메타21 입니다. mms test"
	'order
	requestNumber = "DK123456"
	requestInfos = "상품명|DK12345678999|2022-04-23|3,900"

	'"at","ft"
	Call FN_PPURIO_MESSAGE(Mbid, Mbid2, strCate, strType, ordenuber,requestInfos) '비즈뿌리오 send ("sms","lms","mms","at","ai","ft","rcs")

	Response.end
	Response.end
	Response.end
	Response.end
%>
<%
	'수정된 함수(기존 문자모아와 분기)  'strFuncMessage.asp
	'	FnWelComeMMS
	'	FnSendMMS
	'	FnSendSMS

	'strFuncMessage.asp
		'[삭제한 함수]
			'FnWelComeMMS
			'FnSendMMS
			'FnSendSMS

		'[추가된 함수]
			'Function FN_MemMessage_Send(ByVal Mbid, ByVal Mbid2, ByVal strCate)
			' ↘ Function FN_GetMessageTemplate

			'Function FN_PPURIO_MESSAGE(Mbid, Mbid2, strCate, strType, requestNumber, requestInfos)
			'	↘ Function FN_PPURIO_TOKEN_REQ(byRef pTokenStatus, byRef r_accesstoken, byRef r_type)
			'	↘ Function FN_PPURIO_MESSAGE_REQ(r_type, r_accesstoken, jsonBody, IDENTITY)
			'	↘	Function FN_PPURIO_MESSAGE_VARIABLE_REPLACE(strCate, sendMsg, requestNumber, requestInfos)
			'	↘ FN_PPURIO_FILEKEY(strImg)
			'		↘↘FN_SendFileData(filePath, strAccount, SEND_URL, boundary, Charset)

	'strFunc.asp
	'추가된 함수/class
	'	Class base64Crypt
	'	BASE64_Encrypt(Class base64Crypt)
	'	JsonNoSpaces
	'	JSONEncode
	'	BytesToStr
	'	BinaryToText

	'추가된 테이블
		'HJ_PPURIO_LOG
	'추가된 프로시져
		'HJP_PPURIO_LOG_INSERT
		'HJP_PPURIO_LOG_UPDATE
		'HJP_PPURIO_LOG_RECEIVE_RESULT_UPDATE
		'HJP_PPURIO_LOG_RECEIVE_RESULTS
		'HJP_PPURIO_LOG_RECEIVE_RESULTS_CS

	'추가된페이지 push URL
	'/API/ppurio/receiveResult.asp  (뿌리오 개발팀에 URL등록 요청, 메일로)
	'수신확인 설정
	'	Biz Lounge > 모듈연동 환경설정
	'	리포트 수신 값을 '예(전송결과를 고객서버로 전송' )
	' 수정 안되는 경우(잘못된 요청 에러) 뿌리오 개발팀에 수정 요청해야함!

	' 발급받은 파일키는 당일 00시에 무효화되므로(1회성)
	'	MMS 전송 시마다 해당 이미지에 대한 파일키를 발급받아야함<!DOCTYPE html>
%>
<%
	'남은작업 카톡 'at,ft...
%>

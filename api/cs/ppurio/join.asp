<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "_config.asp"-->
<%
' *****************************************************************************
'	/api/cs/ppurio/join
' 뿌리오 문자모아 CS용 API
' 웹과 공통 함수 사용 FN_PPURIO_MESSAGE
' *****************************************************************************
	strCate				= "join"
	strType 			= "at"
	requestInfos 	= "CS"

	Select Case LCase(SET_CONTENT_TYPE)
		Case "application/x-www-form-urlencoded"
			mbid		= Request.form("mbid")
			mbid2		= Request.form("mbid2")


		Case "application/json"
			If Request.TotalBytes < 1 Then
				Response.Status = "'400' Bad Request"		'Status 강제로 0으로 만들어주기!!
				PRINT "{""result"" : ""error"", ""resultmsg"" : ""json syntax error""}" : Response.End
			End If

			Dim lngBytesCount, jsonText
			lngBytesCount = Request.TotalBytes

			jsonText = BytesToStr(Request.BinaryRead(lngBytesCount))
			Response.Clear

			Dim jsonBody : Set jsonBody = JSON.parse(join(array(jsonText)))

			mbid	= jsonBody.mbid
			mbid2	= jsonBody.mbid2


	End Select

	'On Error Resume Next
	'	CardLogss = "/api/cs/receive"
	'	Dim Fso : Set Fso = CreateObject("Scripting.FileSystemObject")
	'	Dim LogPath : LogPath = Server.MapPath (CardLogss&"/r_") & Replace(Date(),"-","") & ".log"
	'	Dim Sfile : Set Sfile = Fso.OpenTextFile(LogPath,8,true)
	'	Sfile.WriteLine chr(13)
	'	Sfile.WriteLine "Date	: "	& now()
	'	Sfile.WriteLine "Domain	: "	& Request.ServerVariables("HTTP_HOST")
	'	Sfile.WriteLine "mbid	: " & mbid
	'	Sfile.WriteLine "mbid2	: " & mbid2
	'	Sfile.WriteLine "jsonText	: " & jsonText
	'	Sfile.Close
	'	Set Fso= Nothing
	'	Set objError= Nothing
	'On Error GoTo 0
%>
<%

	'▣ 필수값 체크
	If mbid = "" Or mbid2 = "" Then
		PRINT "{""result"" : ""error"", ""resultmsg"" : ""회원번호 없음""}" : Response.End
	End If
	'회원번호확인(탈퇴회원 제외)
	MEM_SQL = " SELECT COUNT(*) FROM [tbl_Memberinfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ? And [LeaveCheck] = 1 AND [LeaveDate] = '' "
	arrParams_MEM = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2) _
	)
	memberCnt = CInt(Db.execRsData(MEM_SQL,DB_TEXT,arrParams_MEM,DB3))
	If memberCnt < 1 Then
		PRINT "{""result"" : ""error"", ""resultmsg"" : ""존재하지 않는 회원번호""}" : Response.End
	End If


	'▣ 뿌리오 메세지 전송
	Call FN_PPURIO_MESSAGE(mbid, mbid2, strCate, strType, OrderNumber, requestInfos)


	If IsNumeric(requestInfos) And Not IsNull(requestInfos) Then
		PRINT "{""result"" : ""success"", ""resultmsg"" : ""알림톡이 전송되었습니다.""}" : Response.End
	Else
		resultmsg	= "잘못된 인덱스값(정보확인)"
		PRINT "{""result"" : ""error"", ""resultmsg"" : """&resultmsg&"""}" : Response.End
	End If


	Response.End

	'CS 결과확인 안함!!!
%>
<%
	'▣ 결과확인
	If IsNumeric(requestInfos) And Not IsNull(requestInfos) And 1=22222 Then
		LOG_IDENTITY = requestInfos

		Call Delay(3)			'결과값 PUSH리턴 대기

		arrParamsLB = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,LOG_IDENTITY) _
		)
		Set HJRSLB = Db.execRs("HJP_PPURIO_LOG_RECEIVE_RESULTS",DB_PROC,arrParamsLB,DB3)
		If Not HJRSLB.BOF And Not HJRSLB.EOF Then
			RS_r_RESULT	= Trim(HJRSLB(0))
			RS_r_TELRES	= Trim(HJRSLB(2))
			RS_r_KAORES	= Trim(HJRSLB(3))
			RS_r_RCSRES	= Trim(HJRSLB(4))
		End If
		Call closeRS(HJRSLB)
		'Call ResRW(LOG_IDENTITY,"LOG_IDENTITY")
		'Call ResRW(RS_r_RESULT,"RS_r_RESULT")
		'Call ResRW(RS_r_TELRES,"RS_r_TELRES")

		IF RS_r_RESULT = "OK" Then	'1차 알림톡 전송 성공
			PRINT "{""result"" : ""success"", ""resultmsg"" : ""알림톡이 전송되었습니다.""}" : Response.End
		Else

			If RS_r_TELRES = "" Then
				PRINT "{""result"" : ""error"", ""resultmsg"" : "" errorcode : "&RS_r_RESULT&"""}" : Response.End
			Else

				IF RS_r_TELRES = "OK" Then 	'2차 문자 대체전송 성공
					PRINT "{""result"" : ""success"", ""resultmsg"" : ""문자로 대체 전송되었습니다.""}" : Response.End
				Else
					PRINT "{""result"" : ""error"", ""resultmsg"" : "" errorcode : "&RS_r_TELRES&"""}" : Response.End
				End If

			End If
		End If

	Else
		resultmsg	= "잘못된 인덱스값(정보확인)"
		PRINT "{""result"" : ""error"", ""resultmsg"" : """&resultmsg&"""}" : Response.End
	End If

	Response.end
%>

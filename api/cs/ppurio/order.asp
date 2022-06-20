<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "_config.asp"-->
<%
' *****************************************************************************
'	/api/cs/ppurio/order
' 뿌리오 문자모아 CS용 API
' 웹과 공통 함수 사용 FN_PPURIO_MESSAGE
' *****************************************************************************
	strCate				= "order"
	strType 			= "at"
	requestInfos 	= "CS"

	Select Case LCase(SET_CONTENT_TYPE)
		Case "application/x-www-form-urlencoded"
			mbid		= Request.form("mbid")
			mbid2		= Request.form("mbid2")
			OrderNumber	= Request.form("OrderNumber")

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
			OrderNumber	= jsonBody.OrderNumber

	End Select

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

	'주문번호확인(탈퇴회원 제외)
	ORDER_SQL = " SELECT COUNT(*) FROM [tbl_Salesdetail] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ? And [OrderNumber] = ?"
	arrParams_ORDER = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2), _
		Db.makeParam("@OrderNumber",adVarChar,adParamInput,20,OrderNumber) _
	)
	orderCnt = CInt(Db.execRsData(ORDER_SQL,DB_TEXT,arrParams_ORDER,DB3))
	If orderCnt < 1 Then
		PRINT "{""result"" : ""error"", ""resultmsg"" : ""존재하지 않는 주문번호""}" : Response.End
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

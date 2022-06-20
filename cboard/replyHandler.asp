<!--#include virtual = "/_lib/strFunc.asp" -->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	'Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	If DOMAIN_NAME_IS = "" Then DOMAIN_NAME_IS = PUSH_DOMAIN_IS

	appIDX = pRequestTF("appIDX",True)
	mode = pRequestTF("mode",True)
	strBoardName = pRequestTF("bname",True)


	If DK_MEMBER_TYPE = "GUEST" Then
		REPLY_WRITE_ID = DK_MEMBER_ID
		REPLY_WRITE_NAME = pRequestTF("replyName",True)
		REPLY_WRITE_PASS = pRequestTF("replyPass",True)
	Else
		REPLY_WRITE_ID = DK_MEMBER_ID
		REPLY_WRITE_NAME = DK_MEMBER_NAME
		REPLY_WRITE_PASS = ""
	End If



Select Case mode
	Case "INSERT"
		strContent = pRequestTF("strContent",True)
		replySecret = pRequestTF("replySecret",False)
		If replySecret = "" Then replySecret = "F"
		arrParams = Array(_
			Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,REPLY_WRITE_ID), _
			Db.makeParam("@strName",adVarChar,adParamInput,20,REPLY_WRITE_NAME), _
			Db.makeParam("@strPass",adVarChar,adParamInput,32,REPLY_WRITE_PASS), _
			Db.makeParam("@strContent",adVarChar,adParamInput,2000,strContent), _
			Db.makeParam("@replySecret",adChar,adParamInput,1,replySecret), _

			Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
		)
		Call Db.exec("DKP_NBOARD_REPLY_INSERT",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


		'900	웹 게시판 작성 적립
		'901	웹 게시판 삭제 차감
		'902	웹 게시판 답글 작성 적립
		'903	웹 게시판 답글 삭제 차감
		'904	웹 게시판 댓글 작성 적립
		'905	웹 게시판 댓글 삭제 차감
		'910	웹 게시판 추천 적립
		'911	웹 게시판 추천 작성자 적립
		'990	웹 출석 적립
		'991	웹 출석 특별 적립

		arrParams9 = Array(_
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
		)
		Set DKRS9 = Db.execRs("DKPA_FORUM_CONFIG_POINT",DB_PROC,arrParams9,Nothing)

		If Not DKRS9.BOF And Not DKRS9.EOF Then
			DKRS9_isPointUse			= DKRS9("isPointUse")
			DKRS9_intPointView			= DKRS9("intPointView")
			DKRS9_intPointWrite			= DKRS9("intPointWrite")
			DKRS9_intPointReply			= DKRS9("intPointReply")
			DKRS9_intPointUpload		= DKRS9("intPointUpload")
			DKRS9_intPointDownload		= DKRS9("intPointDownload")
			DKRS9_intPointComment		= DKRS9("intPointComment")
			DKRS9_intPointVote			= DKRS9("intPointVote")
			DKRS9_isPointDelete			= DKRS9("isPointDelete")
			DKRS9_isPointDelComment		= DKRS9("isPointDelComment")
			DKRS9_intPointVoteWriter	= DKRS9("intPointVoteWriter")

			If DKRS9_isPointUse = "T" Then
				If DKRS9_intPointComment <> 0 Then
					Call FNC_CS_POINT_INPUT(DK_MEMBER_ID1,DK_MEMBER_ID2,DK_MEMBER_NAME,DKRS9_intPointComment,"904",0,"","WEB_POINT","댓글 작성 "&strBoardName&"-"&appIDX&" 에 댓글 등록",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
				End If
				SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,?,'댓글 작성','댓글 작성 "&strBoardName&"-"&appIDX&" 에 댓글 등록')"
				arrParams = Array(_
					Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
					Db.makeParam("@intPoint",adInteger,adParamInput,0,DKRS9_intPointComment) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

			End If

		End If
		Call closeRs(DKRS9)


	Case "DELETE"

		SQL = "SELECT [strUserID] FROM [DK_NBOARD_COMMENT] WHERE [intIDX] = ?"
		arrParams = Array(_
			Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX) _
		)
		thisUserID = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
		SQL = "SELECT COUNT([intIDX]) FROM [DK_NBOARD_COMMENT] WHERE [intList] = ?"
		arrParams = Array(_
			Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX) _
		)
		thisRRcnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

		If thisUserID <> DK_MEMBER_ID And DK_MEMBER_TYPE <> "ADMIN" Then
			OUTPUT_VALUE = "NOTUSER"
		Else
			If thisRRcnt > 1 Then
				OUTPUT_VALUE = "CNTBIG"
			Else
				arrParams = Array(_
					Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX), _
					Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
				)
				Call Db.exec("DKP_NBOARD_REPLY_DELETE",DB_PROC,arrParams,Nothing)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			End If
		End If
	Case "REPLY"
		strContent = pRequestTF("strContent",True)
		upIDX = pRequestTF("upIDX",True)

		arrParams = Array(_
			Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
			Db.makeParam("@strName",adVarChar,adParamInput,20,DK_MEMBER_NAME), _
			Db.makeParam("@strContent",adVarChar,adParamInput,2000,strContent), _
			Db.makeParam("@upIDX",adInteger,adParamInput,0,upIDX), _

			Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
		)
		Call Db.exec("DKP_NBOARD_RREPLY_INSERT",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		arrParams9 = Array(_
			Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
		)
		Set DKRS9 = Db.execRs("DKPA_FORUM_CONFIG_POINT",DB_PROC,arrParams9,Nothing)

		If Not DKRS9.BOF And Not DKRS9.EOF Then
			DKRS9_isPointUse			= DKRS9("isPointUse")
			DKRS9_intPointView			= DKRS9("intPointView")
			DKRS9_intPointWrite			= DKRS9("intPointWrite")
			DKRS9_intPointReply			= DKRS9("intPointReply")
			DKRS9_intPointUpload		= DKRS9("intPointUpload")
			DKRS9_intPointDownload		= DKRS9("intPointDownload")
			DKRS9_intPointComment		= DKRS9("intPointComment")
			DKRS9_intPointVote			= DKRS9("intPointVote")
			DKRS9_isPointDelete			= DKRS9("isPointDelete")
			DKRS9_isPointDelComment		= DKRS9("isPointDelComment")
			DKRS9_intPointVoteWriter	= DKRS9("intPointVoteWriter")

			If DKRS9_isPointUse = "T" Then
				If DKRS9_intPointComment <> 0 Then
					Call FNC_CS_POINT_INPUT(DK_MEMBER_ID1,DK_MEMBER_ID2,DK_MEMBER_NAME,DKRS9_intPointComment,"904",0,"","WEB_POINT","댓글 작성 "&strBoardName&"-"&appIDX&" 에 댓글 등록",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
				End If
				SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,?,'댓글 작성','댓글 작성 "&strBoardName&"-"&appIDX&" 에 댓글 등록')"
				arrParams = Array(_
					Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
					Db.makeParam("@intPoint",adInteger,adParamInput,0,DKRS9_intPointComment) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

			End If

		End If
		Call closeRs(DKRS9)


End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"
			Call alerts(LNG_REPLYHANDLER_ALERT01,"p_reloada","")
		Case "NOTUSER"
			Call ALERTS(LNG_REPLYHANDLER_ALERT02,"p_reloada","")
		Case "CNTBIG"
			Call ALERTS(LNG_REPLYHANDLER_ALERT03,"p_reloada","")
		Case "FINISH"

			'댓글 작성 시 푸시메세지 전송 (댓글 덧글)
			If UCase(mode) = "INSERT" Or UCase(mode) = "REPLY" Then
				arrParams = Array(_
					Db.makeParam("@appIDX",adInteger,adParamInput,0,appIDX) _
				)
				token = Db.execRsData("DKP_NBOARD_LOAD_PUSH_TOKEN_BYIDX",DB_PROC,arrParams,Nothing)

				If Len(token) > 0 Then
					message = "회원님의 게시글에 댓글이 등록되었습니다.\r\n확인 하시겠습니까?"
					url = "http://www."&DOMAIN_NAME_IS&"/m/cboard/board_view.asp?bname="&strBoardName&"&num="&appIDX
					'Call FnPushMessage(token, message, url, "reply", "auto")
				End If
			End If

			Call ALERTS(LNG_REPLYHANDLER_ALERT04,"p_reloada","")
			'Call ALERTS(LNG_REPLYHANDLER_ALERT04,"p_reloada","")
	End Select







%>



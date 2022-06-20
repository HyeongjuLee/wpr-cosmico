<!--#include virtual = "/_lib/strFunc.asp" -->
<%
	'Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	appIDX	= pRequestTF("appIDX",True)
	mode	= pRequestTF("mode",True)
	strBoardName	= pRequestTF("strBoardName",True)		'모바일 추가

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

			'모바일 추가
			idx	= pRequestTF("idx",True)
			If idx <> "" Then
				appIDX = idx
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
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"
			Call alerts(LNG_REPLYHANDLER_ALERT01,"GO","/m/cboard/board_view.asp?bname="&strBoardName&"&num="&appIDX)
		Case "NOTUSER"
			Call ALERTS(LNG_REPLYHANDLER_ALERT02,"GO","/m/cboard/board_view.asp?bname="&strBoardName&"&num="&appIDX)
		Case "CNTBIG"
			Call ALERTS(LNG_REPLYHANDLER_ALERT03,"GO","/m/cboard/board_view.asp?bname="&strBoardName&"&num="&appIDX)
		Case "FINISH"
			Call ALERTS(LNG_REPLYHANDLER_ALERT04,"GO","/m/cboard/board_view.asp?bname="&strBoardName&"&num="&appIDX)
	End Select

'	Select Case OUTPUT_VALUE
'		Case "ERROR"
'			Call alerts(LNG_REPLYHANDLER_ALERT01,"p_reloada","")
'		Case "NOTUSER"
'			Call ALERTS(LNG_REPLYHANDLER_ALERT02,"p_reloada","")
'		Case "CNTBIG"
'			Call ALERTS(LNG_REPLYHANDLER_ALERT03,"p_reloada","")
'		Case "FINISH"
'			Call ALERTS(LNG_REPLYHANDLER_ALERT04,"p_reloada","")
'	End Select







%>



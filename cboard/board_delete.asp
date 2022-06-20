<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = pRequestTF("strBoardName",True)
%>
<!--#include file = "board_config.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%


	bidx = pRequestTF("intIDX",True)
	bList = pRequestTF("list",True)
	bDepth = pRequestTF("depth",True)
	bRIDX = pRequestTF("ridx",True)


	Select Case DK_MEMBER_TYPE
		Case "GUEST"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_DELETE_ALERT01,"back","")
			inputPass = pRequestTF("strPass",True)

			'★password암호화
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
				If inputPass	<> "" Then inputPass	= objEncrypter.Encrypt(inputPass)
				On Error GoTo 0
			Set objEncrypter = Nothing

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,bidx) _
			)
			OriPass = Db.execRsData("DKP_NBOARD_CONTENT_GUEST_PASSWORD",DB_PROC,arrParams,Nothing)
			If inputPass <> OriPass Then
				Call ALERTS(LNG_JS_PASSWORD_INCORRECT,"back","")
			End If
		Case "MEMBER","COMPANY"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_DELETE_ALERT01,"back","")
		Case "ADMIN","OPERATOR"
	End Select









	' 답변글 체크
	SQL = "SELECT [strUserID] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	WRITEID = Db.execRsData(SQL, DB_TEXT, arrParams, Nothing)


	SQL = "SELECT COUNT(*) FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intList] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intList",adInteger,adParamInput,4,bList) _
	)
	DataCnt = CInt(Db.execRsData(SQL, DB_TEXT, arrParams, Nothing))

	'◈Direct아래댓글유무판단 (bDepth + 1 & bRIDX + 1)
	SQL2 = "SELECT COUNT(*) FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intList] = ? "
	SQL2 = SQL2 & "	AND [intDepth] = ? AND [intRIDX] = ? "
	arrParams2 = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intList",adInteger,adParamInput,4,bList), _
		Db.makeParam("@intDepth",adInteger,adParamInput,4,bDepth + 1), _
		Db.makeParam("@intRIDX",adInteger,adParamInput,4,bRIDX + 1) _
	)
	DirReplyCnt = CInt(Db.execRsData(SQL2, DB_TEXT, arrParams2, Nothing))

	Select Case DK_MEMBER_TYPE
		Case "ADMIN","OPERATOR"
		Case "MEMBER","COMPANY"
			If WRITEID <> DK_MEMBER_ID Then Call alerts(LNG_BOARD_DELETE_ALERT03,"back","")
			If DirReplyCnt > 0 Then Call alerts(LNG_BOARD_DELETE_ALERT04&"("&DirReplyCnt&")","back","")
			'If DataCnt > 1 Then Call alerts(LNG_BOARD_DELETE_ALERT04,"back","")
			'If DataCnt > 1 Then Call alerts("해당 게시물에 답변이 존재합니다. 게시물을 삭제할 수 없습니다.","back","")
		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If WRITEID <> DK_MEMBER_ID Then Call alerts(LNG_BOARD_DELETE_ALERT05,"back","")
				If DataCnt > 1 Then Call alerts(LNG_BOARD_DELETE_ALERT05,"back","")
			End If
		Case "GUEST"
			If WRITEID <> "GUEST" Then Call alerts(LNG_BOARD_DELETE_ALERT06,"back","")
			If DataCnt > 1 Then Call alerts(LNG_BOARD_DELETE_ALERT05,"back","")
	End Select


	SQL = "SELECT [strPic] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		strImg = DKRS(0)

		strFilePath = REAL_PATH("board/pic") & "\" &  strImg
		strFilePath1 = REAL_PATH("board/index") & "\" & strImg
		strFilePath2 = REAL_PATH("board/thum") & "\" & strImg

		Call sbDeleteFiles(strFilePath) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
		Call sbDeleteFiles(strFilePath1) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
		Call sbDeleteFiles(strFilePath2) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
	End If
	Call closeRs(DKRS)

	SQL = "SELECT [strData1] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		strData1 = DKRS(0)
		If strData1 <> "" And Not IsNull(strData1) Then

			Dim strFilePath3
			'// C:\Files\TEST.doc 파일을 삭제합니다.
			'strFilePath3 = REAL_PATH("data/data1") & "\" &  strData1
			strFilePath3 = REAL_PATH2("/uploadData/data1") & "\" &  strData1


			Call sbDeleteFiles(strFilePath3) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
			DATAON1 = 1
		End If
	End If
	Call closeRs(DKRS)
	SQL = "SELECT [strData2] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		strData2 = DKRS(0)
		If strData2 <> "" And Not IsNull(strData2) Then

			Dim strFilePath4
			'// C:\Files\TEST.doc 파일을 삭제합니다.
			'strFilePath4 = REAL_PATH("data/data1") & "\" &  strData2
			strFilePath4 = REAL_PATH2("/uploadData/data2") & "\" &  strData2

			Call sbDeleteFiles(strFilePath4) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
			DATAON2 = 1
		End If
	End If
	Call closeRs(DKRS)
	SQL = "SELECT [strData3] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		strData3 = DKRS(0)

		If strData3 <> "" And Not IsNull(strData3) Then
			Dim strFilePath5
			'// C:\Files\TEST.doc 파일을 삭제합니다.
			'strFilePath5 = REAL_PATH("data/data3") & "\" &  strData3
			strFilePath5 = REAL_PATH2("/uploadData/data3") & "\" &  strData3

			Call sbDeleteFiles(strFilePath5) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
			DATAON3 = 1
		End If
	End If
	Call closeRs(DKRS)


	SQL = "SELECT [strPic1] FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [strBoardName] = ? AND [intIDX] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		strData4 = DKRS(0)

		If strData4 <> "" And Not IsNull(strData4) Then
			Dim strFilePath6
			'// C:\Files\TEST.doc 파일을 삭제합니다.
			strFilePath6 = REAL_PATH("data/pic1") & "\" &  strData4


			Call sbDeleteFiles(strFilePath6) '// 함수에서 해당 파일이 있으면 삭제처리합니다.
			DATAON4 = 1
		End If
	End If
	Call closeRs(DKRS)




	SQL = "SELECT [isPointUse],[intPointWrite],[intPointUpload],[intPointComment],[isPointDelete],[isPointDelComment] FROM [DK_NBOARD_POINT] WITH(NOLOCK) WHERE [strBoardName] = ?"
	arrParams = Array( _
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		isPointUse			= DKRS("isPointUse")
		intPointWrite		= DKRS("intPointWrite")
		intPointUpload		= DKRS("intPointUpload")
		intPointComment		= DKRS("intPointComment")
		isPointDelete		= DKRS("isPointDelete")
		isPointDelComment	= DKRS("isPointDelComment")
	End If
	Call closeRS(DKRS)

	DATAALLCHK = DATAON1 + DATAON2 + DATAON3 + DATAON4
'print DATAALLCHK

	Call Db.beginTrans(Nothing)


		If bDepth = 0 Then
			SQL = "DELETE FROM [DK_NBOARD_CONTENT] WHERE [strBoardName] = ? AND [intList] = ?"
			arrParams = Array( _
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				Db.makeParam("@intList",adInteger,adParamInput,4,bList) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

			SQL = "UPDATE [DK_NBOARD_CONTENT] SET [intNum] = [intNum] - 1 WHERE [intDepth] = 0 AND [strBoardName] = ? AND [intIDX] > ?"
			arrParams = Array( _
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				Db.makeParam("@intList",adInteger,adParamInput,4,bList) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		Else
			SQL = "DELETE FROM [DK_NBOARD_CONTENT] WHERE [strBoardName] = ? AND [intIDX] = ?"
			arrParams = Array( _
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				Db.makeParam("@intList",adInteger,adParamInput,4,bidx) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		End If

		If DK_MEMBER_LEVEL > 0 Then
			If isPointUse = "T" Then
				If intPointWrite <> 0 Then
					SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
					arrParams = Array(_
						Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointWrite),_
						Db.makeParam("@strUserID",adVarChar,adParamInput,20,WRITEID)_
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,-?,'게시물 삭제',CONCAT(?,'에 ',?,'게시물 삭제'))"
					arrParams = Array(_
						Db.makeParam("@strUserID",adVarChar,adParamInput,20,WRITEID),_
						Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointWrite),_
						Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
						Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _

					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					If isCSMemberOk = "T" Then Call FNC_CS_POINT_INPUT_WEB(WRITEID,0,"",intPointWrite,"901","WEB_POINT",strBoardName&" 에 "&bidx&" 게시물 삭제","")
				End If

				If DATAALLCHK > 0 Then
					If intPointUpload <> 0 Then
						SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
						arrParams = Array(_
							Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointUpload),_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,WRITEID)_
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
						SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,-?,'게시물 삭제시 자료 삭제',CONCAT(?,'에 ',?,'게시물 삭제'))"
						arrParams = Array(_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,WRITEID),_
							Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointUpload),_
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
							Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
						If isCSMemberOk = "T" Then Call FNC_CS_POINT_INPUT_WEB(WRITEID,0,"",intPointUpload,"907","WEB_POINT",strBoardName&" 에 "&bidx&" 게시물 삭제 - 자료삭제","")

					End If
				End If

			End If
		End If






	Call alertDB(LNG_BOARD_DELETE_ALERT07,"board_list.asp?bname="&strBoardName,"")









'PRINT	BOARDCODE
'PRINT bidx
'PRINT bList
'PRINT bDepth
'PRINT bRIDX
'print DataCnt





%>

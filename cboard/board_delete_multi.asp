<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<%


	If DK_MEMBER_TYPE <> "ADMIN" And DK_MEMBER_TYPE <> "OPERATOR" Then
		Call ALERTS(LNG_BOARD_DELETE_MULTI_ALERT01,"CLOSE","")
	End If
	moveIDX = Trim(pRequestTF("mchk",True))

	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		moveIDXencoe		= Trim(StrCipher.Decrypt(moveIDX,EncTypeKey1,EncTypeKey2))		'아이디
	Set StrCipher = Nothing

	moveIDXs = Split(moveIDXencoe,",")
	moveIDXc = UBound(moveIDXs)

	Call Db.beginTrans(Nothing)


	For i = 0 To moveIDXc

		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,moveIDXs(i))_
		)
		Set TIODKRS = Db.execRS("DKPA_NBOARD_MULTI_DELETE",DB_PROC,arrParams,Nothing)
		If Not TIODKRS.BOF And Not TIODKRS.EOF Then
			bidx			= moveIDXs(i)
			bList			= TIODKRS("intList")
			bDepth			= TIODKRS("intDepth")
			bRIDX			= TIODKRS("intRIDX")
			strBoardName	= TIODKRS("strBoardName")
		End If
		Call closeRs(TIODKRS)

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

		DATAALLCHK = DATAON1 + DATAON2 + DATAON3
	'print DATAALLCHK



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
						Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID)_
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,-?,'게시물 삭제',?+'에 게시물 삭제')"
					arrParams = Array(_
						Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
						Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointWrite),_
						Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				End If
				If DATAALLCHK > 0 Then
					If intPointUpload <> 0 Then
						SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
						arrParams = Array(_
							Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointUpload),_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID)_
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
						SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,-?,'게시물 삭제시 자료 삭제',?+'에 게시물 삭제')"
						arrParams = Array(_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
							Db.makeParam("@intPoint",adInteger,adParamInput,0,intPointUpload),_
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					End If
				End If
			End If
		End If
	Next
	Call alertDB(LNG_BOARD_DELETE_MULTI_ALERT02,"board_list.asp?bname="&strBoardName,"OC")




















'PRINT	BOARDCODE
'PRINT bidx
'PRINT bList
'PRINT bDepth
'PRINT bRIDX
'print DataCnt





%>

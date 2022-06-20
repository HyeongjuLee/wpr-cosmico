<%
	PAGE_SETTING2 = "SUBPAGE"
	
	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName)_
	)
	Set DKRS = Db.execRs("DKSP_NBOARD_CONFIG",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		PAGE_SETTING				= DKRS("strCateCode")
		strBoardTitle				= DKRS("strBoardTitle")
		strBoardType				= DKRS("strBoardType")
		strBoardSkin				= DKRS("strBoardSkin")
		isUse						= DKRS("isUse")
		isLeft						= DKRS("isLeft")
		strLeftMode					= DKRS("strLeftMode")
		isCategoryUse				= DKRS("isCategoryUse")
		isCommentUse				= DKRS("isCommentUse")

		isImg						= DKRS("isImg")
		strImg						= BACKWORD(DKRS("strImg"))

		intLevelList				= DKRS("intLevelList")
		intLevelView				= DKRS("intLevelView")
		intLevelWrite				= DKRS("intLevelWrite")
		intLevelReply				= DKRS("intLevelReply")
		intLevelCommentList			= DKRS("intLevelCommentList")
		intLevelCommentWrite		= DKRS("intLevelCommentWrite")
		intLevelCommentReply		= DKRS("intLevelCommentReply")
		intLevelUpload				= DKRS("intLevelUpload")
		intLevelDownload			= DKRS("intLevelDownload")

		mainVar						= DKRS("mainVar")
		subVar						= DKRS("subVar")
		tdHeight					= DKRS("tdHeight")

		isSearch					= DKRS("isSearch")
		intListView					= DKRS("intListView")
		isSMS						= DKRS("isSMS")
		defaultSMS					= DKRS("defaultSMS")
		newIconDate					= DKRS("newIconDate")
		isSubImg					= DKRS("isSubImg")
		SubImg						= BACKWORD(DKRS("SubImg"))
		sViewVar					= DKRS("sViewVar")
		isVote						= DKRS("isVote")						'좋아유(추천) DB 수동입력

		isVoteMaxLength = 100
		NB_intWriteLimit			= DKRS("intWriteLimit")
		NB_intReplyLimit			= DKRS("intReplyLimit")
		NB_isReplyLimitDate			= DKRS("isReplyLimitDate")
		NB_isGroupUse				= DKRS("isGroupUse")

		NB_isTopNotice				= DKRS("isTopNotice")
		NB_intTopNotice				= DKRS("intTopNotice")
		NB_isViewNameType			= DKRS("isViewNameType")
		NB_isViewNameChg			= DKRS("isViewNameChg")
		NB_intViewNameCnt			= DKRS("intViewNameCnt")

		NB_isTopBestView			= DKRS("isTopBestView")
		NB_intTopBestView			= DKRS("intTopBestView")
		NB_intTopBestLimit			= DKRS("intTopBestLimit")

		NBRS_isTopNavi				= DKRS("isTopNavi")
		NBRS_isTopMargin			= DKRS("isTopMargin")
		NBRS_intTopMargin			= DKRS("intTopMargin")
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRs(DKRS)

	'If strBoardName = "liner" Then
	'	isVoteMaxLength = 300
	'End If

	If PAGE_SETTING = "MYOFFICE" Then
		Select Case LCase(strBoardName)
			Case "myoffice"
				INFO_MODE	 = "NOTICE1-1"
			Case "qna"
				INFO_MODE	 = "NOTICE1-2"
			Case Else
				INFO_MODE	 = "NOTICE1-1"
		End Select
	End If

	mNum = mainVar
	sNum = subVar
	view = subVar
	sView = sViewVar


	ISSUBTOP = "T"
	ISSUBVISUAL = "F"

	'▣ 게시판 상단 내용 확인 S
		If NBRS_isTopNavi = "T" Then '게시판 상단 내비 사용 관련 내용 추가 예정
		End If

		If NBRS_isTopMargin = "T" Then

			FORUM_TOP_MARGIN = "margin-top:"&NBRS_intTopMargin&"px;"
		Else
			FORUM_TOP_MARGIN = ""
		End If



	'▣ 게시판 상단 내용 확인 E



	'▣ 이미지 확인 S
		If ISSUBTOP = "T" Then
			imgPath = VIR_PATH("board/subImg")&"/"&SubImg
			imgWidth = 0
			imgHeight = 0
			Call ImgInfo(imgPath,imgWidth,imgHeight,"")
			ViewTopImg = "<p>"&viewImg(imgPath,imgWidth,imgHeight,"")&"</p>"
		Else
			ViewTopImg = ""
		End If


		If isImg = "T" Then
			imgPath = VIR_PATH("board/topimg")&"/"&strImg
			imgWidth = 0
			imgHeight = 0
			Call ImgInfo(imgPath,imgWidth,imgHeight,"")
			ViewMenuImg = viewImg(imgPath,imgWidth,imgHeight,"")
		Else
			ViewMenuImg = ""
		End If
	'▣ 이미지 확인 E


	'▣ 회원인 경우 회원정보 가져오기 S
		If DK_MEMBER_LEVEL > 0 Then
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
			)
			Set DKRS = Db.execRs("DKP_NBOARD_MEMBER_INFO",DB_PROC,arrParams,Nothing)

			If Not DKRS.BOF And Not DKRS.EOF Then
				nb_strPass = DKRS("strPass")
				nb_strEmail = DKRS("strEmail")
				nb_strMobile = DKRS("strMobile")

				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
						If nb_strEmail		<> "" Then nb_strEmail	= objEncrypter.Decrypt(nb_strEmail)
						If nb_strMobile		<> "" Then nb_strMobile	= objEncrypter.Decrypt(nb_strMobile)
					On Error GoTo 0
				Set objEncrypter = Nothing

			End If
		End If
	'▣ 회원인 경우 회원정보 가져오기 E




	'▣ 게시판 글쓰기 제한 확인 S
		Function FN_CHECK_BOARD_WRITE_COUNT(ByVal sbn, ByVal dmi, ByVal limits, ByVal types)
			arrParams_NB = array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,sbn), _
				Db.makeParam("@toDay",adVarChar,adParamInput,10,Left(NoW,10)), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,dmi) _
			)
			toDayBcount = Db.execRsData("[DKP_NBOARD_WRITE_COUNT_CHECK]",DB_PROC,arrParams_NB,Nothing)
			FN_CHECK_BOARD_WRITE_COUNT = "T"

			If limits > 0 Then
				Select Case types
					Case "A"
						If CDbl(toDayBcount) >= CDbl(limits) Then
							Call ALERTS("해당 게시판의 일일 작성 한도를 초과하셨습니다. 익일 새로 작성해주세요\n해당 게시판의 일일 글쓰기는 "&limits&" 회입니다","BACK","")
						End If
					Case "TF"
						If CDbl(toDayBcount) >= CDbl(limits) Then
							FN_CHECK_BOARD_WRITE_COUNT = "F"
						Else
							FN_CHECK_BOARD_WRITE_COUNT = "T"
						End If
				End Select
			End If
		End Function

	'▣ 게시판 글쓰기 제한 확인 E

	'▣ 게시판 글쓰기 제한 확인 S
		Function FN_CHECK_BOARD_WRITE_COUNT_KIN(ByVal sbn, ByVal dmi, ByVal limits, ByVal types, ByVal depth)
			arrParams_NB = array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,sbn), _
				Db.makeParam("@toDay",adVarChar,adParamInput,10,Left(NoW,10)), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,dmi), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,depth) _
			)
			toDayBcount = Db.execRsData("[DKSP_NBOARD_WRITE_COUNT_CHECK_KIN]",DB_PROC,arrParams_NB,Nothing)
			FN_CHECK_BOARD_WRITE_COUNT_KIN = "T"

			If limits > 0 Then
				Select Case types
					Case "A"
						If CDbl(toDayBcount) >= CDbl(limits) Then
							Call ALERTS("해당 게시판의 일일 작성 한도를 초과하셨습니다. 익일 새로 작성해주세요\n해당 게시판의 일일 글쓰기는 "&limits&" 회입니다","BACK","")
						End If
					Case "TF"
						If CDbl(toDayBcount) >= CDbl(limits) Then
							FN_CHECK_BOARD_WRITE_COUNT_KIN = "F"
						Else
							FN_CHECK_BOARD_WRITE_COUNT_KIN = "T"
						End If
				End Select
			End If
		End Function

	'▣ 게시판 글쓰기 제한 확인 E



	'▣ 그룹데이터 확인 S
		If NB_isGroupUse = "T" Then
			If DK_MEMBER_STYPE = "0" Then
				GroupData = DKRSG_businesscode
				If DKRSG_businesscode = "" Then	Call ALERTS("센터에 가입되어있는 판매원 등급의 회원만 접근이 가능합니다","BACK","")
			Else
				Call ALERTS("센터에 가입되어있는 판매원 등급의 회원만 접근이 가능합니다","BACK","")
			End If
			BBS_SUBJECT_ADD1 = RS_BusinessName
		Else
			GroupData = ""
			BBS_SUBJECT_ADD1 = ""
		End If
		strBoardTitle = strBoardTitle & BBS_SUBJECT_ADD1
	'▣ 그룹데이터 확인 E

	Function FNC_HOME_POINT_INSERT(ByVal strBoardName, ByVal pType, ByVal memberid, ByVal values, ByVal vComment, ByVal dComment)

		DKRS9_isPointUse = "F"
		If strBoardName <> "" Then
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


				Select Case pType
					Case "view"				thisValue = DKRS9_intPointView
					Case "write"			thisValue = DKRS9_intPointWrite
					Case "reply"			thisValue = DKRS9_intPointReply
					Case "upload"			thisValue = DKRS9_intPointUpload
					Case "download"			thisValue = DKRS9_intPointDownload
					Case "comment"			thisValue = DKRS9_intPointComment
					Case "vote"				thisValue = DKRS9_intPointVote
					Case "delete"			thisValue = DKRS9_isPointDelete
					Case "delcomment"		thisValue = DKRS9_isPointDelComment
					Case "votewriter"		thisValue = DKRS9_intPointVoteWriter
					Case Else				thisValue = values
				End Select
			End If
		Else
			DKRS9_isPointUse = "T"
			thisValue = values
		End If
		Call closeRs(DKRS9)

		If DKRS9_isPointUse = "T" Then
			SQL = "INSERT INTO [DK_MEMBER_POINT_LOG]([strUserID],[intValue],[ValueComment],[dComment]) VALUES (?,?,?,?)"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,memberid),_
				Db.makeParam("@intValue",adInteger,adParamInput,20,thisValue),_
				Db.makeParam("@ValueComment",adVarChar,adParamInput,50,vComment),_
				Db.makeParam("@dComment",adVarChar,adParamInput,200,dComment) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		End If
	End Function







%>

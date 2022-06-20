<%
	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName)_
	)
	Set DKRS = Db.execRs("DKSP_NBOARD_CONFIG",DB_PROC,arrParams,Nothing)
	'Set DKRS = Db.execRs("DKP_NBOARD_CONFIG",DB_PROC,arrParams,Nothing)

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
		strImg						= DKRS("strImg")

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
		SubImg						= DKRS("SubImg")
		sViewVar					= DKRS("sViewVar")
		isVote						= DKRS("isVote")						'좋아유(추천)

		isVoteMaxLength = 100
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRs(DKRS)

	mNum = mainVar
	view = subVar
	sView = sViewVar

	ISSUBVISUAL = "F"

	ISSUBTOP = isSubImg
	SUB_TOP_WIDTH = 780
	SUB_TOP_HEIGHT = 65

	SUB_TOP_IMG = VIR_PATH("board/sub_Img")&"/"&SubImg

	' 이미지 확인
'		If isImg = "T" Then
'			imgPath = VIR_PATH("board/topimg")&"/"&strImg
'			imgWidth = 0
'			imgHeight = 0
'			Call ImgInfo(imgPath,imgWidth,imgHeight,"")
'			ViewTopImg = "<p>"&viewImg(SUB_TOP_IMG,SUB_TOP_WIDTH,SUB_TOP_HEIGHT,"")&"</p><p>"&viewImg(imgPath,imgWidth,imgHeight,"")&"</p>"
'		Else
'			ViewTopImg = ""
'		End If

' 윈홀딩스 전용
		If isImg = "T" Then
			imgPath = VIR_PATH("board/topimg")&"/"&strImg
			imgWidth = 0
			imgHeight = 0
			Call ImgInfo(imgPath,imgWidth,imgHeight,"")
			ViewMenuImg = viewImg(imgPath,imgWidth,imgHeight,"")
		Else
			ViewMenuImg = ""
		End If

	' 회원인 경우 회원정보 가져오기
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


	' 이미지 치환 확인하기




'	Select Case strBoardName
'		Case "notice","myoffice"
'			strBoardTitle = LNG_CUSTOMER_01
'		Case "qna"
'			strBoardTitle = LNG_CUSTOMER_04
'		Case Else
'			Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"go","/m")
'	End Select


%>
<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage =65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode = upForm("mode",True)


	strBoardName		= upForm("strBoardName",True)

	Select Case mode
'************* 게시판 생성
		Case "CREATE"
			idcheck				= upForm("idcheck",True)
			strCateCode			= upForm("strCateCode",True)
			strBoardTitle		= upForm("strBoardTitle",True)
			strBoardType		= upForm("strBoardType",True)
			strBoardSkin		= "basic"
			isUse				= upForm("isUse",True)

			isLeft				= "T"
			strLeftMode			= ""

			isCategoryUse		= upForm("isCategoryUse",True)
			isCommentUse		= upForm("isCommentUse",True)

			If idcheck <> strBoardName Then Call ALERTS("중복확인이 정상적으로 되지 못했습니다.","back","")


			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@cate1",adVarChar,adParamInput,20,strCateCode),_
				Db.makeParam("@strBoardTitle",adVarWChar,adParamInput,100,strBoardTitle),_
				Db.makeParam("@strBoardType",adVarChar,adParamInput,50,strBoardType),_
				Db.makeParam("@strBoardSkin",adVarChar,adParamInput,50,strBoardSkin),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_
				Db.makeParam("@isLeft",adChar,adParamInput,1,isLeft),_
				Db.makeParam("@strLeftMode",adVarChar,adParamInput,20,strLeftMode),_
				Db.makeParam("@isCategoryUse",adChar,adParamInput,1,isCategoryUse),_
				Db.makeParam("@isCommentUse",adChar,adParamInput,1,isCommentUse),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_CREATE",DB_PROC,arrParams,Nothing)

' ****************** 기본 설정 시작
		Case "CONFIG"
			strCateCode			= upForm("strCateCode",True)
			strBoardTitle		= upForm("strBoardTitle",True)
			'strBoardType		= "board"'upForm("strBoardType",True)
			strBoardType		= upForm("strBoardType",True)
			'strBoardSkin		= upForm("strBoardSkin",True)
			isUse				= upForm("isUse",True)

			'isLeft				= upForm("isLeft",True)
			'strLeftMode			= upForm("strLeftMode",False)

			'isCategoryUse		= upForm("isCategoryUse",True)
			isCommentUse		= upForm("isCommentUse",True)
			blockWord			= upForm("blockWord",False)
			blockWordChg		= upForm("blockWordChg",False)
			defaultWord			= upForm("defaultWord",False)
			isSearch			= upForm("isSearch",False)
			intListView			= upForm("intListView",False)
			isSMS				= upForm("isSMS",True)
			defaultSMS			= upForm("defaultSMS",False)
			newIconDate			= upForm("newIconDate",True)

			o_strImg			= upForm("o_strImg",False)
			o_SubImg			= upForm("o_SubImg",False)

			isImg				= upForm("isImg",False)
			isSubImg			= upForm("isSubImg",False)

			mainVar				= upForm("mainVar",False)
			subVar				= upForm("subVar",False)
			sViewVar			= upForm("sViewVar",False)		'sview
			isVote				= upForm("isVote",False)		: If isVote = "" Then isVote = "F"

			intWriteLimit		= upForm("intWriteLimit",False)	: If intWriteLimit = "" Then intWriteLimit = 0
			intReplyLimit		= upForm("intReplyLimit",False)	: If intReplyLimit = "" Then intReplyLimit = 0
			isReplyLimitDate	= upForm("isReplyLimitDate",True)
			isGroupUse			= upForm("isGroupUse",True)

			isTopNotice			= upForm("isTopNotice",True)
			intTopNotice		= upForm("intTopNotice",True)
			isViewNameType		= upForm("isViewNameType",True)
			isViewNameChg		= upForm("isViewNameChg",True)
			intViewNameCnt		= upForm("intViewNameCnt",True)


			isTopBestView		= upForm("isTopBestView",False)		: If isTopBestView		= "" Then isTopBestView		= "F"
			intTopBestView		= upForm("intTopBestView",False)	: If intTopBestView		= "" Then intTopBestView	= 0
			intTopBestLimit		= upForm("intTopBestLimit",False)	: If intTopBestLimit	= "" Then intTopBestLimit	= 0

			isTopNavi			= upForm("isTopNavi",False)		: If isTopNavi		= "" Then isTopNavi		= "F"
			isTopMargin			= upForm("isTopMargin",False)	: If isTopMargin	= "" Then isTopMargin	= "F"
			intTopMargin		= upForm("intTopMargin",False)	: If intTopMargin	= "" Then intTopMargin	= 0




			If o_strImg = "" Then o_strImg = ""
			If o_SubImg = "" Then o_SubImg = ""
			If mainVar = "" Then mainVar = ""
			If subVar = "" Then subVar = ""
			If sViewVar = "" Then sViewVar = 0

			If Upload.Form("strImg") <> "" Then strImg = upImg("strImg",REAL_PATH("board\topImg")) Else strImg = o_strImg End If
			If Upload.Form("SubImg") <> "" Then SubImg = upImg("SubImg",REAL_PATH("board\SubImg")) Else SubImg = o_SubImg End If



			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@strCateCode",adVarChar,adParamInput,20,strCateCode),_
				Db.makeParam("@strBoardTitle",adVarChar,adParamInput,100,strBoardTitle),_
				Db.makeParam("@strBoardType",adVarChar,adParamInput,50,strBoardType),_

				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_
				Db.makeParam("@isCommentUse",adChar,adParamInput,1,isCommentUse),_

				Db.makeParam("@blockWord",adVarChar,adParamInput,MAX_LENGTH,blockWord),_
				Db.makeParam("@blockWordChg",adVarChar,adParamInput,20,blockWordChg),_
				Db.makeParam("@defaultWord",adVarChar,adParamInput,MAX_LENGTH,defaultWord),_
				Db.makeParam("@isSearch",adChar,adParamInput,1,isSearch),_
				Db.makeParam("@intListView",adInteger,adParamInput,4,intListView),_

				Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_
				Db.makeParam("@defaultSMS",adVarChar,adParamInput,200,defaultSMS),_
				Db.makeParam("@newIconDate",adInteger,adParamInput,4,newIconDate),_

				Db.makeParam("@isImg",adChar,adParamInput,1,isImg),_
				Db.makeParam("@isSubImg",adChar,adParamInput,1,isSubImg),_

				Db.makeParam("@strImg",adVarWChar,adParamInput,200,strImg),_
				Db.makeParam("@SubImg",adVarWChar,adParamInput,200,SubImg),_

				Db.makeParam("@mainVar",adInteger,adParamInput,4,mainVar),_
				Db.makeParam("@subVar",adInteger,adParamInput,4,subVar),_
				Db.makeParam("@sViewVar",adInteger,adParamInput,4,sViewVar),_
				Db.makeParam("@isVote",adChar,adParamInput,1,isVote),_
				Db.makeParam("@intWriteLimit",adInteger,adParamInput,4,intWriteLimit),_
				Db.makeParam("@intReplyLimit",adInteger,adParamInput,4,intReplyLimit),_
				Db.makeParam("@isReplyLimitDate",adChar,adParamInput,1,isReplyLimitDate),_
				Db.makeParam("@isGroupUse",adChar,adParamInput,1,isGroupUse),_

				Db.makeParam("@isTopNotice",adChar,adParamInput,1,isTopNotice), _
				Db.makeParam("@intTopNotice",adInteger,adParamInput,4,intTopNotice), _
				Db.makeParam("@isViewNameType",adChar,adParamInput,1,isViewNameType), _
				Db.makeParam("@isViewNameChg",adChar,adParamInput,1,isViewNameChg), _
				Db.makeParam("@intViewNameCnt",adInteger,adParamInput,4,intViewNameCnt), _

				Db.makeParam("@isTopBestView",adChar,adParamInput,1,isTopBestView), _
				Db.makeParam("@intTopBestView",adInteger,adParamInput,4,intTopBestView), _
				Db.makeParam("@intTopBestLimit",adInteger,adParamInput,4,intTopBestLimit), _

				Db.makeParam("@isTopNavi",adChar,adParamInput,1,isTopNavi), _
				Db.makeParam("@isTopMargin",adChar,adParamInput,1,isTopMargin), _
				Db.makeParam("@intTopMargin",adInteger,adParamInput,4,intTopMargin), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKSP_FORUM_CONFIG_UPDATE_ADMIN",DB_PROC,arrParams,Nothing)
' 레벨 조정 시작
		Case "LEVEL"
			intLevelList				= upForm("intLevelList",True)
			intLevelView				= upForm("intLevelView",True)
			intLevelWrite				= upForm("intLevelWrite",True)
			intLevelReply				= upForm("intLevelReply",True)
			intLevelCommentList			= upForm("intLevelCommentList",True)
			intLevelCommentWrite		= upForm("intLevelCommentWrite",True)
			intLevelCommentReply		= upForm("intLevelCommentReply",True)
			intLevelUpload				= upForm("intLevelUpload",True)
			intLevelDownload			= upForm("intLevelDownload",True)





			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@intLevelList",adInteger,adParamInput,0,intLevelList), _
				Db.makeParam("@intLevelView",adInteger,adParamInput,0,intLevelView), _
				Db.makeParam("@intLevelWrite",adInteger,adParamInput,0,intLevelWrite), _
				Db.makeParam("@intLevelReply",adInteger,adParamInput,0,intLevelReply), _
				Db.makeParam("@intLevelCommentList",adInteger,adParamInput,0,intLevelCommentList), _
				Db.makeParam("@intLevelCommentWrite",adInteger,adParamInput,0,intLevelCommentWrite), _
				Db.makeParam("@intLevelCommentReply",adInteger,adParamInput,0,intLevelCommentReply), _
				Db.makeParam("@intLevelUpload",adInteger,adParamInput,0,intLevelUpload), _
				Db.makeParam("@intLevelDownload",adInteger,adParamInput,0,intLevelDownload), _


				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_LEVEL_UPDATE",DB_PROC,arrParams,Nothing)

' ****************** 카테고리 추가
		Case "CATEGORYINSERT"
			CateName			= upForm("CateName",True)
			isUseTF				= upForm("isUseTF",False)
			If isUseTF = "" Then isUseTF = "F"

			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@CateName",adVarChar,adParamInput,50,CateName), _
				Db.makeParam("@isUseTF",adChar,adParamInput,1,isUseTF), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_CATEGORY_INSERT",DB_PROC,arrParams,Nothing)
' ****************** 카테고리 추가
		Case "POINT"
			isPointUse			= upForm("isPointUse",True)
			intPointView		= upForm("intPointView",True)
			intPointWrite		= upForm("intPointWrite",True)
			'intPointReply		= 0
			intPointReply		= upForm("intPointReply",True)
			intPointUpload		= upForm("intPointUpload",True)
			intPointDownload	= upForm("intPointDownload",True)
			intPointComment		= upForm("intPointComment",True)
			intPointVote		= upForm("intPointVote",True)
			isPointDelete		= upForm("isPointDelete",True)
			isPointDelComment	= upForm("isPointDelComment",True)
			intPointVoteWriter		= upForm("intPointVoteWriter",True)


			'If Not IsNumeric(isPointUse) Then isPointUse = 0
			If Not IsNumeric(intPointView) Then intPointView = 0
			If Not IsNumeric(intPointWrite) Then intPointWrite = 0
			If Not IsNumeric(intPointReply) Then intPointReply = 0
			If Not IsNumeric(intPointUpload) Then intPointUpload = 0
			If Not IsNumeric(intPointDownload) Then intPointDownload = 0
			If Not IsNumeric(intPointComment) Then intPointComment = 0
			If Not IsNumeric(intPointVote) Then intPointVote = 0
			If Not IsNumeric(intPointVoteWriter) Then intPointVoteWriter = 0
			If isPointDelete = "" Then isPointDelete = "T"
			If isPointDelComment = "" Then isPointDelComment = "T"


			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@isPointUse",adChar,adParamInput,1,isPointUse), _
				Db.makeParam("@intPointView",adInteger,adParamInput,0,intPointView), _
				Db.makeParam("@intPointWrite",adInteger,adParamInput,0,intPointWrite), _
				Db.makeParam("@intPointReply",adInteger,adParamInput,0,intPointReply), _
				Db.makeParam("@intPointUpload",adInteger,adParamInput,0,intPointUpload), _
				Db.makeParam("@intPointDownload",adInteger,adParamInput,0,intPointDownload), _
				Db.makeParam("@intPointComment",adInteger,adParamInput,0,intPointComment), _
				Db.makeParam("@intPointVote",adInteger,adParamInput,0,intPointVote), _
				Db.makeParam("@isPointDelete",adChar,adParamInput,1,isPointDelete), _
				Db.makeParam("@isPointDelComment",adChar,adParamInput,1,isPointDelComment), _
				Db.makeParam("@intPointVoteWriter",adInteger,adParamInput,4,intPointVoteWriter), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_POINT_UPDATE",DB_PROC,arrParams,Nothing)
		Case "WRITE"
			isEditor			= upForm("isEditor",True)
			intEditorLevel		= upForm("intEditorLevel",True)
			isEmail				= upForm("isEmail",True)
			isEmailTF			= upForm("isEmailTF",True)
			isMobile			= upForm("isMobile",True)
			isMobileTF			= upForm("isMobileTF",True)
			isTel				= upForm("isTel",True)
			isTelTF				= upForm("isTelTF",True)
			isData1				= upForm("isData1",True)
			isData1TF			= upForm("isData1TF",True)
			intData1MB			= upForm("intData1MB",True)
			isData2				= upForm("isData2",True)
			isData2TF			= upForm("isData2TF",True)
			intData2MB			= upForm("intData2MB",True)
			isData3				= upForm("isData3",True)
			isData3TF			= upForm("isData3TF",True)
			intData3MB			= upForm("intData3MB",True)
			isPic				= upForm("isPic",True)
			isPicTF				= upForm("isPicTF",True)
			intPicMB			= upForm("intPicMB",True)
			isLink				= upForm("isLink",True)
			isLinkTF			= upForm("isLinkTF",True)
			'이미지1,2,3 추가
			isPic1    			= upForm("isPic1",True)
			isPic1TF  			= upForm("isPic1TF",True)
			intPic1MB 			= upForm("intPic1MB",True)
			isPic2    			= upForm("isPic2",True)
			isPic2TF  			= upForm("isPic2TF",True)
			intPic2MB 			= upForm("intPic2MB",True)
			isPic3    			= upForm("isPic3",True)
			isPic3TF  			= upForm("isPic3TF",True)
			intPic3MB 			= upForm("intPic3MB",True)

			isMovie 			= upForm("isMovie",True)
			isMovieTF 			= upForm("isMovieTF",True)

			intContentMinLimit 			= upForm("intContentMinLimit",True)
			intReplyMinLimit 			= upForm("intReplyMinLimit",True)

			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@isEditor",adChar,adParamInput,1,isEditor),_
				Db.makeParam("@intEditorLevel",adInteger,adParamInput,0,intEditorLevel), _
				Db.makeParam("@isEmail",adChar,adParamInput,1,isEmail), _
				Db.makeParam("@isEmailTF",adChar,adParamInput,1,isEmailTF), _
				Db.makeParam("@isMobile",adChar,adParamInput,1,isMobile), _
				Db.makeParam("@isMobileTF",adChar,adParamInput,1,isMobileTF), _
				Db.makeParam("@isTel",adChar,adParamInput,1,isTel), _
				Db.makeParam("@isTelTF",adChar,adParamInput,1,isTelTF), _
				Db.makeParam("@isData1",adChar,adParamInput,1,isData1), _
				Db.makeParam("@isData1TF",adChar,adParamInput,1,isData1TF), _
				Db.makeParam("@intData1MB",adInteger,adParamInput,0,intData1MB), _
				Db.makeParam("@isData2",adChar,adParamInput,1,isData2), _
				Db.makeParam("@isData2TF",adChar,adParamInput,1,isData2TF), _
				Db.makeParam("@intData2MB",adInteger,adParamInput,0,intData2MB), _
				Db.makeParam("@isData3",adChar,adParamInput,1,isData3), _
				Db.makeParam("@isData3TF",adChar,adParamInput,1,isData3TF), _
				Db.makeParam("@intData3MB",adInteger,adParamInput,0,intData3MB), _
				Db.makeParam("@isPic",adChar,adParamInput,1,isPic), _
				Db.makeParam("@isPicTF",adChar,adParamInput,1,isPicTF), _
				Db.makeParam("@intPicMB",adInteger,adParamInput,0,intPicMB), _
				Db.makeParam("@isLink",adChar,adParamInput,1,isLink), _
				Db.makeParam("@isLinkTF",adChar,adParamInput,1,isLinkTF), _

				Db.makeParam("@isPic1",adChar,adParamInput,1,isPic1), _
				Db.makeParam("@isPic1TF",adChar,adParamInput,1,isPic1TF), _
				Db.makeParam("@intPic1MB",adInteger,adParamInput,0,intPic1MB), _
				Db.makeParam("@isPic2",adChar,adParamInput,1,isPic2), _
				Db.makeParam("@isPic2TF",adChar,adParamInput,1,isPic2TF), _
				Db.makeParam("@intPic2MB",adInteger,adParamInput,0,intPic2MB), _
				Db.makeParam("@isPic3",adChar,adParamInput,1,isPic3), _
				Db.makeParam("@isPic3TF",adChar,adParamInput,1,isPic3TF), _
				Db.makeParam("@intPic3MB",adInteger,adParamInput,0,intPic3MB), _

				Db.makeParam("@isMovie",adChar,adParamInput,1,isMovie), _
				Db.makeParam("@isMovieTF",adChar,adParamInput,1,isMovieTF), _

				Db.makeParam("@intContentMinLimit",adInteger,adParamInput,4,intContentMinLimit), _
				Db.makeParam("@intReplyMinLimit",adInteger,adParamInput,4,intReplyMinLimit), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_WRITE_UPDATE",DB_PROC,arrParams,Nothing)

		Case "READ"
			intEmailLevel		= upForm("intEmailLevel",False)
			intMobileLevel		= upForm("intMobileLevel",False)
			intTelLevel			= upForm("intTelLevel",False)
			intData1Level		= upForm("intData1Level",False)
			intData2Level		= upForm("intData2Level",False)
			intData3Level		= upForm("intData3Level",False)
			intLinkLevel		= upForm("intLinkLevel",False)



			If intEmailLevel		= "" Then intEmailLevel = 10
			If intMobileLevel		= "" Then intMobileLevel = 10
			If intTelLevel			= "" Then intTelLevel = 10
			If intData1Level		= "" Then intData1Level = 10
			If intData2Level		= "" Then intData2Level = 10
			If intData3Level		= "" Then intData3Level = 10
			If intLinkLevel			= "" Then intLinkLevel = 10



			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_

				Db.makeParam("@intEmailLevel",adInteger,adParamInput,0,intEmailLevel), _
				Db.makeParam("@intMobileLevel",adInteger,adParamInput,0,intMobileLevel), _
				Db.makeParam("@intTelLevel",adInteger,adParamInput,0,intTelLevel), _
				Db.makeParam("@intData1Level",adInteger,adParamInput,0,intData1Level), _
				Db.makeParam("@intData2Level",adInteger,adParamInput,0,intData2Level), _
				Db.makeParam("@intData3Level",adInteger,adParamInput,0,intData3Level), _
				Db.makeParam("@intLinkLevel",adInteger,adParamInput,0,intLinkLevel), _


				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR")_
			)
			Call Db.exec("DKPA_FORUM_READ_UPDATE",DB_PROC,arrParams,Nothing)





End Select


	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	Select Case OUTPUT_VALUE
		Case "ERROR"
			Call ALERTS("저장중 오류가 발생하였습니다.","back","")
		Case "FINISH"
			Select Case mode
				Case "CREATE"			: Call ALERTS("정상처리되었습니다.","go","forum_Regist.asp")
				Case "CONFIG"			: Call ALERTS("정상처리되었습니다.","go","forumConfig.asp?bname="&strBoardName)
				Case "LEVEL"			: Call ALERTS("정상처리되었습니다.","go","forumLevelConfig.asp?bname="&strBoardName)
				Case "CATEGORYINSERT"	: Call ALERTS("정상처리되었습니다.","go","forumCategoryConfig.asp?bname="&strBoardName)
				Case "POINT"			: Call ALERTS("정상처리되었습니다.","go","forumPointConfig.asp?bname="&strBoardName)
				Case "WRITE"			: Call ALERTS("정상처리되었습니다.","go","forumWriteConfig.asp?bname="&strBoardName)
				Case "READ"				: Call ALERTS("정상처리되었습니다.","go","forumViewConfig.asp?bname="&strBoardName)
			End Select
		End Select



%>




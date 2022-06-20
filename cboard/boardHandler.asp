<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	Call noCache

	If DOMAIN_NAME_IS = "" Then DOMAIN_NAME_IS = PUSH_DOMAIN_IS

		MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)


		Set Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
		Upload.MaxBytesToAbort = MaxFileAbort
		Upload.Start REAL_PATH("Temps")


		strDomain		= upfORM("strDomain",True)
		strBoardName	= upfORM("strBoardName",True)
		mode			= upfORM("mode",True)

		strUserID		= upfORM("strUserID",False)
		strName			= upfORM("strName",True)
		strSubject		= upfORM("strSubject",True)

		WYG_MOD			= upfORM("WYG_MOD",False)

		'If WYG_MOD = "T" Then
		'	strContent		= upfORM1("Content1",True)
		'Else
			strContent		= upfORM("Content1",True)
		'End If

		strEmail		= upfORM("strEmail",False)
		strTel			= upfORM("strTel",False)
		strMobile		= upfORM("strMobile",False)
		strPass			= upfORM("strPass",False)
		isSecret		= upfORM("isSecret",False)
		If isSecret = "" Then isSecret = "F"
		strLink			= upfORM("strLink",False)
		'strLink2 = upfORM("strLink2",False)

		category		= upfORM("category",False)
		ostrPic			= upfORM("ostrPic",False)
		ostrData1		= upfORM("ostrData1",False)
		ostrData2		= upfORM("ostrData2",False)
		ostrData3		= upfORM("ostrData3",False)
		'이미지1,2,3 추가
		ostrPic1		= upfORM("ostrPic1",False)
		ostrPic2		= upfORM("ostrPic2",False)
		ostrPic3		= upfORM("ostrPic3",False)

		hostIP			= upfORM("hostIP",False)
		If hostIP = "" Then hostIP = getUserIP()



		intList			= upfORM("intList",False)
		intDepth		= upfORM("intDepth",False)
		intRIDX			= upfORM("intRIDX",False)

		isNotice		= upfORM("isNotice",False)
		If isNotice = "" Then isNotice = "FF"


		regDate1		= upfORM("regDate1",False)
		regDate2		= upfORM("regDate2",False)
		readCnt			= upfORM("readCnt",False)
		If readCnt = "" Or Not IsNumeric(readCnt) Then readCnt = 0

		isMainNotice	= upfORM("isMainNotice",False)
		If isMainNotice = "" Then isMainNotice = "F"


		movieURL		= upfORM("movieURL",False)		'추가
		movieType		= upfORM("movieType",False)		'추가


		strReplyDateS		= upfORM("strReplyDateS",False)		'추가
		strReplyDateE		= upfORM("strReplyDateE",False)		'추가
		If (strReplyDateS = "" And strReplyDateE <> "") Or (strReplyDateS <> "" And strReplyDateE = "") Then Call ALERTS("댓글허용일자선택은 시작일과 종료일 모두를 선택해야합니다","BACK","")

		PB =  upfORM("PB",False)

		'base64 문자형 이미지 체크
		If checkDataImages(strContent) Then Call ALERTS("문자형이미지(드래그 이미지)는 사용할 수 없습니다.","back","")

%>
<!--#include file = "board_config.asp"-->
<%


	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)
	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_WRITE",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		isEditor			= DKRS("isEditor")
		intEditorLevel		= DKRS("intEditorLevel")
		isEmail				= DKRS("isEmail")
		isEmailTF			= DKRS("isEmailTF")
		isMobile			= DKRS("isMobile")
		isMobileTF			= DKRS("isMobileTF")
		isTel				= DKRS("isTel")
		isTelTF				= DKRS("isTelTF")
		isData1				= DKRS("isData1")
		isData1TF			= DKRS("isData1TF")
		intData1MB			= DKRS("intData1MB")
		isData2				= DKRS("isData2")
		isData2TF			= DKRS("isData2TF")
		intData2MB			= DKRS("intData2MB")
		isData3				= DKRS("isData3")
		isData3TF			= DKRS("isData3TF")
		intData3MB			= DKRS("intData3MB")
		isPic				= DKRS("isPic")
		isPicTF				= DKRS("isPicTF")
		intPicMB			= DKRS("intPicMB")
		isLink				= DKRS("isLink")
		isLinkTF			= DKRS("isLinkTF")
	Else
		'Call ALERTS(LNG_BOARD_HANDLER_TEXT01,"back","")
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)


		UPLOADPOINT = "F"


		MaxDataSize1 = intData1MB * 1024 * 1024 ' 실제 Data1의 업로드 시킬 파일 사이즈
		MaxDataSize2 = intData2MB * 1024 * 1024 ' 실제 Data2의 업로드 시킬 파일 사이즈
		MaxDataSize3 = intData3MB * 1024 * 1024 ' 실제 Data3의 업로드 시킬 파일 사이즈
		MaxMovieSize = 100 * 1024 * 1024 ' 실제 Movie의 업로드 시킬 파일 사이즈
		MaxPicSize1 = intPicMB * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

		strData1 = FN_FILEUPLOAD("strData1","F",MaxDataSize1,REAL_PATH2("/uploadData/data1"),ostrData1)
		strData2 = FN_FILEUPLOAD("strData2","F",MaxDataSize2,REAL_PATH2("/uploadData/data2"),ostrData2)
		strData3 = FN_FILEUPLOAD("strData3","F",MaxDataSize3,REAL_PATH2("/uploadData/data3"),ostrData3)


		If Upload.Form("strPic") <> "" Then
			strPic = uploadImg("strPic",REAL_PATH("board\OriginalPic"),REAL_PATH("board\pic"),650,650)
			Call ThumImg(strPic,REAL_PATH("board\pic"),REAL_PATH("board\thum"),300,200)
			Call ThumImg(strPic,REAL_PATH("board\pic"),REAL_PATH("board\index"),115,75)
		Else
			strPic = ostrPic
		End If

		'이미지1,2,3 추가
		If Upload.Form("strPic1") <> "" Then
			strPic1 = uploadImgTabs2("strPic1",REAL_PATH("board\OriginalPic"),REAL_PATH("board\pic1"),600,800)
			UPLOADPOINT = "T"
		Else
			strPic1 = ostrPic1
		End If
		If Upload.Form("strPic2") <> "" Then
			strPic2 = uploadImgTabs2("strPic2",REAL_PATH("board\OriginalPic"),REAL_PATH("board\pic2"),650,650)
		Else
			strPic2 = ostrPic2
		End If
		If Upload.Form("strPic3") <> "" Then
			strPic3 = uploadImgTabs2("strPic3",REAL_PATH("board\OriginalPic"),REAL_PATH("board\pic3"),650,650)
		Else
			strPic3 = ostrPic3
		End If

		Select Case mode
' **************** INSERT
			Case "INSERT"
				If regDate1 = "" Or regDate2 = "" Then
					inputDate = Now
				Else
					inputDate = regDate1 & " " & regDate2
				End If
				If IsDate(inputDate) = False Then Call ALERTS(LNG_BOARD_HANDLER_TEXT05,"back","")

				If strPass <> "" Then
					Function checkPass(ByVal value, ByVal min, ByVal max)
						checkPass = eRegiTest(value, "^[a-zA-Z0-9]{"& min &","& max &"}$")
						'checkPass = eRegiTest(value, "^[a-zA-Z0-9`~!@#$%^&*()-_=+{}\|?]{"& min &","& max &"}$")		'특수문자포함, check.js 동시변경
					End Function

					If Not checkPass(strPass, 6, 20) Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK,"CLOSE","")
				End If

				Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
					If strPass	<> "" Then strPass	= objEncrypter.Encrypt(strPass)
					On Error GoTo 0
				Set objEncrypter = Nothing

				Select Case DK_MEMBER_TYPE
					Case "GUEST"
						If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
					Case "MEMBER","COMPANY"
						If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
						If LCase(strBoardType) = "kin" Then
							If NB_intWriteLimit > 0 Then Call FN_CHECK_BOARD_WRITE_COUNT_KIN(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"A","0")
						Else
							If NB_intWriteLimit > 0 Then Call FN_CHECK_BOARD_WRITE_COUNT(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"A")
						End If
					Case "ADMIN","OPERATOR"

					Case "SADMIN"
						If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
							If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
						End If
					Case Else
						Call ALERTS(LNG_JS_MEMBER_LEVEL_NO_EXIST,"back","")
				End Select


				orderNum			= ""
				SalesItemIndex		= 0
				orderGrade			= 0

				If NB_isGroupUse = "T" Then
					If DK_MEMBER_STYPE = "0" Then
						GroupData = DKRSG_businesscode
						If DKRSG_businesscode = "" Then	Call ALERTS("센터에 가입되어있는 판매원 등급의 회원만 접근이 가능합니다","BACK","")
					Else
						Call ALERTS("센터에 가입되어있는 판매원 등급의 회원만 접근이 가능합니다","BACK","")
					End If
				Else
					GroupData = ""
				End If

				arrParams = Array( _
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
					Db.makeParam("@intCate",adInteger,adParamInput,0,category), _
					Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
					Db.makeParam("@strName",adVarWChar,adParamInput,50,strName), _
					Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
					Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
					Db.makeParam("@strEmail",adVarChar,adParamInput,200,strEmail), _
					Db.makeParam("@strTel",adVarChar,adParamInput,30,strTel), _
					Db.makeParam("@strMobile",adVarChar,adParamInput,30,strMobile), _
					Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass), _
					Db.makeParam("@strPic",adVarWChar,adParamInput,300,strPic), _
					Db.makeParam("@strData1",adVarWChar,adParamInput,300,strData1), _
					Db.makeParam("@strData2",adVarWChar,adParamInput,300,strData2), _
					Db.makeParam("@strData3",adVarWChar,adParamInput,300,strData3), _
					Db.makeParam("@strLink",adVarWChar,adParamInput,300,strLink), _
					Db.makeParam("@UPLOADPOINT",adChar,adParamInput,1,UPLOADPOINT),_
					Db.makeParam("@strDomain",adVarChar,adParamInput,20,strDomain),_
					Db.makeParam("@hostIP",adVarChar,adParamInput,50,hostIP),_
					Db.makeParam("@isNotice",adChar,adParamInput,2,isNotice),_
					Db.makeParam("@isSecret",adChar,adParamInput,1,isSecret),_
					Db.makeParam("@inputDate",adDBTimeStamp,adParamInput,16,inputDate),_
					Db.makeParam("@readCnt",adInteger,adParamInput,0,readCnt),_
					Db.makeParam("@isMainNotice",adChar,adParamInput,1,isMainNotice),_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,LANG),_
					Db.makeParam("@strPic1",adVarWChar,adParamInput,300,strPic1), _
					Db.makeParam("@strPic3",adVarWChar,adParamInput,300,strPic2), _
					Db.makeParam("@strPic3",adVarWChar,adParamInput,300,strPic3), _

					Db.makeParam("@movieType",adChar,adParamInput,1,movieType), _
					Db.makeParam("@movieURL",adVarWChar,adParamInput,100,movieURL), _

					Db.makeParam("@strReplyDateS",adVarChar,adParamInput,10,strReplyDateS), _
					Db.makeParam("@strReplyDateE",adVarChar,adParamInput,10,strReplyDateE), _

					Db.makeParam("@orderNum",adVarChar,adParamInput,50,orderNum), _
					Db.makeParam("@SalesItemIndex",adInteger,adParamInput,4,SalesItemIndex), _
					Db.makeParam("@orderGrade",adInteger,adParamInput,4,orderGrade), _
					Db.makeParam("@GroupData",adVarChar,adParamInput,40,GroupData), _
					Db.makeParam("@boardIntIdx",adInteger,adParamOutput,0,0), _
					Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_
				)
				Call Db.exec("DKP_NBOARD_WRITE",4,arrParams,Nothing)

				boardIntIdx = arrParams(UBound(arrParams)-1)(4)
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
						If DKRS9_intPointWrite <> 0 Then
							Call FNC_CS_POINT_INPUT(DK_MEMBER_ID1,DK_MEMBER_ID2,DK_MEMBER_NAME,DKRS9_intPointWrite,"900",0,"","WEB_POINT","게시물 작성 "&strBoardName&" 에 게시물 등록",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
						End If

						If UPLOADPOINT = "T" And DKRS9_intPointUpload <> 0 Then
							Call FNC_CS_POINT_INPUT(DK_MEMBER_ID1,DK_MEMBER_ID2,DK_MEMBER_NAME,DKRS9_intPointUpload,"906",0,"","WEB_POINT","게시물 작성 "&strBoardName&" 에 게시물 등록 - 자료첨부",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
						End If
					End If

				End If
				Call closeRs(DKRS9)



			Case "UPDATE"
				intIDX = upfORM("intIDX",True)
				'If regDate1 = "" Or regDate2 = "" Then
				'	inputDate = ""
				'Else
				'	inputDate = regDate1 & " " & regDate2
				'End If
				'If IsDate(inputDate) = False Then Call ALERTS("시간형식을 잘못 입력하셨습니다","back","")
				SQL = "SELECT [strUserID] FROM [DK_NBOARD_CONTENT] WHERE [strBoardName] = ? AND [intIDX] = ?"
				arrParams = Array( _
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
					Db.makeParam("@intIDX",adInteger,adParamInput,4,bidx) _
				)
				WRITEID = Db.execRsData(SQL, DB_TEXT, arrParams, Nothing)


				Select Case DK_MEMBER_TYPE
					Case "GUEST"
						If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
						inputPass = pRequestTF("strPass",True)
						arrParams = Array(_
							Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
						)
						OriPass = Db.execRsData("DKP_NBOARD_CONTENT_GUEST_PASSWORD",DB_PROC,arrParams,Nothing)
						If inputPass <> OriPass Then
							Call ALERTS(LNG_JS_PASSWORD_INCORRECT,"back","")
						End If
					Case "MEMBER","COMPANY"
						If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
						If UCase(WRITEID) <> UCase(DK_MEMBER_ID) Then Call ALERTS(DK_MEMBER_ID & LNG_BOARD_TYPE_BOARD_TEXT10,"BACK","")

					Case "ADMIN","OPERATOR"

					Case "SADMIN"
						If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
							If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
						End If
					Case Else
						Call ALERTS(LNG_JS_MEMBER_LEVEL_NO_EXIST,"back","")
				End Select

				arrParams = Array( _
					Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
					Db.makeParam("@intCate",adInteger,adParamInput,0,category), _
					Db.makeParam("@strName",adVarWChar,adParamInput,50,strName), _
					Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject), _
					Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent), _
					Db.makeParam("@strEmail",adVarChar,adParamInput,200,strEmail), _
					Db.makeParam("@strTel",adVarChar,adParamInput,30,strTel), _
					Db.makeParam("@strMobile",adVarChar,adParamInput,30,strMobile), _
					Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass), _
					Db.makeParam("@strPic",adVarWChar,adParamInput,300,strPic), _
					Db.makeParam("@strData1",adVarWChar,adParamInput,300,strData1), _
					Db.makeParam("@strData2",adVarWChar,adParamInput,300,strData2), _
					Db.makeParam("@strData3",adVarWChar,adParamInput,300,strData3), _
					Db.makeParam("@strLink",adVarWChar,adParamInput,300,strLink), _
					Db.makeParam("@hostIP",adVarChar,adParamInput,50,hostIP),_
					Db.makeParam("@isNotice",adChar,adParamInput,2,isNotice),_
					Db.makeParam("@inputDate",adDBTimeStamp,adParamInput,16,inputDate),_
					Db.makeParam("@readCnt",adInteger,adParamInput,0,readCnt),_
					Db.makeParam("@isSecret",adChar,adParamInput,1,isSecret),_
					Db.makeParam("@isMainNotice",adChar,adParamInput,1,isMainNotice),_

						Db.makeParam("@strPic1",adVarWChar,adParamInput,300,strPic1), _
						Db.makeParam("@strPic3",adVarWChar,adParamInput,300,strPic2), _
						Db.makeParam("@strPic3",adVarWChar,adParamInput,300,strPic3), _

						Db.makeParam("@movieType",adChar,adParamInput,1,movieType), _
						Db.makeParam("@movieURL",adVarWChar,adParamInput,100,movieURL), _

					Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

				)
				Call Db.exec("DKP_NBOARD_UPDATE",4,arrParams,Nothing)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Case "REPLY"
				intIDX = upfORM("intIDX",False)

				intDepth = intDepth +1
				If regDate1 = "" Or regDate2 = "" Then
					inputDate = Now
				Else
					inputDate = regDate1 & " " & regDate2
				End If
				If IsDate(inputDate) = False Then Call ALERTS(LNG_BOARD_HANDLER_TEXT05,"back","")

				Select Case DK_MEMBER_TYPE
					Case "MEMBER","GUEST","COMPANY"
						If DK_MEMBER_LEVEL < intLevelReply Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
					Case "ADMIN","OPERATOR"

					Case "SADMIN"
						If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
							If DK_MEMBER_LEVEL < intLevelReply Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
						End If
				End Select

				arrParams = Array( _
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
					Db.makeParam("@intCate",adInteger,adParamInput,0,category), _
					Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
					Db.makeParam("@strName",adVarChar,adParamInput,50,strName), _
					Db.makeParam("@strSubject",adVarChar,adParamInput,100,strSubject), _
					Db.makeParam("@strContent",adVarChar,adParamInput,MAX_LENGTH,strContent), _
					Db.makeParam("@strEmail",adVarChar,adParamInput,200,strEmail), _
					Db.makeParam("@strTel",adVarChar,adParamInput,30,strTel), _
					Db.makeParam("@strMobile",adVarChar,adParamInput,30,strMobile), _
					Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass), _
					Db.makeParam("@strPic",adVarChar,adParamInput,300,strPic), _
					Db.makeParam("@strData1",adVarChar,adParamInput,300,strData1), _
					Db.makeParam("@strData2",adVarChar,adParamInput,300,strData2), _
					Db.makeParam("@strData3",adVarChar,adParamInput,300,strData3), _
					Db.makeParam("@strLink",adVarChar,adParamInput,300,strLink), _
					Db.makeParam("@UPLOADPOINT",adChar,adParamInput,1,UPLOADPOINT),_
					Db.makeParam("@strDomain",adVarChar,adParamInput,20,strDomain),_
					Db.makeParam("@hostIP",adVarChar,adParamInput,50,hostIP),_
					Db.makeParam("@intList",adInteger,adParamInput,0,intList),_
					Db.makeParam("@intDepth",adInteger,adParamInput,0,intDepth),_
					Db.makeParam("@intRIDX",adInteger,adParamInput,0,intRIDX),_
					Db.makeParam("@inputDate",adDBTimeStamp,adParamInput,16,inputDate),_
					Db.makeParam("@readCnt",adInteger,adParamInput,0,readCnt),_


					Db.makeParam("@OUTPUT_VALUE",adVarchar,adParamOutput,20,"ERROR")_

				)
				Call Db.exec("DKP_NBOARD_REPLY",4,arrParams,Nothing)
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
						If DKRS9_intPointWrite <> 0 Then
							Call FNC_CS_POINT_INPUT(DK_MEMBER_ID1,DK_MEMBER_ID2,DK_MEMBER_NAME,DKRS9_intPointReply,"902",0,"","WEB_POINT","답글 작성 "&strBoardName&" 게시물에 답글작성",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
						End If
					End If
				End If
				Call closeRs(DKRS9)




	End Select

	Select Case OUTPUT_VALUE
		Case "ERROR"
			Call alerts(LNG_BOARD_HANDLER_TEXT06,"back","")
		Case "NODATA"
			Call alerts(LNG_BOARD_HANDLER_TEXT07,"back","")
		Case "BEGIN"
			Call alerts(LNG_BOARD_HANDLER_TEXT08,"back","")
		Case "LAST"
			Call alerts(LNG_BOARD_HANDLER_TEXT09,"back","")
		Case "FINISH"

			'여기부터 푸시메세지 전송 (게시물 등록 시)
			If mode = "INSERT" Then
				'** 공지사항 등록시 알림 발송 S
				If UCase(strBoardName) = "NOTICE" Then
					strToken = "/topics/common_topic"
					message = "새로운 공지사항이 등록되었습니다.\r\n공지사항을 확인 하시겠습니까?"
					url = "http://www."&DOMAIN_NAME_IS&"/m/cboard/board_view.asp?bname="&strBoardName&"&num="&boardIntIdx
					'Call FnPushMessage(strToken, message, url, "notice", "auto")
				End If
				'** 공지사항 등록시 알림 발송 E

				'** 센터별 게시판 알림 발송 S
				If UCase(strBoardName) = "BRANCH" Then

					'센터별 회원 정보 가져오기
					arrParams = Array( _
						Db.makeParam("@CENTER_CODE",adVarChar,adParamInput,30,DKRSG_businesscode) _
					)
					arrList = Db.execRsList("DKP_MEMBER_PUSH_CENTER_INFO",DB_PROC,arrParams,listLen,DB3)

					Dim strToken : strToken = ""

					If IsArray(arrList) Then
						For i=0 To listLen
							If Len(strToken) > 0 Then
								strToken = strToken&","
							End If

							strToken = strToken & arrList(0, i)
						Next
					End If

					'Function FnPushMessage(ByRef toArray, ByVal message, ByVal url, ByVal method, ByVal sendTo)
					'str = "회원님이 소속된 센터에 새로운 게시글이 등록되었습니다. 해당 게시물을 확인 하시겠습니까?"
					message = "회원님이 소속된 센터에 새로운 게시글이 등록되었습니다.\r\n해당 게시물을 확인 하시겠습니까?"
					url = "http://www."&DOMAIN_NAME_IS&"/m/cboard/board_view.asp?bname="&strBoardName&"&num="&boardIntIdx
					'Call FnPushMessage(strToken, message, url, "branch", "auto")
				End If
				'** 센터별 게시판 알림 발송 E
			End If


			If PB = "view" And strBoardType = "kin" Then
				Call ALERTS(LNG_BOARD_HANDLER_TEXT10,"go","board_view_kin.asp?bname="&strBoardName&"&num="&intIDX)
			Else
				Call ALERTS(LNG_BOARD_HANDLER_TEXT10,"go","board_list.asp?bname="&strBoardName)
			End If


	End Select

%>



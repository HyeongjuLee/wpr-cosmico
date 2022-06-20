<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	W1200 = "T"
	ADMIN_LEFT_MODE = "DESIGN"

	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize  = 10
	MaxDataSize1 = MaxDataSize * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode		= upForm("mode",True)
	strArea		= upForm("strArea",True)
	IMG_WIDTH	= upForm("IMG_WIDTH",True)
	IMG_HEIGHT	= upForm("IMG_HEIGHT",True)
	bn			= upForm("bn",False)

	Select Case MODE
		Case "REGIST"
			isUse			= upForm("isUse",False)
			isLink			= upForm("isLink",False)
			isLinkTarget	= upForm("isLinkTarget",False)
			strLink			= upForm("strLink",False)
			strLink2		= upForm("strLink2",False)
			strTitle		= upForm("strTitle",False)
			strNationCode	= upForm("strNationCode",False)
			strSubtitle		= upfORM("strSubtitle",False)
			strScontent		= upfORM("strScontent",False)

			If isUse = "" Then isUse = "F"
			If isLink = "" Then isLink = "F"
			If isLinkTarget = "" Then isLinkTarget = "S"
			If strLink = "" Then strLink = "#"
			If strLink2 = "" Then strLink2 = "#"

			'기본URL 제외, 현재 페이지 주소만 호출
			strLink	= FN_ONLY_PAGEURL(strLink)
			strLink2= FN_ONLY_PAGEURL(strLink2)

		'	If isLink = "F" Or strLink = "#" Then
		'		isLink = "F"
		'		'isLinkTarget = "S"
		'		strLink = "#"
		'		strLink2 = "#"
		'	End If

			imgPath = REAL_PATH("shop_design_Banner_O")
			imgPath1 = REAL_PATH("shop_design_Banner_T")
			'print imgPath
			'print imgPath2
			Call ChkPathToCreate(VIR_PATH("shop_design_Banner_O"))
			Call ChkPathToCreate(VIR_PATH("shop_design_Banner_T"))


			strImg = FN_IMAGEUPLOAD("strImg","T",MaxDataSize1,imgPath,imgPath1,"T",IMG_WIDTH,IMG_HEIGHT,"","","","")
			strImg2 = ""

			If strImg <> "" Then strImg = backword(strImg)
			If strImg2 <> "" Then strImg2 = backword(strImg2)

			arrParams = Array(_
				Db.makeParam("@strImg",adVarWChar,adParamInput,150,strImg),_
				Db.makeParam("@strImg",adVarWChar,adParamInput,150,strImg2),_
				Db.makeParam("@strArea",adVarChar,adParamInput,20,strArea),_
				Db.makeParam("@strTitle",adVarWChar,adParamInput,50,strTitle),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_
				Db.makeParam("@isLink",adChar,adParamInput,1,isLink),_
				Db.makeParam("@isLinkTarget",adChar,adParamInput,1,isLinkTarget),_
				Db.makeParam("@strLink",adVarWChar,adParamInput,300,strLink),_
				Db.makeParam("@strLink2",adVarWChar,adParamInput,300,strLink2),_
				Db.makeParam("@strNation",adVarChar,adParamInput,20,strNationCode),_

				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@regHost",adVarChar,adParamInput,30,getUserIP),_
				Db.makeParam("@strSubtitle",adVarWChar,adParamInput,50,strSubtitle), _
				Db.makeParam("@strScontent",adVarWChar,adParamInput,500,strScontent), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_SHOP_DESIGN_BANNER_REGIST_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "UPDATE"
			OristrImg		= UPfORM("OristrImg",False)
			OristrImg2		= UPfORM("OristrImg2",False)
			intIDX			= upForm("intIDX",True)
			isUse			= upForm("isUse",False)
			isLink			= upForm("isLink",False)
			isLinkTarget	= upForm("isLinkTarget",False)
			strLink			= upForm("strLink",False)
			strLink2		= upForm("strLink2",False)
			strTitle		= upForm("strTitle",False)
			strNationCode	= upForm("strNationCode",False)
			strSubtitle		= upfORM("strSubtitle",False)
			strScontent		= upfORM("strScontent",False)

			If isUse = "" Then isUse = "F"
			If isLink = "" Then isLink = "F"
			If isLinkTarget = "" Then isLinkTarget = "S"
			If strLink = "" Then strLink = "#"
			If strLink2= "" Then strLink2 = "#"

			'기본URL 제외, 현재 페이지 주소만 호출
			strLink	= FN_ONLY_PAGEURL(strLink)
			strLink2= FN_ONLY_PAGEURL(strLink2)

		'	If strLink = "#" Then
		'		isLink = "F"
		'		'isLinkTarget = "S"
		'		strLink = "#"
		'	End If

			imgPath = REAL_PATH("shop_design_Banner_O")
			imgPath1 = REAL_PATH("shop_design_Banner_T")
			'print imgPath
			'print imgPath2
			Call ChkPathToCreate(VIR_PATH("shop_design_Banner_O"))
			Call ChkPathToCreate(VIR_PATH("shop_design_Banner_T"))


			'strImg = FN_IMAGEUPLOAD("strImg","F",MaxDataSize1,imgPath,imgPath1,"T",IMG_WIDTH,IMG_HEIGHT,OristrImg,"","","")
			'strImg2 = ""

			'수정시 기존이미지 삭제
			If Upload.Form("strImg") <> "" Then
				strImg = FN_IMAGEUPLOAD("strImg","F",MaxDataSize1,imgPath,imgPath1,"T",IMG_WIDTH,IMG_HEIGHT,OristrImg,"","","")
				Call sbDeleteFiles(REAL_PATH("shop_design_Banner_O")&"\"&backword(OristrImg))
				Call sbDeleteFiles(REAL_PATH("shop_design_Banner_T")&"\"&backword(OristrImg))
			Else
				strImg = OristrImg
			End If

			strImg2 = ""

			If strImg <> "" Then strImg = backword(strImg)
			If strImg2 <> "" Then strImg2 = backword(strImg2)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strTitle",adVarWChar,adParamInput,50,strTitle),_
				Db.makeParam("@strImg",adVarWChar,adParamInput,150,strImg),_
				Db.makeParam("@strImg2",adVarWChar,adParamInput,150,strImg2),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_
				Db.makeParam("@isLink",adChar,adParamInput,1,isLink),_
				Db.makeParam("@isTarget",adChar,adParamInput,1,isLinkTarget),_
				Db.makeParam("@strLink",adVarWChar,adParamInput,300,strLink),_
				Db.makeParam("@strLink2",adVarWChar,adParamInput,300,strLink2),_
				Db.makeParam("@strNation",adVarChar,adParamInput,20,strNationCode),_
				Db.makeParam("@strSubtitle",adVarWChar,adParamInput,50,strSubtitle),_
				Db.makeParam("@strScontent",adVarWChar,adParamInput,500,strScontent),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_SHOP_DESIGN_BANNERS_UPDATE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "chgView"
			isUse		= upForm("value1",True)
			intIDX		= upForm("intIDX",True)
			strNationCode	= upForm("strNationCode",False)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_SHOP_DESIGN_BANNER_CHGVIEW_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "DELETE"
			intIDX		= upForm("intIDX",True)
			strNationCode	= upForm("strNationCode",False)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
				Db.makeParam("@strArea",adVarChar,adParamInput,20,strArea),_
				Db.makeParam("@strNation",adVarChar,adParamInput,20,strNationCode),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_SHOP_DESIGN_BANNERS_DELETE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			'삭제시 이미지 삭제
			If OUTPUT_VALUE = "FINISH" Then
				SQLI = "SELECT [strImg],[strImg2] FROM [DK_SHOP_DESIGN_BANNERS] WITH(NOLOCK) WHERE [intIDX] = ? "
				arrParamsI = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
				)
				Set HJRS = Db.execRs(SQLI,DB_TEXT,arrParamsI,Nothing)
				If Not HJRS.BOF And Not HJRS.EOF Then
					HJRS_strImg  = HJRS("strImg")
					HJRS_strImg2  = HJRS("strImg")
					IF HJRS_strImg <> "" Then
						Call sbDeleteFiles(REAL_PATH("shop_design_Banner_O")&"\"&backword(HJRS_strImg))
						Call sbDeleteFiles(REAL_PATH("shop_design_Banner_T")&"\"&backword(HJRS_strImg))
					End IF
					IF HJRS_strImg2 <> "" Then
						Call sbDeleteFiles(REAL_PATH("shop_design_Banner_O")&"\"&backword(HJRS_strImg2))
						Call sbDeleteFiles(REAL_PATH("shop_design_Banner_T")&"\"&backword(HJRS_strImg2))
					End IF
				End If
				Call closeRS(HJRS)
			End IF

		Case "SORTUP","SORTDN"
			intIDX		= upForm("intIDX",True)
			strNationCode	= upForm("strNationCode",False)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
				Db.makeParam("@mode",adChar,adParamInput,6,MODE),_
				Db.makeParam("@strArea",adVarChar,adParamInput,20,strArea),_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKSP_SHOP_DESIGN_BANNERS_SORT_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)




		Case Else : Call ALERTS("올바르지 않은 모드값이 전송되었습니다.\n\n새로고침 후 다시 시도해주세요.","BACK","")
	End Select



%>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%
	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"
			If bn <> "" Then
				Call ALERTS(DBFINISH,"GO","shop_design_banner.asp?nc="&strNationCode&"&area="&strArea&"&bn="&bn)
			Else
				Call ALERTS(DBFINISH,"GO","shop_design_banner.asp?nc="&strNationCode&"&area="&strArea)
			End if
		Case "NOTUP"	: Call ALERTS("더이상 올릴 수 없습니다.","GO","shop_design_banner.asp?nc="&strNationCode&"&area="&strArea)
		Case "NOTDN"	: Call ALERTS("더이상 내릴 수 없습니다.","GO","shop_design_banner.asp?nc="&strNationCode&"&area="&strArea)
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select

%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->

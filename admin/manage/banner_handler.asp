<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE7-1"

	Call noCache

	MaxDataSize = 1
	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = MaxDataSize * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	MODE = upForm("mode",True)

	Select Case MODE
		Case "REGIST"

			isUse			= upForm("isUse",True)
			isType			= upForm("isType",True)
			strLink			= upForm("strLink",True)

			imgPath = REAL_PATH("banner\partner")
			imgPath2 = REAL_PATH("banner\partner\ori")
			imgWidth = 0
			imgHeight = 0
			strImg = upImg("strImg",imgPath)


			' 1MB 이하의 파일만 저장시작 저장 후 각 폼별 이름 갱신
			If Upload.Form("strImg") <> "" Then
				If Upload.Form("strImg").FileSize < MaxDataSize1 Then
					strData1 = ostrData1
				Else 
					Call ALERTS("이미지 크기는 "&MaxDataSize&"MB를 넘을 수 없습니다.","BACK","")
				End If
			Else
				strData1 = ostrData1
			End If


			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				strLink		= Trim(StrCipher.Encrypt(strLink,EncTypeKey1,EncTypeKey2))		'아이디
			Set StrCipher = Nothing

			arrParams = Array(_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_
				Db.makeParam("@isType",adChar,adParamInput,1,isType),_
				Db.makeParam("@strLink",adVarWChar,adParamInput,100,strLink),_
				Db.makeParam("@strImg",adVarWChar,adParamInput,500,strImg),_
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP()),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_PARTNER_BANNER_REGIST",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "USE"
			intIDX = upForm("intIDX",True)
			isUse = upForm("values",True)

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_PARTNER_BANNER_USECHG",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "MODIFY"


			intIDX		= upForm("intIDX",True)
			strLink		= upForm("values",True)
			isType		= upForm("values2",True)

	
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				strLink		= Trim(StrCipher.Encrypt(strLink,EncTypeKey1,EncTypeKey2))		'아이디
			Set StrCipher = Nothing

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@isType",adChar,adParamInput,1,isType),_
				Db.makeParam("@strLink",adVarWChar,adParamInput,100,strLink),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_PARTNER_BANNER_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "DELETE"
			intIDX = upForm("intIDX",True)

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_PARTNER_BANNER_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	End Select


	Select Case OUTPUT_VALUE
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO","banner_list.asp")
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<!--#include virtual = "/admin/_inc/copyright.asp"-->

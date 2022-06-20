<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode		= upfORM("mode",True)



	Select Case mode
		Case "REGIST"
			strMatchingID		= upfORM("MatchingID",True)
			If Upload.Form("MatchingImg") <> "" Then
				strFile = uploadImg("MatchingImg",REAL_PATH("Matching\ori"),REAL_PATH("Matching"),100,25)
			Else
				Call ALERTS("이미지가 첨부되지 않았습니다.","back","")
			End If

			arrParams = Array(_
				Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,strMatchingID),_
				Db.makeParam("@strFile",adVarChar,adParamInput,512,strFile),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"BASIC") _
			)
			Call Db.exec("DKPA_NBOARD_WRITER_MATCHING_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Case "MODIFY"
			intIDX				= upfORM("idx",True)
			strMatchingID		= upfORM("MatchingID",True)
			ori_icon			= upfORM("ori_icon",True)
			If Upload.Form("MatchingImg") <> "" Then
				Call sbDeleteFiles(REAL_PATH("Matching")&"/"&ori_icon)
				Call sbDeleteFiles(REAL_PATH("Matching\ori")&"/"&ori_icon)
				strFile = uploadImg("MatchingImg",REAL_PATH("Matching\ori"),REAL_PATH("Matching"),100,25)
			Else
				strFile = ori_icon
			End If

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@strMatchingID",adVarChar,adParamInput,100,strMatchingID),_
				Db.makeParam("@strFile",adVarChar,adParamInput,512,strFile),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"BASIC") _
			)
			Call Db.exec("DKPA_NBOARD_WRITER_MATCHING_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Case "DELETE"
			intIDX				= upfORM("idx",True)
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@strFile",adVarChar,adParamOutput,512,""),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"BASIC") _
			)
			Call Db.exec("DKPA_NBOARD_WRITER_MATCHING_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
			strFile = arrParams(UBound(arrParams)-1)(4)
			Call sbDeleteFiles(REAL_PATH("Matching")&"/"&backword(strFile))
			Call sbDeleteFiles(REAL_PATH("Matching\ori")&"/"&backword(strFile))


	End Select

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","matching.asp")
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select



	print mode
	print intIDX

	response.End
	idx				= upfORM("strName",True)
	strPass			= upfORM("strPass",True)

	strzip			= upfORM("strzip",True)
	straddr1		= upfORM("straddr1",True)
	straddr2		= upfORM("straddr2",True)

	strTel1			= upfORM("tel_num1",False)
	strTel2			= upfORM("tel_num2",False)
	strTel3			= upfORM("tel_num3",False)

	strMobile1		= upfORM("mob_num1",True)
	strMobile2		= upfORM("mob_num2",True)
	strMobile3		= upfORM("mob_num3",True)
	isSMS			= upfORM("sendsms",True)

	strEmail1		= upfORM("mailh",False)
	strEmail2		= upfORM("mailt",False)
	isMailing		= upfORM("sendemail",True)


	strBirth1		= upfORM("birthYY",True)
	strBirth2		= upfORM("birthMM",True)
	strBirth3		= upfORM("birthDD",True)

	isSolar			= upfORM("isSolar",True)

	memberType		= upfORM("memberType",True)
	intMemLevel		= upfORM("intMemLevel",True)
	SAdminSite		= upfORM("SAdminSite",False)

	isIDImg			= upfORM("isIDImg",True)
	Org_strFile		= upfORM("Org_strFile",False)

	strTel = ""
	strMobile = ""


	strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
	strTel = strTel1 &"-"& strTel2 &"-"& strTel3


	strEmail = strEmail1 & "@" & strEmail2

	strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3

	If Not IsDate(strBirth) Then strBirth = ""
	If isSMS = "" Then isSMS = "T"
	If isMailing = "" Then isMailing = "T"
	If SAdminSite = "" Then SAdminSite = ""

	'imgName = uploadImg("strFile",REAL_PATH("member\ORI"),REAL_PATH("member"),100,25)

	imgName = upImg("strFile",REAL_PATH("member"))

	If ImgName = "" Then ImgName = Org_strFile
	print backword(imgName)
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID),_
		Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass),_
		Db.makeParam("@strName",adVarChar,adParamInput,30,strName),_

		Db.makeParam("@strBirth",adDBTimeStamp,adParamInput,16,strBirth),_
		Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_
		Db.makeParam("@strTel",adVarChar,adParamInput,20,strTel),_
		Db.makeParam("@strMobile",adVarChar,adParamInput,20,strMobile),_
		Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_

		Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_
		Db.makeParam("@isMailing",adChar,adParamInput,1,isMailing),_
		Db.makeParam("@strzip",adVarChar,adParamInput,10,strzip),_
		Db.makeParam("@strADDR1",adVarChar,adParamInput,512,straddr1),_
		Db.makeParam("@strADDR2",adVarChar,adParamInput,512,straddr2),_

		Db.makeParam("@intMemLevel",adInteger,adParamInput,0,intMemLevel),_
		Db.makeParam("@memberType",adVarChar,adParamInput,10,memberType),_
		Db.makeParam("@SAdminSite",adVarChar,adParamInput,20,SAdminSite),_
		Db.makeParam("@isIDImg",adChar,adParamInput,1,isIDImg),_
		Db.makeParam("@imgName",adVarChar,adParamInput,512,imgName),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_MEMBER_INFO_MODIFY",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH" : Call ALERTS(DBFINISH,"go","member_list.asp")
	End Select



'	Call ResRW(strUserID,"strUserID")






%>
</body>
</html>

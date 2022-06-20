<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%
	'엘라이프 상단 레이어팝업처리(2017-03-02)

	Call noCache

	Function makePopupNo()
		Dim nowTime : nowTime = Now
		Dim firstDay, startTime
		Dim no1_head, no2_year, no3_dayNum, no4_secondNum, no5_rndNo

		firstDay = Year(nowTime) &"-01-01"
		startTime = FormatDateTime(nowTime, 2) &" 00:00:00"

		Randomize
		rndNo = Int(Rnd * 99+Second(nowTime))

		no1_head = "POP"
		no2_year = Right(Year(nowTime), 2)
		no3_dayNum = Right("00"& (DateDiff("d", firstDay, nowTime)+1), 3)
		no4_secondNum = Right("0000"& DateDiff("s", startTime, nowTime), 5)
		no5_rndNo = Right("0"& rndNo, 2)

		makePopupNo = no1_head & no2_year & no3_dayNum & no4_secondNum & no5_rndNo
	End Function


		MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
		MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

		Set Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
		Upload.MaxBytesToAbort = MaxFileAbort
		Upload.Start REAL_PATH("Temps")


		useTF		= upfORM("useTF",True)
		popTitle	= upfORM("popTitle",True)
		marginTop	= upfORM("marginTop",False)
		marginLeft	= upfORM("marginLeft",False)
		popKind		= upfORM("popKind",True)
		linkType	= upfORM("linkType",False)
		linkUrl		= upfORM("linkUrl",False)
		isViewShop	= upfORM("isViewShop",False)
		isViewCom	= upfORM("isViewCom",False)
		strNationCode	= upfORM("strNationCode",True)

		strScontent		= upfORM("strScontent",True)




		If isViewShop = "" Then isViewShop = "F"
		If isViewCom  = "" Then isViewCom  = "F"



'	PRINT CateName
'	PRINT depth
'	PRINT PARENT
'	PRINT CH
'
	'imgName = upImgInfo("imgName",REAL_PATH("popup"),imgWidth,imgHeight)
	newFileName = makePopupNo()
	imgAlt = ""


'	PRINT	imgWidth
'	PRINT	imgHeight
'	RESPONSE.End


'Call ResRW(useTF,"useTF")
'Call ResRW(popTitle,"popTitle")
'Call ResRW(marginTop,"marginTop")
'Call ResRW(marginLeft,"marginLeft")
'Call ResRW(popKind,"popKind")

'Call ResRW(linkType,"linkType")
'Call ResRW(linkUrl,"linkUrl")

'Call ResRW(imgName,"imgName")
'Call ResRW(imgWidth,"imgWidth")
'Call ResRW(imgHeight,"imgHeight")
'Call ResRW(newFileName,"newFileName")
'Call ResRW(strNationCode,"strNationCode")
'Call ResRW(strScontent,"strScontent")
'Response.end
	arrParams = Array(_
		Db.makeParam("@popUniqueNum",adVarChar,adParamInput,20,newFileName),_
		Db.makeParam("@useTF",adChar,adParamInput,1,useTF),_
		Db.makeParam("@popTitle",adVarWChar,adParamInput,50,popTitle),_
		Db.makeParam("@imgName",adVarWChar,adParamInput,150,"Top"),_
		Db.makeParam("@imgWidth",adInteger,adParamInput,0,imgWidth),_
		Db.makeParam("@imgHeight",adInteger,adParamInput,0,imgHeight),_
		Db.makeParam("@imgAlt",adVarChar,adParamInput,512,imgAlt),_
		Db.makeParam("@MarginTop",adInteger,adParamInput,0,MarginTop),_
		Db.makeParam("@MarginLeft",adInteger,adParamInput,0,MarginLeft),_
		Db.makeParam("@popKind",adChar,adParamInput,1,popKind),_
		Db.makeParam("@linkType",adChar,adParamInput,1,linkType),_
		Db.makeParam("@linkUrl",adVarChar,adParamInput,512,linkUrl), _
		Db.makeParam("@isViewShop",adChar,adParamInput,1,isViewShop),_
		Db.makeParam("@isViewCom",adChar,adParamInput,1,isViewCom),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(strNationCode)), _
		Db.makeParam("@strScontent",adVarWChar,adParamInput,1000,strScontent), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKPA_POPUP_REGIST_TOP",DB_PROC,arrParams,Nothing)

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "FINISH": Call ALERTS("정상처리되었습니다..","o_reloadA","")
		Case "ERROR" : Call ALERTS("업로드 중 문제가 발생하였습니다.팝업이 정상적으로 설정되지 않았습니다.","back","")
	End Select


%>

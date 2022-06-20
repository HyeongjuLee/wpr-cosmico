<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.CodePage = 65001
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode = upForm("mode",True)
	strLoc = upForm("strLoc",True)

'	Function upImgInfo(ByVal keys,ByVal ThPath1,ByRef imgWidth, ByRef imgHeight)


	Select Case MODE
		Case "INSERT"
			imgPath = REAL_PATH("banner\"&strLoc)
			imgWidth = 0
			imgHeight = 0
			strImg = upImgInfo("strImg",imgPath,imgWidth,imgHeight)

			isLink				= upForm("isLink",False)
			isLinkTarget		= upForm("isLinkTarget",False)
			strLink				= upForm("strLink",False)


			arrParams = Array(_
				Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc), _
				Db.makeParam("@isLink",adChar,adParamInput,1,isLink), _
				Db.makeParam("@isLinkTarget",adChar,adParamInput,1,isLinkTarget), _
				Db.makeParam("@strLink",adVarWChar,adParamInput,512,strLink), _

				Db.makeParam("@strImg",adVarWChar,adParamInput,500,strImg), _
				Db.makeParam("@intImgWidth",adInteger,adParamInput,4,imgWidth), _
				Db.makeParam("@intImgHeight",adInteger,adParamInput,4,imgHeight), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP()), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKP_DESIGN_BANNER_INSERT_ADMIN",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "USE"
			intIDX = upForm("intIDX",True)
			isUse = upForm("values",True)

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _
				Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKP_DESIGN_BANNER_USECHG_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "DELETE"
			intIDX = upForm("intIDX",True)

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKP_DESIGN_BANNER_DELETE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case Else : Call ALERTS("모드값이 올바르지 않습니다.","BACK","")
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO","banner.asp?loc="&strLoc)
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>




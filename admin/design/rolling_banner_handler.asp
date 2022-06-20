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

'	Function upImgInfo(ByVal keys,ByVal ThPath1,ByRef imgWidth, ByRef imgHeight)


	Select Case MODE
		Case "INSERT"
			imgPath = REAL_PATH("rolling")

			strImg = upImg("strImg",imgPath)

			If strImg <> "" Then strImg = backword(strImg)

			isLink				= upForm("isLink",False)
			isLinkTarget		= upForm("isLinkTarget",False)
			strLink				= upForm("strLink",False)

			'기본URL 제외, 현재 페이지 주소만 호출
			strLink	= FN_ONLY_PAGEURL(strLink)

			arrParams = Array(_
				Db.makeParam("@isLink",adChar,adParamInput,1,isLink), _
				Db.makeParam("@isLinkTarget",adChar,adParamInput,1,isLinkTarget), _
				Db.makeParam("@strLink",adVarWChar,adParamInput,512,strLink), _

				Db.makeParam("@strImg",adVarWChar,adParamInput,500,strImg), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP()), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DESIGN_ROLLING_REGIST",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "USE"
			intIDX = upForm("intIDX",True)
			isUse = upForm("values",True)

			arrParams = Array(_

				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_DESIGN_ROLLING_USECHG",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		Case "SORTUP"
			intIDX = upForm("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@sortMode",adVarChar,adParamInput,8,"SORTUP"), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_DESIGN_ROLLING_SORT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "SORTDOWN"
			intIDX = upForm("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@sortMode",adVarChar,adParamInput,8,"SORTDOWN"), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DESIGN_ROLLING_SORT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "DELETE"
			intIDX = upForm("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DESIGN_ROLLING_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			'삭제시 이미지 삭제
			If OUTPUT_VALUE = "FINISH" Then
				SQLI = "SELECT [strImg] FROM [DK_DESIGN_ROLLING] WITH(NOLOCK) WHERE [intIDX] = ? "
				arrParamsI = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
				)
				Set HJRS = Db.execRs(SQLI,DB_TEXT,arrParamsI,Nothing)
				If Not HJRS.BOF And Not HJRS.EOF Then
					HJRS_strImg  = HJRS("strImg")
					IF HJRS_strImg <> "" Then
						Call sbDeleteFiles(REAL_PATH("rolling")&"\"&backword(HJRS_strImg))
					End IF
				End If
				Call closeRS(HJRS)
			End IF

		Case Else : Call ALERTS("모드값이 올바르지 않습니다.","BACK","")
	End Select


	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO","rolling_banner.asp")
		Case "NODATA"	: Call alerts("처리할 데이터가 없습니다.","back","")
		Case "BEGIN"	: Call alerts("더이상 올릴 수 없습니다.","back","")
		Case "LAST"		: Call alerts("더이상 내릴 수 없습니다.","back","")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>




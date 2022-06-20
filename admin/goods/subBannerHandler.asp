<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	Call noCache

	MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Start REAL_PATH("Temps")


	mode = upForm("mode",True)

	Select Case mode
		Case "INSERT"
			If Upload.Form("strFile") <> "" Then
				strFile = uploadImg("strFile",REAL_PATH("DetailBanner"),REAL_PATH("DetailBanner"),970,2000)
			Else
				Call ALERTS("이미지가 첨부되지 않았습니다.","back","")
			End If
			strTitle = upForm("strTitle",True)
			imgWidth = 0
			imgHeight = 0
			Call imgInfo(VIR_PATH("DetailBanner")&"/"&strFile,imgWidth,imgHeight,"")
			'PRINT imgWidth
			'PRINT imgHeight
			arrParams = Array(_
				Db.makeParam("@strTitle",adVarChar,adParamInput,100,strTitle),_
				Db.makeParam("@strFile",adVarChar,adParamInput,512,strFile),_
				Db.makeParam("@intWidth",adInteger,adParamInput,0,imgWidth),_
				Db.makeParam("@intHeight",adInteger,adParamInput,0,imgHeight),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DETAIL_BANNER_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "DELETE"
			intIDX = upForm("intIDX",True)
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@strFile",adVarChar,adParamOutput,512,""),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DETAIL_BANNER_DELETE",DB_PROC,arrParams,Nothing)
			strFile = arrParams(UBound(arrParams)-1)(4)
			Call sbDeleteFiles(REAL_PATH("DetailBanner")&"/"&strFile)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
	End Select



	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","subBanner.asp")
		Case Else : PRINT OUTPUT_VALUE 'Call ALERTS(DBUNDEFINED,"BACK","")
	End Select





%>

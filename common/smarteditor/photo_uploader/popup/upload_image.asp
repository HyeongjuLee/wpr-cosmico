<!--#include virtual = "/_lib/strFunc.asp" -->
<%
	Call noCache
	Server.ScriptTimeOut = 7200

	MaxFileAbort = 50 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
	MaxDataSize  = 2
	MaxDataSize1 = MaxDataSize * 1024 * 1024

	ALERTS_METHOD = "p_reloada"

	If DK_MEMBER_LEVEL < 10 Then Call alerts(LNG_ERROR_MSG_12,ALERTS_METHOD,"")		'권한 추가

	Set Upload = Server.CreateObject("TABSUpload4.Upload")
	Upload.MaxBytesToAbort = MaxFileAbort
	Upload.Codepage = 65001
	Call ChkPathToCreate(BVIR_PATH("upload"))
	Upload.Start BREAL_PATH("upload")

	'If Upload.Form("Filedata").ImageType = 0 Then Call alerts("이미지만 업로드 할 수 있습니다.","back","")
	If Upload.Form("Filedata").ImageType = 0 Then Call alerts("이미지만 업로드 할 수 있습니다.",ALERTS_METHOD,"")

	imagepath = trim(Upload.Form("imagepaths"))
	irid = trim(Upload.Form("id"))

'	print imagepath
'	Response.End

	arrParams = Array(Db.makeParam("@strPathName",adVarChar,adParamInput,20,imagepath))
	uploadPath = Db.execRsData("[DKSP_UPLOAD_PATH]",DB_PROC,arrParams,Nothing)


'	PRINT uploadPath
'	Response.End

	If uploadPath = "" Or IsNull(uploadPath) Then
		Rurl = "callback.html?callback_func="&Upload.Form("callback_func")
		Rurl = Rurl & "&errstr="&Server.URLEncode(LNG_ALERT_WRONG_ACCESS)
		Response.Redirect(Rurl)
		Response.End
	End If

	'If Not ChkFolderExists(imagepath) Then Call alerts("정상적인 폴더명이 아닙니다.",ALERTS_METHOD,"")

	DirectoryPath = Server.MapPath(uploadPath)
	Call ChkPathToCreate(uploadPath)

'	newFileExet = Upload.Form("Filedata").FileType 'Mid(agoFileName, Instr(agoFileName, ".") + 1)
'	newFileName = Replace(date,"-","")&"_"&Hour(now)&minute(now)&second(now)&"_"&session.sessionID
'	response.write newFileName
'	response.write newFileExet
'	response.End

	'strData1 = FN_IMAGEUPLOAD("Filedata","F",MaxDataSize1,DirectoryPath,"","F","0","0","","t1","t2","t3")
	strData1 = FN_IMAGEUPLOAD("Filedata","F",MaxDataSize1,DirectoryPath,"","F","0","0","",ALERTS_METHOD,newFileName,"t3")

	Rurl = "callback.html?callback_func="&Upload.Form("callback_func")
	Rurl = Rurl & "&sFileName="&strData1
	Rurl = Rurl & "&sFileURL="&uploadPath&"/"&strData1
	Rurl = Rurl & "&bNewLine=true"

	Response.Redirect(Rurl)
%>

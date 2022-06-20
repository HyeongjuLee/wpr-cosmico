<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'한글 깨짐방지
'	Option Explicit


	'Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"


	'▣ 파일명 받아오기 S
		filename = Request("filename")
	'▣ 파일명 받아오기 E


	'▣ 파일명 복호화 S
		errorTF = "F"
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If filename <> ""	Then filename	= objEncrypter.Decrypt(filename)
				If Err.Number <> 0 Then	errorTF = "T"
			On Error GoTo 0
			Err.clear
		Set objEncrypter = Nothing

		If errorTF = "T" Then
			Call FN_TraceLog("/error/downLog","▣ 암호화오류 S =============")
			Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
			Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
			Call FN_TraceLog("/error/downLog","FN : " & filename)
			Call FN_TraceLog("/error/downLog","==================================")
			Call ALERTS(LNG_ERROR_MSG_01,"BACK","")
			Response.End
		End If
	'▣ 파일명 복호화 E

	'▣ 파일명 체크 S
		chkInj = 0
		If InStr(filename,"../") > 0 Then chkInj = chkInj + 1
		If InStr(filename,"..") > 0 Then chkInj = chkInj + 1
		If InStr(filename,"/") > 0 Then chkInj = chkInj + 1

		'Call ResRW(chkInj,"chkInj")
		If chkInj > 0 Then
			'PRINT LNG_ERROR_MSG_02
			Call FN_TraceLog("/error/downLog","▣ 파일명 부모경로존재 S =============")
			Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
			Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
			Call FN_TraceLog("/error/downLog","FN : " & filename)
			Call FN_TraceLog("/error/downLog","==================================")
			Call ALERTS(LNG_ERROR_MSG_02,"BACK","")
			Response.End
		End If
	'▣ 파일명 체크 E


	'▣ 데이터 위치 확인 S
		SQL = "SELECT * FROM [DKTEMP_REAL_DATA] WHERE [strDataName] = ?"
		arrParams = Array(Db.makeParam("@strDataName",adVarChar,adParamInput,100,filename))
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_intIDX			= DKRS("intIDX")
			DKRS_sMemberOnly			= DKRS("sMemberOnly")
			DKRS_strDataName			= DKRS("strDataName")
			DKRS_strRealData			= DKRS("strRealData")
			DKRS_strRealPath			= DKRS("strRealPath")
		Else
			Call FN_TraceLog("/error/downLog","▣ 존재하지 않는 파일요청 S =============")
			Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
			Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
			Call FN_TraceLog("/error/downLog","FN : " & filename)
			Call FN_TraceLog("/error/downLog","==================================")

			Call ALERTS("존재하지 않는 데이터입니다.","BACK","")
		End If
		Call closeRS(DKRS)
	'▣ 데이터 위치 확인 E

	'▣ 회원전용인 경우 체크 S
		If DKRS_sMemberOnly = "T" Then
			If DK_MEMBER_LEVEL < 1 Then
				Call FN_TraceLog("/error/downLog","▣ 회원전용다운로드 직접 연결시도 S =============")
				Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
				Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
				Call FN_TraceLog("/error/downLog","FN : " & filename)
				Call FN_TraceLog("/error/downLog","==================================")

				Call ALERTS("올바른 접속경로가 아닙니다..","BACK","")
			End If
		End If
	'▣ 회원전용인 경우 체크 E


	DFilepath = BACKWORD(Server.Mappath(DKRS_strRealPath))
	DFileName = BACKWORD(DKRS_strRealData)



	'▣ 다운로드 가능한 파일인지 체크 S - 탭스 필요
		DFilepath = DFilepath & "\"& Replace(Replace(Replace(DFileName,"../",""),"..",""),"/","")

		Set FormatDetector = Server.CreateObject("TABSUpload4.FormatDetector")
		On Error Resume Next
			Set FormatInfo = FormatDetector.GuessFormat(DFilepath)
				FormatName = FormatInfo.Name
				FormatMime = FormatInfo.MimeType
			Set FormatDetector = Nothing
			If Err.Number <> 0 Then	errorTF = "T"
		On Error GoTo 0
		Err.clear

		If errorTF = "T" Then
			Call FN_TraceLog("/error/downLog","▣ 실존하지 않은 파일 S =============")
			Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
			Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
			Call FN_TraceLog("/error/downLog","FN : " & DFilepath)
			Call FN_TraceLog("/error/downLog","==================================")
			Call ALERTS(LNG_ERROR_MSG_01,"BACK","")
			Response.End
		End If

		'Call ResRW(FormatName,"FormatName")
		'Call ResRW(FormatMime,"FormatMime")
		'Response.End
		If InStr(TX_FileAccTYPE,","&FormatName&",") < 1 Then
			Call FN_TraceLog("/error/downLog","▣ 업로드 불가능한 파일(확장자)에 대한 다운로드 요청 S =============")
			Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
			Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
			Call FN_TraceLog("/error/downLog","FN : " & DFileName)
			Call FN_TraceLog("/error/downLog","FormatName : " & FormatName)
			Call FN_TraceLog("/error/downLog","FormatMime : " & FormatMime)
			Call FN_TraceLog("/error/downLog","==================================")
			Call ALERTS(LNG_ERROR_MSG_04,"BACK","")
			Response.End
		Else
			If InStr(TX_FileAccMIME,","&FormatMime&",") < 1 Then
				Call FN_TraceLog("/error/downLog","▣ 업로드 불가능한 파일(미디어타입)에 대한 다운로드 요청 S =============")
				Call FN_TraceLog("/error/downLog","IP : " & Request.ServerVariables("REMOTE_ADDR"))
				Call FN_TraceLog("/error/downLog","RF : " & Request.ServerVariables("HTTP_REFERER"))
				Call FN_TraceLog("/error/downLog","FN : " & DFileName)
				Call FN_TraceLog("/error/downLog","FormatName : " & FormatName)
				Call FN_TraceLog("/error/downLog","FormatMime : " & FormatMime)
				Call FN_TraceLog("/error/downLog","==================================")
				Call ALERTS(LNG_ERROR_MSG_04,"BACK","")
				Response.End
			Else
				Set Download = Server.CreateObject("TABSUpload4.Download")

				Download.FilePath = DFilepath
				Download.TransferFile True, True

				Set Download = Nothing

			End If
		End If

	'▣ 다운로드 가능한 파일인지 체크 E





%>

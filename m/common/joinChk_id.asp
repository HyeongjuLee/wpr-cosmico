<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	strUserID = pRequestTF("ids",True)

	'▣CS신버전 암호화 추가(WebID)
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'If strUserID	<> "" Then strUserID	= objEncrypter.Encrypt(strUserID)
		Set objEncrypter = Nothing
	End If

'웹체크
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,100,strUserID) _
	)
	ID_CNT = Db.execRsData("DKPA_TOTAL_ID_CHECK",DB_PROC,arrParams,Nothing)


'CS체크
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,100,strUserID) _
	)
	Set DKRS2 = Db.execRs("DKP_IDCHECK",DB_PROC,arrParams,DB3)

	' 차단 아이디 확인
		SQL1 = " SELECT [strBlockID] FROM [DK_SITE_CONFIG] WHERE [strSiteID] = ?"
		arrParams1 = Array(_
			Db.makeParam("@strSiteID",adVarchar,adParamInput,20,"www") _
		)
		Set DKRS1 = Db.execRs(SQL1,DB_TEXT,arrParams1,Nothing)
		BLOCKID = ""
		If Not DKRS1.BOF And Not DKRS1.EOF Then
			BLOCKID = DKRS1(0)
		End If
		Call closeRS(DKRS1)

'		print BLOCKID


	'▣CS신버전 복호화 추가(WebID) - 현재입력값과 비교
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'If strUserID	<> "" Then strUserID	= objEncrypter.Decrypt(strUserID)
		Set objEncrypter = Nothing
	End If



	If ID_CNT > 0 Then
		'RS_strUserID = DKRS("strUserID")
		PRINT "<span style=""color:red;font-weight:bold"">"&LNG_AJAX_IDCHECK_TEXT01&"</span>"
		PRINT "<input type=""hidden"" name=""idcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strUserID&""" readonly=""readonly"" />"
	ElseIf Not DKRS2.BOF And Not DKRS2.EOF Then
		PRINT "<span style=""color:red;font-weight:bold"">"&LNG_AJAX_IDCHECK_TEXT02&"</span>"
		PRINT "<input type=""hidden"" name=""idcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strUserID&""" readonly=""readonly"" />"
	Else
		If InStr(","& BLOCKID &",",","& strUserID &",") > 0 Then
			PRINT "<span style=""color:red;font-weight:bold"">"&LNG_AJAX_IDCHECK_TEXT01&". </span>"
			PRINT "<input type=""hidden"" name=""idcheck"" value=""F"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strUserID&""" readonly=""readonly"" />"
		Else
			PRINT "<span style=""color:blue;font-weight:bold"">"&LNG_AJAX_IDCHECK_TEXT03&"</span>"
			PRINT "<input type=""hidden"" name=""idcheck"" value=""T"" readonly=""readonly"" /><input type=""hidden"" name=""chkID"" value="""&strUserID&""" readonly=""readonly"" />"
		End If

	End If



'	Call closeRs(DKRS)
'print TempCnt

%>

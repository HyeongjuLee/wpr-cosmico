<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim MODE1, MODE2
		mem_id = Request.Form("memberId")
		mem_name = Request.Form("memberName")
		mem_email = Request.Form("memberMail")
		isCompany = Request.Form("isCom")

	If isCompany = "" Then isCompany = "F"

	If isCompany = "T" Then
		'▣CS신버전 암/복호화 추가
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				'If mem_id		<> "" Then mem_id		= objEncrypter.Encrypt(mem_id)
				If mem_email	<> "" Then mem_email	= objEncrypter.Encrypt(mem_email)
			Set objEncrypter = Nothing
		End If

		SQL = "SELECT [Email] FROM [tbl_Memberinfo] WHERE [WebID] = ? AND [M_Name] = ? AND [Email] = ? AND [LeaveCheck] = '1'"

		arrParams = Array(_
			Db.makeParam("@WebID",adVarChar,adParamInput,100,mem_id), _
			Db.makeParam("@M_Name",adVarWChar,adParamInput,100,mem_name), _
			Db.makeParam("@Email",adVarChar,adParamInput,512,mem_email) _
		)
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
	Else
		'▣CS신버전 암/복호화 추가
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If mem_email	<> "" Then mem_email	= objEncrypter.Encrypt(mem_email)
			Set objEncrypter = Nothing
		End If

		SQL = "SELECT [strEmail] FROM [DK_MEMBER] WHERE [strUserID] = ? AND [strName] = ? AND [strEmail] = ? AND [strState] = '101'"

		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,mem_id), _
			Db.makeParam("@strName",adVarWChar,adParamInput,100,mem_name), _
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,mem_email) _
		)
		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	'	Set DKRS = Db.execRs("DKP_PWDSEARCH",DB_PROC,arrParams,Nothing)
	End If


	If Not DKRS.BOF And Not DKRS.EOF Then

		RND_PWD = RandomChar(8)

		'▣CS신버전 패스워드 암호화
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If RND_PWD		<> "" Then RND_PWD		= objEncrypter.Encrypt(RND_PWD)
			Set objEncrypter = Nothing
		End If

		If isCompany = "T" Then
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,100,mem_id), _
				Db.makeParam("@strPass",adVarChar,adParamInput,100,RND_PWD), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOUTput,10,"ERROR") _
			)
			Call Db.exec("DKP_PWDCHG_CS",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			'▣CS신버전 암/복호화 추가
			If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					'If mem_id		<> "" Then mem_id		= objEncrypter.Decrypt(mem_id)
					If mem_email	<> "" Then mem_email	= objEncrypter.Decrypt(mem_email)
					If RND_PWD		<> "" Then RND_PWD		= objEncrypter.Decrypt(RND_PWD)
				Set objEncrypter = Nothing
			End If
		Else
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,mem_id), _
				Db.makeParam("@strPass",adVarChar,adParamInput,100,RND_PWD), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOUTput,10,"ERROR") _
			)
			Call Db.exec("DKP_PWDCHG",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			'▣CS신버전 암/복호화 추가
			If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					If mem_email	<> "" Then mem_email	= objEncrypter.Decrypt(mem_email)
					If RND_PWD		<> "" Then RND_PWD		= objEncrypter.Decrypt(RND_PWD)
				Set objEncrypter = Nothing
			End If
		End If

			Select Case OUTPUT_VALUE
				Case "FINISH"

				HtmlBody = ""
				HtmlBody = HtmlBody & "<p>"&LNG_AJAX_IDPW_PWD_TEXT01&"</p>"
				HtmlBody = HtmlBody & "<p>"&LNG_AJAX_IDPW_PWD_TEXT02&" "&mem_id&" "&LNG_AJAX_IDPW_PWD_TEXT03&"</p>"
				HtmlBody = HtmlBody & "<p>"&LNG_AJAX_IDPW_PWD_TEXT05&" <span style=""color: #7c7c7c;"">"&RND_PWD&" </span></p>"
				HtmlBody = HtmlBody & "<p><br />"&LNG_AJAX_IDPW_PWD_TEXT06&"</p>"
				HtmlBody = HtmlBody & "<p><br />"&LNG_AJAX_IDPW_PWD_TEXT07&"</p>"

				'CALL SendMail(mem_email, DKCONF_SITE_TITLE & LNG_AJAX_IDPW_PWD_TEXT09, HtmlBody)
				PRINT SendMail(mem_email, DKCONF_SITE_TITLE & LNG_AJAX_IDPW_PWD_TEXT09, HtmlBody)

				Case "ERROR"
					PRINT "<strong class=""red"">"&LNG_AJAX_IDPW_PWD_TEXT11&"</strong>"
				Case Else
					PRINT "<strong class=""red"">"&LNG_AJAX_IDPW_PWD_TEXT12&"</strong>"
			End Select

	Else
		If isCompany = "T" Then
			PRINT "<strong class=""green"">"&LNG_AJAX_IDPW_PWD_TEXT13&"</strong>"
		Else
			PRINT "<strong class=""red"">"&LNG_AJAX_IDPW_PWD_TEXT14&"</strong>"
		End If
	End If

%>

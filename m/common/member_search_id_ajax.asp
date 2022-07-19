<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"



	Dim MODE1, MODE2
		'mem_id = Request.Form("mem_id")
		mem_name = Request.Form("memberName")
		mem_email = Request.Form("memberMail")
		isCompany = Request.Form("isCom")


'	print mem_name
'	print mem_email
'	print isCompany

'	mem_name  = "테스트4"
'	'mem_name  = "웹프로"
'	mem_email ="hjtime07@nate.com"
'	isCompany ="T"
'	print isCompany
'	response.End
	If isCompany = "" Then isCompany = "F"

	'▣CS신버전 암/복호화 추가
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If mem_email	<> "" Then mem_email	= objEncrypter.Encrypt(mem_email)
		Set objEncrypter = Nothing
	End If

	If isCompany = "T" Then
		arrParams2 = Array(_
			Db.makeParam("@M_Name",adVarChar,adParamInput,100,mem_name), _
			Db.makeParam("@Email",adVarWChar,adParamInput,512,mem_email) _
		)
		Set DKRS2 = Db.execRs("DKP_IDSEARCH_CS",DB_PROC,arrParams2,DB3)
		If Not DKRS2.BOF And Not DKRS2.EOF Then
			WebID = DKRS2(0)

			IF SNS_LOGIN_TF = "T" Then		'snsType 컬럼추가 확인!
				On Error Resume Next
				WebPassword = DKRS2(1)
				snsType = DKRS2(2)
				On Error Goto 0
			Else
				WebPassword = ""
				snsType = ""
			End If

			If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					'If WebID	<> "" Then WebID	= objEncrypter.Decrypt(WebID)
				Set objEncrypter = Nothing
			End If

			idLens = Len(WebID)
			idLeng = idLens - 3

			If WebID = "" Then
				If snsType <> "" Then
					PRINT "<strong class=""red2"">SNS 가입회원</span>"
				Else
					PRINT "<strong class=""red2"">"&LNG_AJAX_IDPW_TEXT01&"</span>"
				End If
			Else
				If snsType <> "" And WebPassword = "" Then
					PRINT "<strong class=""red2"">SNS 가입회원!</span>"
				Else
					'PRINT ""&LNG_AJAX_IDPW_TEXT02&"<br /><strong class=""red font_verdana"" style=""font-size:15px;"">"& Left(WebID,idLeng)&"*** </strong><br /><span class=""f8pt"">"&LNG_AJAX_IDPW_TEXT03&"</span>"
					PRINT ""&LNG_AJAX_IDPW_TEXT02&"<br /><strong class=""red font_verdana"" style=""font-size:15px;"">"&WebID&"</strong>"
				End If
			End If
		Else
			PRINT "<strong class=""green"">"&LNG_AJAX_IDPW_TEXT04&"</strong>"
		End If

	Else
		arrParams = Array(_
			Db.makeParam("@strName",adVarWChar,adParamInput,100,mem_name), _
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,mem_email) _
		)
		Set DKRS = Db.execRs("DKP_IDSEARCH",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			strUserID = DKRS(0)
			idLens = Len(strUserID)
			idLeng = idLens - 3
			PRINT ""&LNG_AJAX_IDPW_TEXT02&"<br /><strong class=""red font_verdana"" style=""font-size:15px;"">"& Left(strUserID,idLeng)&"*** </strong><br /><span class=""f8pt"">"&LNG_AJAX_IDPW_TEXT03&"</span>"
		Else
			PRINT "<strong class=""red"">"&LNG_AJAX_IDPW_TEXT05&"</strong>"
		End If

	End IF




%>

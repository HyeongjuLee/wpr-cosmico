<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    strEmail	= pRequestTF_JSON2("email",True)

	'▣CS신버전 암호화 추가(WebID)
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strEmail	<> "" Then strEmail	= objEncrypter.Encrypt(LCase(strEmail))
		Set objEncrypter = Nothing
	End If

	SQL = "SELECT COUNT([Email]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [Email] = ?"
	arrParams = Array(_
		Db.makeParam("@strEmail",adVarWChar,adParamInput,200,strEmail) _
	)
	Email_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)




	If Email_CNT > 0 Then
		PRINT "{""result"":""success"", ""message"":"""&LNG_AJAX_EMAILCHECK_F&""" ,""emailCheck"":""F""}"
		Response.End
	Else
		PRINT "{""result"":""success"", ""message"":"""&LNG_AJAX_EMAILCHECK_T&""",""emailCheck"":""T""}"
		Response.End
	End If



Response.end

%>

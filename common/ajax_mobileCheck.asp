<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    strMobile	= pRequestTF_JSON2("strMobile",True)

	'▣CS신버전 암호화 추가(WebID)
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
		Set objEncrypter = Nothing
	End If

	SQL = "SELECT COUNT([hptel]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [hptel] = ?"
	arrParams = Array(_
		Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMobile) _
	)
	hptel_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	If hptel_CNT > 0 Then
		PRINT "{""result"":""success"", ""message"":"""&LNG_AJAX_MOBILE_CHK_F&""" ,""mobileCheck"":""F""}"
		Response.End
	Else
		PRINT "{""result"":""success"", ""message"":"""&LNG_AJAX_MOBILE_CHK_T&""",""mobileCheck"":""T""}"
		Response.End
	End If



Response.end

%>

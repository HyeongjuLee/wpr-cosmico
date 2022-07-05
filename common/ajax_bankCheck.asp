<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

  bankCode	= pRequestTF_JSON2("bankCode",True)
  bankNumber	= pRequestTF_JSON2("bankNumber",True)

	'▣CS신버전 암호화 추가(WebID)
	If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If bankNumber	<> "" Then bankNumber	= objEncrypter.Encrypt(LCase(bankNumber))
		Set objEncrypter = Nothing
	End If

	SQL = "SELECT COUNT(*) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankCode] = ? And [bankaccnt] = ? "
	arrParams = Array(_
		Db.makeParam("@bankCode",adVarWChar,adParamInput,100,bankCode), _
		Db.makeParam("@bankNumber",adVarChar,adParamInput,100,bankNumber) _
	)
	Bank_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)


	If Bank_CNT > 0 Then
		PRINT "{""result"":""success"", ""message"":""이미 등록된 계좌정보가 존재합니다"" ,""emailCheck"":""F""}"
		Response.End
	Else
		PRINT "{""result"":""success"", ""message"":""등록가능합니다."",""emailCheck"":""T""}"
		Response.End
	End If

Response.end

%>

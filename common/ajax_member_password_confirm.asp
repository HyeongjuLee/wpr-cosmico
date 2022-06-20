<!--#include virtual = "/_lib/strFunc.asp"-->
<%
    '출금 PIN(WebPassWord) ajax
  	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    Money_Output_Pin = pRequestTF_JSON2("Money_Output_Pin",True)


	Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		On Error Resume Next
			If Money_Output_Pin		<> "" Then Money_Output_Pin	= objEncrypter.Encrypt(Money_Output_Pin)
		On Error GoTo 0
	Set objEncrypter = Nothing


	'WebPassWord
	SQL_OP = "SELECT [WebPassWord] FROM [tbl_memberInfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
	arrParamsOP = Array(_
		Db.makeParam("@DK_MEMBER_ID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
	)
	ORI_Money_Output_Pin = Db.execRsData(SQL_OP,DB_TEXT,arrParamsOP,DB3)

	If ORI_Money_Output_Pin = "" Then
	     PRINT "{""statusCode"":""9998"",""message"":"""&LNG_CS_ORDER_LIST_DETAIL_TEXT15&""",""result"":""""}"	'미등록
		Response.End
	End iF

	If ORI_Money_Output_Pin <> Money_Output_Pin Then
        PRINT "{""statusCode"":""9999"",""message"":"""&LNG_JS_PASSWORD_INCORRECT&""",""result"":""""}"
    Else
        PRINT "{""statusCode"":""0000"",""message"":"""&LNG_SHOP_ORDER_LIST_JS01&""",""result"":""""}"
    End If

Response.end

%>

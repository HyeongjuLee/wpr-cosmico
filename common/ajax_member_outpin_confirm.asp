<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
    '출금 PIN ajax
  	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    Money_Output_Pin = pRequestTF_JSON2("Money_Output_Pin",True)

	SQL_OP = "SELECT [Money_Output_Pin] FROM [tbl_memberInfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
	arrParamsOP = Array(_
		Db.makeParam("@DK_MEMBER_ID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
	)
	ORI_Money_Output_Pin = Db.execRsData(SQL_OP,DB_TEXT,arrParamsOP,DB3)

	If ORI_Money_Output_Pin = "" Then
	     PRINT "{""statusCode"":""9998"",""message"":"""&LNG_CS_ORDER_LIST_DETAIL_TEXT15&""",""result"":""""}"	'미등록
		Response.End
	End iF

	'▣SHA=256 암호비교(UCase!!)
	Money_Output_Pin = UCase(SHA256_Encrypt(Money_Output_Pin))

	If ORI_Money_Output_Pin <> Money_Output_Pin Then
        PRINT "{""statusCode"":""9999"",""message"":"""&LNG_JS_PASSWORD_INCORRECT&""",""result"":""""}"
    Else
        PRINT "{""statusCode"":""0000"",""message"":"""&LNG_SHOP_ORDER_LIST_JS01&""",""result"":""""}"
    End If

Response.end

%>

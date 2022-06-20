<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


		strCateCode			= pRequestTF_AJAX2("CateCode",True)
		strNationCode		= pRequestTF_AJAX2("NationCode",True)

		'If strCateCode = "" Then
		'	Call ReturnAjaxMsg("SUCCESS","")
		'End If


		'Response.End


		SQL = "SELECT [strBaseText] FROM [DKT_COUNSEL_1ON1_CATEGORY] WHERE [strCateCode] = ? AND [strNationCode] = ?"


		arrParams = Array( _
			Db.makeParam("@strCateCode",adVarChar,adParamInput,20,strCateCode), _
			Db.makeParam("@strCodeNation",adVarChar,adParamInput,6,strNationCode) _

		)
		strBaseText = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)



		'Call ReturnAjaxMsg("SUCCESS",Replace(strBaseText,"<br />","\n"))
		Call ReturnAjaxMsg("SUCCESS",strBaseText)






%>

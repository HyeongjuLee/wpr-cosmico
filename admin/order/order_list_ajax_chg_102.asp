<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX			= pRequestTF_AJAX("intIDX",True)
		i				= pRequestTF_AJAX("Ri",True)
		strNationCode	= pRequestTF_AJAX("nc",False)		'국가코드


		arrParams1 = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_102_CHK",DB_PROC,arrParams1,Nothing)
		OUTPUT_VALUE1 = arrParams1(Ubound(arrParams1))(4)


If OUTPUT_VALUE1 = "OK" Then
		arrParams2 = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_102",DB_PROC,arrParams2,Nothing)
		OUTPUT_VALUE2 = arrParams2(Ubound(arrParams2))(4)

		Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)	'국가별통화

%>
	<%If isMACCO = "T" Then%>
	<!--#include file="order_list_ajax_chg_MACCO.asp" -->
	<%Else%>
	<!--#include file="order_list_ajax_chg.asp" -->
	<%End If%>
<%Else
	Response.Write "MISS"
End If%>

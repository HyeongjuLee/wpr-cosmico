<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%

	'�ѱ�
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX			= pRequestTF_AJAX("intIDX",True)
		i				= pRequestTF_AJAX("Ri",True)
		strNationCode	= pRequestTF_AJAX("nc",False)		'�����ڵ�


		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_103",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


'		Select Case OUTPUT_VALUE
'			Case "FINISH" : PRINT "FINISH"
'			Case "ERROR" : PRINT "ERROR"
'			Case Else : PRINT "MISS"
'		End Select

		Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)	'��������ȭ

%>
<%If isMACCO = "T" Then%>
<!--#include file="order_list_ajax_chg_MACCO.asp" -->
<%Else%>
<!--#include file="order_list_ajax_chg.asp" -->
<%End If%>
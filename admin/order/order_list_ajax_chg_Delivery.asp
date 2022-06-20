<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX = pRequestTF_AJAX("intIDX",True)
		ChgIDX = pRequestTF_AJAX("ChgIDX",True)

		DtoD_Date  = pRequestTF_AJAX("DtoD_Date",True)
		DtoD_Com   = pRequestTF_AJAX("DtoD_Com",False)
		DtoD_Num   = pRequestTF_AJAX("DtoD_Num",False)

		If DtoD_Com = "date" Then DtoD_Com = 0    '배송일자만 입력시 DtoD_Com 데이터형식오류

		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@ChgIDX",adInteger,adParamInput,4,ChgIDX), _
			Db.makeParam("@DtoD_Com",adInteger,adParamInput,4,DtoD_Com), _
			Db.makeParam("@DtoD_Num",adVarChar,adParamInput,30,DtoD_Num), _
			Db.makeParam("@DtoD_Date",adDbTimeStamp,adParamInput,16,DtoD_Date), _
			Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
			Db.makeParam("@RESULT_VALUE",adVarChar,adParamOutput,10,"MISS"), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_DELIVERY",DB_PROC,arrParams,Nothing)
		RESULT_VALUE = arrParams(Ubound(arrParams)-1)(4)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		If RESULT_VALUE = "OK" Then
%>
<%If isMACCO = "T" Then%>
<!--#include file="order_list_ajax_chg_MACCO.asp" -->
<%Else%>
<!--#include file="order_list_ajax_chg.asp" -->
<%End If%>
<%		Else
	Response.Write Trim("THIS")
		End If
%>


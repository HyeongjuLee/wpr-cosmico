<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
	If DK_MEMBER_TYPE <> "ADMIN" Then Call ALERTS("관리자가 아닙니다.","close","")



	intIDX				= pRequestTF("idx",True)
	strMobile			= pRequestTF("strMobile",True)
	DK_SITE_CALLBACK	= pRequestTF("callback",True)
	SMS_CONTENT			= pRequestTF("smscontent",True)



		arrParams = Array(_
			Db.makeParam("@b2bID",adVarChar,adParamInput,20,DK_SITE_PK) _
		)
		SMSCnt = Db.execRsData("DKP_WEBPRO_SMS_CNT",DB_PROC,arrParams,DB3)

		If Not IsNull(SMSCnt) Then
			If CInt(SMSCnt) > 0 Then

				arrParams = Array(_
					Db.makeParam("@tran_phone",adVarChar,adParamInput,15,strMobile),_
					Db.makeParam("@tran_callback",adVarChar,adParamInput,15,DK_SITE_CALLBACK),_
					Db.makeParam("@tran_msg",adVarChar,adParamInput,255,SMS_CONTENT),_
					Db.makeParam("@tran_id",adVarChar,adParamInput,20,DK_SITE_PK),_
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutPut,10,"ERROR") _
				)
				Call Db.exec("WEBPRO_SMS2",DB_PROC,arrParams,DB3)
				OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
				Select Case OUTPUT_VALUE
					Case "ERROR"  : Call alerts("SMS 전송에 문제가 발생했습니다.","back","")
					Case "FINISH" : Call ALERTS("전송하였습니다.","CLOSE","")
				End Select
			Else
				Call ALERTS("SMS 전송건수가 부족합니다","BACK","")
			End If
		Else
			Call ALERTS("SMS 사용 고객이 아닙니다.","BACK","")
		End If





%>

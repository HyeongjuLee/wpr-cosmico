<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG7-2"



	Cnt_NationCode			= Request.form("NationCode").count
	Cnt_DeliveryFee			= Request.form("DeliveryFee").count
	Cnt_DeliveryFeeLimit	= Request.form("DeliveryFeeLimit").count


	Call RequestLoopCheck("NationCode",True)
	Call RequestLoopCheck("DeliveryFee",True)
	Call RequestLoopCheck("DeliveryFeeLimit",True)


		'국가별 배송비 변경 로그 기록
		Function Fnc_CART_Compare(ByVal NationCode, ByVal COMPARETYPE, ByVal COMPARE1, ByVal COMPARE2)
			If COMPARE1 <> COMPARE2 Then

				arrParams = Array(_
					Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
					Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
					Db.makeParam("@strNationCode",adVarChar,adParamInput,20,NationCode),_
					Db.makeParam("@strFieldName",adVarChar,adParamInput,50,COMPARETYPE), _
					Db.makeParam("@bData",adDouble,adParamInput,16,COMPARE1), _
					Db.makeParam("@aData",adDouble,adParamInput,16,COMPARE2), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("HJPA_DELIVERYFEE_CHG_LOG_INSERT",DB_PROC,arrParams,Nothing)
				OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
				If OUTPUT_VALUE = "FINISH" Then
					RESULT_CNT = RESULT_CNT
					'PRINT COMPARETYPE
				Else
					RESULT_CNT = RESULT_CNT + 1
				End If

			End If

		End Function


	For i = 1 To Cnt_NationCode

		Call Fnc_CART_Compare(Request.form("NationCode")(i),	"DeliveryFee"		,CDbl(Request.form("ori_DeliveryFee")(i)),			CDbl(Request.form("DeliveryFee")(i))	)
		Call Fnc_CART_Compare(Request.form("NationCode")(i),	"DeliveryFeeLimit"	,CDbl(Request.form("ori_DeliveryFeeLimit")(i)),		CDbl(Request.form("DeliveryFeeLimit")(i))	)

		arrParams = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,Request.form("NationCode")(i)), _
			Db.makeParam("@DeliveryFee",adDouble,adParamInput,16,Request.form("DeliveryFee")(i)), _
			Db.makeParam("@DeliveryFeeLimit",adDouble,adParamInput,16,Request.form("DeliveryFeeLimit")(i)), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP()), _
			Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
		)
		Call Db.exec("DKSP_SITE_NATION_DELIVERY_FEE_UPDATE",DB_PROC,arrParams,Nothing)
	Next


	If Err.Number = 0 Then
		Call ALERTS(DBFINISH,"GO","DeliveryFee.asp")
	Else
		Call ALERTS(DBERROR&Err.Description,"back","")
	End If




%>


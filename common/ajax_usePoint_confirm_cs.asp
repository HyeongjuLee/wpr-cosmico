<!--#include virtual = "/_lib/strFunc.asp"-->
<%

  	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    OIDX		= pRequestTF_JSON2("OIDX",True)
    OrderNum	= pRequestTF_JSON2("OrderNum",True)

    usePoint		= pRequestTF_JSON2("usePoint",True)
    ori_totalPrice	= pRequestTF_JSON2("ori_totalPrice",True)
    totalDelivery	= pRequestTF_JSON2("totalDelivery",True)

	usePoint		= CDbl(CStr(usePoint))
	ori_totalPrice	= CDbl(CStr(ori_totalPrice))
	totalDelivery	= CDbl(CStr(totalDelivery))

	If OIDX = "" Or OrderNum = "" Then
		PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&" "&LNG_STRTEXT_TEXT02&"_03"", ""resultData"":""""}"
		Response.End
	End If

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
	)
	Set AHJRS = Db.execRs("HJP_ORDER_TEMP_CHECK_VIEW_CS",DB_PROC,arrParams,DB3)
	If Not AHJRS.BOF And Not AHJRS.EOF Then
		AHJRS_intIDX			= AHJRS("intIDX")
		AHJRS_orderNum			= AHJRS("orderNum")
		AHJRS_MBID				= AHJRS("MBID")
		AHJRS_MBID2				= AHJRS("MBID2")
		AHJRS_totalPrice		= AHJRS("totalPrice")
		AHJRS_totalDelivery		= AHJRS("deliveryFee")
		AHJRS_usePoint			= AHJRS("InputMileage")
		AHJRS_usePoint2			= AHJRS("InputMileage2")

		'▣위변조체크
		If CDbl(ori_totalPrice) <> CDbl(AHJRS_totalPrice+AHJRS_usePoint) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (totalPrice)!"", ""resultData"" : """"}"
			Response.End
		End If
		If CDbl(totalDelivery) <> CDbl(AHJRS_totalDelivery) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (totalDelivery)!"", ""resultData"" : """"}"
			Response.End
		End If


		MILEAGE_TOTAL = CDbl(CStr(MILEAGE_TOTAL))

		If CDbl(MILEAGE_TOTAL) < CDbl(num2Cur(usePoint)) Then
			PRINT "{""result"":""error"", ""message"":"""&LNG_JS_POINT_EXCEEDED&""", ""resultData"" : """"}"
			Response.End
		End If

		'배송비 제외 사용가능
		'If CDbl(ori_totalPrice-totalDelivery) < CDbl(num2Cur(usePoint)) Then
		'	PRINT "{""result"":""error"", ""message"":"""&LNG_JS_POINT_EXCEEDED&"02"", ""resultData"" : """"}"
		'	Response.End
		'End If


		usePoint2 = 0
		usePointFEE = 0

		'▣포인트 업데이트
		arrParamsPU = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum), _
			Db.makeParam("@totalPrice",adDouble,adParamInput,16,ori_totalPrice-usePoint), _
			Db.makeParam("@usePoint",adDouble,adParamInput,16,usePoint), _
			Db.makeParam("@usePoint2",adDouble,adParamInput,16,usePoint2), _

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_POINT_INFO_CS_SHOP_UPDATE",DB_PROC,arrParamsPU,DB3)
		OUTPUT_VALUE = arrParamsPU(UBound(arrParamsPU))(4)

		Select Case OUTPUT_VALUE
			Case "FINISH"
				'▣성공
				PRINT "{""result"":""success"", ""message"":"""&LNG_STRTEXT_TEXT03&"!"", ""resultData"" : {""usePointFEE"":"""&usePointFEE&""", ""usePoint"":"""&usePoint&"""}}"
				Response.End
			Case "NODATA"
				PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&"_01""}"
				Response.End
			Case "ERROR"
				PRINT "{""result"":""error"", ""message"":"""&LNG_STRTEXT_TEXT01&"!""}"
				Response.End
		End Select


	Else
		PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&" "&LNG_STRTEXT_TEXT02&"_02"", ""resultData"":""""}"
		Response.End
	End If
	Call closeRS(AHJRS)




Response.end

%>

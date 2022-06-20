<!--#include virtual = "/_lib/strFunc.asp"-->
<%
    '이체(PC_0000) PIN ajax
  	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

    transPoint	= pRequestTF_JSON2("transPoint",True)
    OIDX		= pRequestTF_JSON2("OIDX",True)
    OrderNum	= pRequestTF_JSON2("OrderNum",True)

	transPoint = CDbl(transPoint)

	If OIDX = "" Or OrderNum = "" Then
		PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&" "&LNG_STRTEXT_TEXT02&"_03"", ""resultData"":""""}"
		Response.End
	End If

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
	)
	Set AHJRS = Db.execRs("HJP_POINT_CHECK_VIEW",DB_PROC,arrParams,DB3)
	If Not AHJRS.BOF And Not AHJRS.EOF Then
		AHJRS_intIDX			= AHJRS("intIDX")
		AHJRS_OrderNum			= AHJRS("OrderNum")
		AHJRS_MBID				= AHJRS("MBID")
		AHJRS_MBID2				= AHJRS("MBID2")
		AHJRS_strUsePageName	= AHJRS("strUsePageName")
		AHJRS_GoogleOTPCheck	= AHJRS("GoogleOTPCheck")
		AHJRS_BTC_qoute			= AHJRS("BTC_qoute")
		AHJRS_BTC_QOUTE_1USD	= AHJRS("BTC_QOUTE_1USD")
		AHJRS_FEE_PERCENT		= AHJRS("FEE_PERCENT")
		AHJRS_transPointTOTAL	= AHJRS("transPointTOTAL")
		AHJRS_transPoint		= AHJRS("transPoint")
		AHJRS_transPointFEE		= AHJRS("transPointFEE")
		AHJRS_WITHDRAW_UNIT		= AHJRS("WITHDRAW_UNIT")			'출금(이체)액단위
		AHJRS_MINIMUM_POINT		= AHJRS("MINIMUM_POINT")
		AHJRS_MAXIMUM_POINT		= AHJRS("MAXIMUM_POINT")
		AHJRS_btc_usd			= AHJRS("btc_usd")
		AHJRS_btc_usd_PERCENT	= AHJRS("btc_usd_PERCENT")
		AHJRS_TranBTC			= AHJRS("TranBTC")
		AHJRS_regDate			= AHJRS("regDate")

		'이체 ============================================================================
			HJRSC_BTC_qoute		= 0
			MINIMUM_POINT		= CONST_CS_MINIMUM_TRANS_POINT
			FEE_PERCENT			= CONST_CS_FEE_PERCENT_TRANS			'이체 수수료(율)
		'이체 ============================================================================

		'▣ OTP 2차검증
		If GOOGLE_OTP_USE_TF = "T" Then
			If AHJRS_GoogleOTPCheck <> "T" Then
				PRINT "{""result"":""error"", ""message"":"""&LNG_GOOGLE_OTP_NOT&"!"", ""resultData"" : """"}"
				Response.End
			End If
		End If

		'▣위변조체크
		If CDbl(HJRSC_BTC_qoute) <> CDbl(AHJRS_BTC_qoute) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (BTC_qoute)!"", ""resultData"" : """"}"
			Response.End
		End If
		If CDbl(FEE_PERCENT) <> CDbl(AHJRS_FEE_PERCENT) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (FEE_PERCENT)!"", ""resultData"" : """"}"
			Response.End
		End If
		If CDbl(num2Cur(MINIMUM_POINT)) <> CDbl(AHJRS_MINIMUM_POINT) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (MINIMUM_POINT)!"", ""resultData"" : """"}"
			Response.End
		End If

		If CDbl(num2Cur(CONST_CS_TRANS_UNIT)) <> CDbl(AHJRS_WITHDRAW_UNIT) Then
			PRINT "{""result"":""error"", ""message"":""Data modulation (WITHDRAW_UNIT)!"", ""resultData"" : """"}"
			Response.End
		End If


		'▣최소이체 확인 #1 (치환)
		MINIMUM_POINT_CHK_TF = ""
		If CDbl(transPoint) < CDbl(num2Cur(MINIMUM_POINT)) Then		'num2Cur!!
			transPoint = MINIMUM_POINT
			MINIMUM_POINT_CHK_TF = "T"
		End If

		'▣수수료 / 총이체액 계산
		transPointFEE	= CDbl(transPoint) * CDbl(FEE_PERCENT)
		transPointTOTAL	= CDbl(transPoint) + CDbl(transPointFEE)

		'★★★ DB입력 자릿수처리 (정수:num2Cur num2CurINT, 2자리:num2CurG, 8자리, num2CurP) ★★★
		transPoint		= CDbl(num2Cur(transPoint))
		transPointFEE	= CDbl(num2Cur(transPointFEE))
		transPointTOTAL = CDbl(num2Cur(transPointTOTAL))

		'▣최소이체 확인 #2
		If MINIMUM_POINT_CHK_TF = "T" Then
			PRINT "{""result"":""minimum"", ""message"":"""&LNG_MINIMUM_WITHDRAW_POINT&" : ("&transPoint&") ! "", ""resultData"":{""transPointFEE"":"""&transPointFEE&""", ""transPointTOTAL"": """&transPointTOTAL&""", ""transPoint"":"""&MINIMUM_POINT&"""}}"
			Response.End
		End If

		'▣이체액 단위 확인
		If transPoint Mod CONST_CS_TRANS_UNIT <> 0 Then
			PRINT "{""result"":""error"", ""message"":"""&LNG_CS_POINT_TRANSFER2CASH_OK_ALERT06& "("&num2cur(CONST_CS_TRANS_UNIT)&")"", ""resultData"" : """"}"
			Response.End
		End If


		'▣ 소수점 비교에러 추가 S =====================
			MILEAGE_TOTAL = CDbl(CStr(MILEAGE_TOTAL))
		'▣ 소수점 비교에러 추가 E =====================

		'If CDbl(MILEAGE_TOTAL) < CDbl(transPointTOTAL) Then				'XXX 비교안됨!
		If CDbl(MILEAGE_TOTAL) < CDbl(num2Cur(transPointTOTAL)) Then		'num2Cur!!
			PRINT "{""result"":""error"", ""message"":"""&LNG_CS_POINT_TRANSFER2CASH_JS02&"!"", ""resultData"" : """"}"
			Response.End
		Else


			'▣포인트 업데이트
			arrParamsPU = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
				Db.makeParam("@transPointTOTAL",adDouble,adParamInput,16,transPointTOTAL), _
				Db.makeParam("@transPoint",adDouble,adParamInput,16,transPoint), _
				Db.makeParam("@transPointFEE",adDouble,adParamInput,16,transPointFEE), _
				Db.makeParam("@TranBTC",adDouble,adParamInput,16,0), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_POINT_INFO_UPDATE",DB_PROC,arrParamsPU,DB3)
			OUTPUT_VALUE = arrParamsPU(UBound(arrParamsPU))(4)

			Select Case OUTPUT_VALUE
				Case "FINISH"
					'▣성공
					PRINT "{""result"":""success"", ""message"":"""&LNG_STRTEXT_TEXT03&"!"", ""resultData"" : {""transPointFEE"":"""&transPointFEE&""", ""transPointTOTAL"":"""&transPointTOTAL&"""}}"
					Response.End
				Case "NODATA"
					PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&"_01""}"
					Response.End
				Case "ERROR"
					PRINT "{""result"":""error"", ""message"":"""&LNG_STRTEXT_TEXT01&"!""}"
					Response.End
			End Select



		End If


	Else
		PRINT "{""result"":""error"", ""message"":"""&LNG_TEXT_NO_DATA&" "&LNG_STRTEXT_TEXT02&"_02"", ""resultData"":""""}"
		Response.End
	End If
	Call closeRS(AHJRS)




Response.end

%>

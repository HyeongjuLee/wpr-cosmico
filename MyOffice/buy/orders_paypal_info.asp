<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	' 개별 변수 받아오기

		Dim takeName		: takeName		= Trim(Request.Form("takeName"))

		Dim takeTel			: takeTel		= Trim(Request.Form("takeTel"))

		Dim takeMob			: takeMob		= Trim(Request.Form("takeMob"))

		Dim takeZip			: takeZip		= Trim(Request.Form("takeZip"))
		Dim takeADDR1		: takeADDR1		= Trim(Request.Form("takeADDR1"))
		Dim takeADDR2		: takeADDR2		= Trim(Request.Form("takeADDR2"))

		Dim v_SellCode		: v_SellCode	= Trim(Request.Form("v_SellCode"))

		Dim payKind			: payKind		= Trim(Request.Form("payKind"))

		Dim orderNum		: orderNum		= Trim(Request.Form("OrdNo"))
		Dim OIDX			: OIDX			= Trim(Request.Form("OIDX"))
		Dim totalPrice		: totalPrice	= Trim(Request.Form("totalPrice"))		'LAST_PRICE = TOTAL_PRICE + DELIVERY_PRICE

		Dim totalDelivery	: totalDelivery	= Trim(Request.Form("totalDelivery"))

		Dim cuidx			: cuidx			= Trim(Request.Form("cuidx"))
		Dim usePoint		: usePoint		= Trim(Request.Form("useCmoney"))
		Dim isDownOrder		: isDownOrder	= Trim(Request.Form("isDownOrder"))
		Dim DtoD			: DtoD			= Trim(Request.Form("DtoD"))			'현장수령여부

		If usePoint = Null Or usePoint = "" Then usePoint = 0
		If DtoD = Null Or DtoD = "" Then DtoD = "T"

		If CDbl(usePoint) > CDbl(MILEAGE_TOTAL) Then Call ALERTS("사용할수 있는 "&SHOP_POINT&"를 초과하였습니다.1","BACK","")

		totalPrice = CDbl(totalPrice) + CDbl(usePoint)		'▣주문임시테이블 합계금 업데이트

		'cmd					= pRequestTF_AJAX("cmd",True)
		'charset				= pRequestTF_AJAX("charset",True)
		'item_name			= pRequestTF_AJAX("item_name",True)
		'item_number			= pRequestTF_AJAX("item_number",True)
		business			= pRequestTF_AJAX("business",True)
		'currency_code		= pRequestTF_AJAX("currency_code",True)
		amount				= pRequestTF_AJAX("amount",True)

		v_C_Etc = "PAYPAL : "&business & ", AMOUNT : "& amount		'상점아이디

		CcCode				= ""
		BankPenName			= ""
		v_C_Number1			= ""
		C_NAME2				= ""

		If LCase(payKind) = "paypal" Then payKind = "card"


		'◈CS신버전  암호화!!
		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If v_C_Number1		<> "" Then v_C_Number1	= objEncrypter.Encrypt(v_C_Number1)

				If DKCONF_ISCSNEW = "T" Then
					If takeADDR1	<> "" Then takeADDR1	= objEncrypter.Encrypt(takeADDR1)
					If takeADDR2	<> "" Then takeADDR2	= objEncrypter.Encrypt(takeADDR2)
					If takeMob		<> "" Then takeMob		= objEncrypter.Encrypt(takeMob)
					If takeTel		<> "" Then takeTel		= objEncrypter.Encrypt(takeTel)
				End If
			Set objEncrypter = Nothing
		End If


'	print OIDX
'	print orderNum
'	print totalPrice
'	print takeName
'	print takeZip
'	print takeADDR2
'	print takeADDR1
'	print takeMob
'	print takeTel
'	print v_SellCode
'	print totalDelivery
'	print payKind
'	print v_C_Etc
'	print usePoint
'	print DtoD
'	Response.End

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
		Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName), _
		Db.makeParam("@takeZip",adVarChar,adParamInput,10,takeZip), _
		Db.makeParam("@takeADDR1",adVarWChar,adParamInput,700,takeADDR1), _
		Db.makeParam("@takeADDR2",adVarWChar,adParamInput,700,takeADDR2), _
		Db.makeParam("@takeMob",adVarChar,adParamInput,100,takeMob), _
		Db.makeParam("@takeTel",adVarChar,adParamInput,100,takeTel), _
		Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
		Db.makeParam("@deliveryFee",adInteger,adParamInput,0,totalDelivery), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,payKind), _

		Db.makeParam("@payPalETC",adVarWChar,adParamInput,250,v_C_Etc), _
		Db.makeParam("@InputMileage",adInteger,adParamInput,0,usePoint), _
		Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_PAYPAL_INFO_UPDATE",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "FINISH" : Response.Write "FINISH"
		Case "ERROR" : Response.Write "ERROR"
		Case "NOTORDER" : Response.Write "NOTORDER"
		Case "UPDATE" : Response.Write "UPDATE"
		Case Else  : Response.Write "ERROR"
	End Select
%>

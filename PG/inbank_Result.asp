<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

' 개별 변수 받아오기 (쇼핑몰 기본정보)
	paykind				= Trim(pRequestTF("paykind",True))
	ordersNumber		= Trim(pRequestTF("OrdNo",True))
	inUidx				= Trim(pRequestTF("cuidx",True))

	strName				= Trim(pRequestTF("strName",True))
	takeName			= Trim(pRequestTF("takeName",False))

	orderMode			= Trim(pRequestTF("orderMode",False))		'mobile(SHOP /MOBILE주문 통합)

	strTel				= Trim(pRequestTF("strTel",False))
	strMob				= Trim(pRequestTF("strMobile",True))
	takeTel				= Trim(pRequestTF("takeTel",False))
	takeMob				= Trim(pRequestTF("takeMobile",False))

	strEmail			= Trim(pRequestTF("strEmail",False))

	strZip				= Trim(pRequestTF("strZip",True))
	strADDR1			= Trim(pRequestTF("strADDR1",True))
	strADDR2			= Trim(pRequestTF("strADDR2",True))

	takeZip				= Trim(pRequestTF("takeZip",False))
	takeADDR1			= Trim(pRequestTF("takeADDR1",False))
	takeADDR2			= Trim(pRequestTF("takeADDR2",False))


	strSSH1 = ""
	strSSH2 = ""

	ori_price				= Trim(pRequestTF("ori_price",True))				'totalPrice ori			추가
	ori_delivery			= Trim(pRequestTF("ori_delivery",True))				'ori_delivery ori		추가
	totalPrice				= Trim(pRequestTF("totalPrice",True))
	totalDelivery			= Trim(pRequestTF("totalDelivery",True))
	DeliveryFeeType			= Trim(pRequestTF("DeliveryFeeType",False))
	GoodsPrice				= Trim(pRequestTF("GoodsPrice",True))

	totalOptionPrice		= Trim(pRequestTF("totalOptionPrice",False))
	totalOptionPrice2		= Trim(pRequestTF("totalOptionPrice2",False))		'goodsOPTcost
	totalPoint				= Trim(pRequestTF("totalPoint",False))
	orderMemo				= Trim(pRequestTF("orderMemo",False))

	input_mode				= Trim(pRequestTF("input_mode",False))

	bankidx					= Trim(pRequestTF("bankidx",False))
	bankingName				= Trim(pRequestTF("bankingName",False))
	usePoint				= Trim(pRequestTF("useCmoney",False))
	usePoint2				= Trim(pRequestTF("useCmoney2",False))				'▶SP포인트		InputMileage2		InputMile_S

	totalVotePoint			= Trim(pRequestTF("totalVotePoint",False))

	GoodsName			= Trim(pRequestTF("GoodsName",False))

	memo1					= Trim(pRequestTF("memo1",True))					'입금예정일 2017-03-20~



	orderEaD				= Trim(pRequestTF("ea",False))						'◆ #5. EA
	GoodIDXs				= Trim(pRequestTF("GoodIDXs",False))				'◆ #5. GoodIDXs
	strOptions				= Trim(pRequestTF("strOptions",False))				'◆ #5. strOptions
	OIDX					= Trim(pRequestTF("OIDX",True))						'◆ #5. 임시주문테이블 idx


	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

	'▣isDirect or Cart 체크 S
		isDirect		= Trim(pRequestTF("isDirect",False))
		GoodIDX			= Trim(pRequestTF("GoodIDX",False))

		If LCase(orderMode) = "mobile" Then
			chgPage = "/m"
		Else
			chgPage = ""
		End If

	''	'isDirect or Cart 체크 (GO_BACK_ADDR)
	''	If isDirect = "T" Then
	''		GO_BACK_ADDR = chgPage&"/shop/detailView.asp?gidx="&GoodIDX
	''	Else
	''		GO_BACK_ADDR = chgPage&"/shop/cart.asp"
	''	End If
	'▣isDirect or Cart 체크 E

	'♠ GO_BACK_ADDR 주문페이지로 보내기 S♠
		gidx = inUidx

		On Error Resume Next
		Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
			gidx = Trim(StrCipher.Encrypt(gidx,EncTypeKey1,EncTypeKey2))
		Set StrCipher = Nothing
		On Error GoTo 0

		GO_BACK_ADDR = chgPage&"/shop/cart_directB.asp?gidx="&gidx
	'♠ GO_BACK_ADDR 주문페이지로 보내기 E♠


''	'◆현금영수증신고S
''		C_HY_TF		 = Trim(pRequestTF("C_HY_TF",False))
''		C_HY_SendNum = Trim(pRequestTF("C_HY_SendNum",False))
''		C_HY_SendNum = Replace(C_HY_SendNum,"-","")
''
''		If C_HY_SendNum <> "" Then
''			If IsNumeric(C_HY_SendNum) = False Or Len(C_HY_SendNum) < 10 Then
''				Call ALERTS("정확한 현금영수증 신고번호를 기입해주세요.","GO",GO_BACK_ADDR)
''			End If
''		End If
''
''		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
''			objEncrypter.Key = con_EncryptKey
''			objEncrypter.InitialVector = con_EncryptKeyIV
''			If C_HY_SendNum	<> "" Then C_HY_SendNum	= objEncrypter.Encrypt(C_HY_SendNum)
''		Set objEncrypter = Nothing
''	'◆현금영수증신고E

	'▣ 현금영수증 관련 필드 추가 S

		receiptInfoTF	= trim(pRequestTF("receiptInfoTF",true))	'신청 / 미신청

		receiptType		= trim(pRequestTF("receiptType",false))		'P개인 소득 / C 사업자 증빙
		receiptPType	= trim(pRequestTF("receiptPType",false))		'휴대폰 hpNum / 주민등록 ssNum / 현금영수증 CdNum

		C_HY_TF					= "0"	'CS 컬럼 현금영수증 발급 (0 미발행, 1 발행)
		C_HY_SendNum			= ""	'CS 컬럼 현금영수증 신청번호
		C_HY_Division			= ""	'CS 컬럼 신청구분 (0 : 개인소득공제용, 1 : 사업자용)
		C_HY_Number_Division	= ""	'CS 컬럼 신청번호구분 (0 : 휴대전화, 1 : 주민번호, 2 : 현금영수증카드번호, 3 : 사업자등록번호 )

		SELECT CASE receiptInfoTF
			CASE "T"
				C_HY_TF = 1
				SELECT CASE receiptType
					CASE "P"
						C_HY_Division = 0
						SELECT CASE receiptPType
							CASE "hpNum"
								recriptHp1		= trim(pRequestTF("recriptHp1",true))
								recriptHp2		= trim(pRequestTF("recriptHp2",true))
								recriptHp3		= trim(pRequestTF("recriptHp3",true))
								C_HY_SendNum = recriptHp1 & recriptHp2 & recriptHp3
								C_HY_Number_Division = 0
							CASE "ssNum"
								recriptSn1		= trim(pRequestTF("recriptSn1",true))
								recriptSn2		= trim(pRequestTF("recriptSn2",true))
								C_HY_SendNum = recriptSn1 & recriptSn2
								C_HY_Number_Division = 1
							CASE "CdNum"
								recriptCd1		= trim(pRequestTF("recriptCd1",true))
								recriptCd2		= trim(pRequestTF("recriptCd2",true))
								recriptCd3		= trim(pRequestTF("recriptCd3",true))
								recriptCd4		= trim(pRequestTF("recriptCd4",true))
								C_HY_SendNum = recriptCd1 & recriptCd2 & recriptCd3 & recriptCd4
								C_HY_Number_Division = 2
							CASE ELSE : CALL ALERTS("지정되지 않은 선택값입니다 (현금영수증 개인소득공제용)","GO",GO_BACK_ADDR)
						END SELECT
					CASE "C"
						C_HY_Division = 1
						recriptCn1		= trim(pRequestTF("recriptCn1",true))
						recriptCn2		= trim(pRequestTF("recriptCn2",true))
						recriptCn3		= trim(pRequestTF("recriptCn3",true))
						C_HY_SendNum = recriptCn1 & recriptCn2 & recriptCn3
						C_HY_Number_Division = 3
					CASE ELSE : CALL ALERTS("지정되지 않은 선택값입니다 (개인/사업자 구분)","GO",GO_BACK_ADDR)
				END SELECT
			CASE "F"
				C_HY_TF = 0
			CASE ELSE : CALL ALERTS("무통장 시 현금영수증 발행관련 값이 올바르지 않습니다.","GO",GO_BACK_ADDR)
		END SELECT
		On Error Resume Next
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If C_HY_SendNum	<> "" Then C_HY_SendNum	= objEncrypter.Encrypt(C_HY_SendNum)
		Set objEncrypter = Nothing
		On Error Goto 0

	'▣ 현금영수증 관련 필드 추가 E


'CS 관련 & 특이사항
	CSGoodCnt		= Trim(pRequestTF("CSGoodCnt",True))				'통합정보 CS상품 갯수
	isSpecialSell	= Trim(pRequestTF("isSpecialSell",False))
	If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then
		v_SellCode		= Trim(pRequestTF("v_SellCode",True))
		SalesCenter		= Trim(pRequestTF("SalesCenter",False))
		DtoD			= Trim(pRequestTF("DtoD",True))
	Else
		v_SellCode		= ""
		SalesCenter		= ""
		DtoD			= "T"
	End If

'직접수령관련 추가
	Select Case DtoD
		Case "T"
			If takeName = "" Then Call ALERTS(LNG_CS_PG_PAY_JS_REC_NAME,"GO",GO_BACK_ADDR)
			If takeMob = ""	Then Call ALERTS(LNG_CS_PG_PAY_JS12,"GO",GO_BACK_ADDR)
			If takeZip = "" Or takeADDR1 = "" Or takeADDR2 = ""	Then
				Call ALERTS(LNG_CS_PG_PAY_JS08,"GO",GO_BACK_ADDR)
			End If
		Case "F"
			ori_price = CDbl(ori_price) - CDbl(ori_delivery)
	End Select

	If CDbl(ori_price) <> (CDbl(totalPrice) + CDbl(usePoint) + CDbl(usePoint2)) Then Call ALERTS("Data Modulation(totalPrice)","GO",GO_BACK_ADDR)

	'◆ 포인트 사용 시
		'▣총출금액 확인
		If CDbl(usePoint) > CDbl(MILEAGE_TOTAL) Then
			Call ALERTS("사용가능한 포인트가 부족합니다 02","GO",GO_BACK_ADDR)
		End If
		'If CDbl(usePoint) > CDbl(MILEAGE2_TOTAL) Then
		'	Call ALERTS("사용가능한 포인트2가 부족합니다 02","GO",GO_BACK_ADDR)
		'End If

		'결제가능 포인트(배송료 제외)
		If CDbl(usePoint) + CDbl(usePoint2) > CDbl(ori_price) - CDbl(totalDelivery) Then
			Call ALERTS("결제가능한 포인트보다 많이 입력하셨습니다!\n\n(포인트는 배송료를 제외하고 사용가능합니다.","GO",GO_BACK_ADDR)
		End If
	'◆ 포인트 사용 시


	'◆ 포인트 미사용시 =================================================================================================
		If CDbl(usePoint) > 0 Then Call ALERTS(LNG_JS_POINT_UNAVAILABLE&" - (무통장결제)","GO",GO_BACK_ADDR)
		If CDbl(usePoint2) > 0 Then Call ALERTS(LNG_JS_POINT2_UNAVAILABLE&" - (무통장결제)","GO",GO_BACK_ADDR)
	'◆ 포인트 미사용시 =================================================================================================





' 정보 빈값등 확인
	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0



%>
<%

	OrderNum = ordersNumber


	'If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & "-" & strTel2 & "-" & strTel3
	'If strMob1 <> "" And strMob2 <> "" And strMob3 <> "" Then strMob = strMob1 & "-" & strMob2 & "-" & strMob3
	'If takeTel1 <> "" And takeTel2 <> "" And takeTel3 <> "" Then takeTel = takeTel1 & "-" & takeTel2 & "-" & takeTel3
	'If takeMob1 <> "" And takeMob2 <> "" And takeMob3 <> "" Then takeMob = takeMob1 & "-" & takeMob2 & "-" & takeMob3
	If takeTel = "" Then takeTel = ""
	If takeMob = "" Then takeMob = ""


	payway = "inbank"
	strDomain = strHostA
	strIDX = DK_SES_MEMBER_IDX
	strUserID = DK_MEMBER_ID
	state = "100"


'▣ 웹주문번호 중복체크 S
	ORDER_DUP_CNT = 0
	SQLNC1 = "SELECT COUNT(*) FROM [DK_ORDER_TEMP] WITH (NOLOCK) WHERE [orderNum] = ? AND [payType] = ? AND [orderType] <> '' "
	arrParamsNC1 = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,OrderNum), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,Paykind) _
	)
	ORDER_DUP_CNT = Db.execRsData(SQLNC1,DB_TEXT,arrParamsNC1,Nothing)

'	If CDbl(ORDER_DUP_CNT) > 0  Then Call ALERTS("비정상적인 주문번호입니다. (새로고침 후 다시 시도해주세요.)","GO",GO_BACK_ADDR)
'▣ 웹주문번호 중복체크 E


	'◆ #6. 구매상품 1차 확인! S
	' - [임시주문 상품테이블]에서 현 주문 상품 정보 호출(카트수량 변조 무시)
	SQLC1 = "SELECT [GoodIDX],[strOption],[orderEa],[isShopType],[strShopID],[GoodsPrice] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? And [OrderNum] = ?"
	arrParamsC1 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
	)
	arrListC1 = Db.execRsList(SQLC1,DB_TEXT,arrParamsC1,listLenC1,Nothing)
	If IsArray(arrListC1) Then
		For c = 0 To listLenC1
			DKRSC1_GoodIDX		= arrListC1(0,c)
			DKRSC1_strOption	= arrListC1(1,c)
			DKRSC1_orderEa		= arrListC1(2,c)
			DKRSC1_GoodsPrice	= arrListC1(5,c)

			If DKRSC1_GoodsPrice < 1 Then Call ALERTS(LNG_SHOP_DETAILVIEW_JS_NO_PRICE,"GO",GO_BACK_ADDR)

			'◈ 상품 정보 확인 S
				SQLC2 = "SELECT  [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept],[GoodsName] FROM [DK_GOODS] WITH (NOLOCK) WHERE [intIDX] = ? AND [GoodsStockType] <> 'S'"
				arrParamsC2 = Array(_
					Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRSC1_GoodIDX) _
				)
				Set DKRSC2 = Db.execRs(SQLC2,DB_TEXT,arrParamsC2,Nothing)
				If Not DKRSC2.BOF And Not DKRSC2.EOF Then
					DKRSC2_DelTF			= DKRSC2("DelTF")
					DKRSC2_GoodsStockType	= DKRSC2("GoodsStockType")
					DKRSC2_GoodsStockNum	= DKRSC2("GoodsStockNum")
					DKRSC2_GoodsViewTF		= DKRSC2("GoodsViewTF")
					DKRSC2_isAccept			= DKRSC2("isAccept")
				Else
					Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
				End If
				Call closeRS(DKRSC2)

				If DKRSC2_DelTF = "T" Then			Call ALERTS(LNG_SHOP_ORDER_WISHLIST_TEXT03 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
				If DKRSC2_isAccept <> "T" Then		Call ALERTS(LNG_SHOP_ORDER_DIRECT_06 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
				If DKRSC2_GoodsViewTF <> "T" Then	Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
			'◈ 상품 정보 확인 E

			'◈ 상품 재고 확인 S
				Select Case DKRSC2_GoodsStockType
					Case "I"
					Case "N"
						If Int(DKRSC2_GoodsStockNum) < Int(DKRSC1_orderEa) Then
							'Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
							Call ALERTS(LNG_SHOP_DETAILVIEW_06 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
						End If
					Case "S" : Call ALERTS(LNG_SHOP_DETAILVIEW_BTN_SOLDOUT & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
					Case Else : Call ALERTS(LNG_JS_INVALID_DATA & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
				End Select
			'◈ 상품 재고 확인 E

		Next
	Else
		Call ALERTS(LNG_JS_TEMPORARY_ORDER_DELETED,"GO",GO_BACK_ADDR)
	End If
	'◆ #6. 구매상품 1차 확인! E ◆◆◆


	'◆ #7. SHOP 주문 임시테이블 정보 UPDATE S
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
			Db.makeParam("@totalPrice",adDouble,adParamInput,16,totalPrice), _
			Db.makeParam("@deliveryFee",adDouble,adParamInput,16,totalDelivery), _
			Db.makeParam("@totalOptionPrice",adDouble,adParamInput,16,totalOptionPrice), _
				Db.makeParam("@totalPoint",adDouble,adParamInput,16,totalPoint), _
				Db.makeParam("@InputMileage",adDouble,adParamInput,16,usePoint), _
				Db.makeParam("@InputMileage2",adDouble,adParamInput,16,usePoint2), _
			Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
			Db.makeParam("@payType",adVarChar,adParamInput,20,payKind), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_ORDER_INFO_SHOP_UPDATE",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE7 = arrParams(Ubound(arrParams))(4)
		Select Case OUTPUT_VALUE7
			Case "FINISH"
			Case "ERROR" : Call ALERTS(LNG_CS_ORDERS_ALERT06,"GO",GO_BACK_ADDR)
			Case "NOTORDER" : Call ALERTS(LNG_CS_ORDERS_ALERT07,"GO",GO_BACK_ADDR)
		End Select
	'◆ #7. SHOP 주문 임시테이블 정보 UPDATE E






' 데이터 저장
'	Call Db.beginTrans(Nothing)

	'CS은행정보 or WEB은행정보 가져오기
	If DK_MEMBER_TYPE = "COMPANY" Then
		arr_CS_BANK_INFO = Split(bankidx,",")
		DKRS_BANK_BankCode		= arr_CS_BANK_INFO(0)		'입금은행코드
		DKRS_BANK_BankName		= arr_CS_BANK_INFO(1)		'은행명
		DKRS_BANK_BankOwner		= arr_CS_BANK_INFO(2)		'BankPenName (계좌가명)
		DKRS_BANK_BankNumber	= arr_CS_BANK_INFO(3)		'입금계좌번호

		SQL_BC = "SELECT [BankName] FROM [DK_BANK_CODE] WITH (NOLOCK) WHERE [BankCode] = ?"
		arrParams_BC = Array(_
			Db.makeParam("@BankCode",adVarChar,adParamInput,5,DKRS_BANK_BankCode) _
		)
		HJBK_BANKNAME = Db.execRsData(SQL_BC,DB_TEXT,arrParams_BC,Nothing)

		SQL_BI = "SELECT [intIDX] FROM [DK_BANK] WITH (NOLOCK) WHERE [BankName] = ?"
		arrParams_BI = Array(_
			Db.makeParam("@BankName",adVarWChar,adParamInput,50,HJBK_BANKNAME) _
		)
		HJBK_intIDX = Db.execRsData(SQL_BI,DB_TEXT,arrParams_BI,Nothing)

		If HJBK_intIDX = "" Or isNull(HJBK_intIDX) Then
			bankidx = 999			'선택된 CS Bank가 WEB DK_BANK에 등록되지 않은경우
		Else
			bankidx = HJBK_intIDX
		End If
	Else
		SQL = "SELECT A.[intIDX],A.[BankName],A.[BankNumber],A.[BankOwner],A.[isUse],B.[BankCode]"
		SQL = SQL & " FROM [DK_BANK] AS A WITH (NOLOCK)"
		SQL = SQL & " JOIN [DK_BANK_CODE] AS B WITH (NOLOCK) ON B.[BankName] = A.[BankName]"
		SQL = SQL & " WHERE A.[intIDX] = ?"

		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,bankidx)_
		)
		Set DKRS_BANK = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
		If Not DKRS_BANK.BOF And Not DKRS_BANK_EOF Then
			DKRS_BANK_BankName		= DKRS_BANK(1)
			DKRS_BANK_BankNumber	= DKRS_BANK(2)
			DKRS_BANK_BankOwner		= DKRS_BANK(3)
			DKRS_BANK_BankCode		= DKRS_BANK(5)			'은행코드 to CS!!
		End If
		Call closeRS(DKRS_BANK)
	End If



	'▣주문정보 암호화
	'	If DKCONF_SITE_ENC = "T" AND DK_MEMBER_TYPE <> "COMPANY" Then
		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If DKRS_BANK_BankNumber	<> "" Then DKRS_BANK_BankNumber	= objEncrypter.Encrypt(DKRS_BANK_BankNumber)	'cacu. C_Number1

				If DKCONF_ISCSNEW = "T" Then
					If strADDR1			<> "" Then strADDR1				= objEncrypter.Encrypt(strADDR1)
					If strADDR2			<> "" Then strADDR2				= objEncrypter.Encrypt(strADDR2)
					If strTel			<> "" Then strTel				= objEncrypter.Encrypt(strTel)
					If strMob			<> "" Then strMob				= objEncrypter.Encrypt(strMob)
					If takeTel			<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
					If takeMob			<> "" Then takeMob				= objEncrypter.Encrypt(takeMob)
					If takeADDR1		<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
					If takeADDR2		<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
					If strEmail			<> "" Then strEmail				= objEncrypter.Encrypt(strEmail)
				End If
			Set objEncrypter = Nothing
		End If

	'▣CS회원 국가코드 호출
	If DK_MEMBER_TYPE = "COMPANY" Then
		SQL_N = "SELECT [Na_Code] FROM [tbl_Memberinfo] WITH (NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
		arrParams_N = Array(_
			Db.makeParam("@mbid",adVarChar,adParamInput,30,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,30,DK_MEMBER_ID2) _
		)
		Set DKRS_N = Db.execRs(SQL_N,DB_TEXT,arrParams_N,DB3)
		If Not DKRS_N.BOF And Not DKRS_N.EOF Then
			RS_MEMBER_NATIONCODE = DKRS_N("Na_Code")
		Else
			RS_MEMBER_NATIONCODE = "KR"
		End If
		Call closeRS(DKRS_N)
	End If

	'주문정보 입력
		SQL = " INSERT INTO [DK_ORDER] ( "
		SQL = SQL & " [strDomain],[OrderNum],[strIDX],[strUserID],[payWay] "
		SQL = SQL & " ,[totalPrice],[totalDelivery],[totalOptionPrice],[totalPoint],[strName] "
		SQL = SQL & " ,[strTel],[strMob],[strEmail],[strZip],[strADDR1] "
		SQL = SQL & " ,[strADDR2],[takeName],[takeTel],[takeMob],[takeZip] "
		SQL = SQL & " ,[takeADDR1],[takeADDR2],[status],[orderMemo],[strSSH1] "
		SQL = SQL & " ,[strSSH2],[bankIDX],[BankingName],[usePoint],[totalVotePoint] "
		SQL = SQL & " ,[bankingCom],[bankingNum],[bankingOwn]"
		SQL = SQL & " ,[strNationCode]"													'국가코드추가
		SQL = SQL & " ,[usePoint2]"														'포인트2

		SQL = SQL & " ) VALUES ( "
		SQL = SQL & " ?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,? "
		SQL = SQL & " ,? "
		SQL = SQL & " ,? "
		SQL = SQL & " ); "
		SQL = SQL & "SELECT ? = @@IDENTITY"
		arrParams = Array( _
			Db.makeParam("@strDomain",adVarchar,adParamInput,50,strDomain), _
			Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum), _
			Db.makeParam("@strIDX",adVarchar,adParamInput,50,strIDX), _
			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
			Db.makeParam("@payWay",adVarchar,adParamInput,6,payWay), _

			Db.makeParam("@totalPrice",adDouble,adParamInput,16,totalPrice), _
			Db.makeParam("@totalDelivery",adDouble,adParamInput,16,totalDelivery), _
			Db.makeParam("@totalOptionPrice",adDouble,adParamInput,16,totalOptionPrice), _
			Db.makeParam("@totalPoint",adDouble,adParamInput,16,totalPoint), _
			Db.makeParam("@strName",adVarWChar,adParamInput,50,strName), _

			Db.makeParam("@strTel",adVarchar,adParamInput,150,strTel), _
			Db.makeParam("@strMob",adVarchar,adParamInput,150,strMob), _
			Db.makeParam("@strEmail",adVarWChar,adParamInput,512,strEmail), _
			Db.makeParam("@strZip",adVarchar,adParamInput,50,strZip), _
			Db.makeParam("@strADDR1",adVarchar,adParamInput,512,strADDR1), _
			Db.makeParam("@strADDR2",adVarchar,adParamInput,512,strADDR2), _

			Db.makeParam("@takeName",adVarWChar,adParamInput,50,takeName), _
			Db.makeParam("@takeTel",adVarchar,adParamInput,150,takeTel), _
			Db.makeParam("@takeMob",adVarchar,adParamInput,150,takeMob), _
			Db.makeParam("@takeZip",adVarchar,adParamInput,10,takeZip), _

			Db.makeParam("@takeADDR1",adVarchar,adParamInput,512,takeADDR1), _
			Db.makeParam("@takeADDR2",adVarchar,adParamInput,512,takeADDR2), _
			Db.makeParam("@state",adChar,adParamInput,3,state), _
			Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo), _
			Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _

			Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2), _
			Db.makeParam("@bankIDX",adInteger,adParamInput,4,bankidx), _
			Db.makeParam("@bankingName",adVarWChar,adParamInput,50,bankingName), _
			Db.makeParam("@usePoint",adDouble,adParamInput,16,usePoint), _
			Db.makeParam("@totalVotePoint",adDouble,adParamInput,16,totalVotePoint), _

			Db.makeParam("@bankingCom",adVarWChar,adParamInput,50,DKRS_BANK_BankName), _
			Db.makeParam("@bankingNum",adVarChar,adParamInput,100,DKRS_BANK_BankNumber), _
			Db.makeParam("@bankingOwn",adVarWChar,adParamInput,50,DKRS_BANK_BankOwner), _
			Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _

			Db.makeParam("@usePoint2",adDouble,adParamInput,16,usePoint2), _

			Db.makeParam("@identity",adInteger,adParamOutput,0,0) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		IDENTITY = arrParams(UBound(arrParams))(4)

	'#####################################
	' 적립금 차감 및 적립금 사용 필드 업데이트
	' 2014-02-27 : 회원인 경우에 CS 회원을 고려하여 FINANCIAL 에 회원이 있는 지 조회 후 없는 경우 FINANCIAL에 회원정보를 기입한다.
	' 2015-03-12 : 적립금을 사용한 경우에만 적립금 차감을 기록한다.
	'#####################################
	''	If DK_MEMBER_TYPE <> "GUEST" Then
	''		SQL = " SELECT * FROM [DK_MEMBER_FINANCIAL] WITH (NOLOCK) WHERE [strUserID] = ?"
	''		arrParams = Array(_
	''			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
	''		)
	''		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	''		If DKRS.BOF Or DKRS.EOF Then
	''			SQL2 = "INSERT INTO [DK_MEMBER_FINANCIAL] ([strUserID]) VALUES (?)"
	''			Call Db.exec(SQL2,DB_TEXT,arrParams,Nothing)
	''		End If
	''		Call closeRS(DKRS)
	''	End If
	''
	''	If usePoint > 0 Then
	''		SQL = "SELECT [intPoint] FROM [DK_MEMBER_FINANCIAL] WITH (NOLOCK) WHERE [strUserID] = ?"
	''		arrParams = Array(_
	''			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
	''		)
	''		nowMemberPoint = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
	''
	''
	''		SQL = "INSERT INTO [DK_MEMBER_POINT_LOG] ("
	''		SQL = SQL & " [strUserID],[intValue],[intRemain],[ValueComment],[dComment] "
	''		SQL = SQL & " ) VALUES ( "
	''		SQL = SQL & " ?,?,?,?,? "
	''		SQL = SQL & " )"
	''		arrParams = Array(_
	''			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
	''			Db.makeParam("@intValue",adInteger,adParamInput,0,-usePoint), _
	''			Db.makeParam("@intRemain",adInteger,adParamInput,0,nowMemberPoint-usePoint), _
	''			Db.makeParam("@ValueComment",adVarChar,adParamInput,50,"ORDER2"), _
	''			Db.makeParam("@dComment",adVarChar,adParamInput,800,OrderNum&"주문 시 사용") _
	''		)
	''		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
	''
	''		SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
	''		arrParams = Array(_
	''			Db.makeParam("@intPoint",adInteger,adParamInput,0,usePoint), _
	''			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
	''		)
	''		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
	''	End If


		'PRINT arrUidx
		CSGoodCnt = 0 ' CS상품 초기화

	'◆ #8. 임시주문 상품테이블에서 현 주문 상품 정보 호출(카트수량 변조 무시) S
		SQLC3 = "SELECT [GoodIDX],[strOption],[orderEa],[isShopType],[strShopID] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? And [OrderNum] = ?"
		arrParamsC3 = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum) _
		)
		arrListC3 = Db.execRsList(SQLC3,DB_TEXT,arrParamsC3,listLenC3,Nothing)
		If IsArray(arrListC3) Then
			For k = 0 To listLenC3
				DKRS_GoodIDX		= arrListC3(0,k)
				DKRS_strOption		= arrListC3(1,k)
				DKRS_orderEa		= arrListC3(2,k)
				DKRS_isShopType		= arrListC3(3,k)
				DKRS_strShopID		= arrListC3(4,k)

				If strOption = "" Or IsNull(strOption) Then strOption = ""


				'상품 정보(수량) 확인
					SQL = "SELECT "
					SQL = SQL & " [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept]"
					SQL = SQL & ",[GoodsName],[imgThum],[GoodsPrice],[GoodsCustomer],[GoodsCost]"
					SQL = SQL & ",[GoodsPoint],[GoodsDeliveryType],[GoodsDeliveryFee],[intPriceNot],[intPriceAuth]"
					SQL = SQL & ",[intPriceDeal],[intPriceVIP],[intMinNot],[intMinAuth],[intMinDeal]"
					SQL = SQL & ",[intMinVIP],[intPointNot],[intPointAuth],[intPointDeal],[intPointVIP]"
					SQL = SQL & ",[isCSGoods]"
					SQL = SQL & ",[isImgType]"
					SQL = SQL & ",[CSGoodsCode]"							'▣CS상품코드추가

					SQL = SQL & " FROM [DK_GOODS] WITH (NOLOCK) WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
					)
					Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
					If Not DKRS.BOF And Not DKRS.EOF Then
						DKRS_DelTF					= DKRS("DelTF")
						DKRS_GoodsStockType			= DKRS("GoodsStockType")
						DKRS_GoodsStockNum			= DKRS("GoodsStockNum")
						DKRS_GoodsViewTF			= DKRS("GoodsViewTF")
						DKRS_isAccept				= DKRS("isAccept")
						DKRS_GoodsName				= DKRS("GoodsName")
						DKRS_imgThum				= DKRS("imgThum")

						DKRS_GoodsPrice				= DKRS("GoodsPrice")
						DKRS_GoodsCustomer			= DKRS("GoodsCustomer")
						DKRS_GoodsCost				= DKRS("GoodsCost")
						DKRS_GoodsPoint				= DKRS("GoodsPoint")

						DKRS_GoodsDeliveryType		= DKRS("GoodsDeliveryType")
						DKRS_GoodsDeliveryFee		= DKRS("GoodsDeliveryFee")

						DKRS_intPriceNot			= DKRS("intPriceNot")
						DKRS_intPriceAuth			= DKRS("intPriceAuth")
						DKRS_intPriceDeal			= DKRS("intPriceDeal")
						DKRS_intPriceVIP			= DKRS("intPriceVIP")
						DKRS_intMinNot				= DKRS("intMinNot")
						DKRS_intMinAuth				= DKRS("intMinAuth")
						DKRS_intMinDeal				= DKRS("intMinDeal")
						DKRS_intMinVIP				= DKRS("intMinVIP")
						DKRS_intPointNot			= DKRS("intPointNot")
						DKRS_intPointAuth			= DKRS("intPointAuth")
						DKRS_intPointDeal			= DKRS("intPointDeal")
						DKRS_intPointVIP			= DKRS("intPointVIP")
						DKRS_isCSGoods				= DKRS("isCSGoods")

						DKRS_isCSGoods				= DKRS("isCSGoods")
						DKRS_isImgType				= DKRS("isImgType")

						DKRS_CSGoodsCode			= DKRS("CSGoodsCode")			'▣CS상품코드추가

						If DKRS_isCSGoods = "T" Then CSGoodCnt = CSGoodCnt + 1


						Select Case DK_MEMBER_LEVEL
							Case 0,1 '비회원, 일반회원
								DKRS_GoodsPrice = DKRS_intPriceNot
								DKRS_GoodsPoint = DKRS_intPointNot
								DKRS_intMinimum = DKRS_intMinNot
							Case 2 '인증회원
								DKRS_GoodsPrice = DKRS_intPriceAuth
								DKRS_GoodsPoint = DKRS_intPointAuth
								DKRS_intMinimum = DKRS_intMinAuth
							Case 3 '딜러회원
								DKRS_GoodsPrice = DKRS_intPriceDeal
								DKRS_GoodsPoint = DKRS_intPointDeal
								DKRS_intMinimum = DKRS_intMinDeal
							Case 4,5 'VIP 회원
								DKRS_GoodsPrice = DKRS_intPriceVIP
								DKRS_GoodsPoint = DKRS_intPointVIP
								DKRS_intMinimum = DKRS_intMinVIP
							Case 9,10,11
								DKRS_GoodsPrice = DKRS_intPriceVIP
								DKRS_GoodsPoint = DKRS_intPointVIP
								DKRS_intMinimum = DKRS_intMinVIP
						End Select

						'▣소비자 가격, 쇼핑몰가/CS가 비교
						If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
							If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
								DKRS_GoodsPrice	 = DKRS_GoodsCustomer
							End If
						End If

					Else
						'Call ALERTS("존재하지 않는 상품구입을 시도했습니다.","GO",GO_BACK_ADDR)
						Call ALERTS(LNG_SHOP_ORDER_DIRECT_05,"GO",GO_BACK_ADDR)
					End If
					Call closeRS(DKRS)

					'If DKRS_DelTF = "T" Then Call ALERTS("삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
					'If DKRS_isAccept <> "T" Then Call ALERTS("승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
					'If DKRS_GoodsViewTF <> "T" Then Call ALERTS("더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
					If DKRS_DelTF = "T" Then Call ALERTS(LNG_SHOP_ORDER_WISHLIST_TEXT03 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
					If DKRS_isAccept <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_06 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
					If DKRS_GoodsViewTF <> "T" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)

					Select Case DKRS_GoodsStockType
						Case "I"
						Case "N"
							If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
								'Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
								Call ALERTS(LNG_SHOP_DETAILVIEW_06 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
							Else
								SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
									Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
								)
								Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
							End If
						Case "S" : Call ALERTS(LNG_SHOP_DETAILVIEW_BTN_SOLDOUT & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
						Case Else : Call ALERTS(LNG_JS_INVALID_DATA & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
					End Select

				' 배송비 타입 확인
					If DKRS_GoodsDeliveryType = "SINGLE" Then
						GoodsDeliveryFeeType	= "선결제"
						GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS_GoodsDeliveryFee)
						GoodsDeliveryLimit		= 0
					ElseIf DKRS_GoodsDeliveryType = "BASIC" Then


						'▣ 국가별 배송비 설정
						arrParams2 = Array(_
							Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
						)
						Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
						If Not DKRS2.BOF And Not DKRS2.EOF Then
							DKRS2_intDeliveryFee		= DKRS2("intDeliveryFee")
							DKRS2_intDeliveryFeeLimit	= DKRS2("intDeliveryFeeLimit")
							GoodsDeliveryFee			= DKRS2_intDeliveryFee
							GoodsDeliveryLimit			= DKRS2_intDeliveryFeeLimit
						Else
							GoodsDeliveryFee	= ""
							GoodsDeliveryLimit	= ""
						End If
						Call closeRS(DKRS2)

						If GoodsDeliveryFee = "0" And GoodsDeliveryLimit = "0" Then
							GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_10	'"무료배송"
						ElseIf GoodsDeliveryFee <> "0" And GoodsDeliveryLimit <> "0" Then
							GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_07	'"선결제"
						Else
							GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_07	'"선결제"
						End If

					''	arrParams2 = Array(_
					''		Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
					''	)
					''	'Set DKRS2 = DB.execRs("DKPA_DELIVEY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
					''	Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
					''	If Not DKRS2.BOF And Not DKRS2.EOF Then
					''		DKRS2_FeeType			= DKRS2("FeeType")
					''		DKRS2_intFee			= Int(DKRS2("intFee"))
					''		DKRS2_intLimit			= Int(DKRS2("intLimit"))
					''	Else
					''		DKRS2_FeeType			= ""
					''		DKRS2_intFee			= ""
					''		DKRS2_intLimit			= ""
					''	End If
					''	Select Case LCase(DKRS2_FeeType)
					''		Case "free"
					''			GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_10	'"무료배송"
					''			GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS2_intFee)
					''			GoodsDeliveryLimit		= DKRS2_intLimit
					''		Case "prev"
					''			GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_07	'"선결제"
					''			GoodsDeliveryFee		= Int(DKRS2_intFee)
					''			GoodsDeliveryLimit		= DKRS2_intLimit
					''		Case "next"
					''			GoodsDeliveryFeeType	= LNG_SHOP_ORDER_DIRECT_TABLE_13	'"착불"
					''			GoodsDeliveryFee		= Int(DKRS2_intFee)
					''			GoodsDeliveryLimit		= DKRS2_intLimit
					''	End Select

					End If
				'옵션가격 확인
					GoodsOptionPrice = 0
					arrResult = Split(CheckSpace(DKRS_strOption),",")
					For j = 0 To UBound(arrResult)
						arrOption = Split(Trim(arrResult(j)),"\")
						arrOptionTitle = Split(arrOption(0),":")
						If arrOption(1) > 0 Then
							OptionPrice = " / + " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
						ElseIf arrOption(1) < 0 Then
							OptionPrice = "/ - " & num2cur(arrOption(1)) &" "&Chg_CurrencyISO&""
						ElseIf arrOption(1) = 0 Then
							OptionPrice = ""
						End If
						GoodsOptionPrice = Int(GoodsOptionPrice) + Int(arrOption(1))
					Next


				'구매정보(상품) 입력
					SQL = " INSERT INTO [DK_ORDER_GOODS] ( "
					SQL = SQL & " [orderIDX],[GoodIDX],[strOption],[orderEa],[goodsPrice]"
					SQL = SQL & ",[goodsOptionPrice],[goodsPoint],[GoodsCost],[isShopType],[strShopID]"
					SQL = SQL & ",[GoodsName],[ImgThum],[GoodsDeliveryType],[GoodsDeliveryFeeType],[GoodsDeliveryFee]"
					SQL = SQL & ",[GoodsDeliveryLimit],[status],[isImgType],[OrderNum]"
					SQL = SQL & ",[isCSGoods],[CSGoodsCode]"									'▣CS상품코드추가
					SQL = SQL & " ) VALUES ( "
					SQL = SQL & " ?, ?, ?, ?, ?"
					SQL = SQL & ",?, ?, ?, ?, ?"
					SQL = SQL & ",?, ?, ?, ?, ?"
					SQL = SQL & ",?, ?, ?, ?"
					SQL = SQL & ",?, ?"															'▣CS상품코드추가
					SQL = SQL & " ) "
					arrParams = Array(_
						Db.makeParam("@orderIDX",adInteger,adParamInput,4,identity), _
						Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRS_GoodIDX), _
						Db.makeParam("@strOption",adVarWChar,adParamInput,512,DKRS_strOption), _
						Db.makeParam("@OrderEa",adInteger,adParamInput,4,DKRS_orderEa),_
						Db.makeParam("@GoodsPrice",adDouble,adParamInput,16,DKRS_GoodsPrice),_

						Db.makeParam("@GoodsOptionPrice",adDouble,adParamInput,16,GoodsOptionPrice),_
						Db.makeParam("@GoodsPoint",adDouble,adParamInput,16,DKRS_GoodsPoint),_
						Db.makeParam("@GoodsCost",adDouble,adParamInput,16,DKRS_GoodsCost),_

						Db.makeParam("@isShopType",adChar,adParamInput,1,DKRS_isShopType),_
						Db.makeParam("@strShopID",adVarChar,adParamInput,50,DKRS_strShopID),_
						Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,DKRS_GoodsName),_
						Db.makeParam("@imgThum",adVarWChar,adParamInput,512,DKRS_imgThum),_

						Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,DKRS_GoodsDeliveryType),_
						Db.makeParam("@GoodsDeliveryFeeType",adVarWChar,adParamInput,20,GoodsDeliveryFeeType),_
						Db.makeParam("@GoodsDeliveryFee",adDouble,adParamInput,16,GoodsDeliveryFee),_
						Db.makeParam("@GoodsDeliveryLimit",adDouble,adParamInput,16,GoodsDeliveryLimit),_
						Db.makeParam("@status",adChar,adParamInput,3,state),_

						Db.makeParam("@isImgType",adChar,adParamInput,1,DKRS_isImgType),_

						Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum), _

						Db.makeParam("@isCSGoods",adChar,adParamInput,1,DKRS_isCSGoods), _
						Db.makeParam("@CSGoodsCode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			Next

		Else
			'Call ALERTS("임시주문정보에서 삭제된 상품입니다. 새로고침 후 다시 시도해주세요2.","GO",GO_BACK_ADDR)
			Call ALERTS(LNG_JS_TEMPORARY_ORDER_DELETED,"GO",GO_BACK_ADDR)
		End If
	'◆ #8. 임시주문 상품테이블에서 현 주문 상품 정보 호출(카트수량 변조 무시) E

	'If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0  Then 'CS회원이고 cs연동상품이 1개 이상 있는 경우
	If DK_MEMBER_TYPE = "COMPANY" Then

			SQL = "SELECT [mbid],[mbid2],[Sell_Mem_TF] FROM [tbl_Memberinfo] WITH (NOLOCK) WHERE [mbid] = ? and [mbid2] = ?"		'DK_MEMBER_WEBID!!!
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,30,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,30,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				MBID1		= DKRS("mbid")
				MBID2		= DKRS("mbid2")
				Sell_Mem_TF = DKRS("Sell_Mem_TF")		'1:소비자, 0:판매원
			Else
				Call ALERTS("회원번호정보 없음","GO",GO_BACK_ADDR)
			End If
			Call closeRS(DKRS)


			If DtoD = "T" Then		'택배수령
				v_Rece_Type = "F"
				GoodsDeliveryFee = totalDelivery
			Else					'현장수령
				v_Rece_Type = "T"
				GoodsDeliveryFee = 0
			End If

			If CSGoodCnt > 0 Then

				' 주문내용을 CS TEMP에 입력
				SQL2 = "INSERT INTO [DK_ORDER_TEMP] ("
				SQL2 = SQL2 & "  [OrderNum],[sessionIDX],[MBID],[MBID2],[totalPrice]"
				SQL2 = SQL2 & " ,[takeName],[takeZip],[takeADDR1],[takeADDR2],[takeMob]"
				SQL2 = SQL2 & " ,[takeTel],[orderType],[payType],[payBankCode],[payBankAccNum]"
				SQL2 = SQL2 & " ,[payBankDate],[payBankSendName],[payBankAcceptName],[PayState]" '4개
				SQL2 = SQL2 & " ,[orderMemo],[M_NAME],[deliveryFee],[takeEmail],[PGorderNum]"
				SQL2 = SQL2 & " ,[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode],[PGCardCom]"
				SQL2 = SQL2 & " ,[PGACP_TIME],[DIR_CSHR_Type],[DIR_CSHR_ResultCode],[DIR_ACCT_BankCode],[InputMileage]"
				SQL2 = SQL2 & " ,[SalesCenter],[DtoD]"
				SQL2 = SQL2 & " ,[InputMileage2]"																		'▶[InputMileage2] 추가
				SQL2 = SQL2 & " ,[C_HY_TF],[C_HY_SendNum],[C_HY_Division],[C_HY_Number_Division]"

				SQL2 = SQL2 & " ) VALUES ("
				SQL2 = SQL2 & "  ?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?,?,?"	'4개
				SQL2 = SQL2 & " ,?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?,?,?,?"
				SQL2 = SQL2 & " ,?,?"
				SQL2 = SQL2 & " ,?"
				SQL2 = SQL2 & " ,?,?,?,?"
				SQL2 = SQL2 & " )"
				SQL2 = SQL2 & " SELECT ? = @@IDENTITY"

				arrParams2 = Array(_
					Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum),_
					Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,strIDX),_
					Db.makeParam("@MBID",adVarChar,adParamInput,20,MBID1),_
					Db.makeParam("@MBID2",adInteger,adParamInput,4,MBID2),_
					Db.makeParam("@totalPrice",adInteger,adParamInput,4,totalPrice),_

					Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName),_
					Db.makeParam("@takeZip",adVarChar,adParamInput,10,Replace(takeZip,"-","")),_
					Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,takeADDR1),_
					Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,takeADDR2),_
					Db.makeParam("@takeMob",adVarChar,adParamInput,150,takeMob),_

					Db.makeParam("@takeTel",adVarChar,adParamInput,150,takeTel),_
					Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode),_
					Db.makeParam("@payType",adVarChar,adParamInput,20,"inbank"),_
					Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,DKRS_BANK_BankCode),_
					Db.makeParam("@payBankAccNum",adVarChar,adParamInput,100,DKRS_BANK_BankNumber),_

					Db.makeParam("@payBankDate",adVarChar,adParamInput,50,""),_
					Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,bankingName),_
					Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,DKRS_BANK_BankOwner),_
					Db.makeParam("@PayState",adChar,adParamInput,3,"102"),_

					Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo),_
					Db.makeParam("@M_NAME",adVarWChar,adParamInput,50,DK_MEMBER_NAME),_
					Db.makeParam("@deliveryFee",adDouble,adParamInput,16,GoodsDeliveryFee),_
					Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
					Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,""),_

					Db.makeParam("@PGCardNum",adVarChar,adParamInput,50,""),_
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,50,""),_
					Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,""),_
					Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,""),_
					Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,""),_

					Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,""),_
					Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
					Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
					Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
					Db.makeParam("@InputMileage",adDouble,adParamInput,16,usePoint), _

					Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _
					Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _
					Db.makeParam("@InputMileage2",adDouble,adParamInput,16,usePoint2), _

						Db.makeParam("@v_C_HY_TF",adSmallInt,adParamInput,4,C_HY_TF),_
						Db.makeParam("@v_C_HY_SendNum",adVarChar,adParamInput,50,C_HY_SendNum),_
						Db.makeParam("@v_C_HY_Division",adVarChar,adParamInput,20,C_HY_Division),_
						Db.makeParam("@v_C_HY_Number_Division",adVarChar,adParamInput,20,C_HY_Number_Division),_

					Db.makeParam("@CS_IDENTITY",adInteger,adParamOutPut,4,0) _
				)
				Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
				CS_IDENTITY = arrParams2(Ubound(arrParams2))(4)
				'print CS_IDENTITY

				'주문정보에서 CS상품을 검색한다
				SQL3 = "SELECT [GoodIDX],[OrderEa] FROM [DK_ORDER_GOODS] WITH (NOLOCK) WHERE [orderIDX] = ?"
				arrParams3 = Array(_
					Db.makeParam("@identity",adInteger,adParamInput,4,identity) _
				)
				arrList3 = Db.execRsList(SQL3,DB_TEXT,arrParams3,listLen3,Nothing)
				If IsArray(arrList3) Then
					For i = 0 To listLen3
						arrList3_GoodIDX		= arrList3(0,i)
						arrList3_OrderEa		= arrList3(1,i)

						'상품 정보(수량) 확인
						SQL4 = "SELECT "
						SQL4 = SQL4 & " [isCSGoods],[CSGoodsCode] "
						SQL4 = SQL4 & " FROM [DK_GOODS] WITH (NOLOCK) WHERE [intIDX] = ?"
						arrParams4 = Array(_
							Db.makeParam("@GoodIDX",adInteger,adParamInput,4,arrList3_GoodIDX) _
						)
						Set DKRS4 = Db.execRs(SQL4,DB_TEXT,arrParams4,Nothing)
						If Not DKRS4.BOF And Not DKRS4.EOF Then
							DKRS4_isCSGoods		= DKRS4("isCSGoods")
							DKRS4_CSGoodsCode	= DKRS4("CSGoodsCode")
						End If
						Call closeRs(DKRS4)

						If DKRS4_isCSGoods = "T" Then

							'▣CS상품정보 변동정보 통합
							'	Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
							arrParams = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode) _
							)
							Set DKRS6 = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
							''Set DKRS6 = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
							If Not DKRS6.BOF And Not DKRS6.EOF Then
								DKRS6_ncode		= DKRS6("ncode")
								DKRS6_price		= DKRS6("price")		'소비자가
								DKRS6_price2	= DKRS6("price2")
								DKRS6_price4	= DKRS6("price4")
								DKRS6_price6	= DKRS6("price6")
							End If
							Call closeRs(DKRS6)

							'▣소비자 가격
							If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
								If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
									DKRS6_price2	= DKRS6_price
								End If
							End If

							SQL7 = "INSERT INTO [DK_ORDER_TEMP_GOODS] ( "
							SQL7 = SQL7 & " [OrderIDX],[GoodsCode],[GoodsPrice],[GoodsPV],[ea] "
							SQL7 = SQL7 & " ) VALUES ("
							SQL7 = SQL7 & " ?,?,?,?,?"
							SQL7 = SQL7 & " )"
							arrParams7 = Array(_
								Db.makeParam("@orderIDX",adInteger,adParamInput,4,CS_IDENTITY), _
								Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode), _
								Db.makeParam("@GoodsPrice",adDouble,adParamInput,16,DKRS6_price2), _
								Db.makeParam("@GoodsPV",adInteger,adParamInput,4,DKRS6_price4), _
								Db.makeParam("@ea",adInteger,adParamInput,4,arrList3_OrderEa) _
							)
							Call Db.exec(SQL7,DB_TEXT,arrParams7,DB3)
						End If
					Next

						'전체상품 가격 체크 WEB (orderIDX + OrderNum)
							SQL80 = "SELECT SUM([GoodsPrice]*[OrderEa]) FROM [DK_ORDER_GOODS] WITH(NOLOCK) WHERE [orderIDX] = ? And [OrderNum] = ?"
							arrParams80 = Array(_
								Db.makeParam("@identity",adInteger,adParamInput,4,identity), _
								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
							)
							WEBDB_TOTAL_PRICE = Db.execRsData(SQL80,DB_TEXT,arrParams80,Nothing)
							WEBDB_TOTAL_PRICE = WEBDB_TOTAL_PRICE + GoodsDeliveryFee

						'전체상품 가격 체크
							SQL8 = "SELECT SUM([GoodsPrice]*[ea]) FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [orderIDX] = ?"
							arrParams8 = Array(_
								Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY) _
							)
							DKCS_TOTAL_PRICE = Db.execRsData(SQL8,DB_TEXT,arrParams8,DB3)

							'■■ CS상품 옵션X, 총결제금액(배송비포함)
							DKCS_TOTAL_PRICE = DKCS_TOTAL_PRICE + GoodsDeliveryFee

						'결제금액의 변조확인
							If CDbl(CStr(WEBDB_TOTAL_PRICE)) <> CDbl(CStr(DKCS_TOTAL_PRICE)) Then Call alerts("결제금액이 변조되었습니다.01","GO",GO_BACK_ADDR)

							CHK_totalPrice = CDbl(totalPrice) + CDbl(usePoint) + CDbl(usePoint2)
							If CDbl(CStr(CHK_totalPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE)) Then Call alerts("결제금액이 변조되었습니다.02","GO",GO_BACK_ADDR)


						'■전체상품 가격 변경■
							SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
							arrParams9 = Array(_
								Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
								Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
							)
							Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

							'v_Etc1 = "입금예정자:"&bankingName&"_"&num2cur(DKCS_TOTAL_PRICE)&"원#웹무통장,"&orderNum
							v_Etc1 = memo1&"#입금예정자:"&bankingName&"_"&num2cur(DKCS_TOTAL_PRICE)&""&Chg_CurrencyISO&"#웹무통장,"&orderNum

							arrParams = Array(_
								Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
								Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

								Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_Etc1),_
								Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

								Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,DKRS_BANK_BankCode),_
								Db.makeParam("@v_C_Number1",adVarWChar,adParamInput,100,DKRS_BANK_BankNumber),_
								Db.makeParam("@v_C_Number2",adVarWChar,adParamInput,100,""),_
								Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,bankingName),_
								Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

								Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
								Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
								Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,""),_

								Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
								Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
							)
							'Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
							Call Db.exec("DKP_ORDER_TOTAL_NEW2",DB_PROC,arrParams,DB3)				'현금영수증 추가
							OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
							OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

							'■CS배송테이블 배송요청사항 입력■
							If orderMemo <> "" Then
								SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "
								arrParams_RECE = Array(_
									Db.makeParam("@Get_Etc1",adVarWChar,adParamInput,100,orderMemo) ,_
									Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
								)
								Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
							End If

							'■주문정보에서 CS주문번호를 삽입한다.
							SQL10 = "UPDATE [DK_ORDER] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
							arrParams10 = Array(_
								Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
								Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
							)
							Call Db.exec(SQL10,DB_TEXT,arrParams10,Nothing)

							'◆ #9. 임시주문정보에서 CS주문번호를 삽입한다. S
							SQL11 = "UPDATE [DK_ORDER_TEMP] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
							arrParams11 = Array(_
								Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
								Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
							)
							Call Db.exec(SQL11,DB_TEXT,arrParams11,Nothing)
							'◆ #9. 임시주문정보에서 CS주문번호를 삽입한다. E

							'◆ #9-1. 임시주문정보에서 CS주문번호를 삽입한다. S
							SQL12 = "UPDATE [DK_ORDER_TEMP] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
							arrParams12 = Array(_
								Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
								Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
							)
							Call Db.exec(SQL12,DB_TEXT,arrParams12,DB3)
							'◆ #9-1. 임시주문정보에서 CS주문번호를 삽입한다. E

							'◆CS CaCu 현금영수증신고 2021-01-20~
							'If C_HY_SendNum <> "" Then
							'	SQL_RECE = "UPDATE [tbl_Sales_Cacu] SET [C_HY_TF] = 1, [C_HY_Date] = ?, [C_HY_SendNum] = ? WHERE [OrderNumber] = ? "
							'	arrParams_RECE = Array(_
							'		Db.makeParam("@C_HY_Date",adVarChar,adParamInput,10,RegTime) ,_
							'		Db.makeParam("@C_HY_SendNum",adVarChar,adParamInput,50,C_HY_SendNum) ,_
							'		Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
							'	)
							'	Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
							'End If

				End If

			End If

	End If
	'=== CS 전산입력 종료 =========================================================================================================
	'==============================================================================================================================
	ALERTS_MESSAGE = ""

	'=== 직판공제번호발급 ====
	If Err.Number = 0 Then
		If isMACCO = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
		%>
		<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
		<%
		End if

		'알림톡 전송
		requestInfos = ""
		'Call FN_PPURIO_MESSAGE(DK_MEMBER_ID1, DK_MEMBER_ID2, "order", "at", OUT_ORDERNUMBER, requestInfos)

	End if


	'Call Db.finishTrans(Nothing)

	If LCase(orderMode) = "mobile" Then
		chgPage = "/m"
	Else
		chgPage = ""
	End If

	If Err.Number <> 0 Then
		'Call alerts("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","GO",GO_BACK_ADDR)
		Call alerts(LNG_ALERT_UPDATE_ERROR,"GO",GO_BACK_ADDR)
	Else

		'▣쇼핑몰 카트삭제(DelTF)
		If CART_DELETE_TF = "T" Then
			If inUidx <> "" Then
				arrUidx = Split(inUidx,",")
				For c = 0 To UBound(arrUidx)
					SQL_C = "UPDATE [DK_CART] SET [DelTF] = 'T', [DeleteDate] = GETDATE() WHERE [intIDX] = ? AND [strMemID] = ? AND [DelTF] = 'F' "
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(c)), _
						Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
					)
					Call Db.exec(SQL_C,DB_TEXT,arrParams,Nothing)
				Next
			End If
		End If

		Call ALERTS(LNG_ALERT_ORDER_OK&"\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
	End If
%>


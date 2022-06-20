<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "NICEPAY_FUNCTION.ASP"-->
<%
	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)


'▣NICEPAY 결제처리(모바일, PC와 99% 동일  'AuthResultCode(AuthResultMsg)는 request에서 인증이 성공했을 시 받는 코드값으로 필수 파라미터X)

'PG 설정


	Dim PGID				: PGID				= NICE_merchantID				'실결제시 merchantKey , CancelPwd 확인!!!!


'공통 필드
	Dim paykind				: paykind			= pRequestTF("paykind",True)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",True)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",True)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",True)

	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

' 주문정보 필드 받아오기

	Dim strName				: strName			= pRequestTF("strName",True)
	Dim strTel				: strTel			= pRequestTF("strTel",False)
	'Dim strMob				: strMob			= pRequestTF("strMobile",True)
	Dim strMobile				: strMobile			= pRequestTF("strMobile",True)

	Dim strEmail			: strEmail			= pRequestTF("strEmail",False)
	Dim strZip				: strZip			= pRequestTF("strZip",True)
	Dim strADDR1			: strADDR1			= pRequestTF("strADDR1",True)
	Dim strADDR2			: strADDR2			= pRequestTF("strADDR2",True)

	Dim takeName			: takeName			= pRequestTF("takeName",True)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMobile			: takeMobile		= pRequestTF("takeMobile",True)
	Dim takeZip				: takeZip			= pRequestTF("takeZip",True)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",True)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",True)



' 금액 관련
	Dim ori_price			: ori_price			= pRequestTF("ori_price",True)
	Dim ori_delivery		: ori_delivery		= pRequestTF("ori_delivery",True)		'추가
	Dim totalPrice			: totalPrice		= pRequestTF("totalPrice",True)
	Dim totalDelivery		: totalDelivery		= pRequestTF("totalDelivery",False)
	Dim DeliveryFeeType		: DeliveryFeeType	= pRequestTF("DeliveryFeeType",False)
	Dim GoodsPrice			: GoodsPrice		= pRequestTF("GoodsPrice",False)

	Dim totalOptionPrice	: totalOptionPrice  = pRequestTF("totalOptionPrice",False)
	Dim totalOptionPrice2	: totalOptionPrice2 = pRequestTF("totalOptionPrice2",False)		'goodsOPTcost
	Dim totalPoint			: totalPoint		= pRequestTF("totalPoint",False)

	Dim usePoint			: usePoint			= pRequestTF("useCmoney",False)
	Dim usePoint2			: usePoint2			= pRequestTF("useCmoney2",False)				'▶SP포인트		InputMileage2		InputMile_S
	Dim totalVotePoint		: totalVotePoint	= pRequestTF("totalVotePoint",False)

	Dim GoodsName			: GoodsName			= pRequestTF("GoodsName",True)

'기타 필드
	Dim orderMemo			: orderMemo			= pRequestTF("orderMemo",False)


	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)


	orderEaD				= Trim(pRequestTF("ea",False))						'◆ #5. EA
	GoodIDXs				= Trim(pRequestTF("GoodIDXs",False))				'◆ #5. GoodIDXs
	strOptions				= Trim(pRequestTF("strOptions",False))				'◆ #5. strOptions
	OIDX					= Trim(pRequestTF("OIDX",True))						'◆ #5. 임시주문테이블 idx


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



'치환
	bankidx		= ""
	bankingName = ""
	strSSH1		= ""
	strSSH2		= ""

	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0


'직접수령관련 추가
	Select Case DtoD
		Case "T"
			If takeName = "" Then Call ALERTS(LNG_CS_PG_PAY_JS_REC_NAME,"GO",GO_BACK_ADDR)
			If takeMobile = ""	Then Call ALERTS(LNG_CS_PG_PAY_JS12,"GO",GO_BACK_ADDR)
			If takeZip = "" Or takeADDR1 = "" Or takeADDR2 = ""	Then
				Call ALERTS(LNG_CS_PG_PAY_JS08,"GO",GO_BACK_ADDR)
			End If
		Case "F"
			ori_price = CDbl(ori_price) - CDbl(ori_delivery)
	End Select

	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)

	'결제금액 확인
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

	If CDbl(totalPrice) < 1000 And (CDbl(usePoint) + CDbl(usePoint2)) > 0 Then Call ALERTS("카드결제시 결제금액이 최소 1000원 이상이어야 합니다","GO",GO_BACK_ADDR)


	If UCase(DK_MEMBER_NATIONCODE) = "KR" Then
		If CDbl(usePoint) > 0 Then Call ALERTS("한국회원은 C포인트를 사용할 수 없습니다.","GO",GO_BACK_ADDR)
	End If









	If takeTel = "" Then takeTel = ""
	If takeMob = "" Then takeMob = ""


	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID

		CardLogss = "log_Card"
		Dim Fso222 : Set  Fso222=CreateObject("Scripting.FileSystemObject")
		Dim LogPath222 : LogPath222 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
		Dim Sfile222 : Set  Sfile222 = Fso222.OpenTextFile(LogPath222,8,true)

		Sfile222.WriteLine chr(13)
		Sfile222.WriteLine "Date : " & now()
		Sfile222.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile222.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
		Sfile222.WriteLine "THIS_PAGE_URL  : " & Request.ServerVariables("URL")
		Sfile222.WriteLine "paykind		 : " & paykind
		Sfile222.WriteLine "orderNum	 : " & orderNum
		Sfile222.WriteLine "OIDX		 : " & OIDX
		Sfile222.WriteLine "usePoint		 : " & usePoint
		Sfile222.WriteLine "usePoint2		 : " & usePoint2

		Sfile222.Close
		Set Fso222= Nothing
		Set objError= Nothing
		On Error GoTo 0


	'◆ #6. 구매상품 1차 확인! S
	' - [임시주문 상품테이블]에서 현 주문 상품 정보 호출(카트수량 변조 무시)
	SQLC1 = "SELECT [GoodIDX],[strOption],[orderEa],[isShopType],[strShopID],[GoodsPrice] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? And [OrderNum] = ?"
	arrParamsC1 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,OIDX), _
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
					Call ALERTS("존재하지 않는 상품구입을 시도했습니다. (새로고침 후 다시 시도해주세요!)"&DKRSC1_GoodIDX,"GO",GO_BACK_ADDR)
				End If
				Call closeRS(DKRSC2)

				If DKRSC2_DelTF = "T" Then			Call ALERTS("삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
				If DKRSC2_isAccept <> "T" Then		Call ALERTS("승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
				If DKRSC2_GoodsViewTF <> "T" Then	Call ALERTS("더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요","GO",GO_BACK_ADDR)
			'◈ 상품 정보 확인 E

			'◈ 상품 재고 확인 S
				Select Case DKRSC2_GoodsStockType
					Case "I"
					Case "N"
						If Int(DKRSC2_GoodsStockNum) < Int(DKRSC1_orderEa) Then
							Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
						End If
					Case "S" : Call ALERTS("품절상품. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
					Case Else : Call ALERTS("수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
				End Select
			'◈ 상품 재고 확인 E

		Next
	Else
		Call ALERTS("임시주문정보에서 삭제된 상품입니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
	End If
	'◆ #6. 구매상품 1차 확인! E ◆◆◆


	'◆ #7. SHOP 주문 임시테이블 정보 UPDATE S
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,OIDX), _
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
			Case "ERROR" : Call ALERTS("상품 가격 업데이트 중 에러가 발생하였습니다.","GO",GO_BACK_ADDR)
			Case "NOTORDER" : Call ALERTS("주문번호가 없습니다","GO",GO_BACK_ADDR)
		End Select
	'◆ #7. SHOP 주문 임시테이블 정보 UPDATE E



%>









<%
	GoodsName = Left(GoodsName,20)	'40byte

	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <결제 결과 설정>
	' 로그 디렉토리는 NICE.dll 설치위치 /log 폴더 입니다.
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Set NICEpay		= Server.CreateObject("NICE.NICETX2.1")
	PInst			= NICEpay.Initialize("")

	merchantKey		= NICE_merchantKey	'상점키
	CancelPwd		= NICE_CancelPwd	'거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!

	NICEpay.SetActionType CLng(PInst),"SECUREPAY"						'거래 설정
	'NICEpay.SetField CLng(PInst),"logpath","C:\log"					'Log Path 설정
	NICEpay.SetField CLng(PInst),"logpath","E:\PG\NICEPAY\log"			'Log Path 설정						'Webpro Log Path 변경!!!!!!!!!!!!!!!!!!!!!!!!!!!
	NICEpay.SetField CLng(PInst),"tid",Request("TID")                   '거래 아이디
	'NICEpay.SetField CLng(PInst),"paymethod",Request("paymethod")      '지불수단
	NICEpay.SetField CLng(PInst),"paymethod",paykind					'지불수단
	NICEpay.SetField CLng(PInst),"mid",Request("mid")                   '상점 ID
	NICEpay.SetField CLng(PInst),"amt",Request("amt")                   '결제금액
	NICEpay.SetField CLng(PInst),"moid",Request("moid")                 '상점 주문번호
	'NICEpay.SetField CLng(PInst),"GoodsName",Request("goodsname")      '상품명
	NICEpay.SetField CLng(PInst),"GoodsName",GoodsName					'상품명								'GoodsName
	NICEpay.SetField CLng(PInst),"currency","KRW"                       '통화구분
	'NICEpay.SetField CLng(PInst),"buyername",Request("buyername")		'성명
	NICEpay.SetField CLng(PInst),"buyername",strName					'성명								'strName
	'NICEpay.SetField CLng(PInst),"malluserid",Request("malluserid")	'회원사고객ID
	NICEpay.SetField CLng(PInst),"malluserid",DK_MEMBER_ID				'회원사고객ID
	'NICEpay.SetField CLng(PInst),"buyertel",Request("buyertel")		'이동전화
	NICEpay.SetField CLng(PInst),"buyertel",strMobile					'이동전화
	'NICEpay.SetField CLng(PInst),"buyeremail",Request("buyeremail")     '이메일
	NICEpay.SetField CLng(PInst),"buyeremail",strEmail				    '이메일
	NICEpay.SetField CLng(PInst),"parentemail",Request("parentemail")   '보호자 이메일 주소
	NICEpay.SetField CLng(PInst),"LicenseKey",merchantKey               '가맹점라이센스 키
	NICEpay.SetField CLng(PInst),"debug","true"                         '로그모드("true" 상세 로그)
	'NICEpay.SetField CLng(PInst),"CancelPwd","123456"                   '취소 패스워드
	NICEpay.SetField CLng(PInst),"CancelPwd",CancelPwd					'거래취소 패스워드
	NICEpay.SetField CLng(PInst),"goodscl",Request("GoodsCl")           '휴대폰/컨텐츠						'휴대폰 결제인 경우 필수
	NICEpay.SetField CLng(PInst),"TransType",Request("TransType")       '거래형태
	NICEpay.SetField CLng(PInst),"trkey",Request("TrKey")
	NICEpay.StartAction(CLng(PInst))

	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <결제 결과 필드>
	' 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	tid             = NICEpay.GetResult(CLng(PInst),"tid")            '거래번호
	moid            = NICEpay.GetResult(CLng(PInst),"moid")           '상점거래번호
	resultCode      = NICEpay.GetResult(CLng(PInst),"resultcode")     '결과코드
	resultMsg       = NICEpay.GetResult(CLng(PInst),"resultmsg")      '결과메시지
	goodsName       = NICEpay.GetResult(CLng(PInst),"GoodsName")      '상품명
	authDate        = NICEpay.GetResult((PInst),"AuthDate")           '승인일시
	authCode        = NICEpay.GetResult((PInst),"authcode")           '승인번호(공통) (신용카드, 계좌이체, 휴대폰)
	amt             = NICEpay.GetResult((PInst),"amt")                '승인금액
	payMethod       = NICEpay.GetResult((PInst),"PayMethod")          '결제수단
	cardCode        = NICEpay.GetResult((PInst),"CardCode")           '카드사 코드
	cardName        = NICEpay.GetResult((PInst),"CardName")           '카드사명
	cardCaptureCode = NICEpay.GetResult((PInst),"AcquCardCode")       '매입사 코드
	cardCaptureName = NICEpay.GetResult((PInst),"AcquCardName")       '매입사 명

	bankCode        = NICEpay.GetResult((PInst),"BankCode")           '은행코드					(실시간계좌이체)
	bankName        = NICEpay.GetResult((PInst),"BankName")           '은행명					(실시간계좌이체)
	RcptType        = NICEpay.GetResult((PInst),"RcptType")           '현금영수증 타입			(실시간계좌이체) (0:발행안함 1:소득공제 2:지출증빙)

	vbankBankCode   = NICEpay.GetResult((PInst),"VbankBankCode")      '가상계좌은행코드			(가상계좌)
	vbankBankName   = NICEpay.GetResult((PInst),"VbankBankName")      '가상계좌은행명			(가상계좌)
	vbankNum        = NICEpay.GetResult((PInst),"VbankNum")           '가상계좌번호				(가상계좌)
	vbankExpDate    = NICEpay.GetResult((PInst),"VbankExpDate")       '가상계좌입금예정일

	carrier         = NICEpay.GetResult((PInst),"Carrier")            '이통사구분
	dstAddr         = NICEpay.GetResult((PInst),"DstAddr")            '휴대폰번호
	'추가
	cardnumber      = NICEpay.GetResult((PInst),"CardNum")              '카드 번호
	cardQuota       = NICEpay.GetResult((PInst),"CardQuota")            '카드 할부기간


		'--------------------------------------------------------------------------------------------------------
		'---------------------------------- WEBPRO --------------------------------------------------------------
		If CDbl(amt) <> CDbl(totalPrice) Then Call ALERTS("amt금액과 주문금액(totalPrice)이 다릅니다.","GO",GO_BACK_ADDR)
		If CDbl(amt) <> (CDbl(ori_price) - (CDbl(usePoint) + CDbl(usePoint2))) Then Call ALERTS("amt금액과 주문금액(totalPrice)이 다릅니다2.","GO",GO_BACK_ADDR)


		'▣주문정보 암호화
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strADDR1		<> "" Then strADDR1		= objEncrypter.Encrypt(strADDR1)
			If strADDR2		<> "" Then strADDR2		= objEncrypter.Encrypt(strADDR2)
			If strTel		<> "" Then strTel		= objEncrypter.Encrypt(strTel)
			If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
			If takeTel		<> "" Then takeTel		= objEncrypter.Encrypt(takeTel)
			If takeMobile	<> "" Then takeMobile	= objEncrypter.Encrypt(takeMobile)
			If takeADDR1	<> "" Then takeADDR1	= objEncrypter.Encrypt(takeADDR1)
			If takeADDR2	<> "" Then takeADDR2	= objEncrypter.Encrypt(takeADDR2)
			If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)

			If cardnumber	<> "" Then cardnumber	= objEncrypter.Encrypt(cardnumber)			'카드번호 암호화 추가
		Set objEncrypter = Nothing

		'로그기록생성 S ============================================================================================
		On Error Resume Next
		IF UCase(paymethod) = "CARD" THEN
			CardLogss = "log_Card"
		ELSEIF UCase(paymethod) = "BANK" Then
			CardLogss = "log_bank"
		ELSEIF UCase(paymethod) = "VBANK" THEN
			CardLogss = "log_vBank"
		END If

		Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine "Date : " & now()
		Sfile2.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile2.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
		Sfile2.WriteLine "THIS_PAGE_URL  : " & Request.ServerVariables("URL")
		Sfile2.WriteLine "paykind		 : " & paykind
		Sfile2.WriteLine "orderNum	 : " & orderNum
		Sfile2.WriteLine "inUidx		 : " & inUidx
		Sfile2.WriteLine "orderMode	 : " & orderMode
		Sfile2.WriteLine "mbid1		 : " & DK_MEMBER_ID1
		Sfile2.WriteLine "mbid2		 : " & DK_MEMBER_ID2
		Sfile2.WriteLine "strEmail	 : " & strEmail
		Sfile2.WriteLine "주문자정보	 : " & strName&"☞"&strTel&"☞"&strMobile&"☞"&strZip&"☞"&strADDR1&"☞"&strADDR2
		Sfile2.WriteLine "배송지정보	 : " & takeName&"☞"&takeTel&"☞"&takeMobile&"☞"&takeZip&"☞"&takeADDR1&"☞"&takeADDR2
		Sfile2.WriteLine "totalPrice	 : " & totalPrice
		Sfile2.WriteLine "totalDelivery : " & totalDelivery
		Sfile2.WriteLine "usePoint : " & usePoint
		Sfile2.WriteLine "usePoint2 : " & usePoint2
		Sfile2.WriteLine "DeliveryFeeType ~: " & DeliveryFeeType&"☞"&GoodsPrice&"☞"&totalOptionPrice&"☞"&totalOptionPrice2&"☞"&totalPoint&"☞"&usePoint&"☞"&usePoint2&"☞"&GoodsName
		Sfile2.WriteLine "isDirect	 : " & isDirect
		Sfile2.WriteLine "GoodIDX		 : " & GoodIDX
		Sfile2.WriteLine "v_SellCode	 : " & v_SellCode
		Sfile2.WriteLine "cardNo1		 : " & cardNo1
		Sfile2.WriteLine "quotabase	 : " & quotabase
		Sfile2.WriteLine "regnumber	 : " & regnumber
		If paykind = "vBank" Then
			Sfile2.WriteLine "=========== VBANK 발급 ============="
		Else
			Sfile2.WriteLine "========= <결제 결과 필드> ========="
		End If
		Sfile2.WriteLine "tid             : " & tid
		Sfile2.WriteLine "moid            : " & moid
		Sfile2.WriteLine "resultCode      : " & resultCode
		Sfile2.WriteLine "resultMsg       : " & resultMsg
		Sfile2.WriteLine "goodsName       : " & goodsName
		Sfile2.WriteLine "authDate        : " & authDate
		Sfile2.WriteLine "authCode        : " & authCode
		Sfile2.WriteLine "amt             : " & amt
		Sfile2.WriteLine "payMethod       : " & payMethod

		IF UCase(paymethod) = "CARD" THEN
			Sfile2.WriteLine "cardCode        : " & cardCode
			Sfile2.WriteLine "cardName        : " & cardName
			Sfile2.WriteLine "cardCaptureCode : " & cardCaptureCode
			Sfile2.WriteLine "cardCaptureName : " & cardCaptureName
			Sfile2.WriteLine "cardnumber      : " & cardnumber
			Sfile2.WriteLine "cardQuota       : " & cardQuota

		ELSEIF UCase(paymethod) = "BANK" Then
			Sfile2.WriteLine "bankCode        : " & bankCode
			Sfile2.WriteLine "bankName        : " & bankName
			Sfile2.WriteLine "RcptType        : " & RcptType

		ELSEIF UCase(paymethod) = "VBANK" THEN
			Sfile2.WriteLine "vbankBankCode   : " & vbankBankCode
			Sfile2.WriteLine "vbankBankName   : " & vbankBankName
			Sfile2.WriteLine "vbankNum        : " & vbankNum
			Sfile2.WriteLine "vbankExpDate    : " & vbankExpDate
		END If

		'Sfile2.WriteLine "carrier         : " & carrier
		'Sfile2.WriteLine "dstAddr         : " & dstAddr


		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <결제 성공 여부 확인>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		paySuccess = False	' 결제 성공 여부

		IF UCase(paymethod) = "CARD" THEN
			If resultCode = "3001" Then paySuccess  = True                  '신용카드(정상 결과코드:3001)
		ELSEIF UCase(paymethod) = "BANK" Then
			If resultCode = "4000" Then paySuccess  = True                  '계좌이체(정상 결과코드:4000)
		ELSEIF UCase(paymethod) = "VBANK" THEN
			If resultCode = "4100" Then paySuccess  = True                  '가상계좌(정상 결과코드:4100)
		ELSEIF UCase(paymethod) = "CELLPHONE" THEN
			If resultCode = "A000" Then paySuccess  = True                  '휴대폰(정상 결과코드:A000)
		END If

		Sfile2.WriteLine "paySuccess : " & paySuccess
		Sfile2.WriteLine "resultCode : " & resultCode
		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
		On Error GoTo 0


		'정상승인시 가맹점DB입력처리!!!! ==========================================================================s
		If paySuccess Then

				On Error Resume Next
				Dim Fso3 : Set  Fso3=CreateObject("Scripting.FileSystemObject")
				Dim LogPath3 : LogPath3 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
				Dim Sfile3 : Set  Sfile3 = Fso3.OpenTextFile(LogPath3,8,true)

				Dir_bankCode	= ""
				Dir_bankName	= ""
				vBankCode		= ""
				vBankName		= ""
				vBankAccNum     = ""
				vBankRecvName	= ""
				vBankDepDate    = ""
				vBankAmt		= 0
				vBankSetDate	= ""
				vBankTRX		= ""
				vBankStatus		= ""
				status101Date	= ""

				Select Case UCase(paykind)
					Case "CARD"
						If CDbl(amt) <> CDbl(totalPrice) Then
							Sfile3.WriteLine "amt금액과 주문금액(totalPrice)이 다릅니다! (카드취소여부확인:/Cancel/)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"amt금액과 주문금액(totalPrice)이 다릅니다!")
						End If

						state = "101"							'입금확인
						payway = "card"

						PGorderNum		= tid						'거래번호
						PGCardNum		= cardnumber				'카드번호(NICEPAY)
						PGAcceptNum		= authCode					'신용카드 승인번호
						PGinstallment	= cardQuota					'할부기간
						PGCardCode		= NICEPAY_CARDCODE(cardcode)'신용카드사코드
						PGCardCom		= cardName					'신용카드발급사
						PGCOMPANY		= "NICEPAY"					'PG사
						PGACP_TIME		= ""						'승인시간

					Case "BANK"		'"DIRECTBANK"
						If CDbl(amt) <> CDbl(totalPrice) Then
							Sfile3.WriteLine "amt금액과 주문금액(totalPrice)이 다릅니다! (취소여부확인:/Cancel/)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"amt금액과 주문금액(totalPrice)이 다릅니다!")
						End If

						state = "101"							'입금확인
						payway = "dbank"

						PGorderNum		= tid					'거래번호
						PGCardNum		= ""
						PGAcceptNum		= authCode				'승인번호
						PGinstallment	= ""					'현금영수증 발행구분코드
						PGCardCode		= bankCode				'은행코드(@v_C_Code)
						PGCardCom		= ""					'은행코드
						PGCOMPANY		= "NICEPAY"				'PG사
						PGACP_TIME		= ""					'승인시간

						Dir_bankCode	= bankCode				'은행코드
						Dir_bankName	= bankName				'은행명

					Case "VBANK"
						state = "100"
						payway = "vbank"

						PGorderNum		= tid					'거래번호
						PGCardNum		= ""
						PGAcceptNum		= authCode				'승인번호
						PGinstallment	= ""					'입금은행코드
						PGCardCode		= VbankBankCode			'가상계좌은행코드
						PGCardCom		= ""
						PGCOMPANY		= "NICEPAY"				'PG사
						PGACP_TIME		= ""					'승인시간

						vBankCode		= VbankBankCode			'가상계좌은행코드		(가상계좌)
						vBankName		= VbankBankName			'가상계좌은행명			(가상계좌)
						vBankAccNum     = VbankNum				'가상계좌입금번호		(가상계좌)
						vBankRecvName	= TXT_vBankRecvName		'수취인명
						vBankDepDate    = VbankExpDate			'가상계좌입금종료일
						vBankAmt		= amt
						vBankSetDate	= ""					'가상계좌 결제일
						vBankTRX		= tid					'가상계좌 거래번호
						vBankStatus		= "100"
						status101Date	= ""

				End Select

				AuthTIME	= Right(authDate,6)			'authDate(NICEPAY 180220111301)
				PGACP_TIME = 	Date()&" "&Left(authDate,2)&":"&Mid(authDate,3,2)&":"&Right(authDate,2)		'승인시간(NICEPAY  2018-02-20 11:13:01)
				Sfile3.WriteLine "PGACP_TIME : " & PGACP_TIME

				'▣신용카드 승인번호 암호화
				If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If PGAcceptNum			<> "" Then PGAcceptNum				= objEncrypter.Encrypt(PGAcceptNum)
					Set objEncrypter = Nothing
				End If


				Sfile3.Close
				Set Fso3= Nothing
				Set objError= Nothing
				On Error GoTo 0


			'+++++++++++++++++++++++++++++++++++++++++++++++

				strDomain	= strHostA
				strIDX		= DK_SES_MEMBER_IDX
				strUserID	= DK_MEMBER_ID

			'====================================================================================================================
'				identity = 0  'default
				SQL = " INSERT INTO [DK_ORDER] ( "
				SQL = SQL & " [strDomain],[OrderNum],[strIDX],[strUserID],[payWay] "
				SQL = SQL & " ,[totalPrice],[totalDelivery],[totalOptionPrice],[totalPoint],[strName] "
				SQL = SQL & " ,[strTel],[strMob],[strEmail],[strZip],[strADDR1] "
				SQL = SQL & " ,[strADDR2],[takeName],[takeTel],[takeMob],[takeZip] "
				SQL = SQL & " ,[takeADDR1],[takeADDR2],[status],[orderMemo],[strSSH1] "
				SQL = SQL & " ,[strSSH2],[bankIDX],[BankingName],[usePoint],[totalVotePoint] "

				SQL = SQL & " ,[PGorderNum],[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode]"
				SQL = SQL & " ,[PGCardCom],[PGCOMPANY]"
				SQL = SQL & " ,[strNationCode]"													'국가코드추가
				SQL = SQL & " ,[usePoint2]"														'포인트2

				SQL = SQL & " ,[Dir_bankCode],[Dir_bankName]"											'실시간계좌이체
				SQL = SQL & " ,[vBankCode],[vBankName],[vBankAccNum],[vBankRecvName],[vBankDepDate]"	'가상계좌
				SQL = SQL & " ,[vBankAmt],[vBankSetDate],[vBankTRX]"									'가상계좌

				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?"
				SQL = SQL & " ,?"
				SQL = SQL & " ,?"

				SQL = SQL & " ,?,?"
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,? "

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

					Db.makeParam("@strTel",adVarchar,adParamInput,50,strTel), _
					Db.makeParam("@strMob",adVarchar,adParamInput,50,strMobile), _
					Db.makeParam("@strEmail",adVarWChar,adParamInput,500,strEmail), _
					Db.makeParam("@strZip",adVarchar,adParamInput,50,strZip), _
					Db.makeParam("@strADDR1",adVarchar,adParamInput,512,strADDR1), _

					Db.makeParam("@strADDR2",adVarchar,adParamInput,512,strADDR2), _
					Db.makeParam("@takeName",adVarWChar,adParamInput,50,takeName), _
					Db.makeParam("@takeTel",adVarchar,adParamInput,50,takeTel), _
					Db.makeParam("@takeMob",adVarchar,adParamInput,50,takeMobile), _
					Db.makeParam("@takeZip",adVarchar,adParamInput,10,takeZip), _

					Db.makeParam("@takeADDR1",adVarchar,adParamInput,512,takeADDR1), _
					Db.makeParam("@takeADDR2",adVarchar,adParamInput,512,takeADDR2), _
					Db.makeParam("@state",adChar,adParamInput,3,state), _
					Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo), _
					Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _

					Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2), _
					Db.makeParam("@bankIDX",adInteger,adParamInput,4,""), _
					Db.makeParam("@bankingName",adVarWChar,adParamInput,50,""), _
					Db.makeParam("@usePoint",adDouble,adParamInput,16,usePoint), _
					Db.makeParam("@totalVotePoint",adDouble,adParamInput,16,totalVotePoint), _

					Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,PGorderNum), _
					Db.makeParam("@PGCardNum",adVarchar,adParamInput,100,PGCardNum), _
					Db.makeParam("@PGAcceptNum",adVarchar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@PGinstallment",adVarchar,adParamInput,20,PGinstallment), _
					Db.makeParam("@PGCardCode",adVarchar,adParamInput,20,PGCardCode), _
					Db.makeParam("@PGCardCom",adVarchar,adParamInput,50,PGCardCom), _
					Db.makeParam("@PGCOMPANY",adVarchar,adParamInput,50,PGCOMPANY), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
					Db.makeParam("@usePoint2",adDouble,adParamInput,16,usePoint2), _

					Db.makeParam("@Dir_bankCode",adChar,adParamInput,3,Dir_bankCode), _
					Db.makeParam("@Dir_bankName",adVarWChar,adParamInput,40,Dir_bankName), _
					Db.makeParam("@vBankCode",adVarChar,adParamInput,3,vBankCode), _
					Db.makeParam("@vBankName",adVarWChar,adParamInput,100,vBankName), _
					Db.makeParam("@vBankAccNum",adVarChar,adParamInput,30,vBankAccNum), _
					Db.makeParam("@vBankRecvName",adVarChar,adParamInput,30,vBankRecvName), _
					Db.makeParam("@vBankDepDate",adVarChar,adParamInput,14,vBankDepDate), _
					Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
					Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
					Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX), _

					Db.makeParam("@identity",adInteger,adParamOutput,0,0) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				identity = arrParams(UBound(arrParams))(4)


				On Error Resume Next
				Dim Fso4 : Set  Fso4=CreateObject("Scripting.FileSystemObject")
				Dim LogPath4 : LogPath4 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
				Dim Sfile4 : Set  Sfile4 = Fso4.OpenTextFile(LogPath4,8,true)

				Sfile4.WriteLine "identity : " & identity
				If identity = "" Or isNull(identity) Or identity < 1 Then
					Sfile4.WriteLine "identity미발생오류 : DK_ORDER 데이타 미입력! (카드취소여부확인:/cardCancel/)"
					If UCase(paymethod) <> "VBANK" Then
						Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"identity미발생오류 : DK_ORDER 데이타 미입력!")
					End If
				End If

				Sfile4.Close
				Set Fso4= Nothing
				Set objError= Nothing
				On Error GoTo 0

				If state = "101" Then
					SQL = "UPDATE [DK_ORDER] SET [status] = '101', [status101Date] = getDate() WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,4,identity) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				End If




				CSGoodCnt = 0 ' CS상품 초기화

			'◆ #8. 임시주문 상품테이블에서 현 주문 상품 정보 호출(카트수량 변조 무시) S
				SQLC3 = "SELECT [GoodIDX],[strOption],[orderEa],[isShopType],[strShopID] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? And [OrderNum] = ?"
				arrParamsC3 = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,4,OIDX), _
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


						On Error Resume Next
						Dim Fso5 : Set  Fso5=CreateObject("Scripting.FileSystemObject")
						Dim LogPath5 : LogPath5 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
						Dim Sfile5 : Set  Sfile5 = Fso5.OpenTextFile(LogPath5,8,true)

						'상품 정보(수량) 확인
							SQL = "SELECT "
							SQL = SQL & " [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept]"
							SQL = SQL & ",[GoodsName],[imgThum],[GoodsPrice],[GoodsCustomer],[GoodsCost]"
							SQL = SQL & ",[GoodsPoint],[GoodsDeliveryType],[GoodsDeliveryFee],[intPriceNot],[intPriceAuth]"
							SQL = SQL & ",[intPriceDeal],[intPriceVIP],[intMinNot],[intMinAuth],[intMinDeal]"
							SQL = SQL & ",[intMinVIP],[intPointNot],[intPointAuth],[intPointDeal],[intPointVIP]"
							SQL = SQL & ",[isCSGoods],[CSGoodsCode]"
							SQL = SQL & ",[isImgType]"

							SQL = SQL & " FROM [DK_GOODS] WHERE [intIDX] = ?"
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
								DKRS_CSGoodsCode			= DKRS("CSGoodsCode")
								DKRS_isImgType				= DKRS("isImgType")

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

								'▣소비자 가격, 쇼핑몰가/CS가 비교(2018-05-18)
							'	If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
							'		DKRS_GoodsPrice	 = DKRS_GoodsCustomer
							'	End If


							Else
								Sfile5.WriteLine "존재하지 않는 상품구입을 시도했습니다.! (결제취소여부확인)"
								If UCase(paymethod) <> "VBANK" Then
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"존재하지 않는 상품구입을 시도했습니다.!")
								End If
							End If
							Call closeRS(DKRS)

							If DKRS_DelTF = "T" Then
								Sfile5.WriteLine "삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(결제취소여부확인)"
								If UCase(paymethod) <> "VBANK" Then
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
								End If
							End If
							If DKRS_isAccept <> "T" Then
								Sfile5.WriteLine "승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(결제취소여부확인)"
								If UCase(paymethod) <> "VBANK" Then
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
								End If
							End If
							If DKRS_GoodsViewTF <> "T" Then
								Sfile5.WriteLine "더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(결제취소여부확인)"
								If UCase(paymethod) <> "VBANK" Then
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
								End If
							End If


							Select Case DKRS_GoodsStockType
								Case "I"
								Case "N"
									If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
										Sfile5.WriteLine "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.(결제취소여부확인)"
										If UCase(paymethod) <> "VBANK" Then
											Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.")
										End If
									Else
										SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
										arrParams = Array(_
											Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
											Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
										)
										Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
									End If
								Case "S"
									Sfile5.WriteLine  "품절상품. 새로고침 후 다시 시도해주세요"
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"품절상품. 새로고침 후 다시 시도해주세요")
								Case Else
									Sfile5.WriteLine  "수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.(결제취소여부확인)"
									If UCase(paymethod) <> "VBANK" Then
										Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.")
									End If
							End Select

							Sfile5.Close
							Set Fso5= Nothing
							Set objError= Nothing
							On Error GoTo 0



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
							''			GoodsDeliveryFeeType	= "무료배송"
							''			GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS2_intFee)
							''			GoodsDeliveryLimit		= DKRS2_intLimit
							''		Case "prev"
							''			GoodsDeliveryFeeType	= "선결제"
							''			GoodsDeliveryFee		= Int(DKRS2_intFee)
							''			GoodsDeliveryLimit		= DKRS2_intLimit
							''		Case "next"
							''			GoodsDeliveryFeeType	= "착불"
							''			GoodsDeliveryFee		= Int(DKRS2_intFee)
							''			GoodsDeliveryLimit		= DKRS2_intLimit
							''	End Select

							End If
						'옵션가격 확인
							GoodsOptionPrice = 0
							GoodsOptionPrice2 = 0
							arrResult = Split(CheckSpace(DKRS_strOption),",")
							For j = 0 To UBound(arrResult)
								arrOption = Split(Trim(arrResult(j)),"\")
								arrOptionTitle = Split(arrOption(0),":")
								If arrOption(1) > 0 Then
									OptionPrice = " / + " & num2cur(arrOption(1)) &" 원"
								ElseIf arrOption(1) < 0 Then
									OptionPrice = "/ - " & num2cur(arrOption(1)) &" 원"
								ElseIf arrOption(1) = 0 Then
									OptionPrice = ""
								End If
								GoodsOptionPrice = Int(GoodsOptionPrice) + Int(arrOption(1))
								GoodsOptionPrice2 = Int(GoodsOptionPrice2) + Int(arrOption(2))
							Next



						'구매정보(상품) 입력
							SQL = " INSERT INTO [DK_ORDER_GOODS] ( "
							SQL = SQL & " [orderIDX],[GoodIDX],[strOption],[orderEa],[goodsPrice]"
							SQL = SQL & ",[goodsOptionPrice],[goodsPoint],[GoodsCost],[isShopType],[strShopID]"
							SQL = SQL & ",[GoodsName],[ImgThum],[GoodsDeliveryType],[GoodsDeliveryFeeType],[GoodsDeliveryFee]"
							SQL = SQL & ",[GoodsDeliveryLimit],[status],[isImgType],[GoodsOPTcost],[OrderNum]"
							SQL = SQL & ",[isCSGoods],[CSGoodsCode]"									'▣CS상품코드추가
							SQL = SQL & " ) VALUES ( "
							SQL = SQL & " ?, ?, ?, ?, ?"
							SQL = SQL & ",?, ?, ?, ?, ?"
							SQL = SQL & ",?, ?, ?, ?, ?"
							SQL = SQL & ",?, ?, ?, ?, ?"
							SQL = SQL & ",?, ?"
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
								Db.makeParam("@GoodsOPTcost",adDouble,adParamInput,16,GoodsOptionPrice2),_

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



			'전산입력
			'=============================================================================================================================
			'===  CS전산입력 =============================================================================================================
			nowTime = Now
			RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
			Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

			'If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then 'CS회원이고 cs연동상품이 1개 이상 있는 경우
			If DK_MEMBER_TYPE = "COMPANY" Or DK_MEMBER_TYPE = "GUEST" Then												'▣바이오플래넷 비회원주문 → CS
				SQL = "SELECT * FROM [tbl_Memberinfo] WHERE [mbid] = ? and [mbid2] = ?"		'DK_MEMBER_WEBID!!!
				arrParams = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,30,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,30,DK_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					MBID1		= DKRS("mbid")
					MBID2		= DKRS("mbid2")
					Sell_Mem_TF = DKRS("Sell_Mem_TF")		'1:소비자, 0:판매원

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

						SQL2 = SQL2 & " ,[Dir_bankCode],[Dir_bankName]"		'실시간계좌이체
						SQL2 = SQL2 & " ,[vBankCode],[vBankName],[vBankAccNum],[vBankRecvName],[vBankDepDate]"	'가상계좌
						SQL2 = SQL2 & " ,[vBankAmt],[vBankSetDate],[vBankTRX]"					'가상계좌

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

						SQL2 = SQL2 & " ,?,?"
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?"

						SQL2 = SQL2 & " )"
						SQL2 = SQL2 & " SELECT ? = @@IDENTITY"

						arrParams2 = Array(_
							Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum),_
							Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,strIDX),_
							Db.makeParam("@MBID",adVarChar,adParamInput,20,MBID1),_
							Db.makeParam("@MBID2",adInteger,adParamInput,4,MBID2),_
							Db.makeParam("@totalPrice",adDouble,adParamInput,16,totalPrice),_

							Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName),_
							Db.makeParam("@takeZip",adVarChar,adParamInput,10,Replace(takeZip,"-","")),_
							Db.makeParam("@takeADDR1",adVarWChar,adParamInput,700,takeADDR1),_
							Db.makeParam("@takeADDR2",adVarWChar,adParamInput,700,takeADDR2),_
							Db.makeParam("@takeMob",adVarChar,adParamInput,100,takeMobile),_

							Db.makeParam("@takeTel",adVarChar,adParamInput,100,takeTel),_
							Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode),_
							Db.makeParam("@payType",adVarChar,adParamInput,20,paykind),_
							Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,""),_
							Db.makeParam("@payBankAccNum",adVarChar,adParamInput,50,""),_

							Db.makeParam("@payBankDate",adVarChar,adParamInput,50,""),_
							Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,""),_
							Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,""),_
							Db.makeParam("@PayState",adChar,adParamInput,3,"103"),_

							Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo),_
							Db.makeParam("@M_NAME",adVarWChar,adParamInput,50,strName),_
							Db.makeParam("@deliveryFee",adDouble,adParamInput,16,GoodsDeliveryFee),_
							Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
							Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,PGorderNum),_

							Db.makeParam("@PGCardNum",adVarChar,adParamInput,50,PGCardNum),_
							Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,50,PGAcceptNum),_
							Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,PGinstallment),_
							Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode),_
							Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCom),_

							Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,status101Date),_
							Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@InputMileage",adDouble,adParamInput,16,usePoint), _

							Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _

								Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

								Db.makeParam("@InputMileage2",adDouble,adParamInput,16,usePoint2), _

								Db.makeParam("@Dir_bankCode",adChar,adParamInput,3,Dir_bankCode), _
								Db.makeParam("@Dir_bankName",adVarWChar,adParamInput,40,Dir_bankName), _
								Db.makeParam("@vBankCode",adVarChar,adParamInput,3,vBankCode), _
								Db.makeParam("@vBankName",adVarWChar,adParamInput,100,vBankName), _
								Db.makeParam("@vBankAccNum",adVarChar,adParamInput,30,vBankAccNum), _
								Db.makeParam("@vBankRecvName",adVarChar,adParamInput,30,vBankRecvName), _
								Db.makeParam("@vBankDepDate",adVarChar,adParamInput,14,vBankDepDate), _
								Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
								Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
								Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX), _

							Db.makeParam("@CS_IDENTITY",adInteger,adParamOutPut,4,0) _
						)
						Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
						CS_IDENTITY = arrParams2(Ubound(arrParams2))(4)
						'print CS_IDENTITY



						'주문정보에서 CS상품을 검색한다
						SQL3 = "SELECT [GoodIDX],[OrderEa] FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
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
								SQL4 = SQL4 & " FROM [DK_GOODS] WHERE [intIDX] = ?"
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
									arrParams = Array(_
										Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)), _
										Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode) _
									)
									Set DKRS6 = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
									'Set DKRS6 = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
									If Not DKRS6.BOF And Not DKRS6.EOF Then
										DKRS6_ncode		= DKRS6("ncode")
										DKRS6_price		= DKRS6("price")		'소비자가
										DKRS6_price2	= DKRS6("price2")
										DKRS6_price4	= DKRS6("price4")
										DKRS6_price6	= DKRS6("price6")
									End If
									Call closeRs(DKRS6)

									'▣소비자 가격, 쇼핑몰가/CS가 비교(2018-05-18)
								'	If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
								'		DKRS6_price2	= DKRS6_price
								'	End If


									SQL7 = "INSERT INTO [DK_ORDER_TEMP_GOODS] ( "
									SQL7 = SQL7 & " [OrderIDX],[GoodsCode],[GoodsPrice],[GoodsPV],[ea] "
									SQL7 = SQL7 & " ) VALUES ("
									SQL7 = SQL7 & " ?,?,?,?,?"
									SQL7 = SQL7 & " )"
									arrParams7 = Array(_
										Db.makeParam("@orderIDX",adInteger,adParamInput,4,CS_IDENTITY), _
										Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode), _
										Db.makeParam("@GoodsPrice",adDouble,adParamInput,16,DKRS6_price2), _
										Db.makeParam("@GoodsPV",adDouble,adParamInput,16,DKRS6_price4), _
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

										'전체상품 가격 체크 CS
											SQL8 = "SELECT SUM([GoodsPrice]*[ea]) FROM [DK_ORDER_TEMP_GOODS] WITH(NOLOCK) WHERE [orderIDX] = ?"
											arrParams8 = Array(_
												Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY) _
											)
											DKCS_TOTAL_PRICE = Db.execRsData(SQL8,DB_TEXT,arrParams8,DB3)

											'■■ CS상품 옵션X, 총결제금액(배송비포함)
											DKCS_TOTAL_PRICE = DKCS_TOTAL_PRICE + GoodsDeliveryFee

										'결제금액의 변조확인
											CHK_totalPrice = CDbl(totalPrice) + CDbl(usePoint) + CDbl(usePoint2)
											If (CDbl(CStr(WEBDB_TOTAL_PRICE)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Or (CDbl(CStr(CHK_totalPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Then
											'If (CDbl(CStr(WEBDB_TOTAL_PRICE)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Or (CDbl(CStr(totalPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Then
												Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,ThisMsg)
											End If

								'■전체상품 가격 변경■
									SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
									arrParams9 = Array(_
										Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
										Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
									)
									Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)



								If UCase(paymethod) <> "VBANK" Then		'가상계좌 아닐때만!!!

									v_Etc1 = "NICEPAY_"&num2cur(DKCS_TOTAL_PRICE)&"원_"&orderNum

									arrParams = Array(_
										Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

										Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
										Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

										Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_Etc1),_
										Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

										Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
										Db.makeParam("@v_C_Number1",adVarWChar,adParamInput,100,PGCardNum),_
										Db.makeParam("@v_C_Number2",adVarWChar,adParamInput,100,PGAcceptNum),_
										Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,strName),_
										Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

										Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
										Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
										Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallment),_

										Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
										Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
									)
									Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
									OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
									OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
									'Sfile.WriteLine OUTPUT_VALUE

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

									On Error Resume Next
									Dim Fso6 : Set  Fso6=CreateObject("Scripting.FileSystemObject")
									Dim LogPath6 : LogPath6 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
									Dim Sfile6 : Set  Sfile6 = Fso6.OpenTextFile(LogPath6,8,true)

									'■배송시 요청사항 CS입력
									If orderMemo <> "" Then
										SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "  'nvarchar(500)
										arrParams_RECE = Array(_
											Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
											Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
										)
										Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
									End If

									Sfile6.WriteLine "CS_ORDERNUM : " & OUT_ORDERNUMBER

									If OUT_ORDERNUMBER = "" Then
										Sfile6.WriteLine  "CS_ORDERNUMBER가 발생하지 않았습니다.(카드취소여부확인)"
										Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"CS_ORDERNUMBER가 발생하지 않았습니다.")
									End If

									Sfile6.Close
									Set Fso6= Nothing
									Set objError= Nothing
									On Error GoTo 0

								End If



						End If

					End If


				End If
				Call closeRS(DKRS)
			End If
			'=== CS 전산입력 종료 =========================================================================================================
			'==============================================================================================================================



			ALERTS_MESSAGE = ""

			'=== 직판공제번호발급 ====
			If isMACCO = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
%>
			<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
<%
			End if



			If Err.Number <> 0 Then
				Call alerts("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","Go",chgPage&"/shop")
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

				If UCase(paymethod) = "VBANK" Then
					Call gotoURL(chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
				Else
					Call ALERTS("구매가 성공적으로 이루어졌습니다..\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
				End If

			End If

		'====================================================================================================================
		'====================================================================================================================

		'+++++++++++++++++++++++++++++++++++++++++++++++


		Else
			Call ALERTS("["&ResultCode&"]"&ResultMsg,"GO",GO_BACK_ADDR)
		End If






		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <클래스 해제>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		NICEpay.Destroy CLng(PInst)
%>

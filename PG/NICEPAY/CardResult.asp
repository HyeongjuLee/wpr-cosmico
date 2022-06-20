<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include file = "NICEPAY_FUNCTION.ASP"-->
<%
	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)


'▣NICEPAY 결제처리(테스트, 2018-02-21~ )

'PG 설정

''	Dim PGID				: PGID				= "coencell7m"		'REAL ID (웰메이드코엔, 2018-05-18~)
	Dim PGID				: PGID				= "nictest04m"		'test ID


'공통 필드
	Dim paykind				: paykind			= "CARD"							'pRequestTF("paykind",True)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",True)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",True)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",True)

	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

' 주문정보 필드 받아오기

	Dim strName				: strName			= pRequestTF("strName",True)
	Dim strTel				: strTel			= pRequestTF("strTel",False)
	Dim strMob				: strMob			= pRequestTF("strMobile",True)


	Dim strEmail			: strEmail			= pRequestTF("strEmail",False)
	Dim strZip				: strZip			= pRequestTF("strZip",True)
	Dim strADDR1			: strADDR1			= pRequestTF("strADDR1",True)
	Dim strADDR2			: strADDR2			= pRequestTF("strADDR2",True)

	Dim takeName			: takeName			= pRequestTF("takeName",False)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMob				: takeMob			= pRequestTF("takeMobile",False)
	Dim takeZip				: takeZip			= pRequestTF("takeZip",False)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",False)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",False)

	Dim infoChg				: infoChg			= pRequestTF("infoChg",False)

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
	'isDirect or Cart 체크
	Dim isDirect			: isDirect			= pRequestTF("isDirect",False)
	Dim GoodIDX				: GoodIDX			= pRequestTF("GoodIDX",False)

'CS관련
	Dim v_SellCode			: v_SellCode		= pRequestTF("v_SellCode",False)				'CS상품 구매종류
	Dim BusCode				: BusCode			= pRequestTF("BusCode",False)

'무통장 관련 필드
	Dim bankidx				: bankidx			= pRequestTF("bankidx",False)
	Dim bankingName			: bankingName		= pRequestTF("bankingName",False)

	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

	'CS 관련 & 특이사항
	CSGoodCnt		= Trim(pRequestTF("CSGoodCnt",True))				'통합정보 CS상품 갯수
	isSpecialSell	= Trim(pRequestTF("isSpecialSell",False))
	If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then
		v_SellCode		= Trim(pRequestTF("v_SellCode",True))				'CS상품 구매종류
		SalesCenter		= Trim(pRequestTF("SalesCenter",False))				'판매센터
		DtoD			= Trim(pRequestTF("DtoD",True))						'판매센터
	Else
		v_SellCode		= ""
		SalesCenter		= ""
		DtoD			= "T"
	End If


'카드 추가필드
	Dim cardNo1				: cardNo1	= pRequestTF("cardNo1",True)
	Dim cardNo2				: cardNo2	= pRequestTF("cardNo2",True)
	Dim cardNo3				: cardNo3	= pRequestTF("cardNo3",True)
	Dim cardNo4				: cardNo4	= pRequestTF("cardNo4",True)
	Dim card_mm				: card_mm	= pRequestTF("card_mm",True)		'유효기간(월) MM
	Dim card_yy				: card_yy	= pRequestTF("card_yy",True)		'유효기간(년) YYYY
	Dim quotabase			: quotabase = pRequestTF("quotabase",True)
	Dim CardPass			: CardPass	= pRequestTF("CardPass",True)		'카드비번(앞2자리)
	Dim strBirth1			: strBirth1	= pRequestTF("birthYY",True)		'생년월일
	Dim strBirth2			: strBirth2	= pRequestTF("birthMM",True)
	Dim strBirth3			: strBirth3	= pRequestTF("birthDD",True)


	orderEaD				= Trim(pRequestTF("ea",False))						'◆ #5. EA
	GoodIDXs				= Trim(pRequestTF("GoodIDXs",False))				'◆ #5. GoodIDXs
	strOptions				= Trim(pRequestTF("strOptions",False))				'◆ #5. strOptions
	OIDX					= Trim(pRequestTF("OIDX",True))						'◆ #5. 임시주문테이블 idx

	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0


	'''isDirect or Cart 체크 (GO_BACK_ADDR)
	''If isDirect = "T" Then
	''	GO_BACK_ADDR = chgPage&"/shop/detailView.asp?gidx="&GoodIDX
	''Else
	''	GO_BACK_ADDR = chgPage&"/shop/cart.asp"
	''End If
		If LCase(orderMode) = "mobile" Then
			chgPage = "/m"
		Else
			chgPage = ""
		End If

	'♠ GO_BACK_ADDR 주문페이지로 보내기 S♠
		gidx = inUidx

		On Error Resume Next
		Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
			gidx = Trim(StrCipher.Encrypt(gidx,EncTypeKey1,EncTypeKey2))
		Set StrCipher = Nothing
		On Error GoTo 0

		GO_BACK_ADDR = chgPage&"/shop/cart_directB.asp?gidx="&gidx
	'♠ GO_BACK_ADDR 주문페이지로 보내기 E♠




	If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then
		birth = strBirth1 & strBirth2 & strBirth3
		regnumber = Right(birth,6)
	Else
		Call ALERTS("생년월일이 입력되지 않았습니다.","GO",GO_BACK_ADDR)
	End If

	card_mm = Right("00"&card_mm,2)



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


'치환
	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID

	cardNo		= cardNo1 & cardNo2 & cardNo3 & cardNo4
	cardYYMM	= Right(card_yy,2) & card_mm

	bankidx		= ""
	bankingName = ""
	strSSH1		= ""
	strSSH2		= ""


	CardLogss = "log_CardAPI"

	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)

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


'	Call ResRW(PGID					,"PGID")
'	Call ResRW(PGPWD				,"PGPWD")
'	Call ResRW(paykind				,"paykind")
'	Call ResRW(orderNum				,"orderNum")
'	Call ResRW(inUidx				,"inUidx")
'	Call ResRW(gopaymethod			,"gopaymethod")
'	Call ResRW(strName				,"strName")
'	Call ResRW(strTel				,"strTel")
'	Call ResRW(strMobile			,"strMobile")
'	Call ResRW(strEmail				,"strEmail")
'	Call ResRW(strZip				,"strZip")
'	Call ResRW(strADDR1				,"strADDR1")
'	Call ResRW(strADDR2				,"strADDR2")
'	Call ResRW(takeName				,"takeName")
'	Call ResRW(takeTel				,"takeTel")
'	Call ResRW(takeMobile			,"takeMobile")
'	Call ResRW(takeZip				,"takeZip")
'	Call ResRW(takeADDR1			,"takeADDR1")
'	Call ResRW(takeADDR2			,"takeADDR2")
'	Call ResRW(infoChg				,"infoChg")
	Call ResRW(totalPrice			,"totalPrice")
	Call ResRW(ori_price			,"ori_price")
'	Call ResRW(totalDelivery		,"totalDelivery")
'	Call ResRW(DeliveryFeeType		,"DeliveryFeeType")
'	Call ResRW(GoodsPrice			,"GoodsPrice")
'	Call ResRW(totalOptionPrice		,"totalOptionPrice")
'	Call ResRW(totalOptionPrice2	,"totalOptionPrice2")
'	Call ResRW(totalPoint			,"totalPoint")
'
	Call ResRW(usePoint				,"usePoint")
	Call ResRW(usePoint2			,"usePoint2")
'	Call ResRW(totalVotePoint		,"totalVotePoint")
'
'	Call ResRW(orderMemo			,"orderMemo")
'
'	Call ResRW(v_SellCode			,"v_SellCode")
'	Call ResRW(BusCode				,"BusCode")
'
'	Call ResRW(cardNo1				,"cardNo1")
'	Call ResRW(cardNo2				,"cardNo2")
'	Call ResRW(cardNo3				,"cardNo3")
'	Call ResRW(cardNo4				,"cardNo4")
'	Call ResRW(card_mm				,"card_mm")
'	Call ResRW(card_yy				,"card_yy")
'	Call ResRW(quotabase			,"quotabase")
'
'	Call ResRW(strDomain			,"strDomain")
'	Call ResRW(strIDX				,"strIDX")
'	Call ResRW(strUserID			,"strUserID")
'	Call ResRW(cardNo				,"cardNo")
'	Call ResRW(cardYYMM				,"cardYYMM")
'	Call ResRW(GoodsName			,"GoodsName")
'	Call ResRW(CardPass				,"CardPass")
'	Call ResRW(birth				,"birth")
'	Call ResRW(GO_BACK_ADDR			,"GO_BACK_ADDR")
Response.End




%>
<%
'▣ 웹주문번호 중복체크 S
	ORDER_DUP_CNT = 0
	SQLNC1 = "SELECT COUNT(*) FROM [DK_ORDER_TEMP] WITH (NOLOCK) WHERE [orderNum] = ? AND [payType] = ? AND [orderType] <> '' "
	arrParamsNC1 = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,OrderNum), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,Paykind) _
	)
	ORDER_DUP_CNT = Db.execRsData(SQLNC1,DB_TEXT,arrParamsNC1,Nothing)

	If CDbl(ORDER_DUP_CNT) > 0  Then Call ALERTS("비정상적인 주문번호입니다. (새로고침 후 다시 시도해주세요.)","GO",GO_BACK_ADDR)
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

			'▣ 상품 정보 확인 S
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
					Call ALERTS("존재하지 않는 상품구입을 시도했습니다. (새로고침 후 다시 시도해주세요!)","GO",GO_BACK_ADDR)
				End If
				Call closeRS(DKRSC2)

				If DKRSC2_DelTF = "T" Then			Call ALERTS("삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
				If DKRSC2_isAccept <> "T" Then		Call ALERTS("승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
				If DKRSC2_GoodsViewTF <> "T" Then	Call ALERTS("더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요","GO",GO_BACK_ADDR)
			'▣ 상품 정보 확인 E

			'◈ 상품 재고 확인 S  ''추가
				Select Case DKRSC2_GoodsStockType
					Case "I"
					Case "N"
						If Int(DKRSC2_GoodsStockNum) < Int(DKRSC1_orderEa) Then
							'Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
							Call ALERTS(LNG_SHOP_DETAILVIEW_06 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
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
			Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
			Db.makeParam("@totalPrice",adInteger,adParamInput,4,totalPrice), _
			Db.makeParam("@deliveryFee",adInteger,adParamInput,4,totalDelivery), _
			Db.makeParam("@totalOptionPrice",adInteger,adParamInput,4,totalOptionPrice), _
				Db.makeParam("@totalPoint",adInteger,adParamInput,0,totalPoint), _
				Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _
				Db.makeParam("@InputMileage2",adInteger,adParamInput,4,usePoint2), _
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
%>





<%
	GoodsName = Left(GoodsName,20)	'40byte

	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <결제 결과 설정>
	' 로그 디렉토리는 NICE.dll 설치위치 /log 폴더 입니다.
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Set NICEpay = Server.CreateObject("NICE.NICETX2.1")
	PInst = NICEpay.Initialize("")

'웰메이드 실결제
'	merchantKey = "Fi5Sjix/NUgZBOAej1Ksxkj3t29iym9ZTFEpogwnaZGXFQChav1UypMFDCPYSSn6nz+dj0AkLw5SUTFm6tAEfA=="
'	CancelPwd	= "coencell7"		'거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!
'테스트
	merchantKey = "b+zhZ4yOZ7FsH8pm5lhDfHZEb79tIwnjsdA0FBXh86yLc6BJeFVrZFXhAoJ3gEWgrWwN+lJMV0W4hvDdbe4Sjw=="
	CancelPwd	= "123456"		'거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!


	'NICEpay.SetField CLng(PInst),"MID",Request("MID")                  '상점 ID
	NICEpay.SetField CLng(PInst),"MID",PGID								'상점 ID							'PGID
	'NICEpay.SetField CLng(PInst),"logpath","C:\log"					'Log Path 설정
	NICEpay.SetField CLng(PInst),"logpath","E:\PG\NICEPAY\log"			'Log Path 설정						'Webpro Log Path
	NICEpay.SetField CLng(PInst),"LicenseKey",merchantKey               'MID
	NICEpay.SetField CLng(PInst),"CardInterest","0"                     '무이자할부 여부 (1:YES, 0:NO)
	NICEpay.SetField CLng(PInst),"CancelPwd",CancelPwd					'거래취소 패스워드
	NICEpay.SetField CLng(PInst),"debug", "true"                        '로그모드(true = 상세 로그)
	NICEpay.SetField CLng(PInst),"AuthFlag","2"                         '비인증결제: 2
	NICEpay.SetActionType CLng(PInst), "FORMPAY"                        '결제방법
	NICEpay.SetField CLng(PInst),"PayMethod",paykind					'결제수단							'paykind
	NICEpay.SetField CLng(PInst),"Amt",totalPrice						'결제금액							'totalPrice
	NICEpay.SetField CLng(PInst),"Moid",orderNum						'상점주문번호						'orderNum
	NICEpay.SetField CLng(PInst),"GoodsName",GoodsName					'상품명								'GoodsName
	NICEpay.SetField CLng(PInst),"Currency","KRW"                       '화폐단위
	NICEpay.SetField CLng(PInst),"BuyerName",strName					'구매자 이름						'strName
	NICEpay.SetField CLng(PInst),"MallUserID",DK_MEMBER_ID				'구매자 ID							'DK_MEMBER_ID
	NICEpay.SetField CLng(PInst),"BuyerTel",strMobile					'구매자 전화번호					'strMobile
	NICEpay.SetField CLng(PInst),"BuyerEmail",strEmail					'구매자 이메일						'strEmail
	NICEpay.SetField CLng(PInst),"CardNum",cardNo						'카드 번호							'cardNo
	NICEpay.SetField CLng(PInst),"CardExpire",cardYYMM					'카드 유효기간						'cardYYMM
	NICEpay.SetField CLng(PInst),"CardQuota",quotabase				    '카드 할부기간						'quotabase
	NICEpay.SetField CLng(PInst),"CardPwd",CardPass						'카드 비밀번호						'CardPass
	NICEpay.SetField CLng(PInst),"BuyerAuthNum",regnumber				'카드소유주 생년월일(yymmdd)		'regnumber
	NICEpay.StartAction(CLng(PInst))


	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <결제 결과 필드>
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	tid             = NICEpay.GetResult(CLng(PInst),"TID")              '거래번호
	moid            = NICEpay.GetResult(CLng(PInst),"Moid")             '거래번호X							'상점주문번호orderNum
	resultCode      = NICEpay.GetResult(CLng(PInst),"ResultCode")       '결과코드TID
	resultMsg       = NICEpay.GetResult(CLng(PInst),"ResultMsg")        '결과메시지
	n_mid           = NICEpay.GetResult((PInst),"MID")                  'MID
	paymethod       = NICEpay.GetResult((PInst),"PayMethod")            '결제수단
	authDate        = NICEpay.GetResult((PInst),"AuthDate")             '승인일시YYMMDDHH24mmss
	authCode        = NICEpay.GetResult((PInst),"AuthCode")             '승인번호
	amt             = NICEpay.GetResult((PInst),"Amt")                  '승인금액
	buyerName       = NICEpay.GetResult((PInst),"BuyerName")            '구매자명
	mallUserID      = NICEpay.GetResult((PInst),"MallUserID")           '회원사고객ID malluserid
	goodsName       = NICEpay.GetResult((PInst),"GoodsName")            '상품명
	cardcode        = NICEpay.GetResult((PInst),"CardCode")             '신용카드사 코드
	cardcodename    = NICEpay.GetResult((PInst),"CardName")             '신용카드사 명
	cardcapturecode = NICEpay.GetResult((PInst),"AcquCardCode")         '매입카드사 코드
	cardcapturename = NICEpay.GetResult((PInst),"AcquCardName")         '매입카드사 명
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
			If strMob		<> "" Then strMob		= objEncrypter.Encrypt(strMob)
			If takeTel		<> "" Then takeTel		= objEncrypter.Encrypt(takeTel)
			If takeMob		<> "" Then takeMob		= objEncrypter.Encrypt(takeMob)
			If takeADDR1	<> "" Then takeADDR1	= objEncrypter.Encrypt(takeADDR1)
			If takeADDR2	<> "" Then takeADDR2	= objEncrypter.Encrypt(takeADDR2)
			If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
		Set objEncrypter = Nothing


		'로그기록생성 S ============================================================================================
		Dim  Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine "Date : " & now()
		Sfile2.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile2.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
		Sfile2.WriteLine "THIS_PAGE_URL  : " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
		Sfile2.WriteLine "paykind		 : " & paykind
		Sfile2.WriteLine "orderNum	 : " & orderNum
		Sfile2.WriteLine "inUidx		 : " & inUidx
		Sfile2.WriteLine "orderMode	 : " & orderMode
		Sfile2.WriteLine "mbid1		 : " & DK_MEMBER_ID1
		Sfile2.WriteLine "mbid2		 : " & DK_MEMBER_ID2
		Sfile2.WriteLine "strEmail	 : " & strEmail
		Sfile2.WriteLine "주문자정보	 : " & strName&"☞"&strTel&"☞"&strMob&"☞"&strZip&"☞"&strADDR1&"☞"&strADDR2
		Sfile2.WriteLine "배송지정보	 : " & takeName&"☞"&takeTel&"☞"&takeMob&"☞"&takeZip&"☞"&takeADDR1&"☞"&takeADDR2
		Sfile2.WriteLine "totalPrice	 : " & totalPrice
		Sfile2.WriteLine "totalDelivery : " & totalDelivery
		Sfile2.WriteLine "DeliveryFeeType ~: " & DeliveryFeeType&"☞"&GoodsPrice&"☞"&totalOptionPrice&"☞"&totalOptionPrice2&"☞"&totalPoint&"☞"&usePoint&"☞"&usePoint2&"☞"&GoodsName
		Sfile2.WriteLine "isDirect	 : " & isDirect
		Sfile2.WriteLine "GoodIDX		 : " & GoodIDX
		Sfile2.WriteLine "v_SellCode	 : " & v_SellCode
		Sfile2.WriteLine "cardNo1		 : " & cardNo1
		Sfile2.WriteLine "quotabase	 : " & quotabase
		Sfile2.WriteLine "regnumber	 : " & regnumber
		Sfile2.WriteLine "=== <결제 결과 필드> ==="
		Sfile2.WriteLine "tid : " & tid
		Sfile2.WriteLine "moid: " & moid
		Sfile2.WriteLine "resultCode : " & resultCode
		Sfile2.WriteLine "resultMsg : " & resultMsg
		Sfile2.WriteLine "n_mid : " & n_mid
		Sfile2.WriteLine "paymethod : " & paymethod
		Sfile2.WriteLine "amt		 : " & amt
		Sfile2.WriteLine "buyerName	 : " & buyerName
		Sfile2.WriteLine "mallUserID : " & mallUserID
		Sfile2.WriteLine "goodsName	 : " & goodsName
		Sfile2.WriteLine "cardcode	 : " & cardcode
		Sfile2.WriteLine "cardcodename : " & cardcodename
		'Sfile2.WriteLine "cardnumber : " & cardnumber
		Sfile2.WriteLine "cardQuota	: " & cardQuota






		'나이스페이먼츠 답신내용 추가(2018-02-20~) : PC_TX_ASP\sample\payResult_utf.asp 참조
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <결제 성공 여부 확인>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		paySuccess = False	' 결제 성공 여부

		IF UCase(paymethod) = "CARD" THEN
			If resultCode = "3001" Then paySuccess  = True                  '신용카드(정상 결과코드:3001)
		ELSEIF UCase(paymethod) ="BANK" Then
			If resultCode = "4000" Then paySuccess  = True                  '계좌이체(정상 결과코드:4000)
		ELSEIF UCase(paymethod) ="VBANK" THEN
			If resultCode = "4100" Then paySuccess  = True                  '휴대폰(정상 결과코드:A000)
		ELSEIF UCase(paymethod) ="CELLPHONE" THEN
			If resultCode = "A000" Then paySuccess  = True                  '가상계좌(정상 결과코드:4100)
		END If




		'정상승인시 가맹점DB입력처리!!!! ==========================================================================s
		If paySuccess Then

				If usePoint = Null Or usePoint = "" Then usePoint = 0


				strDomain	 = strHostA
				strIDX		 = DK_SES_MEMBER_IDX
				strUserID	 = DK_MEMBER_ID

				'/*-- 카드사 정보 -------------*/
				state = "101"							'입금확인
				payway = "card"

				PGorderNum		= tid				'거래번호
				PGCardNum_MACCO	= Left(cardNo,6)	'카드번호 6자리(직판신고용 ,2016-09-19)
				PGCardNum		= cardNo			'카드번호 12자리
				'카드번호* 처리
				C_Number_LEN = 0
				C_Number_LEFT = ""
				C_Number_LEN = Len(PGCardNum)
				If C_Number_LEN >= 12 Then
					C_Number_LEFT = Left(PGCardNum,(C_Number_LEN-12))
				Else
					C_Number_LEFT = ""
				End If
				PGCardNum = C_Number_LEFT & "************"

				PGAcceptNum		= AuthCode						'신용카드 승인번호
				PGinstallment	= cardQuota						'할부기간
				PGCardCode		= NICEPAY_CARDCODE(cardcode)	'신용카드사코드
				PGCardCom		= cardcodename					'신용카드발급사
				PGCOMPANY		= "NICEPAY"						'PG사
				PGACP_TIME		= ""							'승인시간
					AuthTIME	= Right(AuthDate,6)				'AuthDate(NICEPAY 180220111301)
				PGACP_TIME = 	Date()&" "&Left(AuthTIME,2)&":"&Mid(AuthTIME,3,2)&":"&Right(AuthTIME,2)		'승인시간(NICEPAY  2018-02-20 11:13:01)

				Sfile2.WriteLine "PGAcceptNum : " & PGAcceptNum
				Sfile2.WriteLine "PGCardNum : " & PGCardNum
				Sfile2.WriteLine "PGCardCode : " & PGCardCode
				Sfile2.WriteLine "authDate : " & authDate


				'▣신용카드 승인번호 암호화
				If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If PGAcceptNum			<> "" Then PGAcceptNum				= objEncrypter.Encrypt(PGAcceptNum)
					Set objEncrypter = Nothing
				End If

				identity = 0  'default

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

				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "

				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,? "
				SQL = SQL & " ,?"
				SQL = SQL & " ,?"
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

					Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,PGorderNum), _
					Db.makeParam("@PGCardNum",adVarchar,adParamInput,100,PGCardNum), _
					Db.makeParam("@PGAcceptNum",adVarchar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@PGinstallment",adVarchar,adParamInput,20,PGinstallment), _
					Db.makeParam("@PGCardCode",adVarchar,adParamInput,20,PGCardCode), _

					Db.makeParam("@PGCardCom",adVarchar,adParamInput,20,PGCardCom), _
					Db.makeParam("@PGCOMPANY",adVarchar,adParamInput,50,PGCOMPANY), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _
					Db.makeParam("@usePoint2",adDouble,adParamInput,16,usePoint2), _

					Db.makeParam("@identity",adInteger,adParamOutput,0,0) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				identity = arrParams(UBound(arrParams))(4)

				Sfile2.WriteLine "identity : " & identity
				If identity = "" Or isNull(identity) Or identity < 1 Then
					Sfile2.WriteLine "identity미발생오류 : DK_ORDER 데이타 미입력! (카드취소여부확인:/cardCancel/)"
					Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"identity미발생오류 : DK_ORDER 데이타 미입력!")
				End If

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

						'▣소비자 가격
					'	If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
					'		DKRS_GoodsPrice	 = DKRS_GoodsCustomer
					'	End If

						Else
							Sfile2.WriteLine "존재하지 않는 상품구입을 시도했습니다.! (카드취소여부확인)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"존재하지 않는 상품구입을 시도했습니다.!")
						End If
						Call closeRS(DKRS)

						If DKRS_DelTF = "T" Then
							Sfile2.WriteLine "삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(카드취소여부확인)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
						End If
						If DKRS_isAccept <> "T" Then
							Sfile2.WriteLine "승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(카드취소여부확인)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
						End If
						If DKRS_GoodsViewTF <> "T" Then
							Sfile2.WriteLine "더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.(카드취소여부확인)"
							Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.")
						End If

						Select Case DKRS_GoodsStockType
							Case "I"
							Case "N"
								If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
									Sfile2.WriteLine "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.(카드취소여부확인)"
									Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.")
								Else
									SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
									arrParams = Array(_
										Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
										Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
									)
									Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
								End If
							Case "S" :
								Sfile2.WriteLine  "품절상품. 새로고침 후 다시 시도해주세요"
								Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"품절상품. 새로고침 후 다시 시도해주세요")
							Case Else
								Sfile2.WriteLine  "수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.(카드취소여부확인)"
								Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.")

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
						''		DKRS2_FeeType		= DKRS2("FeeType")
						''		DKRS2_intFee		= Int(DKRS2("intFee"))
						''		DKRS2_intLimit		= Int(DKRS2("intLimit"))
						''	Else
						''		DKRS2_FeeType		= ""
						''		DKRS2_intFee		= ""
						''		DKRS2_intLimit		= ""
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




			'=============================================================================================================================
			'===  CS전산입력 =============================================================================================================
				nowTime = Now
				RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
				Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

				If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then 'CS회원이고 cs연동상품이 1개 이상 있는 경우

					SQL = "SELECT * FROM [tbl_Memberinfo] WHERE [mbid] = ? AND [mbid2] = ? "
					arrParams = Array(_
						Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1) , _
						Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
					)
					Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
					If Not DKRS.BOF And Not DKRS.EOF Then
						MBID1		= DKRS("mbid")
						MBID2		= DKRS("mbid2")
						Sell_Mem_TF = DKRS("Sell_Mem_TF")		'1:소비자, 0:판매원



					' CS상품 갯수체크
						If CSGoodCnt > 0 Then

							orderType = v_SellCode      'CS상품 구매종류선택

							GoodsDeliveryFee = totalDelivery	'**배송비**

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
								Db.makeParam("@takeMob",adVarChar,adParamInput,100,takeMob),_

								Db.makeParam("@takeTel",adVarChar,adParamInput,100,takeTel),_
								Db.makeParam("@orderType",adVarChar,adParamInput,20,orderType),_
								Db.makeParam("@payType",adVarChar,adParamInput,20,"card"),_
								Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,""),_
								Db.makeParam("@payBankAccNum",adVarChar,adParamInput,50,""),_

								Db.makeParam("@payBankDate",adVarChar,adParamInput,50,""),_
								Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,""),_
								Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,""),_
								Db.makeParam("@PayState",adChar,adParamInput,3,"101"),_

								Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo),_
								Db.makeParam("@M_NAME",adVarWChar,adParamInput,50,DK_MEMBER_NAME),_
								Db.makeParam("@deliveryFee",adDouble,adParamInput,16,GoodsDeliveryFee),_
								Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
								Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,PGorderNum),_

								Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum),_
								Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
								Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,""),_
								Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode),_
								Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,""),_

								Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,PGACP_TIME),_
								Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
								Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
								Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
								Db.makeParam("@InputMileage",adDouble,adParamInput,16,usePoint), _

								Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _

									Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

									Db.makeParam("@InputMileage2",adDouble,adParamInput,16,usePoint2), _

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
												Sfile2.WriteLine  ThisMsg
												Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,ThisMsg)
											End If

										'■전체상품 가격 변경■
										SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
										arrParams9 = Array(_
											Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
											Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
										)
										Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

										v_Etc1 = "NICEPAY_"&num2cur(DKCS_TOTAL_PRICE)&"원_"&orderNum

										arrParams = Array(_
											Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

											Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
											Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

											Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_Etc1),_
											Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

											Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
											Db.makeParam("@v_C_Number1",adVarChar,adParamInput,100,PGCardNum),_
											Db.makeParam("@v_C_Number2",adVarChar,adParamInput,100,PGAcceptNum),_
											Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,DK_MEMBER_NAME),_
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

										'■배송시 요청사항 CS입력
										If orderMemo <> "" Then
											SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "  'nvarchar(500)
											arrParams_RECE = Array(_
												Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
												Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
											)
											Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
										End If

										Sfile2.WriteLine "CS_ORDERNUMBER : " & OUT_ORDERNUMBER

										If OUT_ORDERNUMBER = "" Then
											Sfile2.WriteLine  "CS_ORDERNUMBER가 발생하지 않았습니다.(카드취소여부확인)"
											Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"CS_ORDERNUMBER가 발생하지 않았습니다.")
										End If

							End If


						End If



					End If
					Call closeRS(DKRS)
				Else
					'Response.Write DAOU_SUCCESS
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



			'Call PG_NICEPAY_CANCEL(merchantKey, PGID, "123456", amt, tid, isDirect, GoodIDX, chgPage,"존재하지 않는 상품구입을 시도했습니다.취소성공?")

			Select Case OUTPUT_VALUE
				Case "FINISH"
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

					Call ALERTS("구매가 성공적으로 이루어졌습니다.\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
				Case Else
					Sfile2.WriteLine  "OUTPUT_VALUE : 자료를 등록하는 도중 에러가 발생하였습니다. (카드취소여부확인)"
					Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"OUTPUT_VALUE : 자료를 등록하는 도중 에러가 발생하였습니다. ")

					Call ALERTS("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
			End Select


		Else
			'Sfile2.WriteLine "resultCode : ["&resultCode&"]"&resultMsg
			Call ALERTS("["&resultCode&"]"&resultMsg,"GO",GO_BACK_ADDR)
		End If
		'정상승인시 가맹점DB입력처리!!!! ==========================================================================e


		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine chr(13)
		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
		'로그기록생성 E ============================================================================================
		'---------------------------------- WEBPRO -----------------------------------------------------------------
		'-----------------------------------------------------------------------------------------------------------







	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <인스턴스 해제>
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	NICEpay.Destroy CLng(PInst)
	Response.End

%>

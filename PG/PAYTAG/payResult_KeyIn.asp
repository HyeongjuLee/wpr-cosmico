<!-- #include virtual = "/_lib/strFunc.asp" -->
<!-- #include virtual = "/_lib/strPGFunc.asp" -->
<!-- #include virtual = "/_lib/json2.asp" -->
<!-- #include file = "PAYTAG_CONFIG.ASP"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


'▣개별 변수 받아오기 (쇼핑몰 기본정보) S
	Dim paykind				: paykind			= pRequestTF("paykind",True)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",True)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",True)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",True)

	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

	Dim strName				: strName			= pRequestTF("strName",True)
	Dim strTel				: strTel			= pRequestTF("strTel",False)
	Dim strMobile			: strMobile			= pRequestTF("strMobile",True)
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

	Dim infoChg				: infoChg			= pRequestTF("infoChg",False)


	Dim ori_price			: ori_price			= pRequestTF("ori_price",True)
	Dim totalPrice			: totalPrice		= pRequestTF("totalPrice",True)
	Dim totalDelivery		: totalDelivery		= pRequestTF("totalDelivery",False)
	Dim DeliveryFeeType		: DeliveryFeeType	= pRequestTF("DeliveryFeeType",False)
	Dim GoodsPrice			: GoodsPrice		= pRequestTF("GoodsPrice",False)

	Dim totalOptionPrice	: totalOptionPrice  = pRequestTF("totalOptionPrice",False)
	Dim totalOptionPrice2	: totalOptionPrice2 = pRequestTF("totalOptionPrice2",False)		'goodsOPTcost
	Dim totalPoint			: totalPoint		= pRequestTF("totalPoint",False)

	Dim usePoint			: usePoint			= pRequestTF("useCmoney",False)
	Dim usePoint2			: usePoint2			= pRequestTF("useCmoney2",False)
	Dim totalVotePoint		: totalVotePoint	= pRequestTF("totalVotePoint",False)

	Dim GoodsName			: GoodsName			= Trim(pRequestTF("GoodsName",True))

	Dim TOTAL_POINTUSE_MAX	: TOTAL_POINTUSE_MAX= pRequestTF("TOTAL_POINTUSE_MAX",False)	'▶ 최대 포인트사용가능 금액

	Dim orderMemo			: orderMemo			= pRequestTF("orderMemo",False)
	Dim BusCode				: BusCode			= pRequestTF("BusCode",False)


	Dim bankidx				: bankidx			= 0		'pRequestTF("bankidx",False)
	Dim bankingName			: bankingName		= ""	'pRequestTF("bankingName",False)

	Dim orderEaD			: orderEaD	= pRequestTF("ea",True)			'◆ #5. EA
	Dim GoodIDXs			: GoodIDXs	= pRequestTF("GoodIDXs",True)	'◆ #5. GoodIDXs
	Dim strOptions			: strOptions= pRequestTF("strOptions",False)	'◆ #5. strOptions
	Dim OIDX				: OIDX		= pRequestTF("OIDX",True)		'◆ #5. 임시주문테이블 idx
'▣개별 변수 받아오기 (쇼핑몰 기본정보) S

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

	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)

'▣ CS 특이사항 S
	CSGoodCnt		= Trim(pRequestTF("CSGoodCnt",True))			'통합정보 CS상품 갯수
	isSpecialSell	= Trim(pRequestTF("isSpecialSell",False))
	If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then
		v_SellCode		= Trim(pRequestTF("v_SellCode",True))		'CS상품 구매종류
		SalesCenter		= Trim(pRequestTF("SalesCenter",False))		'판매센터
		DtoD			= Trim(pRequestTF("DtoD",True))				'판매센터
	Else
		v_SellCode		= ""
		SalesCenter		= ""
		DtoD			= "T"
	End If
'▣ CS 특이사항 E

%>
<%


'▣카드결제 정보 S
	Dim cardNo1				: cardNo1 = pRequestTF("cardNo1",True)
	Dim cardNo2				: cardNo2 = pRequestTF("cardNo2",True)
	Dim cardNo3				: cardNo3 = pRequestTF("cardNo3",True)
	Dim cardNo4				: cardNo4 = pRequestTF("cardNo4",True)
	Dim card_mm				: card_mm = pRequestTF("card_mm",True)
	Dim card_yy				: card_yy = pRequestTF("card_yy",True)

	Dim cardKind			: cardKind = pRequestTF("cardKind",True)	'카드구분

	Dim strBirth1		: strBirth1			= pRequestTF("birthyy",False)	'생년월일
	Dim strBirth2		: strBirth2			= pRequestTF("birthmm",False)
	Dim strBirth3		: strBirth3			= pRequestTF("birthdd",False)
	Dim CorporateNumber	: CorporateNumber	= pRequestTF("CorporateNumber",False)	'사업자등록번호

	Dim CardPass			: CardPass  = pRequestTF("CardPass",True)	'비밀번호
	Dim quotabase			: quotabase = pRequestTF("quotabase",True)	'할부기간


	'일반(생년월일(YYMMDD, 6자리)	/	법인사업자 = 사업자번호 10자리 /
	Select Case cardKind	'카드구분추가
		Case "P"	'개인카드
			birth = ""
			If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then
				birth = strBirth1 & strBirth2 & strBirth3
				CARDAUTH_Input = Right(birth,6)
			Else
				Call ALERTS("생년월일이 입력되지 않았습니다.","GO",GO_BACK_ADDR)
			End If
			card_user_type = "0"

		Case "C"	'법인카드
			If CorporateNumber <> "" Then
				CARDAUTH_Input = CorporateNumber
			Else
				Call ALERTS("사업자등록번호가 입력되지 않았습니다.","GO",GO_BACK_ADDR)
			End If
			card_user_type = "1"

		Case Else
			Call ALERTS("잘못된 카드구분입니다.","GO",GO_BACK_ADDR)
	End Select

	'Call ResRw(cardKind,"cardKind")
'▣카드결제 정보 E



'치환
	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID
	state		= "101"

	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0
	If takeTel = "" Then takeTel = ""
	If takeMobile = "" Then takeMobile = ""


	card_mm		= Right("00"&card_mm,2)
	CardYYMM	= Right(card_yy,2) & card_mm
	cardMMYY	= card_mm & Right(card_yy,2)					'PAYTAG용 추가!! (MMYY)
	CardNo		= cardNo1 & cardNo2 & cardNo3 & cardNo4

	'★★★★★★  유효기간 체크!!!			 ★★★★★★★★★★★★
		THIS_MONTH = CDbl(Left(Replace(date(),"-",""),6))

		If CDbl(THIS_MONTH) > CDbl(card_yy&card_mm) Then
			Call ALERTS("정확한 유효기간 정보를 입력해주세요!(카드유효기간 상이)","GO",GO_BACK_ADDR)
		End If
	'★★★★★★  유효기간 체크!!!			 ★★★★★★★★★★★★
	'Response.End


'▣ 결제금 체크(포인트) S
	If CDbl(totalPrice) < 1000 And CDbl(usePoint) > 0 Then Call ALERTS("카드결제시 결제금액이 최소 1000원 이상이어야 합니다","GO",GO_BACK_ADDR)

''	If CDbl(usePoint) > CDbl(TOTAL_POINTUSE_MAX) Then Call ALERTS("결제가능한 포인트보다 많이 입력하셨습니다.","GO",GO_BACK_ADDR)		'웰니스
'▣ 결제금 체크(포인트) E






'확인
'	Call ResRW(Pgid					,"Pgid				")
'	Call ResRW(Pgpwd				,"Pgpwd				")
'	Call ResRW(Paykind				,"Paykind				")
'	Call ResRW(Ordernum				,"Ordernum			")
'	Call ResRW(Inuidx				,"Inuidx				")
'	Call ResRW(Gopaymethod			,"Gopaymethod			")
'	Call ResRW(Strname				,"Strname				")
'	Call ResRW(Strtel				,"Strtel				")
'	Call ResRW(Strmobile			,"Strmobile			")
'	Call ResRW(Stremail				,"Stremail			")
'	Call ResRW(Strzip				,"Strzip				")
'	Call ResRW(Straddr1				,"Straddr1			")
'	Call ResRW(Straddr2				,"Straddr2			")
'	Call ResRW(Takename				,"Takename			")
'	Call ResRW(Taketel				,"Taketel				")
'	Call ResRW(Takemobile			,"Takemobile			")
'	Call ResRW(Takezip				,"Takezip				")
'	Call ResRW(Takeaddr1			,"Takeaddr1			")
'	Call ResRW(Takeaddr2			,"Takeaddr2			")
'	Call ResRW(Infochg				,"Infochg				")
'	Call ResRW(Totalprice			,"Totalprice			")
'	Call ResRW(Totaldelivery		,"Totaldelivery		")
'	Call ResRW(Deliveryfeetype		,"Deliveryfeetype		")
'	Call ResRW(Goodsprice			,"Goodsprice			")
'	Call ResRW(Totaloptionprice		,"Totaloptionprice	")
'	Call ResRW(Totaloptionprice2	,"Totaloptionprice2	")
'	Call ResRW(Totalpoint			,"Totalpoint			")
'
'	Call ResRW(Usepoint				,"Usepoint			")
'	Call ResRW(Totalvotepoint		,"Totalvotepoint		")
'
'	Call ResRW(Ordermemo			,"Ordermemo			")
'
'	Call ResRW(V_sellcode			,"V_sellcode			")
'	Call ResRW(Buscode				,"Buscode				")
'
'	Call ResRW(Cardno1				,"Cardno1				")
'	Call ResRW(Cardno2				,"Cardno2				")
'	Call ResRW(Cardno3				,"Cardno3				")
'	Call ResRW(Cardno4				,"Cardno4				")
'	Call ResRW(Card_mm				,"Card_mm				")
'	Call ResRW(Card_yy				,"Card_yy				")
'	Call ResRW(Quotabase			,"Quotabase			")
'
'	Call ResRW(Strdomain			,"Strdomain			")
'	Call ResRW(Stridx				,"Stridx			")
'	Call ResRW(Struserid			,"Struserid			")
'	Call ResRW(Cardno				,"Cardno			")
'	Call ResRW(Cardyymm				,"Cardyymm			")
'	Call ResRW(Goodsname			,"Goodsname			")
'Response.end



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


		CardLogss = "cardShopAPI"

		On Error Resume Next
		Dim Fso0 : Set  Fso0=CreateObject("Scripting.FileSystemObject")
		Dim LogPath0 : LogPath0 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile0 : Set  Sfile0 = Fso0.OpenTextFile(LogPath0,8,true)

		Sfile0.WriteLine chr(13)
		Sfile0.WriteLine "Date		: "	& now()
		Sfile0.WriteLine "Domain		: "	& Request.ServerVariables("HTTP_HOST")
		Sfile0.WriteLine "--- Order Info -----------------------------"
		Sfile0.WriteLine "inUidx		 : " & inUidx
		Sfile0.WriteLine "takeName	 : " & takeName
		Sfile0.WriteLine "mbid1		 : " & DK_MEMBER_ID1
		Sfile0.WriteLine "mbid2		 : " & DK_MEMBER_ID2
		Sfile0.WriteLine "ori_price(total) : " & ori_price
		Sfile0.WriteLine "totalPrice	 : " & totalPrice
		Sfile0.WriteLine "totalDelivery	 : " & totalDelivery
		Sfile0.WriteLine "paykind		 : " & paykind
		Sfile0.WriteLine "v_SellCode	 : " & v_SellCode
		Sfile0.WriteLine "usePoint	 : " & usePoint
		Sfile0.WriteLine "DtoD		 : " & DtoD
		Sfile0.Close
		Set Fso0= Nothing
		Set objError= Nothing
		On Error GoTo 0


%>
<%

	'카드결제 (실결제) =================================================================================================
	'★★★★ PAYTAG(코드블럭) API  S ★★★★

	servicecode     =   "PAYTAG"		'   필수 : 고정값
	reqtype			=   "L"				'   필수 : 'L'-API연동 고정값
	restype			=   "J"				'   필수 : 'J'-JSON 결과 리턴
	cmdtype         =   "PAYKEYIN"		'   필수 : 고정값
	paytag_apiurl	=   "https://api.paytag.kr/pay/cardkeyin"       ' 필수 : 고정값 ( rest 주소값 )

	' =========================================
	' 페이태그로 부터 부여받은 값			'	PAYTAG_CONFIG.ASP
	' -------------------------------------------------------------------
	shopcode        =   TX_PAYTAG_shopcode	'   필수 : 페이태그 가맹점 번호
	loginid			=   TX_PAYTAG_loginid	'   필수 : 페이태그 로그인ID
	api_key			=   TX_PAYTAG_api_key	'   필수 : 암호화 키값

	' ========================================
	' 주문정보
	' -------------------------------------------------------------------
	goods_name		=   GoodsName	    '   필수 : 상품명
	tran_amt		=   totalPrice		'   필수 : 결제요청금액
	taxfree_yn		=   "N"				'   N-과세, Y-면세

	order_name		=   strName			'   필수 : 주문자-이름
	order_hp		=   Left(strMobile,11)	'   필수 : 주문자-휴대폰번호		''PAY_CARD UPDATE:개체가 이 속성 또는 메서드를 지원하지 않습니다. 핸드폰 자리수 11자리 넘어가면
	order_email		=   strEmail		'   선택 : 주문자-이메일

	payer_name		=   takeName		'   필수 : 결제자-이름
	payer_hp		=   Left(takeMobile,11)		'   필수 : 결제자-휴대폰번호		''PAY_CARD UPDATE:개체가 이 속성 또는 메서드를 지원하지 않습니다. 핸드폰 자리수 11자리 넘어가면
	payer_email		=	strEmail		'   선택 : 결제자-이름

	' ========================================
	' 결제진행할 카드정보
	' 구인증( 카유비생) 필수값 : card_certno, card_pwd
	' -------------------------------------------------------------------
	cardno			=   cardNo					'   필수 : 카드번호
	expire_date		=   cardMMYY					'   필수 : 유효기간 (MMYY)
	tran_inst		=   quotabase					'   필수 : 할부기간 00-일시불, 5만원이상, 12개월 이내
	card_type		=   "0"				'   필수 : 0-개인카드, 1-사업자카드
	card_certno		=   CARDAUTH_Input					'   (구인증/카유비생)필수 : 카드인증번호 / 개인카드=주민번호6자리 YYMMDD, 사업자카드:사업자번호10자리
	card_pwd        =   CardPass			'   (구인증/카유비생)필수필수 : 비밀번호 앞2자리

	' =======================================
	' 가맹점 자체값
	' -------------------------------------------------------------------
	shop_orderno	=   ""              '   선택 : 가맹점 자체 주문번호
	shop_member		=   ""              '   선택 : 가맹점 자체 회원번호
	shop_field1		=   ""              '   선택 : 예비필드1
	shop_field2		=   ""              '   선택 : 예비필드2
	shop_field3		=   ""              '   선택 : 예비필드3



	' =======================================
	' 보안인증값생성
	' 가맹점마다의 key값으로 암호화 한다.
	' -------------------------------------------------------------------
	cert_str =	servicecode & "|" & _
					cmdtype & "|" & _
					shopcode & "|" & _
					cardno & "|" & _
					expire_date & "|" & _
					tran_amt


	' ######################################################################
	' AES256 암/복호화 DLL
	' ######################################################################
	set aesCom = server.createobject("PayTagCom.EncryptDecrypt")
	certval = aesCom.Aes256Encrypt(cert_str, api_key)

	if Err.Number <> 0 then
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	end if


	' ========================================
	' header 파라메터 정의
	' -------------------------------------------------------------------
	REQ_HEADER_STR  = "servicecode=" & servicecode & _
					"&reqtype=" & reqtype & _
					"&restype=" & restype & _
					"&shopcode=" & shopcode & _
					"&apiver=1" & _
					"&cmdtype=" & cmdtype & _
					"&certval=" & server.urlencode(certval)


	' ========================================
	' body 파라메터 정의
	' -------------------------------------------------------------------
	REQ_BODY_STR =  "tran_amt=" & tran_amt & _
					"&taxfree_yn=" & server.urlencode(taxfree_yn) & _
					"&goods_name=" & server.urlencode(goods_name) & _
					"&order_name=" & server.urlencode(order_name) & _
					"&order_hp=" & order_hp & _
					"&order_email=" & server.urlencode(order_email) & _
					"&payer_name=" & server.urlencode(payer_name) & _
					"&payer_hp=" & payer_hp & _
					"&payer_email=" & server.urlencode(payer_email) & _
					"&loginid=" & server.urlencode(loginid) & _
					"&tran_inst=" & tran_inst & _
					"&card_type=" & card_type & _
					"&card_certno=" & server.urlencode(card_certno) & _
					"&card_pwd=" & server.urlencode(card_pwd) & _
					"&shop_orderno=" & server.urlencode(shop_orderno) & _
					"&shop_member=" & server.urlencode(shop_member) & _
					"&shop_field1=" & server.urlencode(shop_field1) & _
					"&shop_field2=" & server.urlencode(shop_field2) & _
					"&shop_field3=" & server.urlencode(shop_field3)

	'response.write "body:" & REQ_BODY_STR & "<br>"
%>
<!--#include file="aspJSON1.17.asp" -->
<%
	Set xmlClient = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")
	xmlClient.setTimeouts 5000, 5000, 30000, 30000

	xmlClient.open "POST", paytag_apiurl, FALSE

	xmlClient.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlClient.setRequestHeader "CharSet", "UTF-8"
	xmlClient.setRequestHeader "Accept-Language","ko"
	xmlClient.send REQ_HEADER_STR&"&"&REQ_BODY_STR


	' 서버 다운이나.. 없는 도메인일 경우
	If Err.Number = 0 Then

		server_status = xmlClient.Status

		If server_status >= 400 And server_status <= 599 Then

			Err.Raise 1020, "error", "결제서버오류["&server_status&"]"
			call onErrorCheckDefault()
		else

			Set responseStrm = CreateObject("ADODB.Stream")
			responseStrm.Open
			responseStrm.Position = 0
			responseStrm.Type = 1
			responseStrm.Write xmlClient.responseBody
			responseStrm.Position = 0
			responseStrm.Type = 2
			responseStrm.Charset = "UTF-8"
			resultStr = responseStrm.ReadText

			responseStrm.Close
			Set responseStrm = Nothing

			'response.write resultstr


			Set oJSON = New aspJSON
			oJSON.loadJSON(resultstr)

			recv_resultcode      =  oJSON.data("resultcode")		'결과코드 0000' or '00' 정상
			recv_errmsg          =  oJSON.data("errmsg")			'에러내용(실패시 오류내용)
			recv_tran_amt        =  oJSON.data("tran_amt")			'결제요청금액
			recv_goods_name      =  oJSON.data("goods_name")		'상품명
			recv_order_name      =  oJSON.data("order_name")		'주문자-이름
			recv_order_hp        =  oJSON.data("order_hp")			'주문자-휴대폰번호
			recv_order_email     =  oJSON.data("order_email")		'주문자-이메일
			recv_payer_name      =  oJSON.data("payer_name")		'결제자-이름
			recv_payer_hp        =  oJSON.data("payer_hp")			'결제자-휴대폰번호
			recv_payer_email     =  oJSON.data("payer_email")		'결제자-이메일
			recv_loginid         =  oJSON.data("loginid")			'
			recv_tran_inst       =  oJSON.data("tran_inst")			'할부기간
			recv_taxfree_yn      =  oJSON.data("taxfree_yn")
			recv_shop_orderno    =  oJSON.data("shop_orderno")
			recv_shop_member     =  oJSON.data("shop_member")
			recv_shop_field1     =  oJSON.data("shop_field1")
			recv_shop_field2     =  oJSON.data("shop_field2")
			recv_shop_field3     =  oJSON.data("shop_field3")

			recv_orderno         =  oJSON.data("orderno")           '페이태그 주문번호		'페이태그 거래보호로 디비에 저장하셔야 합니다. ( 결제취소 연동 )
			recv_tranno          =  oJSON.data("tranno")			'PG거래번호				'KSNET's [rTransactionNo]
			recv_apprno          =  oJSON.data("apprno")            '승인번호 ( 정상결제시만 제공됨 )
			recv_trandate        =  oJSON.data("trandate")			'거래일
			recv_trantime        =  oJSON.data("trantime")			'거래시간
			recv_cardno          =  oJSON.data("cardno")
			recv_cardname        =  oJSON.data("cardname")
			recv_transeq         =  oJSON.data("transeq")
			recv_receipt_url     =  oJSON.data("receipt_url")       '전표주소 full url ( 정상결제시만 제공됨 )

			recv_cardcode        =  oJSON.data("cardcode")			'◆웹프로요청 : 매입사코드표 추가 (자체 매입사코드표입니다.각 PG사마다 발급사는 제각기 이기 때문에 매입사만 통일하여 관리하고 있습니다.)
		End If


	Else
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	End If

	Set xmlClient = Nothing

	'★★★★ PAYTAG(코드블럭) API  E ★★★★
%>


<%


	'▣ 로그 기록 S
		On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine "--- Card PAY -------------------------------"
			Sfile2.WriteLine "OrderNum	: "	& OrderNum
			Sfile2.WriteLine "shopcode	: " & shopcode
			Sfile2.WriteLine "loginid		: "	& loginid
			'Sfile2.WriteLine "api_key		: "	& Left(api_key,4)&"****"

			Sfile2.WriteLine "server_status  : "	& server_status
			'Sfile2.WriteLine "cert_str  : "	& cert_str
			'Sfile2.WriteLine "certval  : "	& certval

			Sfile2.WriteLine "recv_resultcode  : "	& recv_resultcode
			Sfile2.WriteLine "recv_errmsg      : "	& recv_errmsg
			Sfile2.WriteLine "recv_tran_amt    : "	& recv_tran_amt
			Sfile2.WriteLine "recv_goods_name  : "	& recv_goods_name
			Sfile2.WriteLine "recv_order_name  : "	& recv_order_name
			'Sfile2.WriteLine "recv_order_hp    : "	& recv_order_hp
			'Sfile2.WriteLine "recv_order_email : "	& recv_order_email
			Sfile2.WriteLine "recv_payer_name  : "	& recv_payer_name
			'Sfile2.WriteLine "recv_payer_hp    : "	& recv_payer_hp
			'Sfile2.WriteLine "recv_payer_email : "	& recv_payer_email
			Sfile2.WriteLine "recv_loginid     : "	& recv_loginid
			Sfile2.WriteLine "recv_tran_inst   : "	& recv_tran_inst
			Sfile2.WriteLine "recv_taxfree_yn  : "	& recv_taxfree_yn
			'Sfile2.WriteLine "recv_shop_orderno: "	& recv_shop_orderno
			'Sfile2.WriteLine "recv_shop_member : "	& recv_shop_member
			'Sfile2.WriteLine "recv_shop_field1 : "	& recv_shop_field1
			'Sfile2.WriteLine "recv_shop_field2 : "	& recv_shop_field2
			'Sfile2.WriteLine "recv_shop_field3 : "	& recv_shop_field3
			Sfile2.WriteLine "recv_orderno     : "	& recv_orderno
			Sfile2.WriteLine "recv_tranno      : "	& recv_tranno
			Sfile2.WriteLine "recv_apprno      : "	& recv_apprno
			Sfile2.WriteLine "recv_trandate    : "	& recv_trandate
			Sfile2.WriteLine "recv_trantime    : "	& recv_trantime
			'Sfile2.WriteLine "recv_cardno      : "	& recv_cardno
			Sfile2.WriteLine "recv_cardname    : "	& recv_cardname
			Sfile2.WriteLine "recv_transeq     : "	& recv_transeq
			Sfile2.WriteLine "recv_receipt_url : "	& recv_receipt_url
			Sfile2.WriteLine "recv_cardcode (매입사코드): "	& recv_cardcode
			Sfile2.WriteLine "---------------------------------------------"


			Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
		On Error Goto 0
	'▣ 로그 기록 E
'Response.end


	'결제정보 DB입력

	'PAYTAG(코드블럭)
		'공백 붙어서 옴! 없애주자 ㅡㅜ
		recv_apprno		= Trim(recv_apprno)
		recv_errmsg		= Trim(recv_errmsg)
		recv_tranno		= Trim(recv_tranno)
		recv_tran_inst	= Trim(recv_tran_inst)
		recv_cardcode	= Trim(recv_cardcode)
		recv_trandate	= Trim(recv_trandate)

		PGorderNum		= recv_tranno			'거래번호
		PGCardNum_MACCO	= Left(CardNo,6)		'카드번호 6자리(직판신고용)
		PGCardNum		= CardNo	'rCardNo	'카드번호

		'카드번호* 처리
		C_Number_LEN = 0
		C_Number_LEFT = ""
		C_Number_LEN = Len(PGCardNum)

		cStars = ""
		If C_Number_LEN >= 14 Then
			For s = 1 To 8				'1234********1234
				cStars = cStars&"*"
			Next
			PGCardNum = Left(PGCardNum,4) & cStars & Right(PGCardNum,C_Number_LEN - (4+8))
		Else
			For s = 1 To 8
				cStars = cStars&"*"		'1234********8
			Next
			PGCardNum =	Left(PGCardNum,4) & cStars & Right(PGCardNum,1)
		End If

		PGAcceptNum		= recv_apprno						'신용카드 승인번호
		PGinstallment	= recv_tran_inst					'할부기간
		PGCardCode		= PAYTAG_CARDCODE(recv_cardcode)	'매입사코드(PAYTAG 치환)
		PGCardCom		= rIssCode							'신용카드발급사
		PGAcceptDate	= recv_trandate						'원승인일자
		PGCOMPANY		= "PAYTAG"							'PG사
		PGID			= TX_PAYTAG_shopcode				'PGID
		If PGinstallment = "" Or IsNull(PGinstallment) Then PGinstallment = "00"



%>
<%

		If recv_resultcode = "0000" Or recv_resultcode = "00"Then		'PAYTAG(코드블럭)

				Call Db.beginTrans(Nothing)


				'▣주문정보 암호화
					If DKCONF_SITE_ENC = "T" Then
						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							If DKRS_BANK_BankNumber	<> "" Then DKRS_BANK_BankNumber	= objEncrypter.Encrypt(DKRS_BANK_BankNumber)	'cacu. C_Number1

							If DKCONF_ISCSNEW = "T" Then
								If strADDR1			<> "" Then strADDR1				= objEncrypter.Encrypt(strADDR1)
								If strADDR2			<> "" Then strADDR2				= objEncrypter.Encrypt(strADDR2)
								If strTel			<> "" Then strTel				= objEncrypter.Encrypt(strTel)
								If strMobile		<> "" Then strMobile			= objEncrypter.Encrypt(strMobile)
								If takeTel			<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
								If takeMobile		<> "" Then takeMobile			= objEncrypter.Encrypt(takeMobile)
								If takeADDR1		<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
								If takeADDR2		<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
								If strEmail			<> "" Then strEmail				= objEncrypter.Encrypt(strEmail)
								If PGCardNum		<> "" Then PGCardNum			= objEncrypter.Encrypt(PGCardNum)			'카드번호 암호화
							End If
						Set objEncrypter = Nothing
					End If

				'입력 시작
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
					SQL = SQL & " ,?,?"
					SQL = SQL & " ,?"
					SQL = SQL & " ,?"
					SQL = SQL & " ); "
					SQL = SQL & "SELECT ? = @@IDENTITY"
					arrParams = Array( _
						Db.makeParam("@strDomain",adVarchar,adParamInput,50,strDomain), _
						Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum), _
						Db.makeParam("@strIDX",adVarchar,adParamInput,50,strIDX), _
						Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
						Db.makeParam("@payWay",adVarchar,adParamInput,20,paykind), _

						Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
						Db.makeParam("@totalDelivery",adInteger,adParamInput,0,totalDelivery), _
						Db.makeParam("@totalOptionPrice",adInteger,adParamInput,0,totalOptionPrice), _
						Db.makeParam("@totalPoint",adInteger,adParamInput,0,totalPoint), _
						Db.makeParam("@strName",adVarWChar,adParamInput,50,strName), _

						Db.makeParam("@strTel",adVarchar,adParamInput,150,strTel), _
						Db.makeParam("@strMob",adVarchar,adParamInput,150,strMobile), _
						Db.makeParam("@strEmail",adVarWChar,adParamInput,512,strEmail), _
						Db.makeParam("@strZip",adVarchar,adParamInput,50,strZip), _
						Db.makeParam("@strADDR1",adVarchar,adParamInput,512,strADDR1), _

						Db.makeParam("@strADDR2",adVarchar,adParamInput,512,strADDR2), _
						Db.makeParam("@takeName",adVarWChar,adParamInput,50,takeName), _
						Db.makeParam("@takeTel",adVarchar,adParamInput,150,takeTel), _
						Db.makeParam("@takeMob",adVarchar,adParamInput,150,takeMobile), _
						Db.makeParam("@takeZip",adVarchar,adParamInput,10,takeZip), _

						Db.makeParam("@takeADDR1",adVarchar,adParamInput,512,takeADDR1), _
						Db.makeParam("@takeADDR2",adVarchar,adParamInput,512,takeADDR2), _
						Db.makeParam("@state",adChar,adParamInput,3,state), _
						Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo), _
						Db.makeParam("@strSSH1",adVarchar,adParamInput,6,""), _

						Db.makeParam("@strSSH2",adVarchar,adParamInput,7,""), _
						Db.makeParam("@bankIDX",adInteger,adParamInput,4,""), _
						Db.makeParam("@bankingName",adVarWChar,adParamInput,50,""), _
						Db.makeParam("@usePoint",adInteger,adParamInput,4,usePoint), _
						Db.makeParam("@totalVotePoint",adInteger,adParamInput,4,totalVotePoint), _

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

				'카드인 경우 101 로 스탯 변경
					If state = "101" Then
						SQL = "UPDATE [DK_ORDER] SET [status] = '101', [status101Date] = getDate() WHERE [intIDX] = ?"
						arrParams = Array(_
							Db.makeParam("@intIDX",adInteger,adParamInput,0,identity) _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					End If


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


							SQL = SQL & " FROM [DK_GOODS] WITH(NOLOCK) WHERE [intIDX] = ?"
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

								'▣소비자 가격, 쇼핑몰가/CS가 비교
								If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
									If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
										DKRS_GoodsPrice	 = DKRS_GoodsCustomer
									End If
								End If

							Else
								ThisCancel = "T"
								ThisMsg		= "존재하지 않는 상품구입을 시도했습니다."
								Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)		'recv_orderno로 취소!!

							End If
							Call closeRS(DKRS)

							If DKRS_DelTF = "T" Then
								ThisCancel = "T"
								ThisMsg		= "삭제된 상품의 구매를 시도했습니다."
								Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
							End If
							If DKRS_isAccept <> "T" Then
								ThisCancel = "T"
								ThisMsg		= "승인되지 않은 상품의 구매를 시도했습니다."
								Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
							End If
							If DKRS_GoodsViewTF <> "T" Then
								ThisCancel = "T"
								ThisMsg		= "더이상 판매되지 않는 상품의 구매를 시도했습니다."
								Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
							End If

							Select Case DKRS_GoodsStockType
								Case "I"
								Case "N"
									If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
										ThisCancel = "T"
										ThisMsg = "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요."
										Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
									Else
										SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
										arrParams = Array(_
											Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
											Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
										)
										Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
									End If
								Case "S"
									ThisCancel = "T"
									ThisMsg = "품절상품. 새로고침 후 다시 시도해주세요"
									Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
								Case Else
									ThisCancel = "T"
									ThisMsg		= "수량정보가 올바르지 않습니다."
									Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
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
							SQL = SQL & ",?, ?"															'▣CS상품코드추가
							SQL = SQL & " ) "
							arrParams = Array(_
								Db.makeParam("@orderIDX",adInteger,adParamInput,4,identity), _
								Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRS_GoodIDX), _
								Db.makeParam("@strOption",adVarWChar,adParamInput,512,DKRS_strOption), _
								Db.makeParam("@OrderEa",adInteger,adParamInput,4,DKRS_orderEa),_
								Db.makeParam("@GoodsPrice",adInteger,adParamInput,4,DKRS_GoodsPrice),_

								Db.makeParam("@GoodsOptionPrice",adInteger,adParamInput,4,GoodsOptionPrice),_
								Db.makeParam("@GoodsPoint",adInteger,adParamInput,4,DKRS_GoodsPoint),_
								Db.makeParam("@GoodsCost",adInteger,adParamInput,4,DKRS_GoodsCost),_
								Db.makeParam("@isShopType",adChar,adParamInput,1,DKRS_isShopType),_
								Db.makeParam("@strShopID",adVarChar,adParamInput,50,DKRS_strShopID),_

								Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,DKRS_GoodsName),_
								Db.makeParam("@imgThum",adVarWChar,adParamInput,512,DKRS_imgThum),_
								Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,DKRS_GoodsDeliveryType),_
								Db.makeParam("@GoodsDeliveryFeeType",adVarWChar,adParamInput,20,GoodsDeliveryFeeType),_
								Db.makeParam("@GoodsDeliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_

								Db.makeParam("@GoodsDeliveryLimit",adInteger,adParamInput,4,GoodsDeliveryLimit),_
								Db.makeParam("@status",adChar,adParamInput,3,state),_
								Db.makeParam("@isImgType",adChar,adParamInput,1,DKRS_isImgType),_
								Db.makeParam("@GoodsOPTcost",adInteger,adParamInput,4,GoodsOptionPrice2),_

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
				'=== CS 전산입력 =============================================================================================================
					If DK_MEMBER_TYPE = "COMPANY" Then

						SQL = "SELECT * FROM [tbl_Memberinfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ? "
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
									Db.makeParam("@totalPrice",adInteger,adParamInput,4,totalPrice),_

									Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName),_
									Db.makeParam("@takeZip",adVarChar,adParamInput,10,Replace(takeZip,"-","")),_
									Db.makeParam("@takeADDR1",adVarWChar,adParamInput,700,takeADDR1),_
									Db.makeParam("@takeADDR2",adVarWChar,adParamInput,700,takeADDR2),_
									Db.makeParam("@takeMob",adVarChar,adParamInput,100,takeMobile),_

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
									Db.makeParam("@deliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_
									Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
									Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,PGorderNum),_

									Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum),_
									Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
									Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,""),_
									Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode),_
									Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCom),_

									Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,Recordtime),_
									Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
									Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
									Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
									Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _

										Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _
										Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

									Db.makeParam("@InputMileage2",adDouble,adParamInput,16,usePoint2), _

									Db.makeParam("@CS_IDENTITY",adInteger,adParamOutPut,4,0) _
								)
								Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
								CS_IDENTITY = arrParams2(Ubound(arrParams2))(4)
								'print CS_IDENTITY

								'주문정보에서 CS상품을 검색한다
								SQL3 = "SELECT [GoodIDX],[OrderEa] FROM [DK_ORDER_GOODS] WITH(NOLOCK) WHERE [orderIDX] = ?"
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
										SQL4 = SQL4 & " FROM [DK_GOODS] WITH(NOLOCK) WHERE [intIDX] = ?"
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
												Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode) _
											)
											Set DKRS6 = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
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
												ThisCancel = "T"
												ThisMsg	   = "결제금액이 변조되었습니다.01"
												Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
											End If

											'■전체상품 가격 변경■
											SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
											arrParams9 = Array(_
												Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
												Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
											)
											Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

											If PGinstallment = "00" Then PGinstallmentN = "일시불" Else PGinstallmentN = PGinstallment

											v_Etc1 = PGCOMPANY&"/"&PGAcceptNum&"_"&num2cur(DKCS_TOTAL_PRICE)&"원#웹카드,"&orderNum

											card_yy = ""
											card_mm = ""

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

												Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,card_yy),_
												Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,card_mm),_
												Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallmentN),_

												Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
												Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
											)
											Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
											OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
											OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

											'주문정보에서 CS주문번호를 삽입한다.
											SQL10 = "UPDATE [DK_ORDER] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
											arrParams10 = Array(_
												Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
												Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
											)
											Call Db.exec(SQL10,DB_TEXT,arrParams10,Nothing)

											'■CS배송테이블 배송요청사항 입력■
											If orderMemo <> "" Then
												'SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Get_etc1] = ? WHERE [OrderNumber] = ? "
												SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "
												arrParams_RECE = Array(_
													Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
													Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
												)
												Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
											End If

											If OUT_ORDERNUMBER = "" Then
												ThisCancel = "T"
												ThisMsg	   = "CS_ORDERNUMBER가 발생하지 않았습니다.(카드취소여부확인)"
												Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
											End If

											On Error Resume Next
											Dim Fso5 : Set  Fso5=CreateObject("Scripting.FileSystemObject")
											Dim LogPath5 : LogPath5 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
											Dim Sfile5 : Set  Sfile5 = Fso5.OpenTextFile(LogPath5,8,true)
												Sfile5.WriteLine "orderNum_Fso5	: " & orderNum
												Sfile5.WriteLine "CS_ORDERNUMBER	: " & OUT_ORDERNUMBER
												If ThisCancel = "T" Then
													Sfile5.WriteLine "CanCel_Msg	: " & ThisMsg
												End If
												Sfile5.WriteLine "==========================================="
												Sfile5.Close
											Set Fso5= Nothing
											Set objError= Nothing
											On Error Goto 0


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

				If UCase(DK_MEMBER_NATIONCODE) = "KR" Then

						'##################################################################################################
						'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################
						On Error Resume Next
						If MLM_TF = "T" Then

							HJCS_ORDER_SELLTF = 0
							SQL_TF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WITH(NOLOCK) WHERE [OrderNumber] = ?"
							arrParams_TF = Array(_
								Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
							)
							HJCS_ORDER_SELLTF = Db.execRsData(SQL_TF,DB_TEXT,arrParams_TF,DB3)

							If HJCS_ORDER_SELLTF = 1 Then

								arrParams_MLM1 = Array(_
									Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
									Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
								)
								Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams_MLM1,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									DKRS_cpno		= DKRS("cpno")
									DKRS_Address1	= DKRS("Address1")
									DKRS_Address2	= DKRS("Address2")
									DKRS_hometel	= DKRS("hometel")
									DKRS_hptel		= DKRS("hptel")
									'생년월일
									DKRS_BirthDay	= DKRS("BirthDay")
									DKRS_BirthDay_M	= DKRS("BirthDay_M")
									DKRS_BirthDay_D	= DKRS("BirthDay_D")

									Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
										objEncrypter.Key = con_EncryptKey
										objEncrypter.InitialVector = con_EncryptKeyIV
										On Error Resume Next
											If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)
											If DKRS_Address1	<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
											If DKRS_Address2	<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
											If DKRS_hometel		<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
											If DKRS_hptel		<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
										On Error GoTo 0
									Set objEncrypter = Nothing

								End If

								CS_Birth = DKRS_BirthDay & DKRS_BirthDay_M & DKRS_BirthDay_D		'생년월일

								If DKRS_cpno <> "" And Len(DKRS_cpno) = 13 Then
									DKRS_cpno = DKRS_cpno
								Else
									If Len(CS_Birth) <> 8 Then
										CS_Birth = ""
									End If
									DKRS_cpno = Right(CS_Birth,6)
								End If

								arrParams_MLM2 = Array(_
									Db.makeParam("@CmpCode",adVarChar,adParamInput,10,MLM_CmpCode),_
									Db.makeParam("@OrderNo",adVarChar,adParamInput,40,OUT_ORDERNUMBER),_
									Db.makeParam("@_Cpno",adVarWChar,adParamInput,40,DKRS_cpno),_
									Db.makeParam("@_Hptel",adVarWChar,adParamInput,40,DKRS_hptel),_
									Db.makeParam("@_HomeTel",adVarWChar,adParamInput,40,DKRS_hometel),_
									Db.makeParam("@_Address1",adVarWChar,adParamInput,700,DKRS_Address1),_
									Db.makeParam("@_Address2",adVarWChar,adParamInput,700,DKRS_Address2),_
									Db.makeParam("@mlmunionSeq",adInteger,adParamOutput,4,1) _
								)
								Call Db.exec("p_mlmunion_Order_3",DB_PROC,arrParams_MLM2,DB3)

							'특판 로그기록생성
								Dim Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
								Dim LogPath : LogPath = Server.MapPath("/MLM/logss/Result_") & Replace(Date(),"-","") & ".log"
								Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

									Sfile.WriteLine chr(13)
									Sfile.WriteLine "Date : " & now()
									Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
									Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
									Sfile.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
									Sfile.WriteLine "IP_ADRESS		: " & getUserIP()
									Sfile.WriteLine "Web_OrderNum		: " & OrderNum
									Sfile.WriteLine "CS_OrderNumber	: " & OUT_ORDERNUMBER
									Sfile.WriteLine "payway		: " & UCase(payway)
									Sfile.WriteLine "MLM_CmpCode	: " & MLM_CmpCode
									Sfile.WriteLine "DK_MEMBER_STYPE : " & DK_MEMBER_STYPE
									Sfile.WriteLine "DK_MEMBER_ID	: " & DK_MEMBER_ID1&"-"&DK_MEMBER_ID2

									SQL_MLM = "SELECT [InsuranceNumber],[InsuranceNumber_Date],[Union_Seq] FROM [tbl_salesdetail] WITH(NOLOCK) WHERE [OrderNumber] = ?"
									arrParams_MLM = Array(_
										Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
									)
									Set HJMLM = Db.execRs(SQL_MLM,DB_TEXT,arrParams_MLM,DB3)
									If Not HJMLM.BOF And Not HJMLM.EOF Then
										HJMLM_InsuranceNumber		= HJMLM("InsuranceNumber")
										HJMLM_InsuranceNumber_Date	= HJMLM("InsuranceNumber_Date")
										HJMLM_Union_Seq				= HJMLM("Union_Seq")
									End If
									Call closeRs(HJMLM)

									Sfile.WriteLine "InsuranceNumber	: " & HJMLM_InsuranceNumber
									Sfile.WriteLine "InsuranceNumber_Date: " & HJMLM_InsuranceNumber_Date
									Sfile.WriteLine "Union_Seq			: " & HJMLM_Union_Seq

								Sfile.Close
								Set Fso= Nothing


							End If

						End If
						On Error Goto 0
						'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################
						'##################################################################################################
					End If





				Call Db.finishTrans(Nothing)


				If Err.Number <> 0 Then
					ThisMsg	   = "자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오"
					Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)
					''Call ALERTS("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","GO",GO_BACK_ADDR)
				Else

					''ThisMsg = "구매성공 테스트 결제 삭제 처리"
					''Call PG_PAYTAG_CANCEL(PGID, recv_orderno,loginid, api_key, recv_trandate, recv_tran_amt, GoodIDX, isDirect, chgPage, ThisMsg)

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
				End If
		Else
			Call ALERTS("PG사 통신중 오류가 발생하였습니다. 지속적인 오류 발생 시 관리자에게 문의하여 주십시오.\n\n오류 내용 : "&recv_errmsg&" "&rMessage2,"GO",GO_BACK_ADDR)

		End If






	Response.End

%>

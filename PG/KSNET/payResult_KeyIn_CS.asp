<!-- #include virtual = "/_lib/strFunc.asp" -->
<!-- #include virtual = "/_lib/strPGFunc.asp" -->
<!-- #include virtual = "/_lib/json2.asp" -->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)
'	If webproIP<>"T" Then
'		Call ALERTS("PG결제 테스트중입니다.","GO","/index.asp")
'		Response.End
'	End If

'▣개별 변수 받아오기 (마이오피스 구매 기본정보) S
	Dim payKind				: payKind			= pRequestTF("paykind",True)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",True)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",True)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",True)
	payKind = gopaymethod															'모바일 마이오피스 구매 결재방식 변수 치환

	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

	Dim takeName			: takeName			= pRequestTF("takeName",True)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMob				: takeMob			= pRequestTF("takeMobile",True)				'takeMob X
	Dim takeZip				: takeZip			= pRequestTF("takeZip",True)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",True)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",False)

	Dim ori_price			: ori_price			= pRequestTF("ori_price",True)
	Dim totalPrice			: totalPrice		= pRequestTF("totalPrice",True)				'TOTAL_GOODS_PRICE + TOTAL_DELIVERYFEE
	Dim totalDelivery		: totalDelivery		= pRequestTF("totalDelivery",False)
	Dim DeliveryFeeType		: DeliveryFeeType	= pRequestTF("DeliveryFeeType",False)
	Dim GoodsPrice			: GoodsPrice		= pRequestTF("GoodsPrice",False)

	Dim usePoint			: usePoint			= pRequestTF("useCmoney",False)
	Dim usePoint2			: usePoint2			= pRequestTF("useCmoney2",False)

	Dim GoodsName			: GoodsName			= pRequestTF("GoodsName",False)

	Dim TOTAL_POINTUSE_MAX	: TOTAL_POINTUSE_MAX= pRequestTF("TOTAL_POINTUSE_MAX",False)	'▶ 최대 포인트사용가능 금액

	Dim orderMemo			: orderMemo			= pRequestTF("orderMemo",False)
	Dim BusCode				: BusCode			= pRequestTF("BusCode",False)

	Dim bankidx				: bankidx			= 0
	Dim bankingName			: bankingName		= ""
	Dim memo1				: memo1				= ""

	Dim OIDX				: OIDX				= pRequestTF("OIDX",True)					'◆ #5. 임시주문테이블 idx

	Dim v_SellCode			: v_SellCode		= pRequestTF("v_SellCode",True)
	Dim SalesCenter			: SalesCenter		= pRequestTF("SalesCenter",False)			'판매센터
	Dim DtoD				: DtoD				= pRequestTF("DtoD",False)

'▣개별 변수 받아오기 (쇼핑몰 기본정보) S

	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

'▣isDirect or Cart 체크 S
	isDirect	= "M"		'myoffice 결제(취소용)
	GoodIDX		= 0

	If LCase(orderMode) = "mobile" Then
		chgPage = "/m"
	Else
		chgPage = "/myoffice"
	End If

'▣isDirect or Cart 체크 E

'♠ GO_BACK_ADDR 주문페이지로 보내기 S♠
	gidx = inUidx

	On Error Resume Next
	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		gidx = Trim(StrCipher.Encrypt(gidx,EncTypeKey1,EncTypeKey2))
	Set StrCipher = Nothing
	On Error GoTo 0

	GO_BACK_ADDR = chgPage&"/buy/cart_directB.asp?gidx="&gidx
'♠ GO_BACK_ADDR 주문페이지로 보내기 E♠


	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)


'▣카드결제 정보 S
	Dim cardNo1			: cardNo1 = pRequestTF("cardNo1",True)
	Dim cardNo2			: cardNo2 = pRequestTF("cardNo2",True)
	Dim cardNo3			: cardNo3 = pRequestTF("cardNo3",True)
	Dim cardNo4			: cardNo4 = pRequestTF("cardNo4",True)
	Dim card_mm			: card_mm = pRequestTF("card_mm",True)
	Dim card_yy			: card_yy = pRequestTF("card_yy",True)

	Dim cardKind		: cardKind = pRequestTF("cardKind",True)	'카드구분

	Dim strBirth1		: strBirth1			= pRequestTF("birthyy",False)	'생년월일
	Dim strBirth2		: strBirth2			= pRequestTF("birthmm",False)
	Dim strBirth3		: strBirth3			= pRequestTF("birthdd",False)
	Dim CorporateNumber	: CorporateNumber	= pRequestTF("CorporateNumber",False)	'사업자등록번호

	Dim CardPass			: CardPass  = pRequestTF("CardPass",True)	'비밀번호
	Dim quotabase			: quotabase = pRequestTF("quotabase",True)	'할부기간


	'일반(생년월일(YYMMDD, 6자리)	/	법인사업자 = 사업자번호 10자리 /
	Select Case cardKind	'카드구분추가
		Case "P","I"	'일반신용, 개인사업자
			birth = ""
			If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then
				birth = strBirth1 & strBirth2 & strBirth3
				CARDAUTH_Input = Right(birth,6)
			Else
				Call ALERTS("생년월일이 입력되지 않았습니다.","BACK","")
			End If
			card_user_type = "0"

		Case "C"	'법인카드
			If CorporateNumber <> "" Then
				CARDAUTH_Input = CorporateNumber
			Else
				Call ALERTS("사업자등록번호가 입력되지 않았습니다.","BACK","")
			End If
			card_user_type = "1"

		Case Else
			Call ALERTS("잘못된 카드구분입니다.","BACK","")
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
	CardNo		= cardNo1 & cardNo2 & cardNo3 & cardNo4

	'★★★★★★  유효기간 체크!!!			 ★★★★★★★★★★★★
		THIS_MONTH = CDbl(Left(Replace(date(),"-",""),6))

		If CDbl(THIS_MONTH) > CDbl(card_yy&card_mm) Then
			'Call ALERTS("정확한 유효기간 정보를 입력해주세요!(카드유효기간 상이)","GO",GO_BACK_ADDR)
		End If
	'★★★★★★  유효기간 체크!!!			 ★★★★★★★★★★★★
	'Response.End

%>
<%
	'CS포인트 체크 추가
	If isSHOP_POINTUSE = "T" Then
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
			If CDbl(ori_price) <> CDbl(AHJRS_totalPrice+AHJRS_usePoint) Then
				Call ALERTS("Data modulation (oriprice)","GO",GO_BACK_ADDR)
			End If
			If CDbl(totalPrice) <> CDbl(AHJRS_totalPrice) Then
				Call ALERTS("Data modulation (totalPrice)","GO",GO_BACK_ADDR)
			End If
			If CDbl(totalDelivery) <> CDbl(AHJRS_totalDelivery) Then
				Call ALERTS("Data modulation (totalDelivery)","GO",GO_BACK_ADDR)
			End If
			If CDbl(usePoint) <> CDbl(AHJRS_usePoint) Then
				Call ALERTS("Data modulation (usePoint)","GO",GO_BACK_ADDR)
			End If

		Else
			Call ALERTS(LNG_TEXT_NO_DATA&" "&LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
		End If
		Call closeRS(AHJRS)
	End If

%>
<%


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
		ORDER_DUP_CNT = Db.execRsData(SQLNC1,DB_TEXT,arrParamsNC1,DB3)

		If CDbl(ORDER_DUP_CNT) > 0  Then Call ALERTS("비정상적인 주문번호입니다. (새로고침 후 다시 시도해주세요.)","GO",GO_BACK_ADDR)
	'▣ 웹주문번호 중복체크 E

	'▣ 국가별 배송비 설정
		arrParams2 = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)) _
		)
		Set DKRS2 = DB.execRs("HJP_GLOBAL_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
		If Not DKRS2.BOF And Not DKRS2.EOF Then
			DKRS2_intDeliveryFee		= DKRS2("intDeliveryFee")
			DKRS2_intDeliveryFeeLimit	= DKRS2("intDeliveryFeeLimit")
		Else
			Response.Write LNG_SHOP_DETAILVIEW_22
		End If
		Call closeRS(DKRS2)

		If CDbl(CStr(GoodsPrice)) >= CDbl(CStr(DKRS2_intDeliveryFeeLimit)) Then
			TOTAL_DELIVERYFEE = "0"
		Else
			TOTAL_DELIVERYFEE = DKRS2_intDeliveryFee
		End If

		If CDbl(CStr(TOTAL_DELIVERYFEE)) <> CDbl(CStr(totalDelivery)) Then
			Call ALERTS("Data modulation (TOTAL_DELIVERYFEE)","GO",GO_BACK_ADDR)
		End If
%>
<%
	'◆ #6. CS 구매상품 확인! S
	' - [임시주문 상품테이블]에서 현 주문 상품 정보 호출(카트수량 변조 무시)
	'SQLC1 = "SELECT [GoodIDX],[strOption],[orderEa],[isShopType],[strShopID] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? And [OrderNum] = ?"		'SHOP DB
	SQLC1 = "SELECT [intIDX],[OrderIDX],[GoodsCode],[GoodsPrice],[GoodsPV],[ea] FROM [DK_ORDER_TEMP_GOODS] WITH (NOLOCK) WHERE [OrderIDX] = ? "						'CS DB
	arrParamsC1 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX) _
	)
	arrListC1 = Db.execRsList(SQLC1,DB_TEXT,arrParamsC1,listLenC1,DB3)
	If IsArray(arrListC1) Then
		For c = 0 To listLenC1
			DKRSC1_intIDX    	= arrListC1(0,c)
			DKRSC1_OrderIDX  	= arrListC1(1,c)
			DKRSC1_GoodsCode 	= arrListC1(2,c)
			DKRSC1_GoodsPrice	= arrListC1(3,c)
			DKRSC1_GoodsPV   	= arrListC1(4,c)
			DKRSC1_orderEa     	= arrListC1(5,c)

			If DKRSC1_GoodsPrice < 1 Then Call ALERTS(LNG_SHOP_DETAILVIEW_JS_NO_PRICE,"GO",GO_BACK_ADDR)

			'◈ CS[임시주문 테이블] 정보 확인
			SQLC11 = "SELECT  [intIDX],[OrderNum],[MBID],[MBID2] FROM [DK_ORDER_TEMP] WITH (NOLOCK) WHERE [intIDX] = ? "
			arrParamsC1 = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRSC1_OrderIDX) _
			)
			Set DKRSC11 = Db.execRs(SQLC11,DB_TEXT,arrParamsC1,DB3)
			If Not DKRSC11.BOF And Not DKRSC11.EOF Then
				DKRSC11_intIDX		= DKRSC11("intIDX")
				DKRSC11_OrderNum	= DKRSC11("OrderNum")
				DKRSC11_MBID		= DKRSC11("MBID")
				DKRSC11_MBID2		= DKRSC11("MBID2")

				'주문번호 체크
				If orderNum <> DKRSC11_OrderNum Then Call ALERTS("Data modulation (orderNum)","GO",GO_BACK_ADDR)
				'회원번호 체크
				If (DK_MEMBER_ID1 <> DKRSC11_MBID) Or (DK_MEMBER_ID2 <> DKRSC11_MBID2) Then	Call ALERTS("Data modulation (MEMBER_ID12)","GO",GO_BACK_ADDR)
			Else
				Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
			End If
			Call closeRS(DKRSC11)

			'◈ CS 상품 정보 확인 S
				SQLC2 = "SELECT  [ncode],[GoodUse] FROM [tbl_Goods] WITH (NOLOCK) WHERE [ncode] = ? "
				arrParamsC2 = Array(_
					Db.makeParam("@GoodIDX",adVarChar,adParamInput,20,DKRSC1_GoodsCode) _
				)
				Set DKRSC2 = Db.execRs(SQLC2,DB_TEXT,arrParamsC2,DB3)
				If Not DKRSC2.BOF And Not DKRSC2.EOF Then
					DKRSC2_ncode		= DKRSC2("ncode")
					DKRSC2_GoodUse		= DKRSC2("GoodUse")
				Else
					Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
				End If
				Call closeRS(DKRSC2)

				If DKRSC2_GoodUse <> "0" Then Call ALERTS(LNG_SHOP_ORDER_DIRECT_05 & LNG_STRTEXT_TEXT02,"GO",GO_BACK_ADDR)
			'◈ 상품 정보 확인 E

		Next

	Else
		Call ALERTS("임시주문정보에서 삭제된 상품입니다. 새로고침 후 다시 시도해주세요.","GO",GO_BACK_ADDR)
	End If
	'◆ #6. 구매상품 1차 확인! E ◆◆◆

'=================================================================================================

		CardLogss = "cardShopAPI"

		On Error Resume Next
		Dim Fso0 : Set  Fso0=CreateObject("Scripting.FileSystemObject")
		Dim LogPath0 : LogPath0 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile0 : Set  Sfile0 = Fso0.OpenTextFile(LogPath0,8,true)

		Sfile0.WriteLine chr(13)
		Sfile0.WriteLine "Date			: "	& now()
		Sfile0.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
		Sfile0.WriteLine "--- Order Info -----------------------------"
		Sfile0.WriteLine "inUidx			 : " & inUidx
		Sfile0.WriteLine "takeName			 : " & takeName
		Sfile0.WriteLine "mbid1			 : " & DK_MEMBER_ID1
		Sfile0.WriteLine "mbid2			 : " & DK_MEMBER_ID2
		Sfile0.WriteLine "ori_price(total)	 : " & ori_price
		Sfile0.WriteLine "totalPrice		 : " & totalPrice
		Sfile0.WriteLine "totalDelivery		 : " & totalDelivery
		Sfile0.WriteLine "paykind			 : " & paykind
		Sfile0.WriteLine "v_SellCode		 : " & v_SellCode
		Sfile0.WriteLine "usePoint			 : " & usePoint
		Sfile0.WriteLine "DtoD				 : " & DtoD
		Sfile0.Close
		Set Fso0= Nothing
		Set objError= Nothing
		On Error GoTo 0


%>
<!-- #include file=KSPayApprovalCancel_ansi.inc -->
<%

	'카드결제 (실결제) =================================================================================================
	'★★★★ KSNET API ★★★★
	'payment	카드승인요청

	'Header부 Data --------------------------------------------------
		EncType			= "2" 					'0: 암화안함, 1:ssl, 2: seed
		Version			= "0603"				' 전문버전
		VType			= "00"					' 구분
		Resend			= "0"					' 전송구분 : 0 : 처음,  2: 재전송

		RequestDate		=	SetData(Year(Now),    4, "9") & _
							SetData(Month(Now),   2, "9") & _
							SetData(Day(Now),     2, "9") & _
							SetData(Hour(Now),    2, "9") & _
							SetData(Minute(Now),  2, "9") & _
							SetData(Second(Now),  2, "9")

		KeyInType		= "K" 					'KeyInType 여부 : S : Swap, K: KeyInType
		LineType		= "1"					'lineType 0 : offline, 1:internet, 2:Mobile
		ApprovalCount	= "1"					'복합승인갯수
		GoodType		= "0" 					'제품구분 0 : 실물, 1 : 디지털
		HeadFiller		= ""					'예비

		StoreId			= TX_KSNET_TID_KEYIN 											'*상점아이디(키인)

		OrderNumber		= orderNum														'*주문번호
		UserName		= Trim(Left(eRegiReplace(strName,"[^-가-힣a-zA-Z0-9]",""),15)) 	'*주문자명
		IdNum			= request.form("idnum") 										'주민번호 or 사업자번호
		Email			= strEmail 														'*email
		GoodName		= Trim(Left(eRegiReplace(GoodsName,"[^-가-힣a-zA-Z0-9]",""),15)) 	'*제품명
		PhoneNo			= Left(Replace(strMobile,"-",""),12)							'*휴대폰번호
	'Header end -------------------------------------------------------------------

	'Data Default-------------------------------------------------
		ApprovalType		= "1300" 												'승인구분 1300 (구인증 카유비생, 1000 카유)
		InterestType		= "1"						 							'일반/무이자구분 1:일반 2:무이자 <input type=hidden name="interesttype"			value="1"> 무시
		TrackII				= CardNo&"="&CardYYMM							      	'카드번호=유효기간  or 거래번호
		Installment			= quotabase 											'할부  00일시불
		Amount				= totalPrice											'금액
		Passwd				= CardPass			 									'비밀번호 앞2자리
		LastIdNum			= CARDAUTH_Input										'주민번호  뒤7자리, 사업자번호10
		CurrencyType		= "WON"						 							'통화구분 0:원화 1: 미화 <input type=hidden name="currencytype"			value="WON"> 무시

		BatchUseType		= "0" 				'거래번호배치사용구분  0:미사용 1:사용
		'CardSendType		= "0" 				'카드정보전송유무
		CardSendType		= "2" 				'카드정보전송유무
		'0:미전송 1:카드번호,유효기간,할부,금액,가맹점번호 2:카드번호앞14자리 + "XXXX",유효기간,할부,금액,가맹점번호
		VisaAuthYn			= "7" 				'비자인증유무 0:사용안함,7:SSL,9:비자인증
		Domain				= "" 				'도메인 자체가맹점(PG업체용)
		IpAddr				= Request.ServerVariables("REMOTE_ADDR")			'IP ADDRESS 자체가맹점(PG업체용)
		BusinessNumber		= "" 												'사업자 번호 자체가맹점(PG업체용)
		Filler				= "" 												'예비
		AuthType			= "" 												'ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
		MPIPositionType		= "" 												'K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
		MPIReUseType		= "" 	      										'Y : 재사용, N : 재사용아님
		EncData				= "" 												'MPI, ISP 데이터

	'Data Default end -------------------------------------------------------------

	'Server로 부터 응답이 없을시 자체응답
		rApprovalType		= "1001"
		rTransactionNo		= "" 							'거래번호
		rStatus				= "X" 							'상태 O : 승인, X : 거절
		rTradeDate			= "" 							'거래일자
		rTradeTime			= "" 							'거래시간
		rIssCode			= "00" 							'발급사코드
		rAquCode			= "00" 							'매입사코드
		rAuthNo				= "9999" 						'승인번호 or 거절시 오류코드
		rMessage1			= "승인거절" 					'메시지1
		rMessage2			= "C잠시후재시도" 				'메시지2
		rCardNo				= "" 							'카드번호
		rExpDate			= "" 							'유효기간
		rInstallment		= "" 							'할부
		rAmount				= "" 							'금액
		rMerchantNo			= "" 							'가맹점번호
		rAuthSendType		= "N" 							'전송구분
		rApprovalSendType	= "N" 							'전송구분(0 : 거절, 1 : 승인, 2: 원카드)
		rPoint1				= "000000000000" 				'Point1
		rPoint2				= "000000000000"				'Point2
		rPoint3				= "000000000000"				'Point3
		rPoint4				= "000000000000" 				'Point4
		rVanTransactionNo	= ""
		rFiller				= "" 							'예비
		rAuthType	 		= "" 							'ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
		rMPIPositionType	= "" 							'K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
		rMPIReUseType		= "" 							'Y : 재사용, N : 재사용아님
		rEncData			= "" 							'MPI, ISP 데이터
	'--------------------------------------------------------------------------------

	if CurrencyType = "WON" or CurrencyType = "410" or CurrencyType = "" then CurrencyType = "0" end if
	if CurrencyType = "USD" or CurrencyType = "840" then CurrencyType = "1" else CurrencyType = "0" end if

	'dll 초기화
	KSPayApprovalCancel "210.181.28.137", 21001

	'Header부 전문조립
	HeadMessage EncType, Version, VType, Resend, RequestDate, StoreId, OrderNumber, UserName, IdNum, Email, GoodType, GoodName, KeyInType, LineType, PhoneNo, ApprovalCount, HeadFiller

	'Data부 전문조립
	CreditDataMessage ApprovalType, InterestType, TrackII, Installment, Amount, Passwd, LastIdNum, CurrencyType, BatchUseType, CardSendType, VisaAuthYn, Domain, IpAddr, BusinessNumber, Filler, AuthType, MPIPositionType, MPIReUseType, EncData


	rSendSoket			= "F"
	'KSPAY로 요청전문송신후 수신데이터 파싱
	If SendSocket("1") = True Then
		rSendSoket			= "T"
		rApprovalType		= ApprovalType			'승인구분코드(서비스종류를 구분할수 있습니다. 첨부된전문내역서상의 승인코드부 참조)
		rTransactionNo		= TransactionNo	  		' 거래번호
		rStatus				= Status		  		' 상태 O : 승인, X : 거절
		rTradeDate			= TradeDate		  		' 거래일자
		rTradeTime			= TradeTime		  		' 거래시간
		rIssCode			= IssCode		  		' 발급사코드
		rAquCode			= AquCode		  		' 매입사코드
		rAuthNo				= AuthNo		  		' 승인번호 or 거절시 오류코드
		rMessage1			= Message1		  		' 메시지1
		rMessage2			= Message2		  		' 메시지2
		rCardNo				= CardNo		  		' 카드번호
		rExpDate			= ExpDate		  		' 유효기간
		rInstallment		= Installment	  		' 할부
		rAmount				= Amount		  		' 금액
		rMerchantNo			= MerchantNo	  		' 가맹점번호
		rAuthSendType		= AuthSendType	  		' 전송구분= new String(this.read(2))
		rApprovalSendType	= ApprovalSendType		' 전송구분(0 : 거절, 1 : 승인, 2: 원카드)
	End If
%>
<!-- #include file=encoding_utf8.asp -->
<%


	'▣ 로그 기록 S
		On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine "--- Card PAY -------------------------------"
			Sfile2.WriteLine "OrderNum			: "	& OrderNum
			Sfile2.WriteLine "rSendSoket		: " & rSendSoket
			Sfile2.WriteLine "StoreId			: "	& StoreId
			Sfile2.WriteLine "rApprovalType		: "	& rApprovalType
			Sfile2.WriteLine "rTransactionNo		: "	& rTransactionNo
			Sfile2.WriteLine "rStatus			: "	& rStatus
			Sfile2.WriteLine "rTradeDate		: "	& rTradeDate
			Sfile2.WriteLine "rTradeTime		: "	& rTradeTime
			Sfile2.WriteLine "rIssCode			: "	& rIssCode
			Sfile2.WriteLine "rAquCode			: "	& rAquCode
			Sfile2.WriteLine "rAuthNo			: "	& rAuthNo
			Sfile2.WriteLine "rMessage1			: "	& rMessage1
			Sfile2.WriteLine "rMessage2			: "	& rMessage2
			'Sfile2.WriteLine "rCardNo			: "	& rCardNo
			'Sfile2.WriteLine "rExpDate			: "	& rExpDate
			Sfile2.WriteLine "rInstallment		: "	& rInstallment
			Sfile2.WriteLine "rAmount			: "	& rAmount
			Sfile2.WriteLine "rMerchantNo		: "	& rMerchantNo
			Sfile2.WriteLine "rAuthSendType		: "	& rAuthSendType
			Sfile2.WriteLine "rApprovalSendType	: "	& rApprovalSendType
			Sfile2.WriteLine "---------------------------------------------"

			Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
		On Error Goto 0
	'▣ 로그 기록 E
'Response.end




%>
<!-- #include file=encoding_utf8.asp -->

<%
	'결제정보 DB입력

	'KSNET
		'공백 붙어서 옴! 없애주자 ㅡㅜ
		rStatus			= Trim(rStatus)
		rAuthNo			= Trim(rAuthNo)
		rMessage1		= Trim(rMessage1)
		rMessage2		= Trim(rMessage2)
		rTransactionNo	= Trim(rTransactionNo)
		rInstallment	= Trim(rInstallment)
		rIssCode		= Trim(rIssCode)
		rTradeDate		= Trim(rTradeDate)
		StoreId		  	= Trim(StoreId)

		PGorderNum		= rTransactionNo		'거래번호
		PGCardNum_MACCO	= Left(CardNo,6)		'카드번호 6자리(직판신고용)
		PGCardNum		= CardNo	'rCardNo	'카드번호

		'카드번호* 처리
		C_Number_LEN = 0
		C_Number_LEFT = ""
		C_Number_LEN = Len(PGCardNum)
		'If C_Number_LEN >= 12 Then
		'	C_Number_LEFT = Left(PGCardNum,(C_Number_LEN-10))
		'Else
		'	C_Number_LEFT = ""
		'End If
		'PGCardNum = C_Number_LEFT & "************"

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

		PGAcceptNum		= rAuthNo						'신용카드 승인번호
		PGinstallment	= rInstallment					'할부기간
		PGCardCode		= KSNET_CARDCODE(rIssCode)		'신용카드사코드(KSNET 치환)
		PGCardCom		= rIssCode						'신용카드발급사
		PGAcceptDate	= rTradeDate					'원승인일자
		PGCOMPANY		= "KSNET"						'PG사
		PGID			= StoreId						'PGID
		If PGinstallment = "" Or IsNull(PGinstallment) Then PGinstallment = "00"



		If rStatus = "O" Then

				Call Db.beginTrans(Nothing)


				'▣주문정보 암호화
					If DKCONF_SITE_ENC = "T" Then
						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							If DKRS_BANK_BankNumber	<> "" Then DKRS_BANK_BankNumber	= objEncrypter.Encrypt(DKRS_BANK_BankNumber)	'cacu. C_Number1

							If DKCONF_ISCSNEW = "T" Then
								If takeTel			<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
								If takeMob			<> "" Then takeMob				= objEncrypter.Encrypt(takeMob)
								If takeADDR1		<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
								If takeADDR2		<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
								If strEmail			<> "" Then strEmail				= objEncrypter.Encrypt(strEmail)
								If PGCardNum		<> "" Then PGCardNum			= objEncrypter.Encrypt(PGCardNum)			'카드번호 암호화
							End If
						Set objEncrypter = Nothing
					End If

				'입력 시작
				'이하 카드결제시 필요없는 변수
				DIR_CSHR_Type		= ""
				DIR_CSHR_ResultCode	= ""
				DIR_ACCT_BankCode	= ""
				payBankCode			= ""
				payBankAccNum		= ""
				payBankDate			= ""
				payBankSendName		= ""
				payBankAcceptName	= ""
				payState			= "101"

				Select Case payKind
					Case "Card","CardAPI"
						payKind = "card"
					Case Else
						payKind = "payKind"
				End Select

				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
					Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
					Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
					Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName), _
					Db.makeParam("@takeZip",adVarChar,adParamInput,10,takeZip), _
					Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,takeADDR1), _
					Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,takeADDR2), _
					Db.makeParam("@takeMob",adVarChar,adParamInput,50,takeMob), _
					Db.makeParam("@takeTel",adVarChar,adParamInput,50,takeTel), _

					Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
					Db.makeParam("@deliveryFee",adInteger,adParamInput,0,totalDelivery), _
					Db.makeParam("@payType",adVarChar,adParamInput,20,payKind), _
					Db.makeParam("@payState",adChar,adParamInput,3,payState), _

					Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum), _
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,PGinstallment), _
					Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode), _
					Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCom), _
					Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,Recordtime), _

					Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,DIR_CSHR_Type), _
					Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,DIR_CSHR_ResultCode), _
					Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,20,DIR_ACCT_BankCode), _

					Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,payBankCode), _
					Db.makeParam("@payBankAccNum",adVarChar,adParamInput,100,payBankAccNum), _
					Db.makeParam("@payBankDate",adVarChar,adParamInput,50,payBankDate), _
					Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,payBankSendName), _
					Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,payBankAcceptName), _

					Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,PGorderNum), _
					Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _
					Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

						Db.makeParam("@PGIDS",adVarChar,adParamInput,20,PGID), _

					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_ORDER_CARD_INFO_UPDATE_NEW",DB_PROC,arrParams,DB3)




				CS_IDENTITY = OIDX
				GoodsDeliveryFee = totalDelivery

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
					If CDbl(CStr(CHK_totalPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE)) Then
						ThisCancel = "T"
						ThisMsg	   = "결제금액이 변조되었습니다.01"
						Call PG_KSNET_CANCEL(StoreId,PGorderNum,GoodIDX,isDirect,chgPage, ThisMsg)
					End If


					'■전체상품 가격 변경■
					SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
					arrParams9 = Array(_
						Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
						Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
					)
					Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

					If PGinstallment = "00" Then PGinstallmentN = "일시불" Else PGinstallmentN = PGinstallment
					'PGCardCodeS = YESPAY_CARDCODE(PGCardCode)

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

					'◆ #9-1. 임시주문정보에서 CS주문번호를 삽입한다. S
					SQL12 = "UPDATE [DK_ORDER_TEMP] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
					arrParams12 = Array(_
						Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
						Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
					)
					Call Db.exec(SQL12,DB_TEXT,arrParams12,DB3)
					'◆ #9-1. 임시주문정보에서 CS주문번호를 삽입한다. E

					If OUT_ORDERNUMBER = "" Then
						ThisCancel = "T"
						ThisMsg	   = "CS_ORDERNUMBER가 발생하지 않았습니다.(카드취소여부확인)"
						Call PG_KSNET_CANCEL(StoreId,PGorderNum,GoodIDX,isDirect,chgPage, ThisMsg)
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


					ALERTS_MESSAGE = ""

					'=== 직판공제번호발급 ====
					If isMACCO = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
%>
					<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
<%
					End if



				Call Db.finishTrans(Nothing)


				If Err.Number <> 0 Then
					ThisMsg	   = "자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오"
					Call PG_KSNET_CANCEL(StoreId,PGorderNum,GoodIDX,isDirect,chgPage, ThisMsg)
					''Call ALERTS("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","GO",GO_BACK_ADDR)
				Else

				'	ThisMsg = "구매성공 테스트 결제 삭제 처리"
				'	Call PG_KSNET_CANCEL(StoreId,PGorderNum,GoodIDX,isDirect,chgPage, ThisMsg)

					If LCase(orderMode) = "mobile" Then
						chgPage = "/m"
					Else
						chgPage = "/myoffice"
					End If

					Select Case OUTPUT_VALUE
						Case "FINISH"
						'카트삭제
							If CART_DELETE_TF = "T" Then
								arrUidx = Split(inUidx,",")
								For i = 0 To UBound(arrUidx)
									SQL = "DELETE FROM [DK_CART] WHERE [intIDX] = ? AND [MBID] = ? AND [MBID2] = ?"
									arrParams = Array(_
										Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
										Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
										Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
									)
									Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
								Next
							End If

							Call ALERTS(LNG_ALERT_ORDER_OK&"\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/buy/order_list.asp")

						Case "ERROR" : Call ALERTS(LNG_ALERT_ORDER_ERROR,"GO",GO_BACK_ADDR)
					End Select

				End If
		Else
			Call ALERTS("PG사 통신중 오류가 발생하였습니다. 지속적인 오류 발생 시 관리자에게 문의하여 주십시오.\n\n오류 내용 : "&rMessage1&" "&rMessage2,"GO",GO_BACK_ADDR)

		End If






	Response.End

%>

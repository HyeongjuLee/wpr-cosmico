<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
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

	Dim takeName			: takeName			= pRequestTF("takeName",False)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMobile			: takeMobile		= pRequestTF("takeMobile",False)
	Dim takeZip				: takeZip			= pRequestTF("takeZip",False)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",False)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",False)

	Dim infoChg				: infoChg			= pRequestTF("infoChg",False)


	Dim ori_price			: ori_price			= pRequestTF("ori_price",True)				'totalPrice ori			추가
	Dim ori_delivery			: ori_delivery			= pRequestTF("ori_delivery",True)				'totalPrice ori			추가
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

	Dim GoodsName			: GoodsName			= pRequestTF("GoodsName",True)

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

	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)

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
		Case "P","I"	'개인카드
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
	cardYYMM	= Right(card_yy,2) & card_mm
	CardNo		= cardNo1 & cardNo2 & cardNo3 & cardNo4

	'★★★★★★  유효기간 체크!!!			 ★★★★★★★★★★★★	'
		THIS_MONTH = CDbl(Left(Replace(date(),"-",""),6))

		If CDbl(THIS_MONTH) > CDbl(card_yy&card_mm) Then
			Call ALERTS("정확한 유효기간 정보를 입력해주세요!(카드유효기간 상이)","GO",GO_BACK_ADDR)
		End If
	'★★★★★★ PAYSHART 유효기간 체크!!!			 ★★★★★★★★★★★★
	'Response.End


'▣ 결제금 체크(포인트) S
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
		Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
		Dim LogPath : LogPath = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

		Sfile.WriteLine chr(13)
		Sfile.WriteLine "Date			: "	& now()
		Sfile.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
		Sfile.WriteLine "=== Order Info ============================="
		Sfile.WriteLine "inUidx			 : " & inUidx
		Sfile.WriteLine "takeName			 : " & takeName
		Sfile.WriteLine "mbid1				 : " & DK_MEMBER_ID1
		Sfile.WriteLine "mbid2				 : " & DK_MEMBER_ID2
		Sfile.WriteLine "ori_price(total)	 : " & ori_price
		Sfile.WriteLine "totalPrice		 : " & totalPrice
		Sfile.WriteLine "totalDelivery		 : " & totalDelivery
		Sfile.WriteLine "paykind			 : " & paykind
		Sfile.WriteLine "v_SellCode			 : " & v_SellCode
		Sfile.WriteLine "usePoint			 : " & usePoint
		Sfile.WriteLine "DtoD				 : " & DtoD
		Sfile.WriteLine "============================================="

		Sfile.Close
		Set Fso= Nothing
		Set objError= Nothing
		On Error GoTo 0



'	PGorderNum = "19101516132101656103"
'	orderNum = "DK192885833318"
'	totalPrice = "1100"
'	PGAcceptNum = "58283461"
'	PGAcceptDate = "2019115"
'	isDirect = "T"
'	GoodIDX = "1"
'	chgPage = ""
'	ThisMsg = "테스트취소입니다02"
'	Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
'	Response.End



'카드결제 (실결제) =================================================================================================
'★★★★ ONOFFKOREA API ★★★★

		'payment	카드승인요청


		oXmlParam_P = ""
		oXmlParam_P = oXmlParam_P & "onfftid="&TX_ONOFF_TID															'(필) 온오프코리아 TID
		oXmlParam_P = oXmlParam_P & "&tot_amt="&totalPrice														'(필) 결제금액
		oXmlParam_P = oXmlParam_P & "&card_no="&CardNo															'(필) 카드번호
		oXmlParam_P = oXmlParam_P & "&install_period="&quotabase												'(필) 할부기간
		oXmlParam_P = oXmlParam_P & "&user_nm="&Left(eRegiReplace(strName,"[^-가-힣a-zA-Z0-9]",""),15)			'(필) 결제자명
		oXmlParam_P = oXmlParam_P & "&user_phone2="&strMobile													'(필) 결제자 연락처
		oXmlParam_P = oXmlParam_P & "&product_nm="&Left(eRegiReplace(GoodsName,"[^-가-힣a-zA-Z0-9]",""),15)		'(필) 결제 상품명
		oXmlParam_P = oXmlParam_P & "&expire_date="&cardYYMM													'(필) 유효기간(YYMM)
		oXmlParam_P = oXmlParam_P & "&cert_type=0"																'(필) 인증여부	0 – 인증, 1 – 비인증
		oXmlParam_P = oXmlParam_P & "&card_user_type="&card_user_type											'(필) 카드유형	0 – 개인카드, 1 – 법인카드
		oXmlParam_P = oXmlParam_P & "&auth_value="&CARDAUTH_Input												'(필) 인증번호 개인 : 주민번호 앞 6자리 법인 : 사업자등록번호
		oXmlParam_P = oXmlParam_P & "&password="&CardPass														'(필) 카드비밀번호	앞 2자리
		oXmlParam_P = oXmlParam_P & "&card_nm="																	'(선) 카드사명
		oXmlParam_P = oXmlParam_P & "&order_no="&orderNum														'(선) 주문번호 orderNum
		oXmlParam_P = oXmlParam_P & "&pay_type=card"															'(선) 결제타입	신용카드 : card

		''oXmlURL_P = "https://store.onoffkorea.co.kr/payment"				'← 절대안됨!!!!!!!!!!!!!!!!
		oXmlURL_P = "https://store.onoffkorea.co.kr/payment/index.php"

		Set oXmlhttp_P = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

			oXmlhttp_P.setOption 2, 13056
			oXmlhttp_P.open "POST", oXmlURL_P, False
			oXmlhttp_P.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
			oXmlhttp_P.setRequestHeader "Accept-Language","UTF-8"
			oXmlhttp_P.setRequestHeader "CharSet", "UTF-8"
			oXmlhttp_P.setRequestHeader "Content", "text/html;charset=UTF-8"
			oXmlhttp_P.setRequestHeader "Content-Length", Len(oXmlParam_P)
			oXmlhttp_P.send oXmlParam_P

			oResponse_P  = oXmlhttp_P.responseText
			oXmlStatus_P = oXmlhttp_P.status

		Set oXmlhttp_P = Nothing '개체 소멸

		'Call ResRW(oXmlParam_P,"oXmlParam_P")
		'Call ResRW(oResponse_P,"oResponse_P")
		'Call ResRW(oXmlStatus_P,"oXmlStatus_P")

		On Error Resume Next
		Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine "--- Card PAY -------------------------------"
			Sfile2.WriteLine "oXmlStatus_P	: " & oXmlStatus_P
			Sfile2.WriteLine "oResponse_P	: " & oResponse_P

			ALERT_MSG = ""
			ALERT_BR = "\n"

			Select Case oXmlStatus_P
				Case "200"

					'XML 파싱
					Set objMsXmlDom = Server.CreateObject("microsoft.XMLDOM")
						objMsXmlDom.async = False	' 동기식 호출
						objMsXmlDom.validateOnParse = false
						objMsXmlDom.loadXML(oResponse_P)

						result_cd	= "" & Trim(objMsXmlDom.getElementsByTagName("result_cd").Item(0).Text)			'결과 코드
						result_msg	= "" & Replace(Trim(objMsXmlDom.getElementsByTagName("result_msg").Item(0).Text),chr(10),"")		'결과 메시지

						Sfile2.WriteLine "onfftid : "	& TX_ONOFF_TID
						Sfile2.WriteLine "result_cd	: " & result_cd
						Sfile2.WriteLine "result_msg : " & result_msg

						If result_cd <> "0000" Then
							ALERT_MSG = "result_cd : "&result_cd&","&ALERT_BR&"result_msg : "&result_msg&""
								Sfile2.WriteLine "---ERROR1------------------------------------"
								Sfile2.WriteLine "ALERT_MSG	: " & ALERT_MSG
								Sfile2.WriteLine "---------------------------------------------"
							Call ALERTS(ALERT_MSG,"GO",GO_BACK_ADDR)
							Response.End
						End If

						transeq		= "" & Trim(objMsXmlDom.getElementsByTagName("transeq").Item(0).Text)			'결제 일련번호
						auth_no		= "" & Trim(objMsXmlDom.getElementsByTagName("auth_no").Item(0).Text)			'승인번호
						app_date	= "" & Trim(objMsXmlDom.getElementsByTagName("app_date").Item(0).Text)			'결제일시
						app_dt		= "" & Trim(objMsXmlDom.getElementsByTagName("app_dt").Item(0).Text)			'결제일
						app_tm		= "" & Trim(objMsXmlDom.getElementsByTagName("app_tm").Item(0).Text)			'결제시간
						tot_amt		= "" & Trim(objMsXmlDom.getElementsByTagName("tot_amt").Item(0).Text)			'결제금액(총 승인금액)
						order_no	= "" & Trim(objMsXmlDom.getElementsByTagName("order_no").Item(0).Text)			'주문번호
						iss_cd		= "" & Trim(objMsXmlDom.getElementsByTagName("iss_cd").Item(0).Text)			'신용카드사 코드
						iss_nm		= "" & Trim(objMsXmlDom.getElementsByTagName("iss_nm").Item(0).Text)			'신용카드사

					Set objMsXmlDom  = Nothing

					Sfile2.WriteLine "transeq		: "	& transeq
					Sfile2.WriteLine "auth_no		: "	& auth_no
					Sfile2.WriteLine "app_date	: "	& app_date
					Sfile2.WriteLine "app_dt		: "	& app_dt
					Sfile2.WriteLine "app_tm		: "	& app_tm
					Sfile2.WriteLine "tot_amt		: "	& tot_amt
					Sfile2.WriteLine "order_no	: "	& order_no
					Sfile2.WriteLine "iss_cd		: "	& iss_cd
					Sfile2.WriteLine "iss_nm		: "	& iss_nm
					Sfile2.WriteLine "---------------------------------------------"

				Case Else
					ALERT_MSG = "ErrorCode : "&oXmlStatus_P&""
						Sfile2.WriteLine "---ERROR2------------------------------------"
						Sfile2.WriteLine "ALERT_MSG	: " & ALERT_MSG
						Sfile2.WriteLine "---------------------------------------------"
					Call ALERTS(Replace(ALERT_MSG,"&#10;",""),"GO",GO_BACK_ADDR)
					Response.End

			End Select

			Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
		On Error Goto 0



	'결제정보 DB입력

		'ONOFFKOREA
			PGorderNum	= transeq		'거래번호(ONOFFKOREA)
			PGCardNum	= CardNo		'카드번호

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

			PGAcceptNum		= auth_no				'신용카드 승인번호
			PGinstallment	= quotabase				'할부기간
			PGCardCode		= ONOFFKOREA_CARDCODE(iss_cd)	'신용카드사코드(ONOFFKOREA 치환)
			PGCardCom		= iss_nm						'신용카드발급사
			PGAcceptDate	= RegTime						'원승인일자
			PGCOMPANY		= "ONOFFKOREA"					'PG사
			If PGinstallment = "" Or IsNull(PGinstallment) Then PGinstallment = "00"


			On Error Resume Next
			Dim Fso3 : Set  Fso3=CreateObject("Scripting.FileSystemObject")
			Dim LogPath3 : LogPath3 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile3 : Set  Sfile3 = Fso3.OpenTextFile(LogPath3,8,true)
				Sfile3.WriteLine "orderNum_Fso3	: " & orderNum
				Sfile3.WriteLine "PGorderNum		: " & PGorderNum
				'Sfile3.WriteLine "PGCardNum		: " & PGCardNum
				Sfile3.WriteLine "PGAcceptNum		: " & PGAcceptNum
				Sfile3.WriteLine "PGinstallment	: " & PGinstallment
				Sfile3.WriteLine "PGCardCode		: " & PGCardCode
				Sfile3.WriteLine "PGACP_TIME		: " & create_2			'승인시간
				Sfile3.Close
			Set Fso3= Nothing
			Set objError= Nothing
			On Error Goto 0




		If result_cd = "0000" Then

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
						Db.makeParam("@payWay",adVarchar,adParamInput,6,paykind), _

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

								'▣소비자 가격
								If CONST_CS_SOBIJA_PRICE_USE_TF = "T" Then
									If DK_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
										DKRS_GoodsPrice	 = DKRS_GoodsCustomer
									End If
								End If

							Else
								ThisCancel = "T"
								ThisMsg		= "존재하지 않는 상품구입을 시도했습니다."
								Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)

							End If
							Call closeRS(DKRS)

							If DKRS_DelTF = "T" Then
								ThisCancel = "T"
								ThisMsg		= "삭제된 상품의 구매를 시도했습니다."
								Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
							End If
							If DKRS_isAccept <> "T" Then
								ThisCancel = "T"
								ThisMsg		= "승인되지 않은 상품의 구매를 시도했습니다."
								Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
							End If
							If DKRS_GoodsViewTF <> "T" Then
								ThisCancel = "T"
								ThisMsg		= "더이상 판매되지 않는 상품의 구매를 시도했습니다."
								Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
							End If

							Select Case DKRS_GoodsStockType
								Case "I"
								Case "N"
									If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
										ThisCancel = "T"
										ThisMsg = "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요."
										Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
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
									Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
								Case Else
									ThisCancel = "T"
									ThisMsg		= "수량정보가 올바르지 않습니다."
									Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
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
							Else
								Call ALERTS("회원번호정보 없음","GO",GO_BACK_ADDR)
							End If
							Call closeRS(DKRS)


							'CS상품 갯수체크
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

										'전체상품 가격 체크 WEB
											SQL80 = "SELECT SUM([GoodsPrice]*[OrderEa]) FROM [DK_ORDER_GOODS] WITH(NOLOCK) WHERE [orderIDX] = ? And [OrderNum] = ?"
											arrParams80 = Array(_
												Db.makeParam("@identity",adInteger,adParamInput,4,identity), _
												Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
											)
											WEBDB_TOTAL_PRICE = Db.execRsData(SQL80,DB_TEXT,arrParams80,Nothing)
											WEBDB_TOTAL_PRICE = WEBDB_TOTAL_PRICE + GoodsDeliveryFee

										'전체상품 가격 체크
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
												Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
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
												Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
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
				'=== CS 전산입력 종료 =========================================================================================================
				'==============================================================================================================================


				ALERTS_MESSAGE = ""
				If Err.Number = 0 Then
					'=== 직판공제번호발급 ====
					If isMACCO = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
					%>
					<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
					<%
					End if

					'=== 특판공제번호발급 ====
					If MLM_TF = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
					%>
					<!--#include virtual = "/MLM/_inc_MLM_Report.asp"-->
					<%
					End if

					'알림톡 전송
					requestInfos = ""
					'Call FN_PPURIO_MESSAGE(DK_MEMBER_ID1, DK_MEMBER_ID2, "order", "at", OUT_ORDERNUMBER, requestInfos)

				End if

				Call Db.finishTrans(Nothing)


				If Err.Number <> 0 Then
					ThisMsg	   = "자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오"
					Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)
					''Call ALERTS("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","GO",GO_BACK_ADDR)
				Else
					'Call PG_ONOFFKOREA_CANCEL(TX_ONOFF_TID, PGorderNum, orderNum, totalPrice, PGAcceptNum, PGAcceptDate, isDirect, GoodIDX, chgPage, ThisMsg)

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


		End If






	Response.End

%>

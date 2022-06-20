<!-- #include virtual = "/_lib/strFunc.asp" -->
<!-- #include virtual = "/_lib/strPGFunc.asp" -->
<!-- #include virtual = "/_lib/json2.asp" -->
<!-- #include file="KSPayWebHost_m.inc.asp" -->
<%
	'★ 크롬SameSite 이슈로 web.config : outboundRules 추가! ★

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

%>
<%
	Session.CodePage = "949"
	Response.CharSet = "EUC-KR"
%>
<%

'▣개별 변수 받아오기 (쇼핑몰 기본정보) S
	Dim paykind				: paykind			= FN_URLDecode(pRequestTF("ECH_paykind",True))
	Dim orderNum			: orderNum			= FN_URLDecode(pRequestTF("ECH_OrdNo",True))
	Dim inUidx				: inUidx			= FN_URLDecode(pRequestTF("ECH_cuidx",True))
	Dim gopaymethod			: gopaymethod		= FN_URLDecode(pRequestTF("ECH_gopaymethod",True))
	payKind = gopaymethod															'모바일 마이오피스 구매 결재방식 변수 치환

	Dim orderMode			: orderMode			= FN_URLDecode(pRequestTF("ECH_orderMode",False))

	Dim strEmail			: strEmail			= FN_URLDecode(pRequestTF("ECH_strEmail",False))

	Dim takeName			: takeName			= FN_URLDecode(pRequestTF("ECH_takeName",True))
	Dim takeTel				: takeTel			= FN_URLDecode(pRequestTF("ECH_takeTel",False))
	Dim takeMob				: takeMob			= FN_URLDecode(pRequestTF("ECH_takeMobile",True))		'takeMob takeMobile
	Dim takeZip				: takeZip			= FN_URLDecode(pRequestTF("ECH_takeZip",True))
	Dim takeADDR1			: takeADDR1			= FN_URLDecode(pRequestTF("ECH_takeADDR1",True))
	Dim takeADDR2			: takeADDR2			= FN_URLDecode(pRequestTF("ECH_takeADDR2",True))

	Dim ori_price			: ori_price			= FN_URLDecode(pRequestTF("ECH_ori_price",True))
	Dim totalPrice			: totalPrice		= FN_URLDecode(pRequestTF("ECH_totalPrice",True))
	Dim totalDelivery		: totalDelivery		= FN_URLDecode(pRequestTF("ECH_totalDelivery",False))
	Dim DeliveryFeeType		: DeliveryFeeType	= FN_URLDecode(pRequestTF("ECH_DeliveryFeeType",False))
	Dim GoodsPrice			: GoodsPrice		= FN_URLDecode(pRequestTF("ECH_GoodsPrice",False))

	Dim usePoint			: usePoint			= FN_URLDecode(pRequestTF("ECH_usePoint",False))
	Dim usePoint2			: usePoint2			= FN_URLDecode(pRequestTF("ECH_usePoint2",False))
	Dim totalVotePoint		: totalVotePoint	= FN_URLDecode(pRequestTF("ECH_totalVotePoint",False))

	Dim GoodsName			: GoodsName			= FN_URLDecode(pRequestTF("ECH_GoodsName",True))

	Dim TOTAL_POINTUSE_MAX	: TOTAL_POINTUSE_MAX= FN_URLDecode(pRequestTF("ECH_TOTAL_POINTUSE_MAX",False))	'▶ 최대 포인트사용가능 금액

	Dim orderMemo			: orderMemo			= FN_URLDecode(pRequestTF("ECH_orderMemo",False))
	'Dim BusCode				: BusCode			= pRequestTF("BusCode",False)


	Dim bankidx				: bankidx			= 0		'pRequestTF("bankidx",False)
	Dim bankingName			: bankingName		= ""	'pRequestTF("bankingName",False)
	Dim memo1				: memo1				= ""

	Dim OIDX				: OIDX		= FN_URLDecode(pRequestTF("ECH_OIDX",True))			'◆ #5. 임시주문테이블 idx

	Dim v_SellCode			: v_SellCode		= FN_URLDecode(pRequestTF("ECH_v_SellCode",True))		'CS상품 구매종류
	Dim SalesCenter			: SalesCenter		= FN_URLDecode(pRequestTF("ECH_SalesCenter",False))		'판매센터
	Dim DtoD				: DtoD				= FN_URLDecode(pRequestTF("ECH_DtoD",True))				'판매센터

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

%>
<%
	Session.CodePage = "65001"
	Response.CharSet = "UTF-8"
%>
<%
	'KSNET 결제 ======================================================

	dim rcid   : rcid	= Request.Form("reCommConId")
	dim rctype : rctype	= Request.Form("reCommType")
	dim rhash  : rhash	= Request.Form("reHash")

	'rcid 없으면 결제를 끝까지 진행하지 않고 중간에 결제취소

	'단순취소
	If rcid = "" Then
		'If isDirect = "T" Then
		'	GO_CANCEL_ADDR = "/m/shop/detailView.asp?gidx="&GoodIDX
		'Else
		'	GO_CANCEL_ADDR = "/m/shop/cart.asp"
		'End If

		GO_CANCEL_ADDR = "/m/buy/cart_directB.asp?gidx="&gidx

		Call ALERTS("결제가 취소되었습니다.","GO",GO_CANCEL_ADDR)
	End If

	'KSNET 결제 ======================================================
%>
<%

'치환
	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID
	state		= "101"

	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0
	If takeTel = "" Then takeTel = ""
	If takeMob = "" Then takeMob = ""

	If orderMemo <> "" And Len(orderMemo) > 100 Then Call ALERTS("배송요청사항은 100자를 넘길 수 없습니다.","GO",GO_BACK_ADDR)
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
'	Call ResRW(Stremail				,"Stremail			")
'	Call ResRW(Takename				,"Takename			")
'	Call ResRW(Taketel				,"Taketel				")
'	Call ResRW(takeMob			,"takeMob			")
'	Call ResRW(Takezip				,"Takezip				")
'	Call ResRW(Takeaddr1			,"Takeaddr1			")
'	Call ResRW(Takeaddr2			,"Takeaddr2			")
'	Call ResRW(Totalprice			,"Totalprice			")
'	Call ResRW(Totaldelivery		,"Totaldelivery		")
'	Call ResRW(Deliveryfeetype		,"Deliveryfeetype		")
'	Call ResRW(Goodsprice			,"Goodsprice			")
'	Call ResRW(Usepoint				,"Usepoint			")
'	Call ResRW(Ordermemo			,"Ordermemo			")
'	Call ResRW(V_sellcode			,"V_sellcode			")
'	Call ResRW(Buscode				,"Buscode				")
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

		CardLogss = "cardShop"

		On Error Resume Next
		Dim  Fso0 : Set  Fso0=CreateObject("Scripting.FileSystemObject")
		Dim LogPath0 : LogPath0 = Server.MapPath (CardLogss&"/card_") & Replace(Date(),"-","") & ".log"
		Dim Sfile0 : Set  Sfile0 = Fso0.OpenTextFile(LogPath0,8,true)

		Sfile0.WriteLine chr(13)
		Sfile0.WriteLine "Date			: "	& now()
		Sfile0.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
		Sfile0.WriteLine "=== Order Info ============================="
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
		Sfile0.WriteLine "============================================="
		Sfile0.Close
		Set Fso0= Nothing
		Set objError= Nothing
		On Error GoTo 0


%>


<%
	'KSNET 결제

	'dim rcid   : rcid	= Request.Form("reCommConId"		)
	'dim rctype : rctype	= Request.Form("reCommType"			)
	'dim rhash  : rhash	= Request.Form("reHash"				)

	'rcid 없으면 결제를 끝까지 진행하지 않고 중간에 결제취소		'(상단 이동) ↑

	dim authyn
	dim trno
	dim trddt
	dim trdtm
	dim amt
	dim authno
	dim msg1
	dim msg2
	dim ordno
	dim isscd
	dim aqucd
	dim result
	dim resultcd

	KSPayWebHost rcid, Null		'KSNET 결제결과 중 아래에 나타나지 않은 항목이 필요한 경우 Null 대신 필요한 항목명을 설정할 수 있습니다.

	if kspay_send_msg("1") then	'현재 결제대기 상태이며 kspay_send_msg("1")을 호출하셔야 결제가 처리됩니다.

		authyn		= kspay_get_value("authyn")			'성공여부: 영어대문자 O-성공, X-거절
		trno		= kspay_get_value("trno")			'거래번호
		trddt		= kspay_get_value("trddt")			'거래일자(YYYYMMDD)
		trdtm		= kspay_get_value("trdtm")			'거래시간(HHMMTT)
		amt			= kspay_get_value("amt")			'금액
		authno		= kspay_get_value("authno")			'[신용카드]승인번호 : 결제 성공시에만 보임 / [가상계좌]은행코드 / [계좌이체]은행코드
		msg1		= kspay_get_value("msg1")
		msg2		= kspay_get_value("msg2")
		ordno		= kspay_get_value("ordno")			'주문번호
		isscd		= kspay_get_value("isscd")			'[신용카드]발급사코드  / [가상계좌]계좌번호
		aqucd		= kspay_get_value("aqucd")			'[신용카드]매입사코드
		result		= kspay_get_value("result")			'결제수단
		halbu		= kspay_get_value("halbu")
		cardno		= kspay_get_value("cardno")
		'cbtrno		= kspay_get_value("cbtrno")
		'cbauthno	= kspay_get_value("cbauthno")

		if False = IsNull(authyn) and 1 = Len(authyn) then

			if authyn = "O" then
				resultcd = "0000"						'응답코드
			else
				resultcd = trim(authno)
			end if

			kspay_send_msg "3"	'정상처리가 완료되었을 경우 호출합니다.(이 과정이 없으면 일시적으로 kspay_send_msg("1")을 호출하여 거래내역 조회가 가능합니다.)
		end If

	end if



Session.CodePage = "949"
Response.CharSet = "EUC-KR"

	'업체에서 추가하신 인자값을 받는 부분입니다
	dim ECHA : ECHA= request.form("ECHA")
	dim ECHB : ECHB= request.form("ECHB")
	dim ECHC : ECHC= request.form("ECHC")
	dim ECHD : ECHD= request.form("ECHD")

	ECHA = FN_URLDecode(ECHA)
	ECHB = FN_URLDecode(ECHB)
	ECHC = FN_URLDecode(ECHC)
	ECHD = FN_URLDecode(ECHD)

Session.CodePage = "65001"
Response.CharSet = "UTF-8"

%>


<%
	'rcid : w117477536db2ea00910
	'rctype : WH
	'rhash : 1599729709375:AST:7E8B3DD3B56B5863D628889F4A0BE4CE
	'승인성공
	'authyn : O
	'trno : 175610114563
	'trddt : 20200910
	'trdtm : 182310
	'amt : 1300
	'authno : 97174902
	'msg1 : 삼성AMEX개인특별
	'msg2 : OK: 97174902
	'ordno : DK202546607874
	'isscd	: 04
	'aqucd	: 04
	'result : 1001
	'halbu : 00
	'cbtrno :
	'cbauthno :


	'공백 붙어서 옴! 없애주자 ㅡㅜ
	authyn  	= Trim(authyn)
	trno    	= Trim(trno)
	trddt   	= Trim(trddt)
	trdtm   	= Trim(trdtm)
	amt     	= Trim(amt)
	authno  	= Trim(authno)
	msg1    	= Trim(msg1)
	msg2    	= Trim(msg2)
	ordno   	= Trim(ordno)
	isscd   	= Trim(isscd)		'우측 스페이스4칸 발생!
	aqucd   	= Trim(aqucd)		'우측 스페이스4칸 발생!
	result  	= Trim(result)
	halbu   	= Trim(halbu)
	'cbtrno  	= Trim(cbtrno)
	'cbauthno	= Trim(cbauthno)
	cardno		= Trim(cardno)

''	isscd = Replace(isscd," ","")	'우측 스페이스4칸 발생!
''	aqucd = Replace(aqucd," ","")	'우측 스페이스4칸 발생!
	StoreId = TX_KSNET_TID			'상점아이디(일반)

'	Call ResRW(Pgid					,"Pgid				")
'	Call ResRW(Pgpwd				,"Pgpwd				")
'	Call ResRW(Paykind				,"Paykind				")
'	Call ResRW(Ordernum				,"Ordernum			")
'	Call ResRW(Inuidx				,"Inuidx				")
'	Call ResRW(Gopaymethod			,"Gopaymethod			")
'	Call ResRW(Stremail				,"Stremail			")
'	Call ResRW(Takename				,"Takename			")
'	Call ResRW(Taketel				,"Taketel				")
'	Call ResRW(takeMob			,"takeMob			")
'	Call ResRW(Takezip				,"Takezip				")
'	Call ResRW(Takeaddr1			,"Takeaddr1			")
'	Call ResRW(Takeaddr2			,"Takeaddr2			")
'	Call ResRW(Totalprice			,"Totalprice			")
'	Call ResRW(Totaldelivery		,"Totaldelivery		")
'	Call ResRW(Deliveryfeetype		,"Deliveryfeetype		")
'	Call ResRW(Goodsprice			,"Goodsprice			")
'	Call ResRW(Usepoint				,"Usepoint			")
'	Call ResRW(Ordermemo			,"Ordermemo			")
'
'	Call ResRW(V_sellcode			,"V_sellcode			")
'	Call ResRW(Buscode				,"Buscode				")
'
'	Call ResRW(authyn				,"authyn				")
'	Call ResRW(trno				,"trno				")
'	Call ResRW(trddt				,"trddt				")
'	Call ResRW(trdtm				,"trdtm				")
'	Call ResRW(amt					,"amt					")
'	Call ResRW(authno				,"authno				")
'	Call ResRW(msg1				,"msg1				")
'	Call ResRW(msg2				,"msg2				")
'	Call ResRW(ordno				,"ordno				")
'	Call ResRW(isscd				,"isscd				")
'	Call ResRW(aqucd				,"aqucd				")
'	Call ResRW(result				,"result				")
'	Call ResRW(halbu				,"halbu				")
'		Call ResRW(cardno				,"cardno				")
'	Call ResRW(cbtrno				,"cbtrno				")
'	Call ResRW(cbauthno			,"cbauthno			")
'	Call ResRW(ECHA			,"ECHA			")
'	Call ResRW(ECHB			,"ECHB			")
'	Call ResRW(ECHC			,"ECHC			")
'	Call ResRW(ECHD			,"ECHD			")
'
'	Call ResRW(rcid			,"rcid			")
'	Call ResRW(rctype			,"rctype			")
'	Call ResRW(rhash			,"rhash			")




	'결제정보 DB입력

		'KSNET
		PGorderNum	= trno			'거래번호(KSNET)
		PGCardNum	= cardno		'카드번호(KSNET 기본제공X)

		If PGCardNum <> "" Then
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
		End If

		PGAcceptNum		= authno					'신용카드 승인번호
		PGinstallment	= halbu	'quotabase			'할부기간
		PGCardCode		= KSNET_CARDCODE(CStr(isscd))		'신용카드사코드(KSNET 치환)
		PGCardCom		= isscd						'신용카드발급사
		PGAcceptDate	= trddt		'RegTime		'원승인일자
		PGCOMPANY		= "KSNET"					'PG사
		PGID			= StoreId					'PGID
		If PGinstallment = "" Or IsNull(PGinstallment) Then PGinstallment = "00"


		On Error Resume Next
		Dim Fso3 : Set  Fso3=CreateObject("Scripting.FileSystemObject")
		Dim LogPath3 : LogPath3 = Server.MapPath (CardLogss&"/card_") & Replace(Date(),"-","") & ".log"
		Dim Sfile3 : Set  Sfile3 = Fso3.OpenTextFile(LogPath3,8,true)
			Sfile3.WriteLine "orderNum_Fso3	: " & orderNum
			Sfile3.WriteLine "StoreId		: " & StoreId
			Sfile3.WriteLine "PGorderNum	: " & PGorderNum
			Sfile3.WriteLine "PGAcceptNum	: " & PGAcceptNum
			Sfile3.WriteLine "PGinstallment	: " & PGinstallment
			Sfile3.WriteLine "PGCardCode	: " & PGCardCode
			Sfile3.WriteLine "PGACP_TIME	: " & trddt&" "&trdtm		'승인시간
			Sfile3.WriteLine "PGCardCom		: " & PGCardCom
			Sfile3.WriteLine "resultcd		: " & resultcd
			Sfile3.WriteLine "msg1			: " & msg1
			Sfile3.WriteLine "msg2			: " & msg2
			Sfile3.WriteLine "result		: " & result
			Sfile3.WriteLine "resultcd		: " & resultcd
			Sfile3.WriteLine "isscd		: "&isscd
			Sfile3.WriteLine "aqucd		: "&aqucd
			Sfile3.WriteLine "halbu		: " & halbu
			'Sfile3.WriteLine "cbtrno		: " & cbtrno
			'Sfile3.WriteLine "cbauthno		: " & cbauthno
			Sfile3.Close
		Set Fso3= Nothing
		Set objError= Nothing
		On Error Goto 0


'	Response.end

		If resultcd = "0000" Then

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
					Call Db.exec("HJP_ORDER_TOTAL_JADAMIN",DB_PROC,arrParams,DB3)		'A상품군 합계의 1%적립
					'Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
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
					Dim LogPath5 : LogPath5 = Server.MapPath (CardLogss&"/card_") & Replace(Date(),"-","") & ".log"
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


		End If






	Response.End


%>


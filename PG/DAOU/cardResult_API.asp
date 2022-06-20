<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
<%
On Error Resume Next

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

'DAOU API

	'CP_ID = ""								'프리먼스
	CP_ID = "CTS14219"						'테스트


'▣개별 변수 받아오기 (쇼핑몰 기본정보) S
	paykind				= Trim(pRequestTF("paykind",True))
	OrderNum			= Trim(pRequestTF("OrdNo",True))
	inUidx				= Trim(pRequestTF("cuidx",True))

	orderMode			= Trim(pRequestTF("orderMode",False))		'mobile(SHOP /MOBILE주문 통합)
	strEmail			= Trim(pRequestTF("strEmail",False))

	strName				= Trim(pRequestTF("strName",True))
	strTel				= Trim(pRequestTF("strTel",False))
	strMob				= Trim(pRequestTF("strMobile",True))
	strZip				= Trim(pRequestTF("strZip",True))
	strADDR1			= Trim(pRequestTF("strADDR1",True))
	strADDR2			= Trim(pRequestTF("strADDR2",True))

	takeName			= Trim(pRequestTF("takeName",True))
	takeTel				= Trim(pRequestTF("takeTel",False))
	takeMob				= Trim(pRequestTF("takeMobile",True))
	takeZip				= Trim(pRequestTF("takeZip",True))
	takeADDR1			= Trim(pRequestTF("takeADDR1",True))
	takeADDR2			= Trim(pRequestTF("takeADDR2",True))

	orderMemo				= Trim(pRequestTF("orderMemo",False))

	strSSH1 = ""
	strSSH2 = ""

	ori_price				= Trim(pRequestTF("ori_price",True))				'totalPrice ori			추가
	ori_delivery			= Trim(pRequestTF("ori_delivery",True))				'ori_delivery			추가
	totalPrice				= Trim(pRequestTF("totalPrice",True))
	totalDelivery			= Trim(pRequestTF("totalDelivery",True))
	DeliveryFeeType			= Trim(pRequestTF("DeliveryFeeType",True))
	GoodsPrice				= Trim(pRequestTF("GoodsPrice",True))

	totalOptionPrice		= Trim(pRequestTF("totalOptionPrice",False))
	totalOptionPrice2		= Trim(pRequestTF("totalOptionPrice2",False))		'goodsOPTcost
	totalPoint				= Trim(pRequestTF("totalPoint",False))

	input_mode				= Trim(pRequestTF("input_mode",False))

	usePoint				= Trim(pRequestTF("useCmoney",False))
	usePoint2				= Trim(pRequestTF("useCmoney2",False))

	orderEaD				= Trim(pRequestTF("ea",False))
	strOption				= Trim(pRequestTF("strOption",False))

	bankidx					= ""
	bankingName				= ""
	totalVotePoint			= Trim(pRequestTF("totalVotePoint",False))

	orderEaD				= Trim(pRequestTF("ea",False))						'◆ #5. EA
	GoodIDXs				= Trim(pRequestTF("GoodIDXs",False))				'◆ #5. GoodIDXs
	strOptions				= Trim(pRequestTF("strOptions",False))				'◆ #5. strOptions
	OIDX					= Trim(pRequestTF("OIDX",True))						'◆ #5. 임시주문테이블 idx
'▣개별 변수 받아오기 (쇼핑몰 기본정보) E

'▣ CS 특이사항 S
	CSGoodCnt		= Trim(pRequestTF("CSGoodCnt",True))				'통합정보 CS상품 갯수
	isSpecialSell	= Trim(pRequestTF("isSpecialSell",False))
	If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then
		v_SellCode		= Trim(pRequestTF("v_SellCode",True))				'CS상품 구매종류
		SalesCenter		= Trim(pRequestTF("SalesCenter",False))				'판매센터
		DtoD			= Trim(pRequestTF("DtoD",True))				'판매센터
	Else
		v_SellCode		= ""
		SalesCenter		= ""
		DtoD			= "T"
	End If
'▣ CS 특이사항 E

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

'▣카드결제 정보 S
	cardNo1		= pRequestTF("cardNo1",True)		'카드번호
	cardNo2		= pRequestTF("cardNo2",True)
	cardNo3		= pRequestTF("cardNo3",True)
	cardNo4		= pRequestTF("cardNo4",True)

	AuthYY		= pRequestTF("card_yy",True)		'유효기간(년) YYYY
	AuthMM		= pRequestTF("card_mm",True)		'유효기간(월) MM

	cardKind	= pRequestTF("cardKind",True)		'카드구분
		strBirth1		= pRequestTF("birthyy",False)				'생년월일
		strBirth2		= pRequestTF("birthmm",False)
		strBirth3		= pRequestTF("birthdd",False)
		CorporateNumber	= pRequestTF("CorporateNumber",False)
		ssh1			= pRequestTF("ssh1",False)
		ssh2			= pRequestTF("ssh2",False)


	CardPass	= pRequestTF("CardPass",True)		'카드비번(앞2자리)
	quota		= pRequestTF("quotabase",True)		'할부기간

	CardNo		= cardNo1 & cardNo2 & cardNo3 & cardNo4

	Select Case cardKind	'카드구분추가
		Case "P","I"	'일반신용, 개인사업자
			birth = ""
			If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then
				birth = strBirth1 & strBirth2 & strBirth3
				CARDAUTH_Input = Right(birth,6)
			Else
				Call ALERTS("생년월일이 입력되지 않았습니다.","GO",GO_BACK_ADDR)
			End If
		Case "C"	'법인사업자
			If CorporateNumber <> "" Then
				CARDAUTH_Input = CorporateNumber
			Else
				Call ALERTS("사업자등록번호가 입력되지 않았습니다.","GO",GO_BACK_ADDR)
			End If

		Case Else
			Call ALERTS("잘못된 카드구분입니다.","GO",GO_BACK_ADDR)
	End Select
'	Call ResRw(cardKind,"cardKind")
'	Call ResRw(CARDAUTH_Input,"CARDAUTH_Input")
'	Response.end
'▣카드결제 정보 E


'▣다우결제 정보 S
	ORDERNO			= pRequestTF("ORDERNO",True)
	AMOUNT			= pRequestTF("AMOUNT",True)
	EMAIL			= pRequestTF("EMAIL",False)
	USERID			= pRequestTF("USERID",True)
	USERNAME		= pRequestTF("USERNAME",False)
	PRODUCTCODE		= pRequestTF("PRODUCTCODE",False)
	PRODUCTNAME		= pRequestTF("PRODUCTNAME",False)
	TELNO1			= pRequestTF("TELNO1",False)
	TELNO2			= pRequestTF("TELNO2",False)
	RESERVEDINDEX1	= pRequestTF("RESERVEDINDEX1",False)
	RESERVEDINDEX2	= pRequestTF("RESERVEDINDEX2",False)
	'RESERVEDSTRING	= pRequestTF("RESERVEDSTRING",False)
	RESERVEDSTRING	= ""			'-9909 : 파라미터값 최대크기 초과(100byte). 에러 방지, 일반결제 시도후 API수기결제 시도 시 RESERVEDSTRING에 담겼던 값 최대크기 초과 2018-01-16

	PRODUCTTYPE		= "2"
	BILLTYPE		= "13"
	FAXFREECD		= "00"
	IPADDRESS		= Request.Servervariables("REMOTE_ADDR")
	CARDPASSWORD	= cardPass
	CardYYMM		= AuthYY&AuthMM
	CARDAUTH		= CARDAUTH_Input		'cardKind분기값

'	Call ResRw(AuthYY,"AuthYY")
'	Call ResRw(AuthMM,"AuthMM")
'	Call ResRw(CardYYMM,"CardYYMM")
'	Call ResRw(CardPass,"CardPass")
'	Call ResRw(quota,"quota")
'	Call ResRw(birth,"birth")
'	Call ResRw(ORDERNO,"ORDERNO")
'	Call ResRw(AMOUNT,"AMOUNT")
'	Call ResRw(USERID,"USERID")
'	Call ResRw(EMAIL,"EMAIL")
'	Call ResRw(USERNAME,"USERNAME")
'	Call ResRw(PRODUCTCODE,"PRODUCTCODE")
'	Call ResRw(RESERVEDSTRING,"RESERVEDSTRING")
'▣다우결제 정보 E





	payway		= "card"
	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID
	state		= "101"

	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0
	If takeTel = "" Then takeTel = ""
	If takeMob = "" Then takeMob = ""




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

'	'◆ 포인트 미사용시 =================================================================================================
'		If CDbl(usePoint) > 0 Then Call ALERTS(LNG_JS_POINT_UNAVAILABLE&" - (무통장결제)","GO",GO_BACK_ADDR)
'		If CDbl(usePoint2) > 0 Then Call ALERTS(LNG_JS_POINT2_UNAVAILABLE&" - (무통장결제)","GO",GO_BACK_ADDR)
'	'◆ 포인트 미사용시 =================================================================================================

	If CDbl(totalPrice) < 1000 And (CDbl(usePoint) + CDbl(usePoint2)) > 0 Then Call ALERTS("카드결제시 결제금액이 최소 1000원 이상이어야 합니다","GO",GO_BACK_ADDR)

	If CDbl(totalPrice) <> CDbl(AMOUNT)  Then Call ALERTS("결제할 카드금액과 실제결제된 카드결제금액(AMOUNT)이 다릅니다.","GO",GO_BACK_ADDR)

'▣ 결제금 체크(포인트) E


'▣ 웹주문번호 중복체크 S
	ORDER_DUP_CNT = 0
	SQLNC1 = "SELECT COUNT(*) FROM [DK_ORDER] WITH (NOLOCK) WHERE [ordernum] = ?"
	arrParamsNC1 = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,OrderNum) _
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
		Dim  Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		'Dim LogPath2 : LogPath2 = Server.MapPath ("/PG/DAOU/cardShop/te_") & Replace(Date(),"-","") & ".log"
		Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine "Date			: "	& now()
		Sfile2.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
		Sfile2.WriteLine "=== Order Info ============================="
		Sfile2.WriteLine "inUidx			 : " & inUidx
		Sfile2.WriteLine "takeName		 : " & takeName
		Sfile2.WriteLine "mbid1			 : " & DK_MEMBER_ID1
		Sfile2.WriteLine "mbid2			 : " & DK_MEMBER_ID2
		Sfile2.WriteLine "ori_price(total)	 : " & ori_price
		Sfile2.WriteLine "totalPrice		 : " & totalPrice
		Sfile2.WriteLine "totalDelivery		 : " & totalDelivery
		Sfile2.WriteLine "totalOptionPrice	 : " & totalOptionPrice
		Sfile2.WriteLine "totalPoint		 : " & totalPoint
		Sfile2.WriteLine "strOption		 : " & strOption
		Sfile2.WriteLine "totalVotePoint		 : " & totalVotePoint
		Sfile2.WriteLine "cuidx			 : " & cuidx
		Sfile2.WriteLine "paykind			 : " & paykind
		Sfile2.WriteLine "v_SellCode		 : " & v_SellCode
		Sfile2.WriteLine "usePoint		 : " & usePoint
		Sfile2.WriteLine "usePoint2		 : " & usePoint2
		Sfile2.WriteLine "isDownOrder		 : " & isDownOrder
		Sfile2.WriteLine "DtoD			 : " & DtoD
		Sfile2.WriteLine "============================================="

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine "--- Card Connect -----------------------------"
		Sfile2.WriteLine "Browser			: "	& Request.ServerVariables("HTTP_USER_AGENT")
		Sfile2.WriteLine "IPADDRESS		: "	& IPADDRESS
		Sfile2.WriteLine "CP_ID			: "	& CP_ID
		Sfile2.WriteLine "ORDERNO			: "	& ORDERNO
		Sfile2.WriteLine "PRODUCTTYPE		: " & PRODUCTTYPE
		Sfile2.WriteLine "BILLTYPE		: " & BILLTYPE
		Sfile2.WriteLine "FAXFREECD		: " & FAXFREECD
		Sfile2.WriteLine "AMOUNT			: " & AMOUNT
		Sfile2.WriteLine "USERID			: " & USERID
		Sfile2.WriteLine "USERNAME		: " & USERNAME
		Sfile2.WriteLine "PRODUCTCODE		: " & PRODUCTCODE
		Sfile2.WriteLine "PRODUCTNAME		: " & PRODUCTNAME
		Sfile2.WriteLine "RESERVEDINDEX1	: " & RESERVEDINDEX1
		Sfile2.WriteLine "RESERVEDINDEX2	: " & RESERVEDINDEX2
		Sfile2.WriteLine "RESERVEDSTRING	: " & RESERVEDSTRING
		Sfile2.WriteLine "---------------------------------------------"

		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing
		On Error GoTo 0



		Function CheckSpace(CheckValue)
		 CheckValue = trim(CheckValue)                      '양쪽공백을 없애준다.
		 CheckValue = replace(CheckValue, "&nbsp;", "")  '  html &nbsp; <-공백  을  "" <과 같이 붙인다.
		 CheckValue = replace(CheckValue, " ", "")  '  " " <-공백을 "" <- 붙인다.
		 CheckSpace=CheckValue
		End Function

	'▣주문정보 암호화
	'	If DKCONF_SITE_ENC = "T" AND DK_MEMBER_TYPE <> "COMPANY" Then
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If strADDR1		<> "" Then strADDR1			= objEncrypter.Encrypt(strADDR1)
				If strADDR2		<> "" Then strADDR2			= objEncrypter.Encrypt(strADDR2)
				If strTel		<> "" Then strTel			= objEncrypter.Encrypt(strTel)
				If strMob		<> "" Then strMob			= objEncrypter.Encrypt(strMob)
				If takeTel		<> "" Then takeTel			= objEncrypter.Encrypt(takeTel)
				If takeMob		<> "" Then takeMob			= objEncrypter.Encrypt(takeMob)
				If takeADDR1	<> "" Then takeADDR1		= objEncrypter.Encrypt(takeADDR1)
				If takeADDR2	<> "" Then takeADDR2		= objEncrypter.Encrypt(takeADDR2)
				If strEmail		<> "" Then strEmail			= objEncrypter.Encrypt(strEmail)
			Set objEncrypter = Nothing
		End If


'			Call ResRW(inUidx,"장바구니 확인")

'			Call ResRw(strDomain,"도메인")
'			Call ResRw(OrderNum,"주문번호")
'			Call ResRw(strIDX,"쿠키값")
'			Call ResRw(strUserID,"유저아이디")
'			Call ResRw(payWay,"결제방식")
'			Call ResRw(totalPrice,"총 결제금액")
'			Call ResRw(totalDelivery,"총 배송비")
'			Call ResRw(totalOptionPrice,"총 옵션가")
'			Call ResRw(totalPoint,"총 포인트")
'			Call ResRw(strName,"이름")
'			Call ResRw(strTel,"전화")
'			Call ResRw(strMob,"휴대전화")
'			Call ResRw(strEmail,"이메일")
'			Call ResRw(strZip,"우편번호")
'			Call ResRw(strADDR1,"주소1")
'			Call ResRw(strADDR2,"주소2")
'			Call ResRw(takeName,"받는이")
'			Call ResRw(takeTel,"받는이 연락처")
'			Call ResRw(takeMob,"받는이 휴대전화")
'			Call ResRw(takeZip,"받는이 우편번호")
'			Call ResRw(takeADDR1,"받는이 주소1")
'			Call ResRw(takeADDR2,"받는이 주소2")
'			Call ResRw(state,"상태")
'			Call ResRw(orderMemo,"배송메모")
'			Call ResRw(strSSH1,"주민등록번호1")
'			Call ResRw(strSSH2,"주민등록번호2")


	PRODUCTNAME = Left(PRODUCTNAME,30)		'errcode: -9909 파라미터값 최대크기 초과		추가2018-10-17

'************************************************************************************************************
	Set daou = Server.CreateObject("CardDaouPay.CardAgentAPI.1")

	ret = daou.CardOrder(CP_ID	 , _
			 ORDERNO         , _
			 PRODUCTTYPE     , _
			 BILLTYPE        , _
			 FAXFREECD       , _
			 AMOUNT          , _
			 IPADDRESS       , _
			 EMAIL           , _
			 USERID          , _
			 USERNAME        , _
			 PRODUCTCODE     , _
			 PRODUCTNAME     , _
			 TELNO1     	 , _
			 TELNO2     	 , _
			 RESERVEDINDEX1  , _
			 RESERVEDINDEX2  , _
			 RESERVEDSTRING  , _
			 r_RESULTCODE    , _
			 r_ERRORMESSAGE  , _
			 r_ORDERNO       , _
			 r_AMOUNT        , _
			 r_ORDERDATE     , _
			 r_DAOUTRX       , _
			 r_KCPPGID	 , _
			 r_CPNAME        , _
			 r_ESCROWFLAG    , _
			 r_DAOURESERVED1 , _
			 r_DAOURESERVED2 )

	On Error Resume Next
	Dim Fso3 : Set  Fso3=CreateObject("Scripting.FileSystemObject")
	Dim LogPath3 : LogPath3 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
	Dim Sfile3 : Set  Sfile3 = Fso3.OpenTextFile(LogPath3,8,true)

		If ret <> 0 Then
			retMsg = daou.GETERRORMSG(ret)
			Sfile3.WriteLine "---ERROR------------------------------------------"
			Sfile3.WriteLine "ret	: " & ret
			Sfile3.WriteLine "retMsg	: " & retMsg
			Sfile3.WriteLine "---------------------------------------------"
			'Call ALERTS("결제가 정상적으로 이루어 지지 않았습니다. 오류코드 ["&ret&"] 이며 오류내용은 ["&retMsg&"] 입니다","GO",GO_BACK_ADDR)
			'Response.Write "{""statusCode"":"""&ret&""",""message"":"""&server.urlencode("1"&retMsg)&""",""result"":""""}"
			Response.Write "{""statusCode"":"""&ret&""",""message"":"""&retMsg&""",""result"":""""}"
			Response.End
		End If

		If r_ResultCode <> "0000" Then
			Sfile3.WriteLine "---ERROR------------------------------------------"
			Sfile3.WriteLine "r_RESULTCODE	: " & r_RESULTCODE
			Sfile3.WriteLine "r_ERRORMESSAGE	: " & r_ERRORMESSAGE
			Sfile3.WriteLine "---------------------------------------------"
			Call ALERTS("결제가 정상적으로 이루어 지지 않았습니다. 오류코드 ["&r_RESULTCODE&"] 이며 오류내용은 ["&r_ERRORMESSAGE&"] 입니다","GO",GO_BACK_ADDR)
			'Response.Write "{""statusCode"":"""&r_RESULTCODE&""",""message"":"""&server.urlencode("2"&r_ERRORMESSAGE)&""",""result"":""""}"
			Response.End
		End If

		Sfile3.WriteLine "--- Card Connect Result-----------------------------"
		Sfile3.WriteLine "ORDERNO			: "	& ORDERNO
		Sfile3.WriteLine "ret				: "	& ret & "[" & daou.GETERRORMSG(ret) & "]"
		Sfile3.WriteLine "r_RESULTCODE		: "	& r_RESULTCODE
		Sfile3.WriteLine "r_ERRORMESSAGE	: " & r_ERRORMESSAGE
		Sfile3.WriteLine "r_ORDERNO			: " & r_ORDERNO
		Sfile3.WriteLine "r_AMOUNT			: " & r_AMOUNT
		Sfile3.WriteLine "r_ORDERDATE		: " & r_ORDERDATE
		Sfile3.WriteLine "r_DAOUTRX			: " & r_DAOUTRX
		Sfile3.WriteLine "r_KCPPGID			: " & r_KCPPGID
		Sfile3.WriteLine "r_CPNAME			: " & r_CPNAME
		Sfile3.WriteLine "r_ESCROWFLAG		: " & r_ESCROWFLAG
		Sfile3.WriteLine "r_DAOURESERVED1	: " & r_DAOURESERVED1
		Sfile3.WriteLine "r_DAOURESERVED2	: " & r_DAOURESERVED2
		Sfile3.WriteLine "---------------------------------------------"



		Dim DAOUTRX				: DAOUTRX		= r_DAOUTRX
		Dim PAYMETHOD			: PAYMETHOD		= "SSL"
		Dim ENC_INFO			: ENC_INFO		= CardNo
		Dim ENC_DATA			: ENC_DATA		= CardYYMM
		Dim NOINTFLAG			: NOINTFLAG		= ""

		Sfile3.WriteLine "--- Card Auth Connect -----------------------------"
		Sfile3.WriteLine "ORDERNO			: "	& ORDERNO
		Sfile3.WriteLine "CP_ID				: "	& CP_ID
		Sfile3.WriteLine "DAOUTRX			: "	& DAOUTRX
		Sfile3.WriteLine "PAYMETHOD			: " & PAYMETHOD
		Sfile3.WriteLine "AMOUNT			: " & AMOUNT
		Sfile3.WriteLine "QUOTA				: " & QUOTA
		Sfile3.WriteLine "NOINTFLAG			: " & NOINTFLAG
		Sfile3.WriteLine "cardKind			: " & cardKind
		Sfile3.WriteLine "---------------------------------------------"

		ret1 = daou.CardAuth(CP_ID	 , _
				 DAOUTRX         , _
				 PAYMETHOD     , _
				 AMOUNT          , _
				 ENC_INFO       , _
				 ENC_DATA           , _
				 QUOTA          , _
				 NOINTFLAG        , _
				 CARDAUTH     , _
				 CARDPASSWORD     , _
				 r1_RESULTCODE    , _
				 r1_ERRORMESSAGE  , _
				 r1_DAOUTRX       , _
				 r1_AMOUNT        , _
				 r1_ORDERNO        , _
				 r1_AUTHDATE     , _
				 r1_AUTHNO       , _
				 r1_NOINTFLAG	 , _
				 r1_QUOTA        , _
				 r1_CPNAME    , _
				 r1_CPURL , _
				 r1_CPTELNO , _
				 r1_DAOURESERVED1 , _
				 r1_DAOURESERVED2 )

		Sfile3.WriteLine "--- Card Auth Result -----------------------------"
		Sfile3.WriteLine "ORDERNO			: "	& ORDERNO
		Sfile3.WriteLine "ret				: "	& ret1 & "[" & daou.GETERRORMSG(ret1) & "]"
		Sfile3.WriteLine "r1_RESULTCODE		: "	& r1_RESULTCODE
		Sfile3.WriteLine "r1_ERRORMESSAGE	: " & r1_ERRORMESSAGE
		Sfile3.WriteLine "r1_DAOUTRX		: " & r1_DAOUTRX
		Sfile3.WriteLine "r1_AUTHDATE		: " & r1_AUTHDATE
		Sfile3.WriteLine "r1_AUTHNO			: " & r1_AUTHNO
		Sfile3.WriteLine "r1_NOINTFLAG		: " & r1_NOINTFLAG
		Sfile3.WriteLine "r1_QUOTA			: " & r1_QUOTA
		Sfile3.WriteLine "r1_CPNAME			: " & r1_CPNAME
		Sfile3.WriteLine "r1_CPURL			: " & r1_CPURL
		Sfile3.WriteLine "r1_CPTELNO		: " & r1_CPTELNO
		Sfile3.WriteLine "r1_DAOURESERVED1	: " & r1_DAOURESERVED1
		Sfile3.WriteLine "r1_DAOURESERVED2	: " & r1_DAOURESERVED2
		Sfile3.WriteLine "---------------------------------------------"

		If ret1 <> 0 Then
			ret1Msg = daou.GETERRORMSG(ret1)
			Sfile3.WriteLine "---ERROR------------------------------------------"
			Sfile3.WriteLine "ret1	: " & ret1
			Sfile3.WriteLine "retMsg	: " & ret1Msg
			Sfile3.WriteLine "---------------------------------------------"
			Call ALERTS("결제가 정상적으로 이루어 지지 않았습니다. 오류코드 ["&ret1&"] 이며 오류내용은 ["&ret1Msg&"] 입니다","GO",GO_BACK_ADDR)
			'Response.Write "{""statusCode"":"""&ret1&""",""message"":"""&server.urlencode(ret1Msg)&""",""result"":""""}"
			Response.End
		End If

		If r1_ResultCode <> "0000" Then
			Sfile3.WriteLine "---ERROR------------------------------------------"
			Sfile3.WriteLine "r1_RESULTCODE	: " & r1_RESULTCODE
			Sfile3.WriteLine "r1_ERRORMESSAGE	: " & r1_ERRORMESSAGE
			Sfile3.WriteLine "---------------------------------------------"
			Call ALERTS("결제가 정상적으로 이루어 지지 않았습니다. 오류코드 ["&r1_RESULTCODE&"] 이며 오류내용은 ["&r1_ERRORMESSAGE&"] 입니다","GO",GO_BACK_ADDR)
			'Response.Write "{""statusCode"":"""&r1_RESULTCODE&""",""message"":"""&server.urlencode(r1_ERRORMESSAGE)&""",""result"":""""}"
			Response.End
		End If




	'/*-- 카드사 정보 -------------*/
	PGCardNum_MACCO	= Left(CardNo,6)	'카드번호 6자리(직판신고용 ,2016-09-19)
	PGCardNum		= CardNo			'카드번호 12자리
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

	PGorderNum		= r1_DAOUTRX							'다우거래번호
	PGAcceptNum		= r1_AUTHNO								'신용카드 승인번호
	PGinstallment	= ""									'할부기간
	PGCardCode		= DAOUPAY_CARDCODE(r1_DAOURESERVED1)	'신용카드사코드
	PGCardCom		= ""									'신용카드발급사
	status101Date	= r1_AUTHDATE							'승인날짜/시각


	Sfile3.WriteLine "PGCardCode	: " & PGCardCode


	Sfile3.Close
	Set Fso3= Nothing
	Set objError= Nothing
	On Error GoTo 0

'************************************************************************************************************




	If r1_ResultCode = "0000" Then



		Call Db.beginTrans(Nothing)

		'▣주문정보 암호화
		'	If DKCONF_SITE_ENC = "T" AND DK_MEMBER_TYPE <> "COMPANY" Then
			If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					If PGAcceptNum	<> "" Then PGAcceptNum	= objEncrypter.Encrypt(PGAcceptNum)
				Set objEncrypter = Nothing
			End If


			SQL = " INSERT INTO [DK_ORDER] ( "
			SQL = SQL & " [strDomain],[OrderNum],[strIDX],[strUserID],[payWay] "
			SQL = SQL & " ,[totalPrice],[totalDelivery],[totalOptionPrice],[totalPoint],[strName] "
			SQL = SQL & " ,[strTel],[strMob],[strEmail],[strZip],[strADDR1] "
			SQL = SQL & " ,[strADDR2],[takeName],[takeTel],[takeMob],[takeZip] "
			SQL = SQL & " ,[takeADDR1],[takeADDR2],[status],[orderMemo],[strSSH1] "
			SQL = SQL & " ,[strSSH2],[bankIDX],[BankingName],[usePoint],[totalVotePoint] "

			SQL = SQL & " ,[PGorderNum],[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode]"
			SQL = SQL & " ,[PGCardCom],[PGCOMPANY]"
			SQL = SQL & " ,[strNationCode]"
			SQL = SQL & " ,[usePoint2]"

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
			SQL = SQL & " ,? "
			SQL = SQL & " ); "
			SQL = SQL & "SELECT ? = @@IDENTITY"
			arrParams = Array( _
				Db.makeParam("@strDomain",adVarchar,adParamInput,50,strDomain), _
				Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum), _
				Db.makeParam("@strIDX",adVarchar,adParamInput,50,strIDX), _
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
				Db.makeParam("@payWay",adVarchar,adParamInput,6,payWay), _

				Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
				Db.makeParam("@totalDelivery",adInteger,adParamInput,0,totalDelivery), _
				Db.makeParam("@totalOptionPrice",adInteger,adParamInput,0,totalOptionPrice), _
				Db.makeParam("@totalPoint",adInteger,adParamInput,0,totalPoint), _
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
				Db.makeParam("@usePoint",adInteger,adParamInput,4,usePoint), _
				Db.makeParam("@totalVotePoint",adInteger,adParamInput,4,totalVotePoint), _

				Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,r1_DAOUTRX), _
				Db.makeParam("@PGCardNum",adVarchar,adParamInput,100,PGCardNum), _
				Db.makeParam("@PGAcceptNum",adVarchar,adParamInput,100,PGAcceptNum), _
				Db.makeParam("@PGinstallment",adVarchar,adParamInput,20,PGinstallment), _
				Db.makeParam("@PGCardCode",adVarchar,adParamInput,20,PGCardCode), _

				Db.makeParam("@PGCardCom",adVarchar,adParamInput,20,PGCardCom), _
				Db.makeParam("@PGCOMPANY",adVarchar,adParamInput,50,PGCOMPANY), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _

				Db.makeParam("@usePoint2",adInteger,adParamInput,4,usePoint2), _

				Db.makeParam("@identity",adInteger,adParamOutput,0,0) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			identity = arrParams(UBound(arrParams))(4)

			If state = "101" Then
				SQL = "UPDATE [DK_ORDER] SET [status] = '101', [status101Date] = getDate() WHERE [intIDX] = ?"
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,identity) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			End If



		On Error Resume Next
		Dim Fso4 : Set Fso4=CreateObject("Scripting.FileSystemObject")
		Dim LogPath4 : LogPath4 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile4 : Set  Sfile4 = Fso4.OpenTextFile(LogPath4,8,true)

		CSGoodCnt = 0

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
						SQL = SQL & ",[CSGoodsCode]"

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

							'▣CS상품정보 변동정보 통합
							arrParams_G = Array(_
								Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS_CSGoodsCode) _
							)
							Set DKRS_G = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams_G,DB3)
							If Not DKRS_G.BOF And Not DKRS_G.EOF Then
								RS_ncode		= DKRS_G("ncode")
								RS_price2		= DKRS_G("price2")
								RS_price4		= DKRS_G("price4")
								RS_price5		= DKRS_G("price5")
								RS_price6		= DKRS_G("price6")
								RS_SellCode		= DKRS_G("SellCode")
								RS_SellTypeName	= DKRS_G("SellTypeName")
							Else
								RS_price4 = 0
							End If
							Call closeRs(DKRS_G)


						Else
							Sfile4.WriteLine "존재하지 않는 상품구입을 시도했습니다.!"
							Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"존재하지 않는 상품구입을 시도")
						End If
						Call closeRS(DKRS)

						If DKRS_DelTF = "T" Then
							Sfile4.WriteLine "삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
							Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"삭제된 상품의 구매를 시도")
						End If
						If DKRS_isAccept <> "T" Then
							Sfile4.WriteLine "승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
							Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"승인되지 않은 상품의 구매를 시도")
						End If
						If DKRS_GoodsViewTF <> "T" Then
							Sfile4.WriteLine "더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
							Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"더이상 판매되지 않는 상품의 구매를 시도")
						End If

						Select Case DKRS_GoodsStockType
							Case "I"
							Case "N"
								If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
									Sfile4.WriteLine "남아있는 수량이 현재 구입하시려는 수량보다 적습니다. 새로고침 후 다시 시도해주세요."
									Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"남아있는 수량이 구입하려는 수량보다 적음")
								Else
									SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
									arrParams = Array(_
										Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
										Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
									)
									Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
								End If
							Case "S"
								Sfile4.WriteLine "품절상품. 새로고침 후 다시 시도해주세요."
								Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"품절상품")
							Case Else
								Sfile4.WriteLine  "수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요."
								Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"수량정보가 올바르지 않습니다.")
						End Select


					' 배송비 타입 확인
						If DKRS_GoodsDeliveryType = "SINGLE" Then
							GoodsDeliveryFeeType	= "선결제"
							GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS_GoodsDeliveryFee)
							GoodsDeliveryLimit		= 0
						ElseIf DKRS_GoodsDeliveryType = "BASIC" Then
							arrParams2 = Array(_
								Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
							)
							'Set DKRS2 = DB.execRs("DKPA_DELIVEY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
							Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
							If Not DKRS2.BOF And Not DKRS2.EOF Then
								DKRS2_FeeType		= DKRS2("FeeType")
								DKRS2_intFee		= Int(DKRS2("intFee"))
								DKRS2_intLimit		= Int(DKRS2("intLimit"))
							Else
								DKRS2_FeeType		= ""
								DKRS2_intFee		= ""
								DKRS2_intLimit		= ""
							End If
							Select Case LCase(DKRS2_FeeType)
								Case "free"
									GoodsDeliveryFeeType	= "무료배송"
									GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS2_intFee)
									GoodsDeliveryLimit		= DKRS2_intLimit
								Case "prev"
									GoodsDeliveryFeeType	= "선결제"
									GoodsDeliveryFee		= Int(DKRS2_intFee)
									GoodsDeliveryLimit		= DKRS2_intLimit
								Case "next"
									GoodsDeliveryFeeType	= "착불"
									GoodsDeliveryFee		= Int(DKRS2_intFee)
									GoodsDeliveryLimit		= DKRS2_intLimit
							End Select

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
						SQL = SQL & ",[isCSGoods],[CSGoodsCode]"
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
				Sfile4.WriteLine  "임시주문정보에서 삭제된 상품입니다."
				Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"임시주문정보에서 삭제된 상품입니다.")
			End If
		'◆ #8. 임시주문 상품테이블에서 현 주문 상품 정보 호출(카트수량 변조 무시) E

		Sfile4.Close
		Set Fso4= Nothing
		Set objError= Nothing
		On Error GoTo 0



		On Error Resume Next
		Dim Fso5 : Set Fso5=CreateObject("Scripting.FileSystemObject")
		Dim LogPath5 : LogPath5 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile5 : Set  Sfile5 = Fso5.OpenTextFile(LogPath5,8,true)

		'▣ CS전산입력 S
			nowTime = Now
			RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
			Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

			If DK_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then 'CS회원이고 cs연동상품이 1개 이상 있는 경우

				v_C_Etc = PGCardCode&"/"&r1_DAOUTRX&"/"&orderNum ' 카드사코드/다우거래번호/주문번호


					If CSGoodCnt > 0 Then

						orderType		 = v_SellCode
						GoodsDeliveryFee = totalDelivery

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
						SQL2 = SQL2 & " ,[InputMileage2]"
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
							Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
							Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2),_
							Db.makeParam("@totalPrice",adInteger,adParamInput,4,totalPrice),_

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
							Db.makeParam("@deliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_
							Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
							Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,PGAcceptNum),_

							Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum),_
							Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
							Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,""),_
							Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode),_
							Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,""),_

							Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,DAOU_SETTDATE),_
							Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _

							Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _

								Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

								Db.makeParam("@InputMileage2",adInteger,adParamInput,4,usePoint2), _


							Db.makeParam("@CS_IDENTITY",adInteger,adParamOutPut,4,0) _
						)
						Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
						CS_IDENTITY = arrParams2(Ubound(arrParams2))(4)
						'Sfile5.WriteLine "CS_IDENTITY : "&CS_IDENTITY
						'Sfile5.WriteLine "identity : "&identity

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
										Db.makeParam("@GoodsPrice",adInteger,adParamInput,4,DKRS6_price2), _
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
							If (CDbl(CStr(WEBDB_TOTAL_PRICE)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Or (CDbl(CStr(totalPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE))) Then
								Sfile5.WriteLine  "결제금액의 변조되었습니다.01"
								Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"결제금액의 변조되었습니다.01")
							End If

							'■전체상품 가격 변경■
							SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
							arrParams9 = Array(_
								Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
								Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
							)
							Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

							arrParams = Array(_
								Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
								Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

								Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
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

							'■배송시 요청사항 CS입력
							If orderMemo <> "" Then
								SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "  'nvarchar(500)
								arrParams_RECE = Array(_
									Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
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

							Sfile5.WriteLine "CS_ORDERNUMBER : " & OUT_ORDERNUMBER





						Else
							Sfile5.WriteLine  "CS임시주문정보에서 삭제된 상품입니다."
							Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"CS임시주문정보에서 삭제된 상품입니다.")
						End If


					End If




			Else

				'Response.Write DAOU_SUCCESS
			End If
		'▣ CS전산입력 E

		Sfile5.Close
		Set Fso5= Nothing
		Set objError= Nothing
		On Error GoTo 0



	ALERTS_MESSAGE = ""

	'=== 직판공제번호발급 ====
	If isMACCO = "T" And CSGoodCnt > 0  And DK_MEMBER_TYPE = "COMPANY" Then
%>
	<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
<%
	End if




		Call Db.finishTrans(Nothing)


		On Error Resume Next
		Dim Fso6 : Set Fso6=CreateObject("Scripting.FileSystemObject")
		Dim LogPath6 : LogPath6 = Server.MapPath (CardLogss&"/te_") & Replace(Date(),"-","") & ".log"
		Dim Sfile6 : Set  Sfile6 = Fso6.OpenTextFile(LogPath6,8,true)
			Sfile6.WriteLine "ERROR11 : "&Err.Number

			If Err.Number <> 0 Then
				'Call ALERTS(LNG_ALERT_UPDATE_ERROR,"GO",GO_BACK_ADDR)
				Sfile6.WriteLine "ERROR : "&Err.Number
				Call PG_DAOU_K_CANCEL(PGorderNum,AMOUNT,isDirect,GoodIDX,chgPage,"자료를 등록하는 도중 에러가 발생하였습니다. 관리자에게 문의하여 주십시오")
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

				Call gotoURL(chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
				'Call ALERTS(LNG_ALERT_ORDER_OK&"\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/shop/order_finish.asp?orderNum="&OrderNum)
			End If

		Sfile6.WriteLine chr(13)
		Sfile6.WriteLine chr(13)
		Sfile6.Close
		Set Fso6= Nothing
		Set objError= Nothing


	End If




%>

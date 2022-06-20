<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'2021 표준수정

	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "ORDER1-1"

	Call ONLY_MEMBER(DK_MEMBER_LEVEL)


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


''	Dim C_codeName			: C_codeName		= Trim(Request.Form("C_codeName"))
''	Dim C_NAME2				: C_NAME2			= Trim(Request.Form("C_NAME2"))
	Dim bankidx				: bankidx			= pRequestTF("bankidx",False)
	Dim bankingName			: bankingName		= pRequestTF("bankingName",False)
	Dim memo1				: memo1				= pRequestTF("memo1",False)					'입금예정일

	Dim OIDX				: OIDX				= pRequestTF("OIDX",True)					'◆ #5. 임시주문테이블 idx

	Dim v_SellCode			: v_SellCode		= pRequestTF("v_SellCode",True)
	Dim SalesCenter			: SalesCenter		= pRequestTF("SalesCenter",False)			'판매센터
	Dim DtoD				: DtoD				= pRequestTF("DtoD",False)

	usePoint  = Replace(usePoint,",","")
	usePoint2 = Replace(usePoint2,",","")

	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

'▣개별 변수 받아오기 (마이오피스 구매 기본정보) E

'▣isDirect or Cart 체크 S
	isDirect		= "F"
	GoodIDX			= Trim(pRequestTF("GoodIDX",False))

	If LCase(orderMode) = "mobile" Then
		chgPage = "/m"
	Else
		chgPage = ""
	End If

'▣isDirect or Cart 체크 E

'♠ GO_BACK_ADDR 주문페이지로 보내기 S♠
	gidx = inUidx

	On Error Resume Next
	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		gidx = Trim(StrCipher.Encrypt(gidx,EncTypeKey1,EncTypeKey2))
	Set StrCipher = Nothing
	On Error GoTo 0

	GO_BACK_ADDR = chgPage&"/Myoffice/buy/cart_directB.asp?gidx="&gidx
'♠ GO_BACK_ADDR 주문페이지로 보내기 E♠


	If usePoint = Null Or usePoint = "" Then usePoint = 0
	If usePoint2 = Null Or usePoint2 = "" Then usePoint2 = 0

	If IsNull(strEmail) Then print "널"
	If strEmail = "" Then print "빈값"


	If CDbl(ori_price) <> (CDbl(usePoint) + CDbl(usePoint2)) Then Call ALERTS(LNG_JS_TOTAL_AMOUNT_DIFFERS_FROM_POINT_USE,"GO",GO_BACK_ADDR)
	If CDbl(usePoint)  < CDbl(1)			  Then Call ALERTS(LNG_JS_POINT,"GO",GO_BACK_ADDR)
	If CDbl(usePoint)  > CDbl(MILEAGE_TOTAL)  Then Call ALERTS(LNG_JS_POINT_EXCEEDED,"GO",GO_BACK_ADDR)
	If CDbl(usePoint2) > CDbl(MILEAGE2_TOTAL) Then Call ALERTS(LNG_JS_POINT2_EXCEEDED,"GO",GO_BACK_ADDR)

'	Call ResRw(totalPrice,"totalPrice")
'	Call ResRw(TOTAL_SP_POINTUSE_MAX,"TOTAL_SP_POINTUSE_MAX")

	'If CDbl(totalPrice) <> CDbl(0) Then	Call ALERTS("결제 포인트 사용금액 오류!!","GO",GO_BACK_ADDR)
	If CDbl(totalPrice) <> CDbl(0) Then	Call ALERTS(LNG_JS_POINT_USAGE_ERROR,"GO",GO_BACK_ADDR)



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

	'totalPrice = usePoint							'▣마일리지 단독 구매시 : totalPrice = 포인트사용값으로 치환!!
	totalPrice = CDbl(usePoint) + CDbl(usePoint2)



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
		Call ALERTS(LNG_JS_TEMPORARY_ORDER_DELETED,"GO",GO_BACK_ADDR)
	End If
	'◆ #6. cs 구매상품 1차 확인! E ◆◆◆

%>
<%

	v_C_Etc = ""

	DKRS_BANK_BankCode		= ""
	DKRS_BANK_BankName		= ""
	DKRS_BANK_BankOwner		= ""
	DKRS_BANK_BankNumber	= ""
	bankingName				= ""


	'◈CS신버전  암호화!!
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If DKRS_BANK_BankNumber		<> "" Then DKRS_BANK_BankNumber	= objEncrypter.Encrypt(DKRS_BANK_BankNumber)

			If DKCONF_ISCSNEW = "T" Then
				If takeTel			<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
				If takeMob			<> "" Then takeMob				= objEncrypter.Encrypt(takeMob)
				If takeADDR1		<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
				If takeADDR2		<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
				If strEmail			<> "" Then strEmail				= objEncrypter.Encrypt(strEmail)
			End If
		Set objEncrypter = Nothing
	End If


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
		Db.makeParam("@InputMileage",adInteger,adParamInput,0,usePoint), _
		Db.makeParam("@InputMileage2",adInteger,adParamInput,0,usePoint2), _
		Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_ORDER_POINT_INFO_UPDATE",DB_PROC,arrParams,DB3)
	'Call Db.exec("DKP_ORDER_INBANK_INFO_UPDATE",DB_PROC,arrParams,DB3)
	'Call Db.exec("DKP_ORDER_OTHER_INFO_UPDATE",DB_PROC,arrParams,DB3)

%>
<%

	CS_IDENTITY		= OIDX
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
		CHK_GoodsPrice = CDbl(GoodsPrice) + CDbl(GoodsDeliveryFee)
		If CDbl(CStr(CHK_GoodsPrice)) <> CDbl(CStr(DKCS_TOTAL_PRICE)) Then Call alerts("결제금액이 변조되었습니다.02","GO",GO_BACK_ADDR)

	'■전체상품 가격 변경■
		SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
		arrParams9 = Array(_
			Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
			Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
		)
		Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

	'v_Etc1 = "POINT :"&num2cur(usePoint)&", POINT2 :"&num2cur(usePoint2)
	v_Etc1 = "POINT :"&num2cur(usePoint)

	arrParams = Array(_
		Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

		Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_Etc1),_
		Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

		Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,""),_
		Db.makeParam("@v_C_Number1",adVarChar,adParamInput,50,""),_
		Db.makeParam("@v_C_Number2",adVarChar,adParamInput,20,""),_
		Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,DK_MEMBER_NAME),_
		Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

		Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
		Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
		Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,""),_

		Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_ORDER_TOTAL_NEW_POINT",DB_PROC,arrParams,DB3)
	OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	' 전산입력 종료



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

		Case "ERROR" : Call ALERTS(LNG_ALERT_ORDER_ERROR,"back","")
	End Select





%>

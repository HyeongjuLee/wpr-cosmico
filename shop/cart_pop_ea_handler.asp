<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/shop/cart_pop_ea.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	intIDX	= pRequestTF("idx",True)
	ea		= pRequestTF("ea",True)
	eaORG	= pRequestTF("eaORG",True)
	gIDX	= pRequestTF("gIDX",True)

	If ea < 1 Then Call ALERTS(LNG_CS_CART_JS08,"back","")

	'##################################################################
	'	최소구매수량 / 재고량 비교
	'################################################################## START
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,gIDX) _
		)
		Set DKRS = Db.execRs("DKP_GOODS_DETAILVIEW",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_GoodsStockType	= DKRS("GoodsStockType")
			DKRS_GoodsStockNum	= DKRS("GoodsStockNum")
			DKRS_intMinNot					= DKRS("intMinNot")
			DKRS_intMinAuth					= DKRS("intMinAuth")
			DKRS_intMinDeal					= DKRS("intMinDeal")
			DKRS_intMinVIP					= DKRS("intMinVIP")
		End If
		Call closeRs(DKRS)

		Select Case DK_MEMBER_LEVEL
			Case 0,1 '비회원, 일반회원
				DKRS_intMinimum = DKRS_intMinNot
			Case 2 '인증회원
				DKRS_intMinimum = DKRS_intMinAuth
			Case 3 '딜러회원
				DKRS_intMinimum = DKRS_intMinDeal
			Case 4,5 'VIP 회원
				DKRS_intMinimum = DKRS_intMinVIP
			Case 9,10,11
				DKRS_intMinimum = DKRS_intMinVIP
		End Select

		If DKRS_intMinimum = 0 Then DKRS_intMinimum = 1

		'0.최소구매수량 / 재고량 비교
		If DKRS_GoodsStockType = "N" And DKRS_intMinimum > DKRS_GoodsStockNum Then
			Call ALERTS("최소 구매수량("&DKRS_intMinimum&")보다 재고가("&DKRS_GoodsStockNum&") 부족합니다.","back","")
		End If

		'1.최소구매수량 확인
		If Int(ea) < Int(DKRS_intMinimum)Then
			Call ALERTS(LNG_SHOP_DETAILVIEW_07&"("&DKRS_intMinimum&")","back","")
		End If

		'2.재고비교
		If DKRS_GoodsStockType = "N" And DKRS_GoodsStockNum > 0 Then
			If Int(ea) > Int(DKRS_GoodsStockNum) Then
				Call ALERTS(LNG_SHOP_DETAILVIEW_06,"back","")
			End If
		End If
	'################################################################## END

	'갯수변경 로그
	Function Fnc_CART_Compare(ByVal FK_IDX, ByVal COMPARE1, ByVal COMPARE2,  ByVal COMPARETYPE,ByRef RESULT_CNT)
		If COMPARE1 <> COMPARE2 Then

			arrParams = Array(_
				Db.makeParam("@FK_IDX",adInteger,adParamInput,4,FK_IDX), _
				Db.makeParam("@strComName",adVarWChar,adParamInput,100,DK_MEMBER_ID),_
				Db.makeParam("@GoodIDX",adInteger,adParamInput,4,gIDX),_
				Db.makeParam("@strFieldName",adVarChar,adParamInput,50,COMPARETYPE), _
				Db.makeParam("@strFieldORG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE1), _
				Db.makeParam("@strFieldCHG",adVarWChar,adParamInput,MAX_LENGTH,COMPARE2), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@HostIP",adVarChar,adParamInput,20,getUserIP), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJPA_CART_CHG_LOG_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
			If OUTPUT_VALUE = "FINISH" Then
				RESULT_CNT = RESULT_CNT
				'PRINT COMPARETYPE
			Else
				RESULT_CNT = RESULT_CNT + 1
			End If

		End If

	End Function
	Call Fnc_CART_Compare(intIDX,CDbl(eaORG)	,CDbl(ea)	,"orderEa",RESULT_CNT)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
		Db.makeParam("@ea",adInteger,adParamInput,4,ea), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_CART_UPDATE_ONE_EA",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
%>
<link rel="stylesheet" href="/shop/cart_pop.css" />
</head>
<body>
<div id="pop_content" class="tcenter" style="line-height: 350px;">
<%
	If OUTPUT_VALUE = "FINISH" Then
		PRINT "<h2>"&DBFINISH&"</h2>"
	End If
%>
</div>
</body>
</html>
<%
	Select Case OUTPUT_VALUE
		'Case "FINISH" : Call ALERTS(DBFINISH,"o_reloada","")
		Case "FINISH" : Call ALERTS(DBFINISH,"p_reload","")			'Modal Dialog
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select
%>

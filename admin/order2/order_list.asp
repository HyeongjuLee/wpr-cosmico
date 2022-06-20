<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"


	Dim SEARCHTERM		:	SEARCHTERM = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request.Form("SEARCHSTR")
	Dim PAGESIZE		:	PAGESIZE = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE = Request.Form("PAGE")
	Dim schpayway		:	schpayway = Request.Form("schpayway")
	Dim minPrice		:	minPrice = Request.Form("minPrice")
	Dim maxPrice		:	maxPrice = Request.Form("maxPrice")


	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then	PAGE = 1
	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	If schpayway = "" Then  schpayway = ""
	If minPrice = "" Then minPrice = 0
	If maxPrice = "" Then maxPrice = 0


	menu = Request.QueryString("menu")
	If menu = "" Then menu = ""
	Select Case menu
		Case "new"
			qstate = "100"
			MAP_DEPTH2 = "주문관리"
			MAP_DEPTH3 = "신규(입금확인 전) 주문 리스트"
		Case "confirm"
			qstate = "101"
			MAP_DEPTH2 = "주문관리"
			MAP_DEPTH3 = "입금확인(배송준비중인) 주문 리스트"
		Case "delivery"
			qstate = "102"
			MAP_DEPTH2 = "주문관리"
			MAP_DEPTH3 = "배송완료(배송중인) 주문 리스트"
		Case "finish"
			qstate = "103"
			MAP_DEPTH2 = "주문관리"
			MAP_DEPTH3 = "구매확정(수취확인)된 주문 리스트"
		Case Else
			qstate = ""
			MAP_DEPTH2 = "전체주문"
			MAP_DEPTH3 = "전체주문리스트"
	End Select

	arrParams = Array(_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@STATE",adVarChar,adParamInput,3,menu), _
		Db.makeParam("@PAYWAY",adVarChar,adParamInput,30,schpayway), _
		Db.makeParam("@MINPRICE",adInteger,adParamInput,0,minPrice), _
		Db.makeParam("@MAXPRICE",adInteger,adParamInput,0,maxPrice), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutPut,0,0) _
	)
'	arrList = Db.execRsList("DKPA_ORDER_LIST",DB_PROC,arrParams,listLen,Nothing)
	arrList = Db.execRsList("DKPA_ORDER_LIST2",DB_PROC,arrParams,listLen,Nothing)
	ALL_COUNT = arrParams(8)(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If


%>
<link rel="stylesheet" href="/admin/css/orders.css" />
<script type="text/javascript" src="/admin/jscript/orders.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<iframe id="hidden" name="hidden" src="/hiddens.asp" width="800" height="200" style="display:none;"></iframe>

<form name="chgFrm" method="post">
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="hidDate" value="" />
</form>
<div id="order">
		<form name="searchform" method="post">
		<table <%=tableatt%> class="orderTable table1">
			<col width="200" />
			<col width="*" />
			<tr>
				<th>결제방식</th>
				<td>
					<label><input type="radio" name="schpayway" value="" class="input_radio" <%=isChecked(schpayway,"")%> />전체</label>
					<label><input type="radio" name="schpayway" value="inbank" class="input_radio" <%=isChecked(schpayway,"inbank")%> />온라인결제</label>
					<label><input type="radio" name="schpayway" value="card" class="input_radio" <%=isChecked(schpayway,"card")%>  />카드결제</label>
				</td>
			</tr><tr>
				<th>주문금액</th>
				<td>
					<input type="text" name="minPrice" class="input_text" value="<%=minPrice%>" /> 원 부터 <input type="text" name="maxPrice" class="input_text"  value="<%=maxPrice%>" /> 원까지
				</td>
			</tr><tr>
				<th>조건검색</th>
				<td>
					<select name="SEARCHTERM" class="select_s">
						<option value=''>조건선택</option>
						<option value=''>--------------</option>
						<option value='strUserID' <%=isSelect(SEARCHTERM,"strUserID")%>>아이디 검색</option>
						<option value='strName' <%=isSelect(SEARCHTERM,"strName")%>>주문자 이름</option>
						<option value='strEmail' <%=isSelect(SEARCHTERM,"strEmail")%>>주문자 이메일</option>
						<option value='takeName' <%=isSelect(SEARCHTERM,"takeName")%>>배송지 이름</option>
						<option value='takeTel' <%=isSelect(SEARCHTERM,"takeTel")%>>배송지 연락처</option>
						<option value='bankingName' <%=isSelect(SEARCHTERM,"bankingName")%>>입금자명</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text"  value="<%=SEARCHSTR%>" />
				</td>
			</tr><tr>
				<th>정렬방식</th>
				<td>
					<select name="pagesize" class="vmiddle">
						<option value="10" <%=isSelect(pagesize,"10")%>>10개씩 보기</option>
						<option value="20" <%=isSelect(pagesize,"20")%>>20개씩 보기</option>
						<option value="30" <%=isSelect(pagesize,"30")%>>30개씩 보기</option>
						<option value="40" <%=isSelect(pagesize,"40")%>>40개씩 보기</option>
						<option value="50" <%=isSelect(pagesize,"50")%>>50개씩 보기</option>
					</select>
					<input type="image" src="<%=IMG_BTN%>/g_list_search.gif" class="vmiddle" />
				</td>
			</tr>
		</table>
		</form>
		<table <%=tableatt%> class="orderTable table2">
			<colgroup>
				<col width="140" />
				<col width="120" />
				<col width="110" />
				<col width="110" />
				<col width="110" />
				<col width="120" />
				<col width="290" />
			</colgroup>
			<thead>
				<tr>
					<th>주문번호</th>
					<th>주문일시</th>
					<th>총 주문금액</th>
					<th>주문자</th>
					<th>아이디</th>
					<th>결제상태</th>
					<th>진행상태</th>
				</tr>
			</thead>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						arr_IDX					= arrList(1,i)
						arr_Domain				= arrList(2,i)
						arr_OrderNum			= arrList(3,i)
						arr_strIDX				= arrList(4,i)
						arr_strUserID			= arrList(5,i)
						arr_payWay				= arrList(6,i)
						arr_totalPrice			= arrList(7,i)
						arr_totalDelivery		= arrList(8,i)
						arr_totalOptionPrice	= arrList(9,i)
						arr_totalPoint			= arrList(10,i)
						arr_strName				= arrList(11,i)
						arr_strTel				= arrList(12,i)
						arr_strMob				= arrList(13,i)
						arr_strEmail			= arrList(14,i)
						arr_strZip				= arrList(15,i)
						arr_strADDR1			= arrList(16,i)
						arr_strADDR2			= arrList(17,i)
						arr_takeName			= arrList(18,i)
						arr_takeTel				= arrList(19,i)
						arr_takeMob				= arrList(20,i)
						arr_takeZip				= arrList(21,i)
						arr_takeADDR1			= arrList(22,i)
						arr_takeADDR2			= arrList(23,i)
						arr_orderMemo			= arrList(24,i)
						arr_strSSH1				= arrList(25,i)
						arr_strSSH2				= arrList(26,i)
						arr_Status				= arrList(27,i)
						arr_status100Date		= arrList(28,i)
						arr_status101Date		= arrList(29,i)
						arr_status102Date		= arrList(30,i)
						arr_status103Date		= arrList(31,i)
						arr_status104Date		= arrList(32,i)
						arr_status201Date		= arrList(33,i)
						arr_status301Date		= arrList(34,i)
						arr_status302Date		= arrList(35,i)
						arr_CancelCause			= arrList(36,i)
						arr_bankIDX				= arrList(37,i)
						arr_bankingName			= arrList(38,i)
						arr_usePoint			= arrList(39,i)
						arr_totalVotePoint		= arrList(40,i)

						arr_PGorderNum			= arrList(41,i)
						arr_PGCardNum			= arrList(42,i)
						arr_PGAcceptNum			= arrList(43,i)
						arr_PGinstallment		= arrList(44,i)
						arr_PGCardCode			= arrList(45,i)
						arr_PGCardCom			= arrList(46,i)

						chg_State = CallState(arr_Status)

						If UCase(arr_payWay) = "VBANK" Then
							DKRS_PGINPUT_BANKCODE = arr_PGinstallment
						End If
						
						If DKRS_PGinstallment = "00" Then
							DKRS_PGinstallment = "일시불"
						Else
							DKRS_PGinstallment = arr_PGinstallment &"개월"
						End If


						goBtn101 = aImg("javascript:go101Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_go101.gif",126,101,"")
						goBtn102 = aImg("javascript:go102Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_go102.gif",126,101,"")
						goBtn102n = aImg("javascript:alert('배송정보를 입력해주세요')",IMG_BTN&"/btn_order_go102n.gif",126,101,"")
						goBtn103 = aImg("javascript:go103Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_go103.gif",126,101,"")
						goBtn104 = viewImg(IMG_BTN&"/btn_order_104.gif",126,101,"")


						backBtn100 = aImg("javascript:back100Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						backBtn101 = aImg("javascript:back101Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						backBtn102 = aImg("javascript:back102Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")


						goBtnCancel = aImg("javascript:goCancelBtn('"&arr_IDX&"')",IMG_BTN&"/btn_order_go_cancel.gif",146,31,"")
						goBtnCancelN = aImg("javascript:alert('수취확인상태의 주문은 취소할 수 없습니다. 상태를 배송완료(배송중)중 이하로 변경해주세요.');",IMG_BTN&"/btn_order_go_cancelN.gif",146,31,"")
					'	goBtnDtoD = aImg("javascript:openDelivery('"&arr_IDX&"')",IMG_BTN&"/btn_order_dtod.gif",146,31,"")

						CancelStat201 = viewImg(IMG_BTN&"/btn_cancel_admin.gif",126,101,"")
						CancelStat301 = viewImg(IMG_BTN&"/btn_cancel_customer.gif",126,101,"")
						CancelStat401 = viewImg(IMG_BTN&"/btn_cancel_customer_f.gif",126,101,"")
						goCancelStat401 = aImg("javascript:goCancelUBtn('"&arr_IDX&"')",IMG_BTN&"/btn_cancel_user.gif",146,31,"")

						goBackCancel102 = aImg("javascript:backc100Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						goBackCancel103 = aImg("javascript:backc101Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
'						goBackCancel104 = aImg("javascript:backc102Btn('"&arr_IDX&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")

						Select Case UCase(arr_payWay)
							Case "INBANK"
								SQL = "SELECT * FROM [DK_BANK] WHERE [intIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@intIDX",adInteger,adParamInput,0,arr_bankIDX) _
								)
								Set RSS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
								If Not RSS.BOF And Not RSS.EOF Then
									setBankName = RSS(1)
									BankNumber = RSS(2)
									BankOwner = RSS(3)
								End If
								Call closeRS(RSS)
								arr_payWay = "온라인입금 <br />"
								arr_payWay = arr_payWay & "입금계좌 : " & setBankName & " " & BankNumber & ", 입금자명 : " & arr_bankingName
							Case "CARD"
								arr_payWay = "카드결제 <br />"
								arr_payWay = arr_payWay & "결제은행 : "& FN_INICIS_CARDCODE_VIEW(arr_PGCardCode) & "("& arr_PGCardCom &"**********) " &DKRS_PGinstallment
								
							Case "VBANK"
								arr_payWay = "가상계좌 <br />"
								arr_payWay = arr_payWay & "입금계좌 : " & FN_INICIS_BANKCODE_VIEW(DKRS_PGINPUT_BANKCODE) & " " & arr_PGCardNum & ", 입금자명 : " & arr_PGAcceptNum & ", 입금예정일 : " & date8to10(arr_PGCardCode)
							Case "DBANK"
								arr_payWay = "실시간계좌이체 <br />"
								arr_payWay = arr_payWay & "결제은행 : "& FN_INICIS_BANKCODE_VIEW(arr_PGCardCom)

						End Select





						PRINT "<tr>"
						PRINT "	<td class='td_centers'><strong>"&arr_OrderNum&"</strong></td>"
						PRINT "	<td class='td_centers'>"&DateValue(arr_status100Date)&"<br />"&TimeValue(arr_status100Date)&"</td>"
						PRINT "	<td class='td_centers'><strong>"&FormatNumber(arr_totalPrice,0)&" 원</strong></td>"
						PRINT "	<td class='td_centers'>"&arr_strName&"</td>"
						PRINT "	<td class='td_centers'>"&arr_strUserID&"</td>"
						PRINT "	<td class='td_centers'>"&chg_State&"</td>"
						PRINT "	<td class='td_centers' rowspan='5'>"
						PRINT "		<div class=""btnZoneLeft"">"
						Select Case arr_status
							Case "100" : PRINT goBtn101
							Case "101"
'								SQL = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
								SQL = "SELECT * FROM [DK_ORDER2_GOODS] WHERE [orderIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@intIDX",adInteger,adParamInput,0,arr_IDX) _
								)
								arrList2 = Db.execRsList(SQL,DB_TEXT,arrParams,listLen2,Nothing)
								chkCnt = 0
								If IsArray(arrList) Then
									For j = 0 To listLen2
										arrDtoD = arrList2(5,j)
										arrDtoDDate = arrList2(7,j)
										If arrDtoD = "" Or IsNull(arrDtoD) Or arrDtoDDate = "" Or IsNull(arrDtoDDate) Then
											chkCnt = chkCnt + 1
										Else
											chkCnt = chkCnt
										End If
									Next
								End If
								If chkCnt > 0 Then PRINT goBtn102n Else PRINT goBtn102 End If

							Case "102" : PRINT goBtn103

							Case "103" : PRINT goBtn104

							Case "201" : PRINT CancelStat201
							Case "301" : PRINT CancelStat301
							Case "302" : PRINT CancelStat401
						End Select
						PRINT "		</div>"
						PRINT "		<div class=""btnZoneRight"">"
						Select Case arr_status
							Case "100"
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "101"
								PRINT "<p class=""blines"">"&backBtn100&"</p>"
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "102"
								PRINT "<p class=""blines"">"&backBtn101&"</p>"
								PRINT "<p class=""blines"">"&goBtnCancel&"</p>"
							Case "103"
								PRINT "<p class=""blines"">"&backBtn102&"</p>"
								PRINT "<p class=""blines"">"&goBtnCancelN&"</p>"
							Case "201"
								PRINT "<p class=""blines"">"&goBackCancel102&"</p>"
								PRINT "<p class=""blines"">"&goBackCancel103&"</p>"
								PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
							Case "301"
								PRINT "<p class=""blines"">"&goCancelStat401&"</p>"
							Case "302"
								PRINT "<p class=""blines"">"&goBackCancel102&"</p>"
								PRINT "<p class=""blines"">"&goBackCancel103&"</p>"
								PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
						End Select
						PRINT "		</div>"

							calsGoodsPrice = 0
							realPrice = 0


						calsGoodsPrice = 0
						calsGoodsPrice = arr_totalPrice -  arr_totalDelivery '상품가격
						'포인트사용
						realPrice = 0
				'		print arrtotalPrice
				'		print arrtotalDelivery
				'		print arrUsePoint

						realPrice = calsGoodsPrice + arr_totalDelivery - arr_UsePoint

						'배송비

						PRINT "	</td>"
						PRINT "</tr><tr>"
						PRINT "	<th>결제금액내용</th>"
					'	PRINT "	<td colspan='5' class='td_lheight'>상품가격 : "&FormatNumber(calsGoodsPrice,0)&"원 + 배송비 : "&FormatNumber(arr_totalDelivery,0)&" - 포인트사용 : "&FormatNumber(arr_UsePoint,0)&"<br /><b>실제 결제금액 : "&FormatNumber(realPrice,0)&"원</b></td>"
						PRINT "	<td colspan='5' class='td_lheight'>상품가격 : "&FormatNumber(calsGoodsPrice,0)&"원 + 배송비 : "&FormatNumber(arr_UsePoint,0)&"<br /><b>실제 결제금액 : "&FormatNumber(realPrice,0)&"원</b></td>"
						PRINT "</tr><tr>"
						PRINT "	<th>결제정보</th>"
						PRINT "	<td colspan='5' class='td_lheight'>"&arr_payWay&"</td>"
						PRINT "</tr><tr>"
						PRINT "	<th>수령인</th>"
						PRINT "	<td colspan='5' class='td_lheight'>"&arr_takeName&" , "&arr_takeTel&" ("&arr_takeMob&")<br />["&arr_takeZip&"] "&backword(arr_takeADDR1)&" "&backword(arr_takeADDR2)&"</td>"
						PRINT "</tr><tr>"
						PRINT "	<th style=""padding:5px 0px;"">남김말</th>"
						PRINT "	<td colspan='5' class='td_lheight'>"&backword(arr_orderMemo)&"</td>"
						PRINT "</tr>"
						If arr_status = "301" Or arr_status = "302" Then
							PRINT "	<tr>"
							PRINT "	<th>취소사유</th>"
							PRINT "	<td colspan='4' class='td_lheight'>"&backword(arr_CancelCause)&"</td>"
							PRINT "	<th>취소요청일자</th>"
							PRINT "	<td class='td_lheight'>"&arr_status301Date&"</td>"
							PRINT "	</tr>"
						End If
						PRINT "	<tr>"
						PRINT "	<td colspan='7' class=""underline"">"
						PRINT "		<table "&tableatt&" class=""innerTable"">"
						PRINT "			<colgroup>"
						PRINT "				<col width=""90"">"
						PRINT "				<col width=""*"">"
						PRINT "				<col width=""130"">"
						PRINT "				<col width=""80"">"
						PRINT "				<col width=""350"">"
						PRINT "			</colgroup>"
						PRINT "			<thead>"
						PRINT "			<tr>"
						PRINT "				<td></td>"
						PRINT "				<td>주문상품</td>"
						PRINT "				<td>가격정보</td>"
						PRINT "				<td>수량</td>"
						PRINT "				<td>배송정보</td>"
						PRINT "			</tr>"
						PRINT "			</thead>"

						SQL = "SELECT A.[GoodIDX],A.[strOption],A.[orderEa],C.[img1Ori],B.[GoodsName], "
						SQL = SQL & " B.[GoodsPrice],A.[orderDtoD],A.[orderDtoDValue],A.[intIDX],B.[GoodsCost],B.[GoodsPrice],A.[orderDtoDDate],A.[goodsPrice] "
'							SQL = SQL & " FROM [DK_ORDER_GOODS] AS A "
'							SQL = SQL & " INNER JOIN [DK_GOODS] AS B "
						SQL = SQL & " FROM [DK_ORDER2_GOODS] AS A "
						SQL = SQL & " INNER JOIN [DK_GOODS2] AS B "
						SQL = SQL & " ON A.[GoodIDX] = B.[intIDX] "
'							SQL = SQL & " INNER JOIN [DK_GOODS_IMGS] AS C ON C.[goodsIDX] = B.[intIDX]"
						SQL = SQL & " INNER JOIN [DK_GOODS2_IMGS] AS C ON C.[goodsIDX] = B.[intIDX]"
						SQL = SQL & " WHERE A.[orderIDX] = ? "
						SQL = SQL & " ORDER BY A.[intIDX] DESC "
						arrParams = Array(_
							Db.makeParam("@Uidx",adInteger,adParamInput,0,arr_IDX) _
						)
						arrList1 = Db.execRsList(SQL,DB_TEXT,arrParams,listLen1,Nothing)

						If IsArray(arrList1) Then
							For j = 0 To listLen1
								arrSUBidx = arrList1(8,j)
								arrSUBname = backword(arrList1(4,j))
								arrSUBea = arrList1(2,j)
								arrSUBprice = arrList1(5,j)
								arrSUBimg = arrList1(3,j)
								gSUBoption = arrList1(1,j)
								arrBuyPrice = arrList1(9,j)
								arrPricess = arrList1(10,j)
								arrGoodsPrice = arrList1(12,j)

								If IsNull(gSUBoption) Then gSUBoption = ""
								arrSUBoption = Split(gSUBoption,",")

								arrDtoD = arrList1(6,j)
								arrDtoDValue = arrList1(7,j)
								arrDtoDDates = Left(arrList1(11,j),10)


								PRINT "		<tr>"
'								PRINT "			<td><img src='"&VIR_PATH("goods/img1")&"/"&arrSUBimg&"' class=""imgs"" /></td>"
								PRINT "			<td><img src='"&VIR_PATH("goods2/img1")&"/"&arrSUBimg&"' class=""imgs"" /></td>"
								PRINT "			<td class=""tleft""><strong>"&arrSUBname&"</strong><br /><span style='font-size:8pt;'>"
								arrtotalOptionPrice = 0
								For k = 0 To UBound(arrSUBoption)
									cutOption = Split(arrSUBoption(k),"\")
									PRINT cutOption(0) &" (+" &cutOption(1) &")" &"</span> <br />"
									arrtotalOptionPrice = cutOption(1)
								Next
									doptionPrice = arrtotalOptionPrice * arrSUBea
									dGoodsPrice = arrGoodsPrice * arrSUBea
								PRINT "			</td>"
								PRINT "			<td>판매가 : "&FormatNumber(dGoodsPrice,0)&" 원<br />"
								PRINT "				옵션가 : "&FormatNumber(doptionPrice,0)&" 원<br /></td>"
								PRINT "			<td>"&arrSUBea&"</td>"
								PRINT "			<td class=""tleft td_lheight td_dtod"">"
								If arr_status <> "101" Then
									readOnlys = " readonly=""readonly"""
									readOnlyc = " readonly"
									disables = " disabled=""disabled"""
									clickDate = " "
								Else
									readOnlys = ""
									readOnlyc = ""
									disables = ""
									clickDate = " onclick=""openCalendar(event, this, 'YYYY-MM-DD');"""
								End If
								PRINT "				<form name='dtodFrm' method='post' onsubmit='return thisfrm(this)'>"
								PRINT "				<p>배송일자 : <input type='text' name='dtodDate' value='"&arrDtoDDates&"' "&noDtoD&" class='input_text "&readOnlyc&"' "&clickDate&" "&disables&" /></p>"
								PRINT "				<p>배송업체 : <select name='dtod' "&noDtoD&" "&disables&">"
								PRINT "					<option value=''>배송업체선택</option>"
								PRINT "					<option value='date' style='color:red;'"&isSelect("0",arrDtoD)&">배송일자만 입력(직접수령, 퀵등)</option>"
								PRINT "					<option value=''>----------------------</option>"
									SQL = "SELECT [intIDX] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [defaultTf] = 'T'"
									basicDtoD = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)
									SQL = " SELECT * FROM [DK_DTOD] WHERE [useTF] = 'T' ORDER BY [intIDX] ASC "
									arrList2 = Db.execRsList(SQL,DB_TEXT,Nothing,listLen2,Nothing)
									If IsArray(arrList2) Then
										For l = 0 To listLen2
											If arrDtoD = "" Or IsNull(arrDtoD) Then
												PRINT "<option value='"&arrList2(0,l)&"'"&isSelect(arrList2(0,l),basicDtoD)&">"&arrList2(2,l)&"</option>"
											Else
												PRINT "<option value='"&arrList2(0,l)&"'"&isSelect(arrList2(0,l),arrDtoD)&">"&arrList2(2,l)&"</option>"
											End If
										Next
									End If
								PRINT "			</select></p><p>송장번호 : <input type='text' name='dtodnum' class='input_text vmiddle "&readOnlyc&"' value='"&arrDtoDValue&"' "&noDtoD&" "&readOnlys&" /><input type='image' src='"&img_btn&"/dtod_input.gif' style='vertical-align:middle;' "&noDtoD&" /></p>"
								PRINT "				<input type='hidden' name='ChgIDX' value='"&arrSUBidx&"' />"
								PRINT "			</form></td>"
								PRINT "		</tr>"
							Next
						Else
							PRINT "		<tr>"
							PRINT "			<td colspan='5' height='70' align='center'>주문된 상품이 삭제 되었거나 정보가 올바르지 않습니다.</td>"
							PRINT "		</tr>"
						End If
						PRINT "		</table>"
						PRINT "	</td>"


					Next
				Else
					PRINT "<tr>"
					PRINT "<td colspan=""7"" height=""70"" align=""center"">주문 정보가 없습니다.</td>"
					PRINT "</tr>"
				End If
			%>
		<tr>
			<td colspan="7" align="center" style="height:45px; border:none;"><%Call pageList(PAGE,PAGECOUNT)%></td>
		</tr>
	</table>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="ORDERS" value="<%=QORDERS%>" />

	<input type="hidden" name="schpayway" value="<%=schpayway%>" />

	<input type="hidden" name="minPrice" value="<%=minPrice%>" />
	<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />



</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->

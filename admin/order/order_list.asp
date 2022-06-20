
<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%

	'On Error Resume Next
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS1-1"

	'▣직판용 권한 체크▣
	If isMACCO = "T" Then Call ALERTS("잘못된 접근입니다.","GO","order_list_MACCO.asp")

	Dim SEARCHTERM		:	SEARCHTERM	 = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR	 = Request.Form("SEARCHSTR")
	Dim PAGESIZE		:	PAGESIZE	 = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE		 = Request.Form("PAGE")
	Dim schpayway		:	schpayway	 = Request.Form("schpayway")
	Dim minPrice		:	minPrice	 = Request.Form("minPrice")
	Dim maxPrice		:	maxPrice	 = Request.Form("maxPrice")

	'strNationCode = Request("nc")
	strNationCode = viewAdminLangCode

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_TEXT = DKRS_FA_strNationName

	menu = Request.QueryString("menu")
	If menu = "" Then menu = ""

	Select Case menu
		Case ""
			INFO_MODE = "ORDERSALL"
		Case "100"
			INFO_MODE = "ORDERS1-0"
		Case "101"
			INFO_MODE = "ORDERS1-1"
		Case "102"
			INFO_MODE = "ORDERS1-2"
		Case "103"
			INFO_MODE = "ORDERS1-3"
		Case "201"
			INFO_MODE = "ORDERS2-1"
		Case "301"
			INFO_MODE = "ORDERS3-1"
		Case "302"
			INFO_MODE = "ORDERS3-2"
		Case Else
			INFO_MODE = "ORDERSALL"
	End Select

	Call FN_NationCurrency(strNationCode,Chg_CurrencyName,Chg_CurrencyISO)


	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then	PAGE = 1
	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	If schpayway = "" Then  schpayway = ""
	If minPrice = "" Then minPrice = 0
	If maxPrice = "" Then maxPrice = 0


	arrParams = Array(_
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
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
	arrList = Db.execRsList("DKSP_ORDER_LIST",DB_PROC,arrParams,listLen,Nothing)
	'arrList = Db.execRsList("DKPA_ORDER_LIST",DB_PROC,arrParams,listLen,Nothing)
	ALL_COUNT = arrParams(Ubound(arrPArams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If


%>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="order_list.js"></script>

<link rel="stylesheet" href="order_list.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<iframe id="hidden" name="hidden" src="/hiddens.asp" width="800" height="200" style="display:none;"></iframe>
<form name="chgFrm" method="post" action="orderStatusHandler.asp">
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="hidDate" value="" />
	<input type="hidden" name="MODE" value="" />
</form>
<div id="loadingPro" class="" style="position:absolute; z-index:33;top:0;left:0; width:100%; text-align:center; background:url(/images/admin/loading_bg70.png) 0 0 repeat; height:100%;display:none;"><div id="loadProg" style="position:absolute;font-weight:bold;"><img src="<%=IMG%>/159.gif" alt="" /><br /><br />데이터 처리중입니다. 잠시만 기다려주세요.</div></div>
<div id="order">
	<form name="searchform" method="post">
		<table <%=tableatt%> class="width100 table1">
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
					<input type="text" name="minPrice" class="input_text" value="<%=minPrice%>" /> ~ <input type="text" name="maxPrice" class="input_text"  value="<%=maxPrice%>" />
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

	<p class="titles">주문목록</p>
	<div class="list">
		<table <%=tableatt%> class="width100 tbfix">
			<colgroup>
				<col width="120" />
				<col width="110" />
				<col width="110" />
				<col width="120" />
				<col width="110" />
				<col width="110" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th class="outTH">주문번호</th>
					<th class="outTH">주문일시</th>
					<th class="outTH">주문자<br />아이디</th>
					<th class="outTH">최종결제금액</th>
					<th class="outTH">결제방식</th>
					<th class="outTH">결제상태</th>
					<th class="outTH">진행상태</th>
				</tr>
			</thead>
			<%
				If IsArray(arrList) Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

					For i = 0 To listLen
						arrList_intIDX					= arrList(1,i)
						arrList_strDomain				= arrList(2,i)
						arrList_OrderNum				= arrList(3,i)
						arrList_strIDX					= arrList(4,i)
						arrList_strUserID				= arrList(5,i)
						arrList_payWay					= arrList(6,i)
						arrList_totalPrice				= arrList(7,i)
						arrList_totalDelivery			= arrList(8,i)
						arrList_totalOptionPrice		= arrList(9,i)
						arrList_totalPoint				= arrList(10,i)
						arrList_strName					= arrList(11,i)
						arrList_strTel					= arrList(12,i)
						arrList_strMob					= arrList(13,i)
						arrList_strEmail				= arrList(14,i)
						arrList_strZip					= arrList(15,i)
						arrList_strADDR1				= arrList(16,i)
						arrList_strADDR2				= arrList(17,i)
						arrList_takeName				= arrList(18,i)
						arrList_takeTel					= arrList(19,i)
						arrList_takeMob					= arrList(20,i)
						arrList_takeZip					= arrList(21,i)
						arrList_takeADDR1				= arrList(22,i)
						arrList_takeADDR2				= arrList(23,i)
						arrList_orderMemo				= arrList(24,i)
						arrList_strSSH1					= arrList(25,i)
						arrList_strSSH2					= arrList(26,i)
						arrList_status					= arrList(27,i)
						arrList_status100Date			= arrList(28,i)
						arrList_status101Date			= arrList(29,i)
						arrList_status102Date			= arrList(30,i)
						arrList_status103Date			= arrList(31,i)
						arrList_status104Date			= arrList(32,i)
						arrList_status201Date			= arrList(33,i)
						arrList_status301Date			= arrList(34,i)
						arrList_status302Date			= arrList(35,i)
						arrList_DtoDCode				= arrList(36,i)
						arrList_DtoDNumber				= arrList(37,i)
						arrList_DtoDDate				= arrList(38,i)
						arrList_CancelCause				= arrList(39,i)
						arrList_bankIDX					= arrList(40,i)
						arrList_bankingName				= arrList(41,i)
						arrList_usePoint				= arrList(42,i)
						arrList_totalVotePoint			= arrList(43,i)
						arrList_PGorderNum				= arrList(44,i)
						arrList_PGCardNum				= arrList(45,i)
						arrList_PGAcceptNum				= arrList(46,i)
						arrList_PGinstallment			= arrList(47,i)
						arrList_PGCardCode				= arrList(48,i)
						arrList_PGCardCom				= arrList(49,i)
						arrList_bankingCom				= arrList(50,i)
						arrList_bankingNum				= arrList(51,i)
						arrList_bankingOwn				= arrList(52,i)
						arrList_TOTAL_CNT				= arrList(53,i)
						arrList_TOTAL_CNT102			= arrList(54,i)

						'print arrList_TOTAL_CNT
						'print arrList_TOTAL_CNT102
						chg_State = CallState(arrList_status)
						'print arrList_strTel

						'If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
							On Error Resume Next
								If arrList_strADDR1		<> "" Then arrList_strADDR1			= Trim(objEncrypter.Decrypt(arrList_strADDR1))
								If arrList_strADDR2		<> "" Then arrList_strADDR2			= Trim(objEncrypter.Decrypt(arrList_strADDR2))
								If arrList_strTel		<> "" Then arrList_strTel			= Trim(objEncrypter.Decrypt(arrList_strTel))
								If arrList_strMob		<> "" Then arrList_strMob			= Trim(objEncrypter.Decrypt(arrList_strMob))
								If arrList_takeTel		<> "" Then arrList_takeTel			= Trim(objEncrypter.Decrypt(arrList_takeTel))
								If arrList_takeMob		<> "" Then arrList_takeMob			= Trim(objEncrypter.Decrypt(arrList_takeMob))
								If arrList_takeADDR1	<> "" Then arrList_takeADDR1		= Trim(objEncrypter.Decrypt(arrList_takeADDR1))
								If arrList_takeADDR2	<> "" Then arrList_takeADDR2		= Trim(objEncrypter.Decrypt(arrList_takeADDR2))
								If arrList_strEmail		<> "" Then arrList_strEmail			= Trim(objEncrypter.Decrypt(arrList_strEmail))
								If arrList_bankingNum	<> "" Then arrList_bankingNum		= Trim(objEncrypter.Decrypt(arrList_bankingNum))
								If arrList_PGAcceptNum	<> "" Then arrList_PGAcceptNum		= Trim(objEncrypter.Decrypt(arrList_PGAcceptNum))
							On Error GoTo 0
						'End If

						'===ajax_chg와동일===
						'CS 주문번호 호출
							SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WHERE [ETC2] = '웹주문번호:'+ ? "
							arrParams = Array(_
								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,arrList_OrderNum) _
							)
							Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
							If Not HJRSC.BOF And Not HJRSC.EOF Then
								RS_OrderNumber   = HJRSC(0)
							Else
								RS_OrderNumber   = ""
							End If
							Call closeRS(HJRSC)

						'CS 주문번호(삭제테이블) 호출
							SQL4 = "SELECT [OrderNumber] FROM [tbl_SalesDetail_Mod_Del] WHERE [ETC2] = '웹주문번호:'+ ? "
							arrParams = Array(_
								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,arrList_OrderNum) _
							)
							Set HJRSC = DB.execRs(SQL4,DB_TEXT,arrParams,DB3)
							If Not HJRSC.BOF And Not HJRSC.EOF Then
								RS_OrderNumber_Del   = HJRSC(0)
							Else
								RS_OrderNumber_Del   = ""
							End If

						'CS 주문번호 승인상태 호출
							SQL2 = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WHERE [OrderNumber] = ? "
							arrParams = Array(_
								Db.makeParam("@OrderNum",adVarChar,adParamInput,50,RS_OrderNumber) _
							)
							Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
							If Not HJRSC.BOF And Not HJRSC.EOF Then
								CS_ORDER_SellTF   = HJRSC(0)

								Select Case CS_ORDER_SellTF
									Case "1"
										CS_ORDER_SellTF = "CS : <span style=""color:blue"">승인</span>"
									Case "0"
										CS_ORDER_SellTF = "CS : <span style=""color:red"">미승인</span>"
									Case Else
										CS_ORDER_SellTF = ""
								End Select
							Else
								CS_ORDER_SellTF   = ""
							End If
							Call closeRS(HJRSC)

						'goBtn101 = aImg("javascript:go101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_go101.gif",126,101,"")
						goBtn101 = aImg("javascript:go101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_go101.gif",126,101,"")

						If arrList_TOTAL_CNT <> arrList_TOTAL_CNT102 Then
							goBtn102 = aImg("javascript:alert('상품/배송정보에서 배송정보를 입력해주세요');viewInDiv('"&i&"','DivGoods','"&arrList_intIDX&"');",IMG_BTN&"/btn_order_go102n.gif",126,101,"")
							'goBtn102 = aImg("javascript:go102Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"')",IMG_BTN&"/btn_order_go102.gif",126,101,"")
						Else
							goBtn102 = aImg("javascript:go102Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_go102.gif",126,101,"")
						End If
						goBtn103 = aImg("javascript:go103Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_go103.gif",126,101,"")
						goBtn104 = viewImg(IMG_BTN&"/btn_order_104.gif",126,101,"")


						backBtn100 = aImg("javascript:back100Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						backBtn101 = aImg("javascript:back101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						backBtn102 = aImg("javascript:back102Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")


						goBtnCancel = aImg("javascript:goCancelBtn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_go_cancel.gif",146,31,"")
						goBtnCancelN = aImg("javascript:alert('수취확인상태의 주문은 취소할 수 없습니다. 상태를 배송완료(배송중)중 이하로 변경해주세요.');",IMG_BTN&"/btn_order_go_cancelN.gif",146,31,"")
						'	goBtnDtoD = aImg("javascript:openDelivery('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_dtod.gif",146,31,"")

						CancelStat201 = viewImg(IMG_BTN&"/btn_cancel_admin.gif",126,101,"")
						CancelStat301 = viewImg(IMG_BTN&"/btn_cancel_customer.gif",126,101,"")
						CancelStat401 = viewImg(IMG_BTN&"/btn_cancel_customer_f.gif",126,101,"")
					'	goCancelStat401 = aImg("javascript:goCancelUBtn('"&arrList_intIDX&"')",IMG_BTN&"/btn_cancel_user.gif",146,31,"")
						goCancelStat401 = aImg("javascript:goCancelUBtn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_cancel_user.gif",146,31,"")

					'''	goBackCancel102 = aImg("javascript:backc100Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
					'''	goBackCancel103 = aImg("javascript:backc101Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						goBackCancel102 = aImg("javascript:backc100Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_back100.gif",146,31,"")
						goBackCancel103 = aImg("javascript:backc101Btn('"&arrList_intIDX&"','tbody_"&arrList_OrderNum&"','"&i&"','"&strNationCode&"')",IMG_BTN&"/btn_order_back101.gif",146,31,"")
						'goBackCancel104 = aImg("javascript:backc102Btn('"&arrList_intIDX&"')",IMG_BTN&"/btn_order_back102.gif",146,31,"")


						'CS 주문삭제 (삭제테이블 주문번호 존재)
						CS_OrderNumber = RS_OrderNumber
						If RS_OrderNumber_Del <> "" Then
							CS_OrderNumber = RS_OrderNumber_Del&"</span><span class=""red ""><br />CS삭제처리</span>"
						End If

						TOTAL_PRICE	= arrList_totalPrice + arrList_usePoint		'▣최종결제금액(usePoint 포함)
						If LCase(arrList_payWay) = "point" Then
							TOTAL_PRICE	= TOTAL_PRICE - arrList_usePoint
						End If

						PRINT "<tbody id=""tbody_"&arrList_OrderNum&""">"
						PRINT "<tr>"
						'PRINT "	<td class='outTD'><strong>"&arrList_OrderNum&"</strong></td>"
						PRINT "	<td class='outTD'><strong>"&arrList_OrderNum&"</strong><br />"&CS_OrderNumber&"</td>"
						PRINT "	<td class='outTD'>"&DateValue(arrList_status100Date)&"<br />"&TimeValue(arrList_status100Date)&"</td>"
						PRINT "	<td class='outTD'>"&arrList_strName&"<br />"&arrList_strUserID&"</td>"
						PRINT "	<td class='outTD'><strong>"&FormatNumber(TOTAL_PRICE,0)&" "&Chg_CurrencyISO&"</strong></td>"		'TOTAL_PRICE
						PRINT "	<td class='outTD'>"&FN_PAYWAY_VIEW(arrList_Payway)&"</td>"
						PRINT "	<td class='outTD'>"&chg_State&"<br />"&CS_ORDER_SellTF&"</td>"
						PRINT "	<td class='outTD stateTD' rowspan='3'>"
						PRINT "		<div class=""btnZoneLeft"">"
						Select Case arrList_status
							Case "100" : PRINT goBtn101
							Case "101"
								SQL = "SELECT * FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@intIDX",adInteger,adParamInput,0,arrList_intIDX) _
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
								If chkCnt > 0 Then PRINT goBtn102 Else PRINT goBtn102 End If

							Case "102" : PRINT goBtn103

							Case "103" : PRINT goBtn104

							Case "201" : PRINT CancelStat201
							Case "301" : PRINT CancelStat301
							Case "302" : PRINT CancelStat401
						End Select
						PRINT "		</div>"
						PRINT "		<div class=""btnZoneRight"">"
						Select Case arrList_status
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
							'	PRINT "<p class=""blines"">"&goBackCancel102&"</p>"
							'	PRINT "<p class=""blines"">"&goBackCancel103&"</p>"
							'	PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
							Case "301"
								PRINT "<p class=""blines"">"&goCancelStat401&"</p>"
							Case "302"
							'	PRINT "<p class=""blines"">"&goBackCancel102&"</p>"
							'	PRINT "<p class=""blines"">"&goBackCancel103&"</p>"
							'	PRINT "<p class=""blines"">"&goBackCancel104&"</p>"
						End Select
						PRINT "		</div>"

						calsGoodsPrice = 0
						realPrice = 0


						calsGoodsPrice = 0

						If arrList_payWay = "point" Then			'▣마일리지 단독구매시!
							calsGoodsPrice	   = arrList_totalPrice - arrList_totalDelivery
							arrList_totalPrice = arrList_totalPrice - arrList_UsePoint
						Else
							calsGoodsPrice = arrList_totalPrice - arrList_totalOptionPrice - arrList_totalDelivery + arrList_UsePoint		'상품가
						End If
						'포인트사용
						realPrice = 0
						'		print arrtotalPrice
						'		print arrtotalDelivery
						'		print arrUsePoint

						realPrice = calsGoodsPrice + arrList_totalDelivery - arrList_UsePoint

						'배송비

						PRINT  "		</td>"
						PRINT  "	</tr><tr>"
						PRINT  "		<th colspan=""6"" class=""outTH"">상세정보보기</th>"
						PRINT  "	</tr><tr>"
						PRINT  "		<td colspan=""6"" class=""outTD"">"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivPrice','');"">결제금액정보</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivPayway','');"">결제정보</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivDelivery','');"">배송지정보</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""database""></span><a href=""javascript:viewInDiv('"&i&"','DivGoods','"&arrList_intIDX&"');"">상품/배송정보</a></span>"
						PRINT  "			<span class=""button medium icon""><span class=""delete""></span><a href=""javascript:hiddInDiv('"&i&"');"">모두닫기</a></span>"
						PRINT  "		</td>"
						PRINT  "	</tr><tr>"
						PRINT  "		<td colspan=""7"" class=""tcenter viewCon"">"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivPrice"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">결제금액정보 ("&Chg_CurrencyISO&")</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th>상품금액</th>"
						PRINT  "						<td>"&num2cur(calsGoodsPrice)&" </td>"
						PRINT  "						<th>옵션금액</th>"
						PRINT  "						<td>"&num2cur(arrList_totalOptionPrice)&" </td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>배송금액</th>"
						PRINT  "						<td>"&num2cur(arrList_totalDelivery)&" </td>"
						PRINT  "						<th>포인트 사용금액</th>"
						PRINT  "						<td>"&num2cur(arrList_usePoint)&" </td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>포인트 적립금액</th>"
						PRINT  "						<td>"&num2cur(arrList_totalPoint)&" </td>"
						PRINT  "						<th>최종결제금액</th>"
						PRINT  "						<td class=""red"">"&num2cur(TOTAL_PRICE)&" </td>"	'TOTAL_PRICE
						PRINT  "					</tr>"
						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivPayway"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">결제정보</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th>결제방식</th>"
						PRINT  "						<td colspan=""3"">"&FN_PAYWAY_VIEW(arrList_Payway)&"</td>"
						PRINT  "					</tr>"
						Select Case LCase(arrList_Payway)
							Case "card"
								PRINT "						<tr>"
								PRINT  "						<th>PG사 주문번호</th>"
								PRINT  "						<td>"&arrList_PGorderNum&"</td>"
								PRINT  "						<th>승인번호</th>"
								PRINT  "						<td>"&arrList_PGAcceptNum&"</td>"
								PRINT  "					</tr><tr>"
								PRINT  "						<th>카드코드/번호</th>"
								PRINT  "						<td>"&arrList_PGCardCode&" ("&FN_INICIS_CARDCODE_VIEW(arrList_PGCardCode)&") / "&arrList_PGCardNum&"</td>"
								PRINT  "						<th>할부개월수</th>"
								PRINT  "						<td class=""red"">"&arrList_PGinstallment&"</td>"
								PRINT  "					</tr>"
							Case "inbank"
								PRINT "						<tr>"
								PRINT  "						<th>입금은행</th>"
								PRINT  "						<td>"&arrList_bankingCom&"</td>"
								PRINT  "						<th>계좌번호</th>"
								PRINT  "						<td>"&arrList_bankingNum&"</td>"
								PRINT  "					</tr><tr>"
								PRINT  "						<th>예금주</th>"
								PRINT  "						<td>"&arrList_bankingOwn&"</td>"
								PRINT  "						<th>입금예정자</th>"
								PRINT  "						<td>"&arrList_bankingName&"</td>"
								PRINT  "					</tr>"
						End Select

						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "			<div class=""inDivs inDiv"&i&" DivDelivery"&i&""" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">배송지정보</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100"">"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<col width=""12%"" />"
						PRINT  "					<col width=""38%"" />"
						PRINT  "					<tr>"
						PRINT  "						<th colspan=""2"">주문자정보</th>"
						PRINT  "						<th colspan=""2"">배송지정보</th>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>주문자명</th>"
						PRINT  "						<td>"&arrList_strName&"</td>"
						PRINT  "						<th>받으시는분</th>"
						PRINT  "						<td>"&arrList_takeName&"</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>연락처</th>"
						PRINT  "						<td>"&arrList_strTel&"</td>"
						PRINT  "						<th>연락처</th>"
						PRINT  "						<td>"&arrList_takeTel&"</td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>휴대폰번호</th>"
						PRINT  "						<td>"&arrList_strMob&"</td>"
						PRINT  "						<th>휴대폰번호</th>"
						PRINT  "						<td><p class=""red"">"&arrList_takeMob&"</p></td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>주소</th>"
						PRINT  "						<td class=""addr""><p>("&arrList_strZip&")</p><p>"&arrList_strADDR1&"</p><p>"&arrList_strADDR2&"</p></td>"
						PRINT  "						<th>주소</th>"
						PRINT  "						<td class=""addr""><p class=""red"">("&arrList_takeZip&")</p><p class=""red"">"&arrList_takeADDR1&"</p><p class=""red"">"&arrList_takeADDR2&"</p></td>"
						PRINT  "					</tr><tr>"
						PRINT  "						<th>이메일</th>"
						PRINT  "						<td>"&arrList_strEmail&"</td>"
						PRINT  "						<th>배송시 요청사항</th>"
						PRINT  "						<td class=""red"">"&arrList_orderMemo&"</td>"
						PRINT  "					</tr>"
						PRINT  "				</table>"
						PRINT  "			</div>"


						PRINT  "			<div class=""inDivs inDiv"&i&" DivGoods"&i&" porel"" style=""display:none;"">"
						PRINT  "				<p class=""tweight f11px fleft"">구매상품</p>"
						PRINT  "				<table "&tableatt&" class=""inTable width100 GoodsTable tableFixed"">"
						PRINT  "					<col width=""100"" />"
						PRINT  "					<col width=""250"" />"
						PRINT  "					<col width=""50"" />"
						PRINT  "					<col width=""40"" />"
						PRINT  "					<col width=""80"" />"
						PRINT  "					<col width=""110"" />"
						PRINT  "					<col width=""130"" />"
						PRINT  "					<col width=""*"" />"
						PRINT  "					<tr>"
						PRINT  "						<th colspan=""2"">상품정보</th>"
						PRINT  "						<th>수량</th>"
						PRINT  "						<th colspan=""2"">금액정보 ("&Chg_CurrencyISO&")</th>"
						PRINT  "						<th>판매자</th>"
						PRINT  "						<th>배송비</th>"
						PRINT  "						<th>배송정보</th>"
						PRINT  "					</tr>"
						PRINT  "					<tbody id=""tbody"&i&""">"
						PRINT  "					</tbody>"
						PRINT  "				</table>"
						PRINT  "			</div>"
						PRINT  "		</td>"
						PRINT  "	</tr>"
						If arrList_status = "301" Or arrList_status = "302" Or arrList_status = "201" Then
							PRINT "	<tr style=""border-top:3px solid #cdcdcd;border-bottom:2px solid #333;"">"
							PRINT "		<th class=""outTH"">취소사유</th>"
							PRINT "		<td colspan='4' class='td_lheight' style='padding-left:5px;'>"&backword(arrList_CancelCause)&"</td>"
							PRINT "		<th class=""outTH"">취소요청일자</th>"
							PRINT "		<td class='td_lheight' style='padding-left:5px;'>"&arrList_status301Date&"</td>"
							PRINT "	</tr>"
						End If
						PRINT "</tbody>"


					Next
					Set objEncrypter = Nothing

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

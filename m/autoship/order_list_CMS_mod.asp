<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "AUTOSHIP1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	oIDX = gRequestTF("oIDX",True)		'A_Seq

%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="buy.css" />
<link rel="stylesheet" href="order_list_CMS.css?v0" />

<!--#include file = "order_list_CMS.js.asp"--><%'JS%>
<script src="order_list_CMS_mod.js?v5"></script>
<script type="text/javascript">
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="loadingsA">
	<div class="loadingImg"><img src="<%=IMG%>/159.gif" width="60" alt="loadingImg" /></div>
</div>
<div id="buy" class="orderList">
	<%
		INFO_CHANGE_TF = "F"
		arrParams = Array(_
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
			Db.makeParam("@oIDX",adInteger,adParamInput,4,oIDX) _
		)
		Set HJRS = Db.execRs("HJP_ORDER_LIST_CMS_DETAIL",DB_PROC,arrParams,DB3)
		If Not HJRS.BOF And Not HJRS.EOF Then
			RS_mbid						= HJRS("mbid")
			RS_mbid2					= HJRS("mbid2")
			RS_ApplyDay					= HJRS("ApplyDay")
			RS_A_ItemCode				= HJRS("A_ItemCode")
			RS_A_Cul_Code				= HJRS("A_Cul_Code")
			RS_A_BankCode				= HJRS("A_BankCode")
			RS_A_BankAccount			= HJRS("A_BankAccount")
			RS_A_BankOwner				= HJRS("A_BankOwner")
			RS_A_BankOwner_Cpno			= HJRS("A_BankOwner_Cpno")
			RS_A_CardCode				= HJRS("A_CardCode")
			RS_A_CardNumber				= HJRS("A_CardNumber")
			RS_A_Period1				= HJRS("A_Period1")				'유효기간YYYY
			RS_A_Period2				= HJRS("A_Period2")				'유효기간MM
			RS_A_Installment_Period		= HJRS("A_Installment_Period")
			RS_A_Card_Name_Number		= HJRS("A_Card_Name_Number")	'소유자명
			RS_A_Start_Date				= HJRS("A_Start_Date")			'정기결제 시작일
			RS_A_Month_Date				= HJRS("A_Month_Date")			'기준일자
			RS_T_index					= HJRS("T_index")
			RS_CMS_TF					= HJRS("CMS_TF")
			RS_CMS_ing					= HJRS("CMS_ing")
			RS_CMS_Result				= HJRS("CMS_Result")
			RS_CMS_Error				= HJRS("CMS_Error")
			RS_A_Receive_Method			= HJRS("A_Receive_Method")
			RS_A_Rec_Name				= HJRS("A_Rec_Name")				'수취인명
			RS_A_hptel					= HJRS("A_hptel")					'연락처 1
			RS_A_hptel2					= HJRS("A_hptel2")					'연락처 2
			RS_A_Addcode1				= HJRS("A_Addcode1")				'우편번호
			RS_A_Address1				= HJRS("A_Address1")				'주소
			RS_A_Address2				= HJRS("A_Address2")				'상세주소
			RS_A_Address3				= HJRS("A_Address3")
			RS_A_ETC					= HJRS("A_ETC")
			RS_A_UseType				= HJRS("A_UseType")
			RS_A_StopDay				= HJRS("A_StopDay")				'중지 시작일
			RS_A_ProcDay				= HJRS("A_ProcDay")				'다음 정기결제일자
			RS_A_RealProcDay			= HJRS("A_RealProcDay")
			RS_A_UserProcDay			= HJRS("A_UserProcDay")
			RS_A_ProcWeek				= HJRS("A_ProcWeek")
			RS_A_ProcWeekDay			= HJRS("A_ProcWeekDay")
			RS_A_ProcAmt				= HJRS("A_ProcAmt")
			RS_A_Seq					= HJRS("A_Seq")						'상품테이블 일련번호
			RS_A_Birth					= HJRS("A_Birth")
			RS_A_Card_Dongle			= HJRS("A_Card_Dongle")			'카드승인(키젠)
			RS_A_Birth1					= HJRS("A_Birth1")					'생년월일
			RS_A_AutoCnt				= HJRS("A_AutoCnt")				'정기결제 주기(개월)
			RS_A_Recordid				= HJRS("A_Recordid")
			RS_A_Recordtime				= HJRS("A_Recordtime")				'기록일자
			RS_Send_Ch_TF				= HJRS("Send_Ch_TF")

			If CDbl(RS_A_ProcAmt) < 1  Then Call ALERTS("정기결제 결제금액 미설정.","BACK","")


			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If RS_A_Period1		<> "" Then RS_A_Period1	= objEncrypter.Decrypt(RS_A_Period1)
					If RS_A_Period2		<> "" Then RS_A_Period2	= objEncrypter.Decrypt(RS_A_Period2)
					If RS_A_hptel		<> "" Then RS_A_hptel	= objEncrypter.Decrypt(RS_A_hptel)
					If RS_A_hptel2		<> "" Then RS_A_hptel2	= objEncrypter.Decrypt(RS_A_hptel2)
					If RS_A_Address1	<> "" Then RS_A_Address1= objEncrypter.Decrypt(RS_A_Address1)
					If RS_A_Address2	<> "" Then RS_A_Address2= objEncrypter.Decrypt(RS_A_Address2)
					If RS_A_Birth		<> "" Then RS_A_Birth	= objEncrypter.Decrypt(RS_A_Birth)
					If RS_A_CardNumber  <> "" Then RS_A_CardNumber = objEncrypter.Decrypt(RS_A_CardNumber)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If RS_A_Card_Dongle = "" Then Call ALERTS("카드 인증작업이 이루어지지 않았습니다.\n\n본사로 문의해주세요.","BACK","")
			If RS_A_Start_Date = "" Or RS_A_Month_Date = "" Or RS_A_ProcDay = "" Then Call ALERTS("정기결제 일자 정보가 입력되지 않았습니다.\n\n본사로 문의해주세요.","BACK","")

		Else
			Call ALERTS("등록된 정보가 없습니다.","BACK","")
		End If
		Call CloseRS(HJRS)

		If Date() > DateAdd("d", -2, date8to10(RS_A_ProcDay)) Then
			INFO_CHANGE_TF = "F"
		Else
			INFO_CHANGE_TF = "T"
		End If

		SQL_MEM = "SELECT [hptel] FROM tbl_Memberinfo WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
		arrParams = Array(_
			Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		)
		Set DKRS = Db.execRs(SQL_MEM,DB_TEXT,arrParams,DB3)
		If Not DKRS.BOF And Not DKRS.EOF Then
			DKRS_hptel	= DKRS("hptel")

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If DKRS_hptel	<> "" Then DKRS_hptel = objEncrypter.Decrypt(DKRS_hptel)
				On Error GoTo 0
			Set objEncrypter = Nothing

		End If
		Call closeRS(DKRS)

		If DKPG_PGCOMPANY = "PAYTAG" Then
			If DKRS_hptel = "" Then
				Call ALERTS(LNG_JS_MOBILE&" (필수값)","GO","/mypage/member_info.asp")
			End if
		End If
	%>
	<!-- <p class="sub_title">정기결제 상세보기</p> -->
	<form name="cfrm" method="post" >
		<input type="hidden" name="PGCOMPANY" value="<%=DKPG_PGCOMPANY%>" />
		<input type="hidden" name="mode" value="MODIFY" />
		<input type="hidden" name="oIDX" value="<%=oIDX%>" readonly="readonly" />
		<input type="hidden" name="A_Card_Dongle" value="<%=RS_A_Card_Dongle%>" readonly="readonly" />
		<input type="hidden" name="INFO_CHANGE_TF" value="<%=INFO_CHANGE_TF%>" readonly="readonly" />

		<div class="width100">
			<p class="titles width95">정기결제 상세보기<label>
			<table <%=tableatt%> class="width100">
				<col width="" />
				<col width="" />
				<col width="" />
				<thead>
					<tr>
						<th>등록일</th>
						<th>시작일</th>
						<th>다음 시작일</th>
					</tr><tr>
						<th>기준일자</th>
						<th>주기</th>
						<th>총 결제금</th>
					</tr>
				</thead>
				<tbody>
					<tr class="bot_line_c_333">
						<!-- <td class="tcenter bot_line_c_333" rowspan="3"><%=oIDX%></td> -->
						<td class="tcenter"><%=Left(RS_A_Recordtime,10)%></td>
						<td class="tcenter" ><%=date8to10(RS_A_Start_Date)%></td>
						<!-- <td class="tcenter tweight" ><%=date8to10(RS_A_ProcDay)%></td> -->
						<td class="tcenter tweight" ><input type="text" name="A_ProcDay" id="A_ProcDay" value="<%=date8to10(RS_A_ProcDay)%>" class="input_text tcenter datepicker" style="width: 92px;" readonly="readonly" /><input type="hidden" name="Ori_A_ProcDay" value="<%=date8to10(RS_A_ProcDay)%>" /></td>
					</tr><tr>
						<!-- <td class="tcenter bot_line_c_333" ><%=date8to10(RS_A_StopDay)%></td> -->
						<td class="tcenter bot_line_c_333">
							<%=RS_A_Month_Date%>일
							<!--
							<select name="A_Month_Date" class="vmiddle input_text" style="width:100px;" >
								<option value="" <% if RS_A_Month_Date = "" Then PRINT "selected" %>>선택 ::::::</option>
								<option value="5" <% if RS_A_Month_Date = "5" Then PRINT "selected" %>>5</option>
								<option value="15" <% if RS_A_Month_Date = "15" Then PRINT "selected" %>>15</option>
								<option value="25" <% if RS_A_Month_Date = "25" Then PRINT "selected" %>>25</option>
							</select>
							<input type="hidden" name="Ori_A_Month_Date" value="<%=RS_A_Month_Date%>" />
							-->
						</td>
						<td class="tcenter bot_line_c_333">
							<!-- <%=RS_A_AutoCnt%> 개월 -->
							<select name="A_AutoCnt" class="vmiddle input_text" style="width:100px;" >
								<option value="" <% if RS_A_AutoCnt = "" Then PRINT "selected" %>>선택 ::::::</option>
								<option value="1" <% if RS_A_AutoCnt = "1" Then PRINT "selected" %>>1개월마다</option>
								<option value="2" <% if RS_A_AutoCnt = "2" Then PRINT "selected" %>>2개월마다</option>
								<option value="3" <% if RS_A_AutoCnt = "3" Then PRINT "selected" %>>3개월마다</option>
							</select>
							<input type="hidden" name="Ori_A_AutoCnt" value="<%=RS_A_AutoCnt%>" />
						</td>
						<td class="tcenter bot_line_c_333 tweight blue2"><%=num2cur(RS_A_ProcAmt)%> 원</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="width100">
			<p class="titles">회원 기본 배송 주소
			<%If INFO_CHANGE_TF = "T" Then %>
				<label><span class="fright blue2 cp"><input type="checkbox" name="recvInfoChgChk" value="T" class="input_checkbox" onClick="fnRecvModify();"/> 배송정보변경</span></label>
			<%End If%>
			</p>
			<table <%=tableatt%> class="innerTable2 autoTable_i1 width100">
				<col width="80" />
				<col width="*" />
				<tr>
					<th>수취인명 <%=startext%></th>
					<td><input type="text" name="strName" class="input_text width100" value="<%=backword_br(RS_A_Rec_Name)%>" /></td>
				</tr><tr>
					<th rowspan="3">주소 <%=starText%></th>
					<td>
						<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle zip" value="<%=RS_A_Addcode1%>" maxlength="7" readonly="readonly" placeholder="" />
						<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode"  title="<%=LNG_TEXT_ZIPCODE%>" style="display:none;"><input type="button" class="a_submit2 design3" value="<%=LNG_TEXT_ZIPCODE%>"/></a>
					</td>
				</tr><tr>
					<td><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text width100 readonly vmiddle" style="" value="<%=RS_A_Address1%>" readonly="readonly" placeholder="" /></td>
				</tr><tr>
					<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text width100" style="ime-mode:active;" value="<%=RS_A_Address2%>"  placeholder="" /></td>
				</tr>
				<tr>
					<th>연락처 1 <%=starText%></th>
					<td><input type="text" name="strMobile" class="input_text width100" maxlength="15" <%=onLyKeys%> value="<%=RS_A_hptel%>"  placeholder="" /></td>
				</tr><tr>
					<th>연락처 2</th>
					<td><input type="text" name="strTel" class="input_text width100" maxlength="15" <%=onLyKeys%> value="<%=RS_A_hptel2%>"  placeholder="" /></td>
				</tr>
			</table>
		</div>

		<%
			'PG사별 오토쉽 인증방식 구분
			Select Case DKPG_PGCOMPANY
				Case "KSNET"
					KEYIN_CARDAUTH_TF = "F"
					Fn_CardModify = "fnCardModify_02();"
				Case Else
					KEYIN_CARDAUTH_TF = "T"
					Fn_CardModify = "fnCardModify();"
			End Select
		%>
		<input type="hidden" name="KEYIN_CARDAUTH_TF" id="KEYIN_CARDAUTH_TF" value="<%=KEYIN_CARDAUTH_TF%>" readonly="readonly" />

		<div class="width100" id="cardAuthArea" >
			<p class="titles">카드 결제 정보
				<%If INFO_CHANGE_TF = "T" Then %>
					<label><span class="fright blue2 cp"><input type="checkbox" name="cardInfoChgChk" value="T" class="input_checkbox" onClick="<%=Fn_CardModify%>"/> 카드정보변경</span></label>
				<%End If%>
			</p>
			<table <%=tableatt%> class="innerTable3 autoTable_i2 width100">
				<col width="80" />
				<col width="*" />
				<%If KEYIN_CARDAUTH_TF = "T" Then%>
					<tbody id="CARD_INFO">
						<tr>
							<th>카드명 <%=startext%></th>
							<td>
								<%
									Select Case DKPG_PGCOMPANY
										Case "ONOFFKOREA"
											V_display = ""
										Case Else
											V_display = "display: none;"
									End Select
								%>
								<select name="A_CardType" class="vmiddle input_text" style="<%=V_display%>">
									<option value="0">개인카드</option>
									<option value="1">법인카드</option>
								</select>
								<select name="A_CardCode" class="vmiddle input_text">
									<option value="">카드사를 선택해주세요</option>
									<%
										SQL = "SELECT [ncode],[cardname] FROM [tbl_Card] WITH(NOLOCK) WHERE [recordid] = 'admin' ORDER BY [nCode] ASC"
										arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
										If IsArray(arrList) Then
											For k = 0 To listLen
												PRINT Tabs(5)& "	<option value="""&arrList(0,k)&""" """&isSelect(RS_A_CardCode,arrList(0,k))&""">"&arrList(1,k)&"</option>"
											Next
										Else
											PRINT Tabs(5)& "	<option value="""">등록된 카드사가 없습니다.</option>"
										End If
									%>
								</select>
							</td>
						</tr><tr>
							<%
								If RS_A_CardNumber <> "" Then
									RS_A_CardNumber1 = Left(RS_A_CardNumber, 4)
									RS_A_CardNumber2 = ""	'Mid(RS_A_CardNumber, 5, 4)
									RS_A_CardNumber3 = ""	'Mid(RS_A_CardNumber, 9, 4)
									RS_A_CardNumber4 = ""	'Mid(RS_A_CardNumber, 13, 4)
								Else
									RS_A_CardNumber1 = ""
									RS_A_CardNumber2 = ""
									RS_A_CardNumber3 = ""
									RS_A_CardNumber4 = ""
								End If
							%>
							<th>카드번호 <%=startext%></th>
							<td>
								<input type="text" name="A_CardNumber1" id="A_CardNumber1" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="<%=RS_A_CardNumber1%>" <%=onlyKeys%>/>
								<input type="password" name="A_CardNumber2" id="A_CardNumber2" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="<%=RS_A_CardNumber2%>" <%=onlyKeys%>/>
								<input type="password" name="A_CardNumber3" id="A_CardNumber3" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value="<%=RS_A_CardNumber3%>" <%=onlyKeys%>/>
								<input type="text" name="A_CardNumber4" id="A_CardNumber4" class="input_text vmiddle card" maxlength="4" value="<%=RS_A_CardNumber4%>" <%=onlyKeys%>/>
							</td>
						<tr><tr>
							<th>유효기간 <%=startext%></th>
							<td>
								<select name="A_Period1" class="vmiddle input_text" style="width:100px;">
									<option value="">유효기간(년)</option>
									<%For i2 = THIS_YEAR To EXPIRE_YEAR%>
										<option value="<%=i2%>" <%=isSelect(RS_A_Period1,i2)%> ><%=i2%></option>
									<%Next%>
								</select>
								<select name="A_Period2" class="vmiddle input_text" style="width:90px;">
									<option value="">유효기간(월)</option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" <%=isSelect(RS_A_Period2,jsmm)%> ><%=jsmm%></option>
									<%Next%>
								</select>
							</td>
						</tr><tr>
							<th>소유자명 <%=startext%></th>
							<td><input type="text" name="A_Card_Name_Number" class="input_text vmiddle width95" value="<%=RS_A_Card_Name_Number%>"/></td>
						</tr>
						<%If DKPG_PGCOMPANY = "PAYTAG" Then%>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="A_CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" <%=onlyKeys%> value="" />
								<span class="red2"> * 비밀번호 앞 2자리 입력</span>
							</td>
						</tr>
						<%Else%>
							<input type="hidden" name="A_CardPass" readonly="readonly" />
						<%End if%>
						<tr>
							<th>
								<span class="A_CardType_txt_0">생년월일</span>
								<span class="A_CardType_txt_1" style="display:none;">사업자번호</span>
								<%=starText%>
							</th>
							<td>
								<input type="password" name="A_Birth" maxlength="6" class="input_text vmiddle " style="width:90px;" value="<%=RS_A_Birth%>" placeholder="YYMMDD" <%=onlyKeys%> /><span class="summary"> ex) 630215 형식</span>
								<span class="summary A_CardType_txt_0"> ex) 630215 형식</span>
								<span class="summary A_CardType_txt_1" style="display:none;"> * 사업자등록번호 10자리 입력</span>
							</td>
						</tr>
						<%If DKPG_PGCOMPANY = "ONOFFKOREA" OR DKPG_PGCOMPANY = "PAYTAG" Then%>
						<tr>
							<th>연락처 <%=starText%></th>
							<td><input type="text" class="input_text vmiddle width100" name="A_CardPhoneNum" maxlength="15" <%=onLyKeys2%> value="<%=DKRS_hptel%>"  placeholder="" /></td>
						</tr>
						<%Else%>
							<input type="hidden" name="A_CardPhoneNum" value="" readonly="readonly" />
						<%End If%>
						<tr id="btn_Auth" style="display:none;" >
							<th>카드인증 <%=starText%></th>
							<td>
								<input type="button" class="txtBtn design3 input_btn width100" onclick="join_cardCheck();" value="카드인증"  />
								<span class="summary" id="cardCheckSpan">
									<input type="hidden" name="cardCheck" value="F" readonly="readonly" />
									<input type="hidden" name="chkA_Card_Dongle" id="chkA_Card_Dongle" value="" readonly="readonly" />
									<input type="hidden" name="chkA_Card_DongleIDX" id="chkA_Card_DongleIDX" value="" readonly="readonly" />

									<input type="hidden" name="chkA_CardType" id="chkA_CardType" value="" readonly="readonly" />
									<input type="hidden" name="chkA_CardCode" id="chkA_CardCode" value="" readonly="readonly" />
									<input type="hidden" name="chkA_CardNumber" value="" readonly="readonly" />
									<input type="hidden" name="chkA_Period1" value="" readonly="readonly" />
									<input type="hidden" name="chkA_Period2" value="" readonly="readonly" />
									<input type="hidden" name="chkA_Card_Name_Number" id="chkA_Card_Name_Number" value="" readonly="readonly" />
									<input type="hidden" name="chkA_Birth" id="chkA_Birth" value="" readonly="readonly" />
									<input type="hidden" name="chkA_CardPhoneNum" id="chkA_CardPhoneNum" value="" readonly="readonly" />
								</span>
							</td>
						</tr>

					</tbody>
				<%Else%>
					<tr>
						<th>카드명</th>
						<td>
							<%
								SQLC = "SELECT [cardname] FROM [tbl_Card] WHERE [recordid] = 'admin' AND [ncode] = ? "
								arrParamsC = Array(_
									Db.makeParam("@ncode",adVarWChar,adParamInput,70,RS_A_CardCode) _
								)
								CardName = Db.execRsData(SQLC,DB_TEXT,arrParamsC,DB3)
							%>
							<span id="CardNameTXT"><%=CardName%></span>
						</td>
					</tr>
					<tr>
						<th>카드번호</th>
						<td><span id="CardNumberTXT"><%=RS_A_CardNumber%></td>
					</tr>
					<tr id ="tr_cardAuth" style="display:none;">
						<th>카드인증 <%=starText%></th>
						<td>
						<%
							Select Case DKPG_PGCOMPANY
								Case "KSNET"
									If TX_KSNET_TID_AUTOSHIP = "2999199999" Then TEST_KEY_TXT = "_test_key!!"
						%>
								<input type="hidden" name="returnUrl" value="" readonly="readonly">
								<input type="hidden" name="storeid" size="10" value="<%=TX_KSNET_TID_AUTOSHIP%>" readonly="readonly">
								<input type="button" class="txtBtn j_medium input_btn width95" onclick="javascript:submitAuth();" value="카드인증<%=TEST_KEY_TXT%>"/>
						<%
							End Select
						%>
							<br />
							<span class="summary" id="cardCheckTXT"></span>
							<select name="A_CardCode" class="vmiddle input_text" style="display:none;"><option value=""></option></select>

							<input type="hidden" name="A_CardNumber1" id="A_CardNumber1" value="" readonly="readonly" />
							<input type="hidden" name="A_CardNumber2" id="A_CardNumber2" value="" readonly="readonly" />
							<input type="hidden" name="A_CardNumber3" id="A_CardNumber3" value="" readonly="readonly" />
							<input type="hidden" name="A_CardNumber4" id="A_CardNumber4" value="" readonly="readonly" />

							<input type="hidden" name="cardCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkA_Card_Dongle" id="chkA_Card_Dongle" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Card_DongleIDX" id="chkA_Card_DongleIDX" value="" readonly="readonly" />
						</td>
					</tr>
					<%If KEYIN_CARDAUTH_TF = "F" And DKPG_PGCOMPANY = "KSNET" Then%>
						<IFRAME id="KSPFRAME" name="KSPFRAME" width="100%" height="0" frameborder="0" src="./blank.html" style="display:nene;"></IFRAME>
					<%End If %>
				<%End If%>
			</table>
		</div>

		<div class="btnZone tcenter" style="padding:10px 0px;40px 0px;">
		<!--
			<span><a href="order_list_cms.asp" type="button" class="txtBtnC medium radius5 gray" style="width:140px;">목록으로 돌아가기</a></span>
			<% If INFO_CHANGE_TF = "T" Then 	'결제 예정일 2일 전까지 수정 / 변경 가능%>
				<span class="pL10"><input type="submit" class="txtBtnC medium radius5 blue2" style="width:120px;color:#fff;" value="수정" /></span>
			<%	Else%>
				<span class="pL10"><a href="javascript:alert('결제 예정일 2일 전까지 수정 할 수 있습니다.');" type="button" class="txtBtnC medium radius5 red2" style="width:120px;">수정불가</a></span>
			<%	End If%>
		-->
		</div>

		<div class="tweight tcenter red2" style="width:95%;margin:0 auto;border:1px solid #ccc;background:#fbfce4;font-size:13px;">
			<div style="margin:0 auto;padding:16px 6px 14px 6px;">
				<!-- <p>※ 결제일 등 날짜 관련 정보 수정은 본사로 문의해 주세요.</p><br /> -->
				<p>※ 정기결제 상품의 수정은 기존 상품이 1종류 인 경우</p>
				<p>  - 변경하실 상품을 등록 하신 후, 기존 상품을 삭제 하셔야 합니다.</p>
			</div>
		</div>

		<div class="width100">
			<p class="titles">정기결제 상품</p>
			<table <%=tableatt%> class="innerTable width100">
				<col width="70" />
				<col width="" />
				<col width="" />
				<col width="" />
				<thead>
					<tr>
						<th>수량</th>
							<th>수량</th>
							<th colspan="3">상품명</th>
					</tr><tr>
						<th>상품코드</th>
						<th>회원가</th>
						<th><%=CS_PV%></th>
						<th><%=CS_PV2%></th>
					</tr>
				</thead>
				<tbody>
					<%
						'▣CMS 배송정보 / 상세상품 리스트
						arrParams1 = Array(_
							Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
							Db.makeParam("@A_Seq",adInteger,adParamInput,4,RS_A_Seq),_
							Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
						)
						arrList1 = Db.execRsList("HJP_ORDER_LIST_CMS_ITEM_DETAIL_CNT",DB_PROC,arrParams1,listLen1,DB3)
						All_Count1 = arrParams1(UBound(arrParams1))(4)

						'정기결제 상품정보
						selfPrice = 0
						selfPV = 0
						selfBV = 0
						TOTAL_GOODS_PRICE = 0
						TOTAL_GOODS_PV = 0
						TOTAL_GOODS_BV = 0
						If IsArray(arrList1) Then
							For j = 0 To listLen1
								arr_mbid            = arrList1(0,j)
								arr_mbid2           = arrList1(1,j)
								arr_ItemCode        = arrList1(2,j)
								arr_Salesitemindex  = arrList1(3,j)			'등록 상품 일련번호 (수동 증가 처리!!)
								arr_ItemCount       = arrList1(4,j)			'정기결제 수
								arr_A_Seq           = arrList1(5,j)
								arr_ItemPrice       = arrList1(6,j)
								arr_ItemPV          = arrList1(7,j)
								arr_ItemTotalPrice  = arrList1(8,j)
								arr_ItemTotalPV     = arrList1(9,j)
								arr_G_PL            = arrList1(10,j)
								arr_us_Code         = arrList1(11,j)
								arr_Recordid        = arrList1(12,j)
								arr_Recordtime      = arrList1(13,j)

								arr_name		    = arrList1(14,j)
								arr_price		    = arrList1(15,j)
								arr_price2		    = arrList1(16,j)
								arr_price4		    = arrList1(17,j)
								arr_price5		    = arrList1(18,j)

								'변경체크
								arrParams = Array(_
									Db.makeParam("@ncode",adVarChar,adParamInput,20,arr_ItemCode) _
								)
								Set DKRS = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams,DB3)
								If Not DKRS.BOF And Not DKRS.EOF Then
									arr_price2	= DKRS("price2")
									arr_price4	= DKRS("price4")
									arr_price5	= DKRS("price5")
								Else
									arr_price2	= arr_price2
									arr_price4	= arr_price4
									arr_price5	= arr_price5
								End If
								Call CloseRS(DKRS)

								selfPrice = Int(arr_ItemCount) * Int(arr_price2)
								selfPV	  = Int(arr_ItemCount) * Int(arr_price4)
								selfBV	  = Int(arr_ItemCount) * Int(arr_price5)
								TOTAL_GOODS_PRICE = TOTAL_GOODS_PRICE + selfPrice
								TOTAL_GOODS_PV	  = TOTAL_GOODS_PV	  + selfPV
								TOTAL_GOODS_BV	  = TOTAL_GOODS_BV	  + selfBV

					%>
					<tr>
						<td>
							<input type="hidden" value="<%=arr_Salesitemindex%>" class="selItemIndex" />
							<span id="viewItemCount_<%=arr_Salesitemindex%>" class="selItemCount"><%=arr_ItemCount%></span>
							<input type="tel" name="ItemCount" id="ItemCount_<%=arr_Salesitemindex%>" class="input_text vmiddle tcenter regItemCount" style="width:85%;background:#fbfce4;display:none;" value="<%=arr_ItemCount%>" maxlength="2" <%=onlyKeys%> />
						</td>
						<td colspan="3">
							<div class="" style="display: flex; justify-content: space-between;">
								<div class="" style="width: calc(100% - 35px);">
									<span id="viewItemCode_<%=arr_Salesitemindex%>"><%=arr_name%></span>
									<select name="ItemCode" id="ItemCode_<%=arr_Salesitemindex%>"  style="display: none;" class="input_text itemCountSelect" onchange="insertThisValue3(this, <%=arr_Salesitemindex%>);">
										<option value="" thisattr="">::: 상품 선택 :::</option>
										<%
											MY_CMS_REG_PROC = "HJP_CSGOODS_PRICE_INFO_MY_CMS_REG"

											arrList = Db.execRsList(MY_CMS_REG_PROC,DB_PROC,Nothing,listLen,DB3)
											If IsArray(arrList) Then
												For i = 0 To listLen
													arrList_ncode	= arrList(0,i)
													arrList_name	= arrList(1,i)
													arrList_price2	= arrList(2,i)
													arrList_price4	= arrList(3,i)
													arrList_SellCode= arrList(4,i)
													arrList_price5	= arrList(5,i)	'bv

													selected = ""
													If arrList(0,i) = arr_ItemCode Then selected = " selected"

													PRINT TABS(5)& "	<option value="""&arrList_ncode&""" thisattr="""&arrList_price2&""" thisattr2="""&arrList_ncode&""" thisattr3="""&arrList_price4&""" thisattr4="""&arrList_SellCode&""" thisattr5="""&arrList_price5&""" "&selected&">"&arrList_name&"  ("&num2cur(arrList_price2)&" 원)</option>"
												Next
											Else
												PRINT TABS(5)& "	<option value="""">상품이 존재하지 않습니다.</option>"
											End If
										%>
									</select>
								</div>
								<%If INFO_CHANGE_TF = "T" Then %>
								<div class="" style="width: 30px">
									<input type="button" class="design2 input_btn width100 cp" onclick="javascript:delThis('<%=arr_Salesitemindex%>');" id="addBtn" value="X" />
								</div>
								<%End If%>
							</div>
							<%If INFO_CHANGE_TF = "T" Then %>
							<div class="" style="margin-top: 5px">
								<input type="button" class="design3 input_btn width100 cp" onclick="javascript:modTable(<%=arr_Salesitemindex%>)" value="수정"  />
							</div>
							<%End If%>
						</td>
					</tr>
					<tr>
						<td class="bot_line_c_333">
							<span id="selItemCode_<%=arr_Salesitemindex%>" class="selItemCode"><%=arr_ItemCode%></span>
						</td>
						<td class="inPrice bot_line_c_333 price">
							<span id="selItemPrice_<%=arr_Salesitemindex%>" class="selItemPrice"><%=num2cur(arr_price2)%></span>
						</td>
						<td class="inPrice bot_line_c_333 pv">
							<span id="selItemPV_<%=arr_Salesitemindex%>" class="selItemPV"><%=num2cur(arr_price4)%>
						</td>
						<td class="inPrice bot_line_c_333 bv">
							<span id="selItemBV_<%=arr_Salesitemindex%>" class="selItemBV"><%=num2cur(arr_price5)%>
						</td>
					</tr>
				<%
						Next
				%>
				</tbody>
				<tfoot>
					<tr>
						<td class="total">합계</td>
						<td class="total price"><span id="totalPrice"><%=num2cur(TOTAL_GOODS_PRICE)%></span></td>
						<td class="total pv"><span id="totalPV"><%=num2cur(TOTAL_GOODS_PV)%></span></td>
						<td class="total bv"><span id="totalBV"><%=num2cur(TOTAL_GOODS_BV)%></span></td>
					</tr>
				<%
					Else
				%>
				<tfoot>
				<tr>
					<td colspan="4" class="notData">등록된 내역이 없습니다.</td>
				</tr>
				<%
					End If
				%>
				</tfoot>
			</table>
			<div class="addBtn tright"><button type="button" class="input_submit design1" onclick="javascript:addThis('mod');"><i class="fas fa-plus"></i> 상품추가</a></button></div>

		</div>
		<div class="btnZone tcenter" style="padding:20px 0px;40px 0px;">
			<% If Date() > DateAdd("d", -2, date8to10(RS_A_ProcDay)) Then %>
			<span class="pL10"><input type="button" class="txtBtnC medium radius5 red" style="width:120px;color:#fff;" value="정기결제취소" onclick="alert('결제 예정일 2일 전까지 취소 할 수 있습니다.');"/></span>
			<span class="pL10"><input type="button" class="txtBtnC medium radius5 blue" style="width:120px;color:#fff;" value="저장" onclick="alert('결제 예정일 2일 전까지 저장 할 수 있습니다.');"/></span>
			<% Else %>
			<span class="pL10"><input type="button" class="txtBtnC medium radius5 red" style="width:120px;color:#fff;" value="정기결제취소" onclick="fnCancel();"/></span>
			<span class="pL10"><input type="button" class="txtBtnC medium radius5 blue" style="width:120px;color:#fff;" value="저장" onclick="fnSubmit();"/></span>
			<% End If %>
			<br /><br />
			<span><a href="order_list_cms.asp" type="button" class="txtBtnC medium radius5 gray" style="width:140px;">뒤로가기</a></span>
		</div>
	</form>
</div>

<div style="display:none;">
	<table id="cloneTable">
		<tr class="cloneTr">
			<td>
				<input type="hidden" value="" class="selItemIndex" />
				<input type="tel" name="ItemCount" id="addCount" class="input_text vmiddle tcenter regItemCount" style="width:85%;background:#fbfce4;" value="1" maxlength="2" <%=onlyKeys%> />
			</td>
			<td colspan="3">
				<div class="" style="display: flex; justify-content: space-between;">
					<div class="" style="width: calc(100% - 35px);">
						<select name="ItemCode" id="addCode" class="input_text itemCountSelect" onchange="insertThisValue3(this, );">
							<option value=""  thisattr="">::: 상품 선택 :::</option>
							<%
								MY_CMS_REG_PROC = "HJP_CSGOODS_PRICE_INFO_MY_CMS_REG"

								arrList = Db.execRsList(MY_CMS_REG_PROC,DB_PROC,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For i = 0 To listLen
										arrList_ncode	= arrList(0,i)
										arrList_name	= arrList(1,i)
										arrList_price2	= arrList(2,i)
										arrList_price4	= arrList(3,i)
										arrList_SellCode= arrList(4,i)
										arrList_price5	= arrList(5,i)	'bv

										PRINT TABS(5)& "	<option value="""&arrList_ncode&""" thisattr="""&arrList_price2&""" thisattr2="""&arrList_ncode&""" thisattr3="""&arrList_price4&""" thisattr4="""&arrList_SellCode&"""  thisattr5="""&arrList_price5&""">"&arrList_name&"  ("&num2cur(arrList_price2)&" 원)</option>"
									Next
								Else
									PRINT TABS(5)& "	<option value="""">상품이 존재하지 않습니다.</option>"
								End If
							%>
						</select>
					</div>
					<div class="" style="width: 30px">
						<input type="button" class="design2 input_btn width100" onclick="addedRemove();" id="addBtn" value="X" />
					</div>
				</div>
			</td>
		</tr><tr class="cloneTr">
			<td class="bot_line_c_333"><span id="addItemCode" class="selItemCode"></span></td>
			<td class="inPrice bot_line_c_333 price"><span id="addItemPrice" class="selItemPrice">0</span></td>
			<td class="inPrice bot_line_c_333 pv"><span id="addItemPV" class="selItemPV">0</span></td>
			<td class="inPrice bot_line_c_333 bv"><span id="addItemBV" class="selItemBV">0</span></td>
		</tr>
	</table>
</div>

<form name="frm" method="post" action="">
	<!-- <input type="hidden" name="TOTAL_GOODS_PRICE" value="<%=TOTAL_GOODS_PRICE%>" /> -->
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SDATE" value="<%=SDATE%>" />
	<input type="hidden" name="EDATE" value="<%=EDATE%>" />
</form>

<%'수정 / 삭제%>
<form name="mfrm" method="post" action="order_list_CMS_mod_Ok.asp" >
	<input type="hidden" name="oIDX" value="<%=oIDX%>" readonly="readonly" /><%'CMS회원테이블, CMSS상품테이블 A_Seq%>
	<input type="hidden" name="INFO_CHANGE_TF" value="<%=INFO_CHANGE_TF%>" />
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="ItemCount" value="" />
	<input type="hidden" name="ItemCode" value="" />
	<input type="hidden" name="All_Count1" value="<%=All_Count1%>" />
</form>
<%
	MODAL_BORDER_THICKNESS = 1
%>
<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->

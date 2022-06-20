<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "AUTOSHIP1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"
	AUTOSHIP_CNT_PAGE = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%
		arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDay_M			= DKRS("BirthDay_M")
		DKRS_BirthDay_D			= DKRS("BirthDay_D")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		'DKRS_Ed_TF				= DKRS("Ed_TF")				'신버전삭제
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")
		DKRS_Remarks			= DKRS("Remarks")			'비고

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If DKRS_Address1		<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
				If DKRS_Address2		<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
				If DKRS_Address3		<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
				If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
				If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
				If DKRS_bankaccnt		<> "" Then DKRS_bankaccnt	= objEncrypter.Decrypt(DKRS_bankaccnt)
				If DKRS_Reg_bankaccnt		<> "" Then DKRS_Reg_bankaccnt	= objEncrypter.Decrypt(DKRS_Reg_bankaccnt)

				'If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
					If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
					If DKRS_WebID		<> "" Then DKRS_WebID		= objEncrypter.Decrypt(DKRS_WebID)
					If DKRS_WebPassWord	<> "" Then DKRS_WebPassWord	= objEncrypter.Decrypt(DKRS_WebPassWord)
					If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)				'▣cpno
				'End If
			On Error GoTo 0
		Set objEncrypter = Nothing
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	If DKPG_PGCOMPANY = "PAYTAG" Then
		If DKRS_hptel = "" Then
			Call ALERTS(LNG_JS_MOBILE&" (필수값)","GO","/mypage/member_info.asp")
		End if
	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<!-- <link rel="stylesheet" href="buy.css" /> -->
<link rel="stylesheet" href="order_list_CMS.css?v0" />
<link rel="stylesheet" href="/m/css/order_list_CMS_mod.css?v0" />

<!--#include file = "order_list_CMS.js.asp"--><%'JS%>
<script src="order_list_CMS_reg.js?v3.1"></script>
<script type="text/javascript">
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div id="loadingsA">
	<div class="loadingImg"><img src="/images/159.gif" width="60" alt="loadingImg" /></div>
</div>
<div id="buy" class="orderList cms">
	<!-- <p class="sub_title">정기결제 상세보기</p> -->
	<form name="cfrm" method="post">
		<input type="hidden" name="PGCOMPANY" value="<%=DKPG_PGCOMPANY%>" />
		<div class="agree_info width100">
			<ul>
				<li class="li_title">정기결제(Autoship)를 위한 정보제공에 대한 동의</li>
				<li>- 정기결제를 위해서 회원님의 개인정보를 수집하고 있습니다</li>
				<li>- 제공정보는 암호화를 통해 안전하게 저장되어 관리됩니다.</li>
				<li>- 제공정보는 자동결제 주문처리 및 주문배송를 위한 목적으로만 사용됩니다.</li>
				<li>- 정보를 제공받는 자 : 주문/배송부서 담당자</li>
				<li>- 정보를 제공받는 자의 개인정보 이용 목적 : 자동결제 및 주문상품의 배송</li>
				<li>- 제공하는 정보의 항목 : 성명, 주소, 연락처, 카드번호, 유효기간, 생년월일<!-- , 카드비밀번호(앞2자리) --></li>
				<li>- 정보를 제공받는 자의 개인정보 보유 및 이용기간 : 이용목적 달성 시까지</li>
			</ul>
			<div class="agreement">
				<label for="autoship_agree"><input type="checkbox" name="autoship_agree" id="autoship_agree" class="input_check" style="" value="T"> 정기결제신청을 위해서 상기 정보제공에 동의합니다</label>
			</div>
		</div>

		<p class="titles">회원 기본 배송 주소</p>
		<table <%=tableatt%> class="innerTable2 width100 table1">
			<col width="80" />
			<col width="*" />
			<tr>
				<th>수취인명 <%=startext%></th>
				<td><input type="text" name="strName" class="input_text width100" value="<%=backword_br(DKRS_M_Name)%>" /></td>
			</tr><tr>
				<th rowspan="3">주소 <%=starText%></th>
				<td>
					<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle zip" value="<%=DKRS_Addcode1%>" maxlength="7" readonly="readonly" placeholder="" />
					<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode"  title="<%=LNG_TEXT_ZIPCODE%>"><input type="button" class="a_submit2 design3" value="<%=LNG_TEXT_ZIPCODE%>"/></a>
				</td>
			</tr><tr>
				<td><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text width100 readonly vmiddle" style="" value="<%=DKRS_Address1%>" readonly="readonly" placeholder="" /></td>
			</tr><tr>
				<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text width100" style="ime-mode:active;" value="<%=DKRS_Address2%>"  placeholder="" /></td>
			</tr>
			<tr>
				<th>연락처 1 <%=starText%></th>
				<td><input type="text" name="strMobile" class="input_text width100" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>"  placeholder="" /></td>
			</tr><tr>
				<th>연락처 2</th>
				<td><input type="text" name="strTel" class="input_text width100" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>"  placeholder="" /></td>
			</tr>
		</table>

		<%
			'PG사별 오토쉽 인증방식 구분
			Select Case DKPG_PGCOMPANY
				Case "KSNET"
					KEYIN_CARDAUTH_TF = "F"
				Case Else
					KEYIN_CARDAUTH_TF = "T"
			End Select
		%>
		<input type="hidden" name="KEYIN_CARDAUTH_TF" id="KEYIN_CARDAUTH_TF" value="<%=KEYIN_CARDAUTH_TF%>" readonly="readonly" />

		<div class="width100" id="cardAuthArea" >
			<p class="titles">카드 결제 정보</p>
			<table <%=tableatt%> class="innerTable3 width100 table2" >
				<col width="80" />
				<col width="*" />
				<tbody id="CARD_INFO">
				<%If KEYIN_CARDAUTH_TF = "T" Then%>
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
								<option value="">카드사 선택</option>
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
						<th>카드번호 <%=startext%></th>
						<td>
							<input type="text" name="A_CardNumber1" id="A_CardNumber1" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value=""  style="" <%=onlyKeys%> size="5" />
							<input type="password" name="A_CardNumber2" id="A_CardNumber2" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value=""  style="" <%=onlyKeys%> size="5" />
							<input type="password" name="A_CardNumber3" id="A_CardNumber3" class="input_text vmiddle card" maxlength="4" onkeyup="focus_next_input(this);" value=""  style="" <%=onlyKeys%> size="5" />
							<input type="text" name="A_CardNumber4" id="A_CardNumber4" class="input_text vmiddle card" maxlength="4" value=""  style="" <%=onlyKeys%> size="5" />
						</td>
					<tr><tr>
						<th>유효기간 <%=startext%></th>
						<td>
							<select name="A_Period1" class="vmiddle input_text">
								<option value="">유효기간(년)</option>
								<%For i2 = THIS_YEAR To EXPIRE_YEAR%>
									<option value="<%=i2%>"><%=i2%></option>
								<%Next%>
							</select>
							<select name="A_Period2" class="vmiddle input_text">
								<option value="">유효기간(월)</option>
								<%For j = 1 To 12%>
									<%jsmm = Right("0"&j,2)%>
									<option value="<%=jsmm%>"><%=jsmm%></option>
								<%Next%>
							</select>
						</td>
					</tr><tr>
						<th>소유자명 <%=startext%></th>
						<td><input type="text" name="A_Card_Name_Number" class="input_text vmiddle width100" value="" <%= R_ONLY%>/></td>
					</tr>
					<%If DKPG_PGCOMPANY = "PAYTAG" Then%>
					<tr>
						<th>비밀번호 <%=startext%></th>
						<td>
							<input type="password" name="A_CardPass" class="input_text tcenter" maxlength="2" style="width:90px;" <%=onlyKeys%> value="" />
							<br /><span class="red2"> * 비밀번호 앞 2자리 입력</span>
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
							<input type="password" name="A_Birth" maxlength="6" class="input_text vmiddle width100" value="" placeholder="YYMMDD" <%=onlyKeys%> />
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
					<tr>
						<th>카드인증</th>
						<td>
							<input type="button" class="txtBtn design3 input_btn width100" onclick="join_cardCheck();" value="카드인증" />
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

				<%Else%>
					<tr>
						<th>카드명</th>
						<td><span id="CardNameTXT"></span></td>
					</tr>
					<tr>
						<th>카드번호</th>
						<td><span id="CardNumberTXT"></td>
					</tr>
					<tr>
						<th>카드인증 <%=starText%></th>
						<td>
						<%
							Select Case DKPG_PGCOMPANY
								Case "KSNET"
									If TX_KSNET_TID_AUTOSHIP = "2999199999" Then TEST_KEY_TXT = "_test_key!!"
						%>
							<input type="hidden" name="returnUrl" value="" readonly="readonly">
							<input type="hidden" name="storeid" size="10" value="<%=TX_KSNET_TID_AUTOSHIP%>" readonly="readonly">
							<!-- <input type="hidden" name="payKey" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardNumb" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardIssureCode" size="30" value="" readonly="readonly">
							<input type="hidden" name="cardPurchaserCode" size="30" value="" readonly="readonly"> -->
							<input type="button" class="txtBtn j_medium input_btn width100" onclick="javascript:submitAuth();" value="카드인증<%=TEST_KEY_TXT%>"/>
						<%
							End Select
						%>
							<span class="summary" id="cardCheckTXT"></span>
							<br />
							<select name="A_CardCode" class="vmiddle input_text" style="display:none;"><option value=""></option></select>
							<input type="hidden" name="A_CardNumber1" id="A_CardNumber1" value="" readonly="readonly"  />
							<input type="hidden" name="A_CardNumber2" id="A_CardNumber2" value="" readonly="readonly"  />
							<input type="hidden" name="A_CardNumber3" id="A_CardNumber3" value="" readonly="readonly"  />
							<input type="hidden" name="A_CardNumber4" id="A_CardNumber4" value="" readonly="readonly"  />

							<input type="hidden" name="cardCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkA_Card_Dongle" id="chkA_Card_Dongle" value="" readonly="readonly" />
							<input type="hidden" name="chkA_Card_DongleIDX" id="chkA_Card_DongleIDX" value="" readonly="readonly" />
						</td>
					</tr>
				<%End If%>
				</tbody>
			</table>
			<%If KEYIN_CARDAUTH_TF = "F" And DKPG_PGCOMPANY = "KSNET" Then%>
				<IFRAME id="KSPFRAME" name="KSPFRAME" width="100%" height="0" frameborder="0" src="./blank.html" style="display:none;"></IFRAME>
			<%End If %>
		</div>

		<!-- <div class="btnZone tcenter" style="padding:10px 0px;40px 0px;">
			<span><a href="order_list_cms.asp" type="button" class="txtBtnC medium radius5 gray" style="width:140px;">목록으로 돌아가기</a></span>
			<% If INFO_CHANGE_TF = "T" Then 	'결제 예정일 2일 전까지 수정 / 변경 가능%>
				<span class="pL10"><input type="submit" class="txtBtnC medium radius5 blue" style="width:120px;color:#fff;" value="수정" /></span>
			<%	Else%>
				<span class="pL10"><a href="javascript:alert('결제 예정일 2일 전까지 수정 할 수 있습니다.');" type="button" class="txtBtnC medium radius5 red2" style="width:120px;">수정불가</a></span>
			<%	End If%>
		</div> -->
		<!-- <div class="tweight tcenter red2" style="width: 100%;margin:0 auto;border:1px solid #ccc;background:#fbfce4;font-size:13px;">
			<div style="margin:0 auto;padding:16px 6px 14px 6px;"><p>※ 결제일 등 날짜 관련 정보 수정은 본사로 문의해 주세요.</p><br /><p> 정기결제 상품의 수정은 기존 상품이 1종류 인 경우 변경하실 상품을 등록 하신 후 기존 상품을 삭제 하셔야 합니다.</p></div>
		</div> -->

			<p class="titles">정기결제 정보</p>
			<table <%=tableatt%> class="innerTable3 width100 table3" >
				<col width="100" />
				<col width="*" />
				<tbody>
					<tr>
						<th>희망 정기결제 시작일 <%=starText%></th>
						<td>
							<input type="hidden" id="TODAY" name="TODAY" value="<%=Date()%>" readonly="readonly" />
							<input type="text" id="A_Start_Date" name="A_Start_Date" class="input_text tweight datepicker" style="width: 100px;" value="" readonly="readonly" />
							<br /><%=AUTOSHIP_PAYABLE_DAYS_TEXT%>
						</td>
					</tr><tr>
						<th>매월 결제일</th>
						<td>
							<span id="A_Month_Date" class="tweight">00</span> 일
						</td>
					</tr><tr>
						<th>적용개월 <%=starText%></th>
						<td>
							<select name="A_AutoCnt" class="vmiddle input_text" style="width:100px;" >
								<option value="">선택 ::::::</option>
								<option value="1">1개월마다</option>
								<option value="2">2개월마다</option>
								<option value="3">3개월마다</option>
							</select>
						</td>
					</tr>
					<!-- <tr>
						<th>비고</th>
						<td><input type="text" class="input_text" name="A_ETC"  style="width:95%;" value="" /></td>
					</tr> -->
				</tbody>
			</table>

			<p class="titles">정기결제 상품</p>
			<table <%=tableatt%> class="innerTable width100 table4" >
				<col width="70" />
				<col width="" />
				<col width="" />
				<col width="" />
				<thead>
					<tr>
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
					<tr class="noTable">
						<td colspan="4" class="notData">등록된 내역이 없습니다.</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td class="total">합계</td>
						<td class="total price"><span id="totalPrice">0</span></td>
						<td class="total pv"><span id="totalPV">0</span></td>
						<td class="total bv"><span id="totalBV">0</span></td>
					</tr>
				</tfoot>
			</table>
			<div class="addBtn tright"><button type="button" class="button write" onclick="javascript:addThis();"><i class="icon-plus-1"></i> 상품추가</a></button></div>
		<div class="btnZone tcenter">
			<input type="button" class="promise" style="color:#fff;" value="등록" onclick="fnSubmit();"/>
			<!-- <span><a href="order_list_cms.asp" type="button" class="txtBtnC medium radius5 gray" style="width:140px;">목록으로 돌아가기</a></span> -->
		</div>
	</form>
</div>

<div style="display:none;">
<table id="cloneTable">
	<tr class="cloneTr">
		<td>
			<input type="hidden" value="" class="selItemIndex" />
			<input type="tel" name="ItemCount" id="addCount" class="input_text vmiddle tcenter regItemCount" value="1" maxlength="2" <%=onlyKeys%> />
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
				<!-- <div class="" style="width: 30px">
					<input type="button" class="design2 input_btn width100 cp" onclick="addedRemove();" id="addBtn" value="X" />
				</div> -->
				<label class="close_btn">
					<input type="button" onclick="addedRemove();" id="addBtn" value="" />
					<i class="icon-cancel"></i>
				</label>
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
<%
	MODAL_BORDER_THICKNESS = 1
%>
<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->

<%
	'If webproIP <> "T" Then Call ALERTS("죄송합니다. 현재페이지 업데이트 중입니다.","back","")

	If pT = "shop" Then
		ptshop = "?pt=shop"
	Else
		ptshop = ""
	End If

	'▣cpno체크
	DKRS_strSSH1 = ""
	DKRS_strSSH2 = ""

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
		DKRS_snsType			= DKRS("snsType")			'snsType

		DKRS_Reg_bankaccnt		= DKRS("Reg_bankaccnt")		'■계좌인증확인
		If NICE_MOBILE_CONFIRM_TF = "T" Then
			On Error Resume Next
			DKRS_mobileAuth			= DKRS("mobileAuth")		'◆휴대폰인증확인		'테이블 컬럼추가 확인!!!!
			On Error Goto 0
		Else
			DKRS_mobileAuth = ""
		End If

		WebID_ORI = DKRS_WebID	'Viral Address Check
		If DKRS_WebID = "" Then
			DKRS_WebID = ""		'"웹아이디 미등록 계정" LNG_MYPAGE_INFO_COMPANY_TEXT01
		End If

		passwordView = ""
		IF DKRS_snsType <> "" Then
			'DKRS_WebID = DKRS_snsType&" 계정 가입 회원"
			passwordView = "display: none;"
		End If

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
				If DKRS_Reg_bankaccnt		<> "" Then DKRS_Reg_bankaccnt	= objEncrypter.Decrypt(DKRS_Reg_bankaccnt)		'추가
				If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
				If DKRS_WebPassWord	<> "" Then DKRS_WebPassWord	= objEncrypter.Decrypt(DKRS_WebPassWord)
				If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)				'▣cpno
			On Error GoTo 0
		Set objEncrypter = Nothing


		'▣cpno체크
		CPNO_CHANGE_TF = "F"
		JOMIN_ERROR_TF = ""

		'▣수당발생내역 확인
		'arrParmas = Array(_
		'	Db.makeParam("@mbid1",adVarChar,adParmaInput,20,DK_MEMBER_ID1), _
		'	Db.makeParam("@mbid2",adInteger,adParmaInput,4,DK_MEMBER_ID2) _
		')
		'MY_TOTAL_ALLOWANCE = Db.execRsData("HJPS_CS_PRICE_TOTAL",DB_PROC,arrParams,DB3)
		'If MY_TOTAL_ALLOWANCE > 0 Then '▣수당발생한경우만 주민번호 변경/수집가능

		If UCase(DK_MEMBER_NATIONCODE) = "KR" And DK_MEMBER_TYPE = "COMPANY" And Sell_Mem_TF = "0" Then		'KR회원 , 판매원

			'▣cpno 앞자리만 입력 = 생년월일
			If Len(DKRS_cpno) = 6 Then
				If CDbl(DKRS_cpno) = CDbl(Right(DKRS_BirthDay&DKRS_BirthDay_M&DKRS_BirthDay_D,6)) Then
					DKRS_cpno = DKRS_cpno&"1000000"
				Else
					JOMIN_ERROR_TF = "T"
				End If
			End If

			'▣cpno체크
			If DKRS_cpno <> "" And Len(DKRS_cpno) = 13 Then		'정상주민번호 자릿수
				DKRS_strSSH1 = Left(DKRS_cpno,6)
				DKRS_strSSH2 = Right(DKRS_cpno,7)

				If CDbl(DKRS_strSSH1) <> CDbl(Right(DKRS_BirthDay&DKRS_BirthDay_M&DKRS_BirthDay_D,6)) Then
					JOMIN_ERROR_TF = "T"
				End If

				If DKRS_strSSH1 > 0 And Right(DKRS_strSSH2,6) = "000000" Then
					bgc   = " background:#f4f4f4"
					rOnly = "readonly=""readonly"""
					CPNO_CHANGE_TF = "T"
				Else
					CPNO_CHANGE_TF = "F"								'정상주민번호(수정불가)

					If juminCheck(DKRS_cpno) = 0 Then	'유효하지 않음
						JOMIN_ERROR_TF = "T"			'본사문의
					End If
'
				End If

			ElseIf DKRS_cpno = ""  Then							'빈값인경우

				'▣미성년자 체크
				If DKRS_BirthDay <> "" And DKRS_BirthDay_M <> "" And DKRS_BirthDay_D <> "" Then
					myBirth  = DKRS_BirthDay&DKRS_BirthDay_M&DKRS_BirthDay_D
					If Len(myBirth) = 8 And IsNumeric(myBirth) = True Then
						myBirth = myBirth
					Else
						myBirth = ""
					End If
				Else
					myBirth = ""
				End If

				isMINORS = FNC_MINORS_CHECK(myBirth)

				Select Case isMINORS
					Case "T"			'미성년
						CPNO_CHANGE_TF = "F"			'정상주민번호(수정불가)
						isMINORS_ERROR_TF = "T"			'미성년자 판매원가입
					Case "E"
						CPNO_CHANGE_TF = "F"			'정상주민번호(수정불가)
						MYBIRTH_ERROR_TF = "T"			'생년월일 오류
					Case "F"			'성년
						BIRTH_strSSH1 = Right(myBirth,6)
						If Len(BIRTH_strSSH1) = 6 Then
							DKRS_strSSH1 = BIRTH_strSSH1
							DKRS_strSSH2 = ""
							bgc   = " background:#f4f4f4"
							rOnly = "readonly=""readonly"""

							CPNO_CHANGE_TF = "T"
						Else
							CPNO_CHANGE_TF = "F"
						End If
					Case Else
						CPNO_CHANGE_TF = "F"
				End Select

			Else												'cpno 존재하지만 13자리 아닌경우
				DKRS_strSSH1 = DKRS_cpno						'ssh1에 cpno전체값 담아 저장
				DKRS_strSSH2 = ""
				CPNO_CHANGE_TF = "F"
			End If

		Else
			CPNO_CHANGE_TF = "F"
		End If

	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)
'	IMG_JOIN = "/images_en/join"

	arrParams99 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy99"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,"KR") _
	)
	policyContent99 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams99,Nothing)
	policyContent99 = Replace(policyContent99,"000",DKCONF_SITE_TITLE)
	If IsNull(policyContent99) Or policyContent99 = "" Then policyContent99 = "개인정보취급방침이 등록되지 않았습니다."


	'CPNO_CHANGE_TF ="F"
%>
<%
	'■계좌인증확인
	If DKRS_Reg_bankaccnt = "" Or (DKRS_Reg_bankaccnt <> DKRS_bankaccnt) Then
		Reg_bankaccnt_TF = "F"
	Else
		Reg_bankaccnt_TF = "T"
	End If

	'◆휴대폰인증확인
	If DKRS_mobileAuth = "" Then
		mobileAuth_TF = "F"
	Else
		mobileAuth_TF = "T"
	End If

	'주민번호 체크
	If CPNO_CHANGE_TF = "F" Then	'정상주민번호(수정불가)
		cpno_Check = "T"
	Else
		cpno_Check = "F"
	End If

%>
<!-- <div id="mypage" class="member_modify userCWidth2"> -->
<div id="mypage" class="common">
	<%If JOMIN_ERROR_TF="T"then%>
		<div class="width100 tcenter tweight red" style="height:30px;line-height:30px;background:#ececec;margin-top:20px;">유효하지 않은 주민번호(또는 생년월일 불일치) 본사에 문의해주세요.</div>
	<%End if%>
	<%If isMINORS_ERROR_TF = "T" Then %>
		<div class="width100 tcenter tweight red" style="height:30px;line-height:30px;background:#ececec;margin-top:20px;">유효하지 않은 생년월일(미성년자). 본사에 문의해주세요.</div>
	<%End if%>
	<%If MYBIRTH_ERROR_TF = "T" Then %>
		<div class="width100 tcenter tweight red" style="height:30px;line-height:30px;background:#ececec;margin-top:20px;">유효하지 않은 생년월일(형식오류). 본사에 문의해주세요.</div>
	<%End if%>
	<form name="cfrm" method="post" action="member_info_company_handler.asp" onsubmit="return memInfoChk(this);">
		<input type="hidden" name="ori_bankCode"  id="ori_bankCode" value="<%=DKRS_bankcode%>" readonly="readonly">
		<input type="hidden" name="ori_bankOwner" id="ori_bankOwner" value="<%=DKRS_bankowner%>" readonly="readonly">
		<input type="hidden" name="ori_bankNumber"id="ori_bankNumber" value="<%=DKRS_bankaccnt%>" readonly="readonly">
		<input type="hidden" name="CPNO_CHANGE_TF" value="<%=CPNO_CHANGE_TF%>">				 <%'▣cpno변경%>
		<input type="hidden" name="cpno_Check"  id="cpno_Check" value="F" readonly="readonly" />  <%'▣cpno변경%>
		<input type="hidden" name="chk_CpnoNum1" id="chk_CpnoNum1" value="" readonly="readonly" /><%'▣cpno변경%>
		<input type="hidden" name="chk_CpnoNum2" id="chk_CpnoNum2" value="" readonly="readonly" /><%'▣cpno변경%>

		<input type="hidden" name="Reg_bankaccnt_TF" id="Reg_bankaccnt_TF" value="<%=Reg_bankaccnt_TF%>" readonly="readonly" />
		<input type="hidden" name="mobileAuth_TF" id="mobileAuth_TF" value="<%=mobileAuth_TF%>" readonly="readonly" />

		<article>
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_NAME%></h5>
					<div class="con"><%=DKRS_M_Name%></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_MEMID%></h5>
					<div class="con"><%=DKRS_mbid%>-<%=Fn_MBID2(DKRS_mbid2)%></div>
				</div>
			</div>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_WEBID%></h5>
					<div class="con"><%=DKRS_WebID%></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_REGTIME%></h5>
					<div class="con"><%=date8to10(DKRS_Regtime)%></div>
				</div>
			</div>
			<div class="password" style="<%=passwordView%>">
				<h5><%=LNG_TEXT_PASSWORD%> <%=starText%></h5>
				<div class="con">
					<input type="password" name="strPass" class="input_text" maxlength="20" />
					<label class="checkbox"><input type="checkbox" name="isChgPass" value="T" class="vmiddle" onClick="checkChgPass(this)" /><span><i class="icon-ok"></i><%=LNG_TEXT_PASSWORD_CHANGE%></span></label>
				</div>
			</div>
			<div id="bodyPass" style="display:none;" class="drow">
				<div>
					<h5><%=LNG_TEXT_NEWPASSWORD%> <%=starText%></h5>
					<div class="con"><input type="password" name="newPass" class="input_text" maxlength="20" /> <p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_NEWPASSWORD_CONFIRM%> <%=starText%></h5>
					<div class="con"><input type="password" name="newPass2" class="input_text" maxlength="20" /> <p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p></div>
				</div>
			</div>
			<%IF DK_MEMBER_STYPE = "0" THEN%>
				<div class="bank">
					<h5><%=LNG_TEXT_BANK_INFO%></h5>
					<%
						SQL = "SELECT [bankName] FROM [tbl_Bank] WHERE [ncode] = ?"
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,10,DKRS_bankcode) _
						)
						DKRS_bankName = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
					%>
					<%If UCase(DK_MEMBER_NATIONCODE) = "KR" And Reg_bankaccnt_TF = "T" And DK_MEMBER_STYPE = "0" and 1=1 Then '기존 계좌인증 받은 경우 수정만%>
					<%'If UCase(DK_MEMBER_NATIONCODE) = "KR" And NICE_BANK_CONFIRM_TF = "T" And DK_MEMBER_STYPE = "0" Then '계좌인증 등록/수정%>
					<div class="con">
						<div class="bankText">
							<%  '■계좌인증(한국, 판매원)
								If DKRS_Reg_bankaccnt <> "" And (DKRS_Reg_bankaccnt = DKRS_bankaccnt) Then
									PRINT "<span id=""bankText""><span class=""text_blue"">[인증계좌]</span>"
									PRINT "["&DKRS_bankName&"] "&DKRS_bankaccnt&"  ["&LNG_TEXT_BANKOWNER&"] : "&DKRS_bankowner &"</span>"
								Else
									PRINT "<span id=""bankText""><span class=""text_red"">[미인증계좌]</span>"
									PRINT "["&DKRS_bankName&"] "&DKRS_bankaccnt&"  ["&LNG_TEXT_BANKOWNER&"] : "&DKRS_bankowner &"</span>"
								End If
							%>

							<input type="button" class="button" style="width: 15%" onclick="javascript:Toggle_BankReg();" id="btnBankReg" value="변경하기"/>
						</div>
					</div>
				</div>
				<div id="bankReg" class="cleft width100" style="display: none;">
					<h5>계좌정보 변경</h5>
					<div class="con">
						<div class="inputs_wrap">
							<div class="inputs">
								<select name="bankCode" class="input_select">
									<option value="">은행을 선택해주세요</option>
									<%
										'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [Na_Code] = 'KR' ORDER BY [nCode] ASC"
										SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [Na_Code] = 'KR' AND [Using_Flag] = 'T' ORDER BY [nCode] ASC"
										arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
										If IsArray(arrList) Then
											For i = 0 To listLen
												PRINT Tabs(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
											Next
										Else
											PRINT Tabs(5)& "	<option value="""">등록된 계좌코드가 없습니다.</option>"
										End If
									%>
								</select>
								<input type="text" name="BankNumber" class="input_text" placeholder="계좌번호" onkeyup="bankAccountKey(event);" maxlength="20" <%=onLyKeys%>/>
								<!-- <a href="javascript: bankAuth();" class="button">계좌인증</a> -->
							</div>
							<input type="button" class="button" onclick="javascript:bankAuth();" style="width: 15%;" value="계좌인증"/>
						</div>

						<p class="regInfo"><span id="bankInfo" class="tweight" style="background: #FFF599;"></span></p>
						<span class="regInfo red">※ 예금주와 회원성명이 다른 경우 마이오피스에서 계좌인증을 할 수 없습니다. 회사로 문의해주세요.</span>
						<input type="hidden" name="ajaxTF" id="ajaxTF" value="F" readonly="readonly" />
						<input type="hidden" name="TempDataNum" id="TempDataNum" value="" readonly="readonly" />
					</div>
					<%Else%>
					<div class="con">
						<p>[<%=DKRS_bankName%>] <%=DKRS_bankaccnt%>  [<%=LNG_TEXT_BANKOWNER%>] : <%=DKRS_bankowner%></p>
					</div>
					<%End IF%>

				</div>
				<%'If CPNO_CHANGE_TF = "T" Then '▣cpno 변경%>
				<div class="bank" id="cpno" style="display:none;">
					<h5><%=LNG_TEXT_CPNO%></h5>
					<div class="con">
						<div class="inputs">
							<input type="text" name="ssh1" class="input_text" value="<%=DKRS_strSSH1%>" maxlength="6" <%=onLyKeys%> <%=rOnly%> />
							<span>-</span>
							<input type="password" name="ssh2" class="input_text"  value="" maxlength="7" <%=onLyKeys%> />
						</div>
						<!-- <img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="주민번호 중복체크" class="cp vmiddle" onclick="join_cpnoCheck()" /> -->
						<input type="button" class="button" onclick="join_cpnoCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="cpnoCheck">
							<!-- <input type="text " name="cpnoCheck" value="F" readonly="readonly" />
							<input type="text " name="chkCpnoNum1" value="" readonly="readonly" />
							<input type="text " name="chkCpnoNum2" value="" readonly="readonly" /> -->
						</p>
					</div>
				</div>
				<div class="agreeArea">
					<div class="title">
						<h3><%=LNG_POLICY_02%></h3>
						<label class="checkbox">
							<input type="checkbox" id="agreement" name="agreement" value="T" onClick="toggle_flex('cpno')" />
							<span><i class="icon-ok"></i><%=LNG_TEXT_I_AGREE%></span>
						</label>
					</div>
					<div class="agreeBox">
						<div class="agree_content"><%=backword_tag(policyContent99)%></div>
					</div>
				</div>
				<%'End If%>
			<%END IF%>
		</article>

		<article>
			<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
			<div class="address dwrap">
				<div>
					<h5><%=LNG_TEXT_ADDRESS1%> <%=starText%></h5>
					<div class="con">
						<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
							<%Case "KR"%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7" value="<%=DKRS_Addcode1%>" readonly="readonly" />
								<!-- <input type="button" class="button" onclick="execDaumPostcode('oris');" value="<%=LNG_TEXT_ZIPCODE%>" /> -->
								<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode" title="우편번호검색" ><input type="button" class="button" value="<%=LNG_TEXT_ZIPCODE%>" style="width:100px;"/></a>
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" readonly="readonly" />
							<%Case "JP"%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7"  <%=onLyKeys%> value="<%=DKRS_Addcode1%>" readonly="readonly"/>
								<input type="button" class="button" onclick="openzip_jp2EN();" value="<%=LNG_TEXT_ZIPCODE%>" />
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" readonly="readonly"/>
							<%Case Else%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7"  <%=onLyKeys%> value="<%=DKRS_Addcode1%>" />
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" />
						<%End Select%>
					</div>
				</div>
				<div>
					<h5><%=LNG_TEXT_ADDRESS2%> <%=starText%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" maxlength="500" value="<%=DKRS_Address2%>" />
					</div>
				</div>
			</div>
			<div class="drow">
				<div class="mobile">
					<h5><%=LNG_TEXT_MOBILE%> <%=starText%></h5>
					<div class="con">
						<%If NICE_MOBILE_CONFIRM_TF = "T" And UCase(DK_MEMBER_NATIONCODE) = "KR" and Sell_Mem_TF = "0" Then '◆휴대폰인증%>
							<div class="inputs_wrap">
								<div class="inputs">
									<input type="text" class="input_text" name="strMobile" id="strMobile" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>" readonly="readonly" />
								</div>
								<input type="hidden" id="authVal" name="authVal" value="" readonly="readonly" />
								<!--#include file = "member_info_mobileAuth.asp"-->
								<input type="button" class="button" onclick="fnAuthPhone();" value="<%=LNG_SUBTITLE_TEXT29%>" />
							</div>
							<%If DKRS_mobileAuth = "" Then%><p id="authStatus" class="red"><%=LNG_UNCERT%></p><%End IF%>
							<p class="summary">* <%=LNG_MYPAGE_INFO_COMPANY_TEXT23%></p>
						<%Else%>
							<p><%=DKRS_hptel%></p>
							<input type="hidden" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>" />
							<!-- <input type="text" name="strMobile" class="input_text" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>" /> -->
							<!-- <span class="summary">* <%=LNG_MYPAGE_INFO_COMPANY_TEXT23%></span> -->
						<%End if%>
					</div>
				</div>
				<div>
					<h5><%=LNG_TEXT_TEL%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>" />
					</div>
				</div>
			</div>
			<style>

			</style>
			<div class="drow">
				<div class="email mobile"> <!-- mobile 스타일 적용 -->
					<h5><%=LNG_TEXT_EMAIL%> <%=startext%></h5>
					<div class="con">
						<div class="inputs_wrap">
							<div class="inputs">
								<input type="text" name="strEmail" class="input_text" maxlength="512" value="<%=DKRS_Email%>" />
							</div>
							<input type="button" class="button" onclick="join_emailCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
							<input type="hidden" name="ori_strEmail" value="<%=DKRS_Email%>" readonly="readonly" />
							<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkEmail" value="" readonly="readonly" />
							<p id="authStatus" class="red"><span id="emailCheckTXT"></span></p>
						</div>
					</div>
				</div>
				<div class="birth radio">
					<h5><%=LNG_TEXT_BIRTH%> <%=starText%></h5>
					<div class="con">
						<input type="hidden" name="birthYY" value="<%=DKRS_BirthDay%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=DKRS_BirthDay_M%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=DKRS_BirthDay_D%>" readonly="readonly" />
						<p><%=DKRS_BirthDay%>-<%=DKRS_BirthDay_M%>-<%=DKRS_BirthDay_D%></p>

						<div class="labels">
							<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
								<label class="checkbox"><input type="radio" name="isSolar" value="1" class="input_radio" <%=isChecked(DKRS_BirthDayTF,"1")%> /><span><i class="icon-ok"></i><%=LNG_TEXT_SOLAR%></span></label>
								<label class="checkbox"><input type="radio" name="isSolar" value="2" class="input_radio" <%=isChecked(DKRS_BirthDayTF,"2")%>  /><span><i class="icon-ok"></i><%=LNG_TEXT_LUNAR%></span></label>
							<%Else%>
								<input type="hidden" name="isSolar" value="<%=DKRS_BirthDayTF%>" />
							<%End If%>
						</div>
					</div>
				</div>
			</div>
			<%If VIRAL_USE_TF = "T" And WebID_ORI <> "" Then%>
			<%If DK_MEMBER_STYPE = "0" Then	'판매원만 바이럴 추천가능%>
			<div class="voter">
				<h5><%=LNG_MYPAGE_INFO_VOTER_ADDRESS%></h5>
				<div class="con">
					<script src="/jscript/jquery.base62.js"></script>
					<script>
						$(document).ready(function(){
							let vidBase62Enc = $d.encodeBase62('<%=WebID_ORI%>');
							$("#vid").text(vidBase62Enc);
						});
					</script>
					<%
						sUrl = Replace(houUrl,"www.","")
						MY_VOTER_ADDRESS = HTTPS&"://"&sUrl&"/v/"
					%>
					<p id="vidAddr"><%=MY_VOTER_ADDRESS%><span id="vid"></span></p>
					<input type="button" class="button" value="<%=LNG_MYPAGE_INFO_COPY%>" onclick="copyAddr();" />
					<!-- <p><%=LNG_MYPAGE_INFO_VOTER_ADDRESS_A%></p> -->
				</div>
			</div>
			<%End If%>
			<%End If%>

			<%If isSHOP_POINTUSE = "T" And DK_MEMBER_STYPE = "0" Then%>
			<%
				IF DKRS_SendPassWord = "" Then
					MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_REGISTER
				Else
					MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_CHANGE
				End If
			%>
			<div class="">
				<h5><%=LNG_MONEY_OUTPUT_PIN%> <%=starText%></h5>
				<div class="con">
					<input type="button" class="design4 cp" style="height: 5rem;" value="<%=MONEY_OUTPUT_PIN_TXT%>" onclick="location.href='/mypage/member_outpin_change.asp'" />
					<%If DKRS_SendPassWord <> "" and 1=222 Then%>
					<input type="button" class="design4 cp" style="height: 5rem;" value="<%=LNG_MONEY_OUTPUT_PIN_RESET%>" onclick="location.href='/mypage/member_outpin_reset.asp'" />
					<%End If%>
				</div>
			</div>
			<%End If%>

		</article>
		<div class="btnZone">
			<input type="submit" class="button" value="<%=LNG_TEXT_CONFIRM%>" />
		</div>

	</form>

	<%'◆핸드폰본인인증%>
	<form name="form_chk" method="post">
		<input type="hidden" name="m" value="checkplusSerivce">
		<input type="hidden" name="EncodeData" value="<%= sEncData %>">
	</form>

</div>

<script type="text/javascript">

	function copyAddr() {
		value = $("#vidAddr").text();
		var IE=(document.all)?true:false;
		if (IE) {
			if(confirm("본인추천주소 :"+value+" 를 복사하시겠습니까?"))
			window.clipboardData.setData("Text", value);
		} else {
			temp = prompt("본인추천주소입니다!!. Ctrl+C를 눌러 클립보드로 복사하세요", value);
		}
	}

</script>
<!--#include virtual="/_include/modal_config.asp" -->

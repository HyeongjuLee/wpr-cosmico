<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"
	view = 2
	sview = 1
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"




	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	sns_authID = pRequestTF("sns_authID",False) : If sns_authID = "" Then sns_authID = ""

	Select Case S_SellMemTF
		Case 0
			'If NICE_MOBILE_CONFIRM_TF = "T" OR NICE_BANK_CONFIRM_TF = "T" Then Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
			sview = 2
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
		Case 1
			sview = 1
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER

			If NICE_MOBILE_CONFIRM_TF = "T" Then
				NICE_MOBILE_CONFIRM_TF = NICE_MOBILE_CONFIRM_SOBIJA	'소비자회원 핸드폰인증
			End If

			NICE_BANK_CONFIRM_TF = "F"

		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select

	'외국인 휴대전화F, 계좌인증F 초기화
	If UCase(DK_MEMBER_NATIONCODE) <> "KR" Then
		NICE_MOBILE_CONFIRM_TF = "F"
		NICE_BANK_CONFIRM_TF = "F"
	End If

'	Select Case UCase(LANG)
'		Case "KR","MN"
			'If Not checkRef(houUrl &"/m/common/joinStep01.asp") Then	Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'		Case Else
'			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
'	End Select

	'국가정보
	'R_NationCode = gRequestTF("cnd",True)
	'R_NationCode = Lang

	R_NationCode = LangGLB

	arrParams = Array(_
		Db.makeParam("@nationCode",adVarChar,adParamInput,20,R_NationCode) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_CHK_NATION",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_nationNameEn	= DKRS("nationNameEn")
		DKRS_nationCode		= DKRS("nationCode")
		DKRS_className		= DKRS("className")
	Else
		Call ALERTS("We are sorry. The country code is not valid.","back","")
	End If

	arrParams1 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy01"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent1 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams1,Nothing)
	policyContent1 = Replace(policyContent1,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = LNG_JOINSTEP02_U_TEXT01 &"("&DKRS_nationNameEn&")"

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = LNG_JOINSTEP02_U_TEXT02 &"("&DKRS_nationNameEn&")"


	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = LNG_JOINSTEP02_U_TEXT03 &"("&DKRS_nationNameEn&")"

	arrParams4 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy04"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent4 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams4,Nothing)
	policyContent4 = Replace(policyContent4,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent4) Or policyContent4 = "" Then policyContent4 = "임의적인 가공 및 재판매 금지서약 약관이 등록되지 않았습니다."

%>
<%
	'SNS 가입
	snsType = pRequestTF("snsType",False) : If snsType = "" Then snsType = ""
	snsToken = pRequestTF("snsToken",False) : If snsToken = "" Then snsToken = ""
	snsName = pRequestTF("snsName", False)	: If snsName = "" Then snsName = ""
	snsEmail = pRequestTF("snsEmail", False)	: If snsEmail = "" Then snsEmail = ""
	snsBirthday = pRequestTF("snsBirthday", False)	: If snsBirthday = "" Then snsBirthday = ""
	snsBirthyear = pRequestTF("snsBirthyear", False)	: If snsBirthyear = "" Then snsBirthyear = ""
	snsGender = pRequestTF("snsGender", False)	: If snsGender = "" Then snsGender = ""
	snsMobile = pRequestTF("snsMobile", False)	: If snsMobile = "" Then snsMobile = ""
	snsFamilyName = pRequestTF("snsFamilyName", False)	: If snsFamilyName = "" Then snsFamilyName = ""
	snsGivenName = pRequestTF("snsGivenName", False)	: If snsGivenName = "" Then snsGivenName = ""

	Select Case Lcase(snsType)
		Case "naver","kakao"
			If snsName <> "" Then
				Call FnNameSeparation(snsName, snsM_Name_Last, snsM_Name_First)
			End If
			snsBirthYY 	= snsBirthyear
			snsBirthMM 	= Left(snsBirthday,2)
			snsBirthDD 	= Right(snsBirthday,2)
	End Select

	IF snsFamilyName <> "" And snsGivenName <> "" Then
		snsM_Name_Last = snsFamilyName		'성
		snsM_Name_First = snsGivenName		'이름
	End If

	If snsType = "kakao" Then
		snsGender = Ucase(Left(snsGender,1))
		'카카오 핸드폰번호 치환(+82 10-1234-5678 형식)
		IF snsMobile <> "" Then
			snsMobile = Replace(snsMobile,"-","")
			'핸드폰 정보 치환
			If Left(snsMobile,4) = "+82 " Then
				snsMobile = Replace(snsMobile,"+82 ","0")
			Else
				snsMobile = ""
			End If
		End If
	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<!--#include file = "joinStep02.js.asp"--><%'JS%>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('.list li').click(function(){
			$(this).toggleClass('on');
		});
	});
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join02" class="joinstep">
	<form name="agreeFrm" id="agreeFrm" method="post" action="joinStep03.asp" onsubmit="return checkAgree(this);">
		<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="name" value="" readonly="readonly" />
		<input type="hidden" name="For_Kind_TF" value="1" readonly="readonly" />
		<input type="hidden" name="sns_authID" value="<%=sns_authID%>" readonly="readonly" />
		<%If NICE_MOBILE_CONFIRM_TF = "T" Then%>
			<!--#include virtual="/MOBILEAUTH/mobileAuth.asp" -->
			<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
			<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
			<input type="hidden" name="birthYY" value="" readonly="readonly" />
			<input type="hidden" name="birthMM" value="" readonly="readonly" />
			<input type="hidden" name="birthDD" value="" readonly="readonly" />
			<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />
		<%Else%>
			<input type="hidden" name="ajaxTF" value="F" readonly="readonly" />
			<input type="hidden" name="strBankCodeCHK" value="" readonly="readonly" />
			<input type="hidden" name="strBankNumCHK" value="" readonly="readonly" />
			<input type="hidden" name="strBankOwnerCHK" value="" readonly="readonly" />
			<input type="hidden" name="birthYYCHK" value="" readonly="readonly" />
			<input type="hidden" name="birthMMCHK" value="" readonly="readonly" />
			<input type="hidden" name="birthDDCHK" value="" readonly="readonly" />
			<input type="hidden" name="TempDataNum" value="" readonly="readonly" />
			<input type="hidden" name="bankOwner" value="<%=strName%>" readonly="readonly" />
			<input type="hidden" name="M_Name_LastCHK" value="" readonly="readonly" />
			<input type="hidden" name="M_Name_FirstCHK" value="" readonly="readonly" />
		<%End If%>
		<%'SNS 가입관련%>
		<input type="hidden" name="snsType" value = "<%=snsType%>" readonly="readonly">
		<input type="hidden" name="snsToken" value = "<%=snsToken%>" readonly="readonly">
		<input type="hidden" name="snsName" value = "<%=snsName%>" readonly="readonly">
		<input type="hidden" name="snsEmail" value = "<%=snsEmail%>" readonly="readonly">
		<input type="hidden" name="snsBirthday" value = "<%=snsBirthday%>" readonly="readonly">
		<input type="hidden" name="snsBirthyear" value = "<%=snsBirthyear%>" readonly="readonly">
		<input type="hidden" name="snsGender" value = "<%=snsGender%>" readonly="readonly">
		<input type="hidden" name="snsMobile" value = "<%=snsMobile%>" readonly="readonly">

		<section class="all">
			<label>
				<input type="checkbox" id="allAgree" onclick="allCheckAgree()" name="allAgree" value="T" />
				<span><%=LNG_JOINSTEP02_U_TEXT07%></span>
			</label>
		</section>
		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_01%></h6>
				<label>
					<input type="checkbox" id="agree01Chk" name="agree01" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent1)%></div>
			</div>
		</section>
		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_02%></h6>
				<label>
					<input type="checkbox" id="agree02Chk" name="agree02" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent2)%></div>
			</div>
		</section>
		<%If S_SellMemTF = 0 Then%>
		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_03%></h6>
				<label>
					<input type="checkbox" id="agree03Chk" name="agree03" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box">
				<div class="agree_content"><%=backword_tag(policyContent3)%></div>
			</div>
		</section>
		<%End IF%>

		<section>
			<div class="agree_tit">
				<h6><%=LNG_POLICY_04%></h6>
				<label>
					<input type="checkbox" id="agree04Chk" name="agree04" value="T" />
					<span><%=LNG_TEXT_I_AGREE%></span>
				</label>
			</div>
			<div class="agree_box" style="height: 17rem;">
				<div class="agree_content"><%=backword_tag(policyContent4)%></div>
			</div>
		</section>

		<%
			If UCase(R_NationCode) = "KR" Then
				IMES_MODE = " ime-mode:active;"
			Else
				IMES_MODE = " ime-mode:disabled;"
			End If
		%>
		<%If NICE_MOBILE_CONFIRM_TF <> "T" Then		'휴대폰 인증 XXX %>
		<article class="privacy">
			<h6><%=LNG_TEXT_MEMBER_REGIST_CHECK%><p><%=LNG_TEXT_CLASS_P%></p></h6>
			<%If UCase(R_NationCode) = "KR" Then%>
			<p><span class="e"><%=DKCONF_SITE_TITLE%></span>은 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.</p>
			<%End If%>
			<div class="info">
				<%If NICE_BANK_CONFIRM_TF = "T" And S_SellMemTF = 0 Then		'계좌인증(판매원)%>
					<table <%=tableatt%>>
						<col width="60" />
						<col width="" />
						<col width="60" />
						<col width="" />
						<tr class="ba nk">
							<th>은행선택</th>
							<td>
								<select name="bankCode" class="input_select" style="width: 100%;">
									<option value="">은행을 선택해주세요</option>
									<%
										SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE ([Na_Code] = 'KR') AND [Using_Flag] = 'T' "
										arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
										If IsArray(arrList) Then
											For i = 0 To listLen
												PRINT Tabs(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
											Next
										Else
											PRINT Tabs(5)& "	<option value="""">"&LNG_JOINSTEP03_U_TEXT15&"</option>"
										End If
									%>
								</select>
							</td>
						</tr><tr>
							<th>계좌번호</th>
							<td>
								<input type="text" name="bankNumber" class="input_text"  maxlength="20" style="" <%=onlyKeys%> placeholder="<%=LNG_JOINSTEP03_02%>" >
							</td>
						</tr>
						<tr class="name">
							<th>예금주</th>
							<td style="display: flex; justify-content: space-between;">
								<div style="width: 40%;">
									<input type="text" name="M_Name_Last" value="<%=snsM_Name_Last%>" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_FAMILY_NAME%>" />
								</div>
								<div style="width: 58%;">
									<input type="text" name="M_Name_First" value="<%=snsM_Name_First%>" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_GIVEN_NAME%>" />
								</div>
							</td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
							<td class="middleTD" colspan="4">
								<select name = "birthYY">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" <%=isSelect(snsbirthYY,i)%> ><%=i%></option>
									<%Next%>
								</select>
								<select name = "birthMM">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" <%=isSelect(snsbirthMM,jsmm)%> ><%=jsmm%></option>
									<%Next%>
								</select>
								<select name = "birthDD">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" <%=isSelect(snsbirthDD,ksdd)%> ><%=ksdd%></option>
									<%Next%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="4" class="tcenter">
								<!-- <input type="submit" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /> -->
								<input type="button" class="button small" onclick="javascript: ajax_accountChk();" value="<%=LNG_JOINSTEP03_03%>" />
								<div class="result_line tcenter tweight" style="font-size: 14px;" id="result_text"><%=LNG_JS_DUPLICATION_CHECK%></div>
							</td>
						</tr>
					</table>
				<%Else		'이름+생년월일 중복체크%>
					<table <%=tableatt%>>
						<col width="60" />
						<col width="" />
						<col width="60" />
						<col width="" />
						<tr>
							<th><%=LNG_TEXT_FAMILY_NAME%>&nbsp;<%=starText%></th>
							<td><input type="text" name="M_Name_Last" value="<%=snsM_Name_Last%>" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_FAMILY_NAME%>"/></td>
							<th><%=LNG_TEXT_GIVEN_NAME%>&nbsp;<%=starText%></th>
							<td><input type="text" name="M_Name_First" value="<%=snsM_Name_First%>" style="<%=IMES_MODE%>" placeholder="<%=LNG_TEXT_GIVEN_NAME%>"/></td>
						</tr>
						<tr>
							<th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
							<td class="middleTD" colspan="4">
								<select name = "birthYY">
									<option value=""></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" <%=isSelect(snsbirthYY,i)%> ><%=i%></option>
									<%Next%>
								</select>
								<select name = "birthMM">
									<option value=""></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" <%=isSelect(snsbirthMM,jsmm)%> ><%=jsmm%></option>
									<%Next%>
								</select>
								<select name = "birthDD">
									<option value=""></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" <%=isSelect(snsbirthDD,ksdd)%> ><%=ksdd%></option>
									<%Next%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="4" class="tcenter">
								<!-- <input type="submit" class="button" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /> -->
								<input type="button" class="button" onclick="ajax_memberDuplicateChk();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
								<div class="result_line tcenter tweight" style="font-size: 14px;" id="result_text"><%=LNG_JS_DUPLICATION_CHECK%></div>
							</td>
						</tr>
					</table>
				<%End If%>

				<div class="btnZone">
					<input type="button" class="cancel" data-ripplet onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
					<input type="submit" class="promise" value="<%=LNG_TEXT_NEXT_STEP%>" />
				</div>

			</div>
		</article>
		<%End If%>
	</form>

	<%If NICE_MOBILE_CONFIRM_TF = "T" Then		'NICE + 휴대폰 인증(계좌인증) mobileAuth.asp %>
		<article class="privacy">
			<div class="btnZone">
				<input type="button" class="cancel" onclick="javascript:history.go(-1);" value="<%=LNG_JOINSTEP02_U_TEXT15%>"/>
				<input type="submit" class="promise" value="휴대폰 본인 인증" onclick="fnPopup('<%=S_SellMemTF%>');" />
			</div>
		</article>
		<form name="form_chk" method="post">
			<input type="hidden" name="m" value="checkplusSerivce">
			<input type="hidden" name="EncodeData" value="<%= sEncData %>">
		</form>
	<%End If%>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
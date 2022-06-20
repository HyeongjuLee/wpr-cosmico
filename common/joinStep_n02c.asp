<!--#include virtual="/_lib/strFunc.asp" -->
<%
'	If UCase(LANG) <> "KR" Then
'		Response.Redirect "joinStep02_u.asp"
'	End If


	PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1
	sview = 4

	TOP_WRAP_FIX = "F"		'상단메뉴고정X


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/common/joinStep01.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select


	'국가정보
	R_NationCode = gRequestTF("cnd",True)
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
	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = "사이트 이용약관이 등록되지 않았습니다."

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)
	policyContent2 = Replace(policyContent2,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = "개인정보취급방침이 등록되지 않았습니다."


	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)
	policyContent3 = Replace(policyContent3,"OOO",LNG_SITE_TITLE)
	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = "사업자회원 가입약관이 등록되지 않았습니다."



%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="join.css" />
<script type="text/javascript" src="joinStep_n02c.js?v1"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="joinStep" class="step02">
	<div class="title_area">
		<p class="c_b_title tweight" style=""><%=LNG_TEXT_BUSINESS_MEMBER%> 약관동의</p>
		<p class="c_s_title tweight" style="">회원가입을 위해서는 약관에 대한 동의가 필요합니다.</p>
	</div>
	<!-- <form name="agreeFrm" method="post" action="joinStep03_c.asp" onsubmit="return chkAgree(this);"> -->
	<form name="agreeFrm" method="post" action="joinStep_n03c.asp" onsubmit="return chkAgree(this);">
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="name" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
		<input type="hidden" name="birthYY" value="" readonly="readonly" />
		<input type="hidden" name="birthMM" value="" readonly="readonly" />
		<input type="hidden" name="birthDD" value="" readonly="readonly" />
		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft">사이트 이용약관</span><span class="fright"><label><input type="checkbox" id="agree01Chk" name="agreement" value="T" class="input_checkbox" /> 동의합니다.</label></span></div>
			<div class="agreeBox"><%=backword_tag(policyContent1)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft"><%=LNG_TEXT_BUSINESS_MEMBER%> 약관</span><span class="fright"><label><input type="checkbox" id="agree02Chk" name="company" value="T" class="input_checkbox" /> 동의합니다.</label></span></div>
			<div class="agreeBox"><%=backword_tag(policyContent3)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft">개인정보취급방침</span><span class="fright"><label><input type="checkbox" id="agree03Chk" name="gather" value="T" class="input_checkbox" /> 동의합니다.</label></span></div>
			<div class="agreeBox"><%=backword_tag(policyContent2)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft">약관 전체동의</span><span class="fright"><label><input type="checkbox" id="allAgree" onclick="allCheckAgree()" name="allAgree" value="T" class="input_checkbox" /> 위 약관에 전체 동의합니다.</label></span></div>
		</div>
	</form>

	<div class="agreeArea">
		<div class="agreeTitle tweight">회원가입 확인</div>
		<div class="agreeBox2">
			<div class="info">
				<%=DKCONF_SITE_TITLE%>은(는) 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.<br />
				<!-- <form name="nfrm" method="post" action="joinCheck_nc.asp" onSubmit="return nameChk2(this)"  />
					<div class="chkArea">
						<table <%=tableatt%> class="" style="">
							<col width="150" />
							<col width="200" />
							<col width="80" />
							<tr>
								<td><span style="margin-left:10px;">이름</span><input type="text" name="name" class="input_text imes_kr" value="" style="width:135px;" placeholder="이름" /></td>
								<td class="middleTD">
									<span style="margin-left:10px;">생년월일</span>
									<select name = "birthYY" class="vmiddle input_select" style="width:60px;">
										<option value=""></option>
										<%For i = MIN_YEAR To MAX_YEAR%>
											<option value="<%=i%>" ><%=i%></option>
										<%Next%>
									</select> 년
									<select name = "birthMM" class="vmiddle input_select" style="width:45px;">
										<option value=""></option>
										<%For j = 1 To 12%>
											<%jsmm = Right("0"&j,2)%>
											<option value="<%=jsmm%>" ><%=jsmm%></option>
										<%Next%>
									</select> 월
									<select name = "birthDD" class="vmiddle input_select" style="width:45px;">
										<option value=""></option>
										<%For k = 1 To 31%>
											<%ksdd = Right("0"&k,2)%>
											<option value="<%=ksdd%>" ><%=ksdd%></option>
										<%Next%>
									</select> 일
								</td>
								<td class="lastTD"><input type="submit" class="txtBtn j_medium" value="가입확인" /></td>
							</tr>
						</table>
					</div>
				</form> -->
				<form name="nfrm" method="post" action="joinCheck_nc_g.asp" onSubmit="return nameChk2(this)"  />
					<input type="hidden" name="name" id="nfrm_name" value="" />

					<div class="chkAreaG">
						<table <%=tableatt%> class="" style="">
							<col width="140" />
							<col width="" />
							<tr>
								<th>성&nbsp;<%=starText%></th>
								<td><input type="text" class="input_text" name="M_Name_Last" class="input_text" style="width:700px;" placeholder="성" /></td>
							</tr><tr>
								<th>이름&nbsp;<%=starText%></th>
								<td><input type="text" class="input_text" name="M_Name_First" class="input_text" style="width:700px; <%=IMES_MODE%>" placeholder="이름" /></td>
							</tr><tr>
								<th>생년월일 <%=starText%></th>
								<td class="middleTD">
									<select name = "birthYY" class="vmiddle input_select" style="width:80px;">
										<option value=""></option>
										<%For i = MIN_YEAR To MAX_YEAR%>
											<option value="<%=i%>" ><%=i%></option>
										<%Next%>
									</select>
									<select name = "birthMM" class="vmiddle input_select" style="width:55px;">
										<option value=""></option>
										<%For j = 1 To 12%>
											<%jsmm = Right("0"&j,2)%>
											<option value="<%=jsmm%>" ><%=jsmm%></option>
										<%Next%>
									</select>
									<select name = "birthDD" class="vmiddle input_select" style="width:55px;">
										<option value=""></option>
										<%For k = 1 To 31%>
											<%ksdd = Right("0"&k,2)%>
											<option value="<%=ksdd%>" ><%=ksdd%></option>
										<%Next%>
									</select> (yyyy/mm/dd)
								</td>
							</tr><tr>
								<td colspan="2" class="tcenter"><input type="submit" class="txtBtn j_medium" value="가입확인" /></td>
							</tr>
						</table>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div class="btnZone tcenter">
		<span><input type="button" class="txtBtnC large radius10 gray " onclick="javascript:history.go(-1);" value="동의하지 않습니다"/></span>
		<span class="pL10"><input type="button" class="txtBtnC large radius10 blue h22" style="width:120px;" value="가입동의" onclick="checkAgree();" /></span>
	</div>



</div>

<!--#include virtual="/_include/copyright.asp" -->

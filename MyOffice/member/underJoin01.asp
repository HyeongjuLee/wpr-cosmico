<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	'Response.Redirect "/myoffice/member/underJoin_u.asp"


	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER2-2"

	ISLEFT = "T"
	ISSUBTOP = "T"

	TOP_WRAP_FIX = "F"		'상단메뉴고정X


	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()

	If CDbl(DKRSG_Down_Month_Count) < 100 Then Call ALERTS(LNG_JS_NO_DUPLICATE_MEMBER_JOIN,"back","")		'gng 다구좌등록 (= 후원 소실적 누적PV 라인 인원 50명 이상)



	''#GNG
	'' 다구좌의 경우 회원별로 2개까지 생성 가능하다
	'' 후원소실적(누적PV) + 50명 달성 시 추가적으로 2명 생성 가능하도록 처리한다.
	''	TOT_COUNT = 0
	''	arrParams5 = Array(_
	''		Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
	''		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	''	)
	''	Set HJRS = Db.execRs("HJP_SPON_LR_INFO",DB_PROC,arrParams5,DB3)
	''	If Not HJRS.BOF And Not HJRS.EOF Then
	''		 L_SPON_NAME	=	HJRS(0)
	''		 L_SPON_ID1		=	HJRS(1)
	''		 L_SPON_ID2		=	HJRS(2)
	''		 R_SPON_NAME	=	HJRS(3)
	''		 R_SPON_ID1		=	HJRS(4)
	''		 R_SPON_ID2		=	HJRS(5)
	''		 L_MAX_LEVEL	=	HJRS(6)
	''		 R_MAX_LEVEL	=	HJRS(7)
	''		 L_TOT_COUNT	=	HJRS(8)
	''		 R_TOT_COUNT	=	HJRS(9)
	''
	''		If (L_SPON_ID2 = 0 Or R_SPON_ID2 = 0) Or (L_SPON_ID2 = 0 And R_SPON_ID2 = 0)  Then	'1 or 2라인 없을 경우
	''			TOT_COUNT = 0
	''		Else
	''			'소실적 인원 계산
	''			If R_TOT_COUNT > L_TOT_COUNT Then		'1라인 인원이 적을경우
	''				TOT_COUNT = L_TOT_COUNT
	''			ElseIf L_TOT_COUNT > R_TOT_COUNT Then	'2라인 인원이 적을경우
	''				TOT_COUNT = R_TOT_COUNT
	''			ElseIf L_TOT_COUNT = R_TOT_COUNT Then	'같을 경우 1라인
	''				TOT_COUNT = L_TOT_COUNT
	''			End If
	''		End If
	''
	''	Else
	''		TOT_COUNT = 0
	''	END If
	''	Call closeRS(HJRS)
	''	If CDbl(TOT_COUNT) < 50 Then Call ALERTS("회원등록을 할 수 없습니다.","BACK","")
	''	Call ResRw(v_SPON_ID1,"v_SPON_ID1")
	''	Call ResRw(v_SPON_ID2,"v_SPON_ID2")
	''	Call ResRw(L_SPON_ID1,"L_SPON_ID1")
	''	Call ResRw(L_SPON_ID2,"L_SPON_ID2")
	''	Call ResRw(R_SPON_ID1,"R_SPON_ID1")
	''	Call ResRw(R_SPON_ID2,"R_SPON_ID2")
	''	Call ResRw(L_TOT_COUNT,"L_TOT_COUNT")
	''	Call ResRw(R_TOT_COUNT,"R_TOT_COUNT")
	''	Call ResRw(TOT_COUNT,"TOT_COUNT")


	'▣▣▣GNG 후원인선택 (추천인의 후원조직중 선택, 20170512)▣▣▣
	arrParams2 = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams2,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_M_Name			= DKRS("M_Name")
		RS_BirthDay			= DKRS("BirthDay")
		RS_BirthDay_M		= DKRS("BirthDay_M")
		RS_BirthDay_D		= DKRS("BirthDay_D")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	'▣ CS 이름 + 생년월일 중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "		'→ 전체회원중복체크
	SQL = SQL & "  AND NOT ( mbid = ? AND mbid2 = ?)"																						'	본인제외
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,RS_M_Name), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,RS_BirthDay), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,RS_BirthDay_M), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,RS_BirthDay_D), _
			Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	DbCheckMember = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

	If CDbl(DbCheckMember) >= 2 Then
		'Call alerts("다구좌 회원등록 최대인원을 초과하였습니다.","BACK","")
		Call alerts(LNG_JS_OVER_DUPLICATE_MEMBER,"BACK","")
	End If









	'국가정보
	''R_NationCode = gRequestTF("cnd",True)
	R_NationCode = DK_MEMBER_NATIONCODE		'소속 국가코드
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

	If IsNull(policyContent1) Or policyContent1 = "" Then policyContent1 = LNG_JOINSTEP02_U_TEXT01 &"("&DKRS_nationNameEn&")"

	arrParams2 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy02"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent2 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams2,Nothing)

	If IsNull(policyContent2) Or policyContent2 = "" Then policyContent2 = LNG_JOINSTEP02_U_TEXT02 &"("&DKRS_nationNameEn&")"


	arrParams3 = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,10,"policy03"), _
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(R_NationCode)) _
	)
	policyContent3 = Db.execRsData("DKP_POLICY_CONTENT",DB_PROC,arrParams3,Nothing)

	If IsNull(policyContent3) Or policyContent3 = "" Then policyContent3 = LNG_JOINSTEP02_U_TEXT03 &"("&DKRS_nationNameEn&")"



%>
<%
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_M_Name			= DKRS("M_Name")
		DKRS_BirthDay		= DKRS("BirthDay")
		DKRS_BirthDay_M		= DKRS("BirthDay_M")
		DKRS_BirthDay_D		= DKRS("BirthDay_D")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"BACK","")
	End If
	Call closeRS(DKRS)
%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" type="text/css" href="/common/join.css" />
<script type="text/javascript">
<!--
	//이름, 생년월일 중복체크

	function nameChk2(f) {
		if (chkEmpty(f.name)) {
			alert("<%=LNG_JS_NAME%>");
			f.name.focus();
			return false;
		}
		if( /[\s]/g.test( f.name.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>");
			f.name.value=f.name.value.replace(/(\s*)/g,'');
			return false;
		}
		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(f.name.value,2)) {
				alert("정확한 한글 이름을 입력해 주세요.");
				f.name.focus();
				return false;
			}
		<%End If%>
		if (!checkSCharNum(f.name.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>");
			f.name.value="";
			f.name.focus();
			return false;
		}
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		f.target = "hidden";
		f.action = "uderJoinCheck.asp";
	}


	function allCheckAgree() {
		if (document.getElementById("allAgree").checked == true)
		{
			document.getElementById("agree01Chk").checked = true;
			document.getElementById("agree02Chk").checked = true;
			document.getElementById("agree03Chk").checked = true;
	//		document.getElementById("agree04Chk").checked = true;
		} else if (document.getElementById("allAgree").checked == false)	{
			document.getElementById("agree01Chk").checked = false;
			document.getElementById("agree02Chk").checked = false;
			document.getElementById("agree03Chk").checked = false;
	//		document.getElementById("agree04Chk").checked = false;
		}
	}


	function checkAgree() {
		var f = document.agreeFrm;
		var g = document.nfrm;


			if (f.agreement.checked == false)
			{
				alert("<%=LNG_JS_POLICY01%>");
				f.agreement.focus();
				return false;
			}
			if (f.company.checked == false)
			{
				alert("<%=LNG_JS_POLICY02%>");
				f.company.focus();
				return false;
			}
			if (f.gather.checked == false)
			{
				alert("<%=LNG_JS_POLICY03%>");
				f.gather.focus();
				return false;
			}


		if (chkEmpty(g.name)) {
			alert("<%=LNG_JS_NAME%>");
			g.name.focus();
			return false;
		}
		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(g.name.value,2)) {
				alert("정확한 한글 이름을 입력해 주세요");
				g.name.focus();
				return false;
			}
		<%End If%>
		if( /[\s]/g.test( g.name.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>");
			g.name.value=g.name.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkSCharNum(g.name.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>");
			g.name.value="";
			g.name.focus();
			return false;
		}

		if (chkEmpty(g.birthYY) || chkEmpty(g.birthMM) || chkEmpty(g.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			g.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(g.birthYY, g.birthMM , g.birthDD)) return false;		// 미성년자체크(생년월일)



		if (chkEmpty(f.name)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>");
			g.name.focus();
			return false;
		}

		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)


		if (f.name.value != g.name.value)
		{
				alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>\n<%=LNG_JS_DUPLICATION_CHECK%>");
				g.name.focus();
				return false;
		}
		if (f.birthYY.value != g.birthYY.value || f.birthMM.value != g.birthMM.value || f.birthDD.value != g.birthDD.value)
		{
				alert("<%=LNG_JS_DUPLICATE_BIRTH_CHANGE%>\n<%=LNG_JS_DUPLICATION_CHECK%>");
				g.birthYY.value='';
				g.birthMM.value='';
				g.birthDD.value='';
				g.birthYY.focus();
				return false;
		}
		f.submit();

	}


//-->
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="joinStep" class="step02">
	<div class="title_area">
		<p class="c_b_title tweight" style=""><%=LNG_JOINSTEP02_U_STITLE01%></p>
		<p class="c_s_title tweight" style=""><%=LNG_JOINSTEP02_U_STITLE02%></p>
	</div>
	<form name="agreeFrm" method="post" action="underJoin02.asp<%=ptshop%>" onsubmit="return chkAgree(this);">
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="name" value="" readonly="readonly" />
		<input type="hidden" name="birthYY" value="" readonly="readonly" />
		<input type="hidden" name="birthMM" value="" readonly="readonly" />
		<input type="hidden" name="birthDD" value="" readonly="readonly" />
		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft"><%=LNG_POLICY_01%></span><span class="fright"><label><input type="checkbox" id="agree01Chk" name="agreement" value="T" class="input_checkbox" /> <%=LNG_JOINSTEP02_U_TEXT04%></label></span></div>
			<div class="agreeBox"><%=backword(policyContent1)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft"><%=LNG_POLICY_03%></span><span class="fright"><label><input type="checkbox" id="agree02Chk" name="company" value="T" class="input_checkbox" /> <%=LNG_JOINSTEP02_U_TEXT05%></label></span></div>
			<div class="agreeBox"><%=backword(policyContent3)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft"><%=LNG_POLICY_02%></span><span class="fright"><label><input type="checkbox" id="agree03Chk" name="gather" value="T" class="input_checkbox" /> <%=LNG_JOINSTEP02_U_TEXT06%></label></span></div>
			<div class="agreeBox"><%=backword(policyContent2)%></div>
		</div>

		<div class="agreeArea">
			<div class="agreeTitle tweight"><span class="fleft"><!-- 약관 전체동의 --></span><span class="fright"><label><input type="checkbox" id="allAgree" onclick="allCheckAgree()" name="allAgree" value="T" class="input_checkbox" /> <%=LNG_JOINSTEP02_U_TEXT07%></label></span></div>
		</div>
	</form>
	<script type="text/javascript">
	<!--
		$(document).ready(function() {
			//Select readOnly
			$("#birthYY option[value!=<%=DKRS_BirthDay%>]").remove();
			$("#birthMM option[value!=<%=DKRS_BirthDay_M%>]").remove();
			$("#birthDD option[value!=<%=DKRS_BirthDay_D%>]").remove();
		});
	// -->
	</script>
	<div class="agreeArea">
		<div class="agreeTitle tweight"><%=LNG_TEXT_MEMBER_REGIST_CHECK%></div>
		<div class="agreeBox2">
			<div class="info">
				<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then %>
				<%=DKCONF_SITE_TITLE%>은(는) 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.<br />
				<%End If%>
				<form name="nfrm" method="post" action="joinCheck_nc.asp" onSubmit="return nameChk2(this)"  />
					<div class="chkArea">
						<table <%=tableatt%> class="" style="">
							<col width="150" />
							<col width="200" />
							<col width="80" />
							<tr>
								<td><span style="margin-left:10px;"><%=LNG_TEXT_NAME%></span><input type="text" name="name" class="input_text imes_kr readonly" value="<%=DKRS_M_Name%>" style="width:135px;" placeholder="<%=LNG_TEXT_NAME%>" readonly="readonly" /></td>
								<td class="middleTD">
									<span style="margin-left:10px;"><%=LNG_TEXT_BIRTH%></span>
									<!-- <select name = "birthYY" class="vmiddle input_select" style="width:60px;" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;' > -->
									<select name = "birthYY" id="birthYY" class="vmiddle input_select readonly" style="width:60px;">
										<option value=""></option>
										<%For i = MIN_YEAR To MAX_YEAR%>
											<option value="<%=i%>" <%=isSelect(i,DKRS_BirthDay)%> ><%=i%></option>
										<%Next%>
									</select> <!-- 년 -->
									<select name = "birthMM" id="birthMM" class="vmiddle input_select readonly" style="width:45px;">
										<option value=""></option>
										<%For j = 1 To 12%>
											<%jsmm = Right("0"&j,2)%>
											<option value="<%=jsmm%>" <%=isSelect(jsmm,DKRS_BirthDay_M)%>><%=jsmm%></option>
										<%Next%>
									</select> <!-- 월 -->
									<select name = "birthDD" id="birthDD" class="vmiddle input_select readonly" style="width:45px;">
										<option value=""></option>
										<%For k = 1 To 31%>
											<%ksdd = Right("0"&k,2)%>
											<option value="<%=ksdd%>"<%=isSelect(ksdd,DKRS_BirthDay_D)%>><%=ksdd%></option>
										<%Next%>
									</select> <!-- 일 -->
								</td>
								<td class="lastTD"><input type="submit" class="txtBtn j_medium" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></td>
							</tr>
						</table>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div class="btnZone tcenter">
		<!-- <span><input type="button" class="txtBtnC large radius10 gray " onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/></span> -->
		<span class="pL10"><input type="button" class="txtBtnC large radius10 blue h22" style="width:120px;" value="<%=LNG_TEXT_NEXT_STEP%>" onclick="checkAgree();" /></span>
	</div>



</div>

<!--#include virtual="/_include/copyright.asp" -->

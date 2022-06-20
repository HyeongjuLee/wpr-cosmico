<!--#include virtual="/_lib/strFunc.asp" -->
<%
'Call WRONG_ACCESS()

	PAGE_SETTING = "MEMBERSHIP"

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	IS_LANGUAGESELECT = "F"

	view = 1
	'sview = 4

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	'▣판매원,소비자 통합
	S_SellMemTF = pRequestTF("S_SellMemTF",True)
	Select Case S_SellMemTF
		Case 0
			sview = 6
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_BUSINESS_MEMBER
		Case 1
			sview = 3
			LNG_TEXT_BUSINESS_MEMBER = LNG_TEXT_NORMAL_MEMBER
		Case Else
			Call ALERTS(LNG_MEMBER_LOGINOK_ALERT02,"BACK","")
	End Select



	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/common/joinStep_n01_m.asp") Then	Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select

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

%>
<%
'#####################################
'	NICE 본인인증(핸드폰)
'#####################################

	sRequestNO = pRequestTF("sRequestNO",True)

	If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go","/common/joinStep01.asp")


	'▣ 인증 데이터 확인 S

		sResponseNumber = SESSION("sResponseNumber")
		If sResponseNumber = "" Then sResponseNumber = ""

'		PRINT sRequestNO & " <br />"
'		print sResponseNumber
'		Response.End

		SQLM = "SELECT * FROM [DKT_MEMBER_MOBILE_AUTH] WITH(NOLOCK) WHERE [sRequestNumber] = ? AND [sType] = 'JOIN' AND [sResponseNumber] = ?"
		arrParamsM = Array(_
			Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
			Db.makeParam("@sResponseNumber",adVarChar,adParamInput,30,sResponseNumber) _
		)
		Set DKRSM = Db.execRs(SQLM,DB_TEXT,arrParamsM,Nothing)

		If Not DKRSM.BOF And Not DKRSM.EOF Then

			DKRSM_intIDX			= DKRSM("intIDX")
			DKRSM_sType				= DKRSM("sType")
			DKRSM_sCipherTime		= DKRSM("sCipherTime")
			DKRSM_sRequestNumber	= DKRSM("sRequestNumber")
			DKRSM_sResponseNumber	= DKRSM("sResponseNumber")
			DKRSM_sAuthType			= DKRSM("sAuthType")
			DKRSM_sName				= DKRSM("sName")
			DKRSM_sGender			= DKRSM("sGender")
			DKRSM_sBirthDate		= DKRSM("sBirthDate")
			DKRSM_sNationalInfo		= DKRSM("sNationalInfo")
			DKRSM_sDupInfo			= DKRSM("sDupInfo")				'중복가입 확인값 (DI_64 byte)
			DKRSM_sConnInfo			= DKRSM("sConnInfo")
			DKRSM_sMobileNo			= DKRSM("sMobileNo")
			DKRSM_sMobileCo			= DKRSM("sMobileCo")
			DKRSM_regTime			= DKRSM("regTime")

			'CS회원 중복체크
			SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
			arrParams_CK = Array(_
				Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
			)
			Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
			If Not DKRSM.BOF And Not DKRSM.EOF Then
				Call ALERTS("이미 등록된 회원입니다.","GO","/common/member_login.asp")
			End If
		Else
			Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO","joinStep01.asp")
		End If
		Call closeRs(DKRSM)

		If Len(DKRSM_sBirthDate) = 8  Then
			strBirthYY = Left(DKRSM_sBirthDate,4)
			strBirthMM = Mid(DKRSM_sBirthDate,5,2)
			strBirthDD = Right(DKRSM_sBirthDate,2)
		Else
			Call ALERTS("생년월일 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO","joinStep01.asp")
		End If

	'▣ 인증 데이터 확인 E

	'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
	'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
	'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="join.css" />
<style>
	#joinStep.step02 .chkAreaM {width:100%; background-color:#fff; margin:0px auto;  padding:5px 0px;}
	#joinStep.step02 .chkAreaM table {width:100%; margin:0px auto;}
	#joinStep.step02 .chkAreaM th {border:1px solid #e7e7e9; background-color:#f3f3f3; text-align:left; padding-left:10px; font-size:1.1em; font-weight:700; height:46px;}
	#joinStep.step02 .chkAreaM td {border:1px solid #e7e7e9;font-size:1.1em; padding:9px 0px 9px 14px; vertical-align:middle;line-height:27px;}
</style>
<script type="text/javascript">

	function nameChk2(f) {

		if (chkEmpty(f.M_Name_Last)) {
			alert("<%=LNG_JS_FAMILY_NAME%>");
			f.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(f.M_Name_First)) {
			alert("<%=LNG_JS_GIVEN_NAME%>");
			f.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}


		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (checkEng(f.M_Name_Last.value)) {
				//console.log("영어만");
				if (f.M_Name_Last.value.length < 2 ) {
					alert("정확한 성 입력해 주세요!");
					f.M_Name_Last.focus();
					return false;
				}
				if (f.M_Name_First.value.length < 2 ) {
					alert("정확한 이름을 입력해 주세요!");
					f.M_Name_First.focus();
					return false;
				}
			} else {
				//console.log("영어외 글자 포함");
				if (!checkkorText(f.M_Name_Last.value,1)) {
					alert("정확한 한글 성을 입력해 주세요.");
					f.M_Name_Last.focus();
					return false;
				}
				if (!checkkorText(f.M_Name_First.value,1)) {
					alert("정확한 한글 이름을 입력해 주세요.");
					f.M_Name_First.focus();
					return false;
				}
			}
		<%End If%>


		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}

		//핸드폰인증된 이름과 비교
		if (f.name.value != f.M_Name_Last.value+f.M_Name_First.value)
		{
			alert("정확한 본인의 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return false;
		}

		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_joinCheck_nc_g.asp"
			,data: {
				 "M_Name_Last"	: f.M_Name_Last.value
				,"M_Name_First"	: f.M_Name_First.value
				,"birthYY"		: f.birthYY.value
				,"birthMM"		: f.birthMM.value
				,"birthDD"		: f.birthDD.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success") {
					//alert(json.message);
					$("#agreeFrm input[name=name]").val(json.datas.name);
					$("#agreeFrm input[name=M_Name_Last]").val(json.datas.M_Name_Last);
					$("#agreeFrm input[name=M_Name_First]").val(json.datas.M_Name_First);
					$("#agreeFrm input[name=birthYY]").val(json.datas.birthYY);
					$("#agreeFrm input[name=birthMM]").val(json.datas.birthMM);
					$("#agreeFrm input[name=birthDD]").val(json.datas.birthDD);

					checkAgree();

				} else {
					alert(json.message);
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});
		return false;

	}

	function checkAgree() {
		var f = document.agreeFrm;
		var g = document.nfrm;

		if (chkEmpty(g.M_Name_Last)) {
			alert("<%=LNG_JS_FAMILY_NAME%>");
			g.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(g.M_Name_First)) {
			alert("<%=LNG_JS_GIVEN_NAME%>");
			g.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( g.M_Name_Last.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			g.M_Name_Last.value=g.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if( /[\s]/g.test( g.M_Name_First.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			g.M_Name_First.value=g.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}


		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (checkEng(f.M_Name_Last.value)) {
				if (g.M_Name_Last.value.length < 2 ) {
					alert("정확한 성 입력해 주세요.");
					g.M_Name_Last.focus();
					return false;
				}
				if (g.M_Name_First.value.length < 2 ) {
					alert("정확한 이름을 입력해 주세요.");
					g.M_Name_First.focus();
					return false;
				}
			} else {
				if (!checkkorText(g.M_Name_Last.value,1)) {
					alert("정확한 한글 성을 입력해 주세요.");
					g.M_Name_Last.focus();
					return false;
				}
				if (!checkkorText(g.M_Name_First.value,1)) {
					alert("정확한 한글 이름을 입력해 주세요.");
					g.M_Name_First.focus();
					return false;
				}
			}
		<%End If%>

		if (!checkSCharNum(g.M_Name_Last.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			g.M_Name_Last.value="";
			g.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(g.M_Name_First.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			g.M_Name_First.value="";
			g.M_Name_First.focus();
			return false;
		}

		if (chkEmpty(g.birthYY) || chkEmpty(g.birthMM) || chkEmpty(g.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			g.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(g.birthYY, g.birthMM , g.birthDD)) return false;		// 미성년자체크(생년월일)


		if (chkEmpty(f.M_Name_Last)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>");
			g.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(f.M_Name_First)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>..");
			g.M_Name_First.focus();
			return false;
		}
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_DUPLICATION_CHECK%>!");
			f.birthYY.focus();
			return false;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		if (f.M_Name_Last.value != g.M_Name_Last.value)
		{
			alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_FAMILY_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
			g.M_Name_Last.focus();
			return false;
		}
		if (f.M_Name_First.value != g.M_Name_First.value)
		{
			alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_GIVEN_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
			g.M_Name_First.focus();
			return false;
		}

		//핸드폰인증된 이름과 비교
		if (g.name.value != g.M_Name_Last.value+g.M_Name_First.value)
		{
			alert("정확한 본인의 이름을 입력해주세요.");
			g.M_Name_First.focus();
			return false;
		}
		if (f.name.value != g.name.value)
		{
			alert("가입확인한 이름과 현재 기입된 이름이 틀립니다. 가입확인을 다시 해주세요.");
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


</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="joinStep" class="step02">
	<div class="title_area">
		<p class="c_b_title tweight" style=""><%=LNG_TEXT_BUSINESS_MEMBER%> - <%=LNG_SUBTITLE_TEXT30%></p>
		<p class="c_s_title tweight" style=""><!-- 회원가입을 위해서는 약관에 대한 동의가 필요합니다. --></p>
	</div>
	<form name="agreeFrm" id="agreeFrm" method="post" action="joinStep_n03_m.asp" onsubmit="return chkAgree(this);">
		<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" />

		<input type="hidden" name="S_SellMemTF" value="<%=S_SellMemTF%>" readonly />
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="name" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_Last" value="" readonly="readonly" />
		<input type="hidden" name="M_Name_First" value="" readonly="readonly" />
		<input type="hidden" name="birthYY" value="" readonly="readonly" />
		<input type="hidden" name="birthMM" value="" readonly="readonly" />
		<input type="hidden" name="birthDD" value="" readonly="readonly" />
		<input type="hidden" name="For_Kind_TF" value="1" readonly="readonly" />
	</form>

	<form name="nfrm" method="post" action="joinCheck_nc_g.asp" onSubmit="return nameChk2(this)"  />
		<div class="agreeArea" style="margin-top:30px;">
			<div class="agreeTitle tweight"><%=LNG_SUBTITLE_TEXT30%></div>
			<div class="agreeBox2">

					<%
						If UCase(R_NationCode) = "KR" Then
							IMES_MODE = " ime-mode:active;"
					%>
					<div style="padding-bottom:20px;"><%=DKCONF_SITE_TITLE%>은(는) 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.</div>
					<%
						Else
							IMES_MODE = " ime-mode:disabled;"
						End If
					%>
						<input type="hidden" name="name" value="<%=DKRSM_sName%>" readonly="readonly" ><%'핸드폰인증된 이름과 비교%>
						<div class="chkAreaM">
							<table <%=tableatt%> class="">
								<col width="120" />
								<col width="" />
								<tr>
									<th><%=LNG_TEXT_FAMILY_NAME%>&nbsp;<%=starText%></th>
									<td><input type="text" class="input_text" name="M_Name_Last" class="input_text" <%=IMES_MODE%> style="text-transform: uppercase;" onKeyUP="this.value = this.value.toUpperCase();" placeholder="<%=LNG_TEXT_FAMILY_NAME%>" /></td>
								</tr><tr>
									<th><%=LNG_TEXT_GIVEN_NAME%>&nbsp;<%=starText%></th>
									<td><input type="text" class="input_text" name="M_Name_First" class="input_text" <%=IMES_MODE%>  style="text-transform: uppercase;" onKeyUP="this.value = this.value.toUpperCase();" placeholder="<%=LNG_TEXT_GIVEN_NAME%>" /></td>
								</tr><tr>
									<th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
									<td class="middleTD">
										<input type="hidden" name="birthYY" value="<%=strBirthYY%>" readonly="readonly" >
										<input type="hidden" name="birthMM" value="<%=strBirthMM%>" readonly="readonly" >
										<input type="hidden" name="birthDD" value="<%=strBirthDD%>" readonly="readonly" >
										<%=strBirthYY%>년 <%=strBirthMM%> 월 <%=strBirthDD%>일
									</td>
								</tr>
								<!-- <tr>
									<td colspan="2" class="tcenter"><input type="submit" class="txtBtn j_medium" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></td>
								</tr> -->
							</table>
						</div>

			</div>
		</div>
		<div class="btnZone tcenter">
			<span><input type="submit" class="txtBtnC large radius10 blue h22" style="min-width:120px;" value="<%=LNG_TEXT_CONFIRM%>" /></span>
		</div>
	</form>

	<!-- <div class="btnZone tcenter">
		<span><input type="button" class="txtBtnC large radius10 gray " onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/></span>
		<span class="pL10"><input type="button" class="txtBtnC large radius10 blue h22" style="min-width:120px;" value="<%=LNG_TEXT_NEXT_STEP%>" onclick="checkAgree();" /></span>
	</div> -->

</div>

<!--#include virtual="/_include/copyright.asp" -->

<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"
	view = 4
	sview = 2
	ISSUBTOP = "T"

	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"


	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	'agreement	= pRequestTF("agreement",True)
	'If agreement <> "T" Then Call ALERTS("가입약관에 동의하지 않으셨습니다.","BACK","")

	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

	If Agree01 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

%>
<%
	If NICE_BANK_WITH_MOBILE_USE = "T" Then
		'#####################################
		'	NICE 본인인증(핸드폰)
		'#####################################

		sRequestNO = pRequestTF("sRequestNO",True)

		If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go", MOB_PATH&"/common/joinStep01.asp")

		'▣ 인증 데이터 확인 S
			sResponseNumber = SESSION("sResponseNumber")
			If sResponseNumber = "" Then sResponseNumber = ""

			'PRINT sRequestNO & " <br />"
			'print sResponseNumber
			'Response.End

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
					Call ALERTS("이미 등록된 회원입니다.","GO", MOB_PATH&"/common/member_login.asp")
				End If
			Else
				Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If
			Call closeRs(DKRSM)

			If Len(DKRSM_sBirthDate) = 8  Then
				strBirthYY = Left(DKRSM_sBirthDate,4)
				strBirthMM = Mid(DKRSM_sBirthDate,5,2)
				strBirthDD = Right(DKRSM_sBirthDate,2)
			Else
				Call ALERTS("생년월일 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If

		'▣ 인증 데이터 확인 E

		'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

	End If
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="joinStep03.js?v1"></script>
<link rel="stylesheet" href="/m/css/joinstep.css?v2" />
<style type="text/css">
	.pass { -webkit-text-security: disc;}

	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block;
								opacity:0.7;background-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:40%; left:45%; z-index:100;}
</style>
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script>
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join03" class="joinstep">
	<form name="joinFrm" method="post" action="joinStep04.asp" onsubmit="return chkAccountFrm(this);">
		<input type="hidden" name="agree01" value="<%=Agree01%>" />
		<input type="hidden" name="agree02" value="<%=Agree02%>" />
		<input type="hidden" name="agree03" value="<%=Agree03%>" />
		<input type="hidden" name="centerName" value="<%=DKRS_ncode%>" />
		<input type="hidden" name="centerCode" value="<%=DKRS_M_Reg_Code%>" />
		<input type="hidden" name="NICE_BANK_WITH_MOBILE_USE" value="<%=NICE_BANK_WITH_MOBILE_USE%>" readonly="readonly" /><%'핸드폰인증용%>
		<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" /><%'핸드폰인증용%>

		<div id="loadings" style="width:100%; height:100%;position:absolute;visibility:hidden;">
			<div id="loading_bg"><img id="loading-image" src="/m/images/159.gif" width="40"  alt="" /></div>
		</div>

		<div class="info_txt">
			<ul>
				<li>&#8226; 이미 가입된 회원은 가입하실 수 없습니다.</li>
				<li>&#8226; 본 사이트의 본인인증 절차는 한국신용정보에서 제공하는 계좌인증 방식을 채택하고 있습니다.</li>
				<li>&#8226; 이곳에서 인증한 계좌 및 이름의 경우에는 회원정보의 기본으로 입력되게 되어있습니다.</span></li>
				<li>&#8226; 회원가입은 <span class="red">만 19세 이상의 성인만 가능</span>합니다.</span></li>
			</ul>
		</div>

		<p><%=DKCONF_SITE_TITLE%>은(는) 회원의 소중한 개인정보를 안전하게 보호하고 있으며 개인정보 보호 정책을 준수합니다.</p>

		<div class="wrap">
			<h6>은행 계좌정보</h6>
			<table <%=tableatt%> class="width100">
				<col width="80" />
				<col width="*" />
				<tr class="bank">
					<th>은행선택</th>
					<td>
						<select name="strBankCode" class="select">
							<option value="">은행을 선택해주세요</option>
							<%
								'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE ([Na_Code] = 'KR') "
								SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE ([Na_Code] = 'KR') AND [Using_Flag] = 'T' "
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
					</td>
				</tr><tr>
					<th>계좌번호</th>
					<td><input type="tel" class="input_text" name="strBankNum" style="width:90%;" /></td>
				</tr>
				<tr class="name">
					<th>예금주</th>
					<td>
						<input type="hidden" name="strBankOwner" class="input_text imes_kr" style="" maxlength="40"  value="<%=DKRSM_sName%>">
						<input type="text" name="M_Name_Last" class="input_text imes_kr" onKeyUP="this.value = this.value.toUpperCase();" maxlength="15"  value=""  placeholder="<%=LNG_TEXT_FAMILY_NAME%>">
						<input type="text" name="M_Name_First" class="input_text imes_kr" onKeyUP="this.value = this.value.toUpperCase();"  maxlength="20"  value=""  placeholder="<%=LNG_TEXT_GIVEN_NAME%>">
					</td>
				</tr>
				<tr class="birth">
					<th>생년월일</th>
					<td>
						<select name = "birthYY" class="input_select">
							<option value=""><%=LNG_TEXT_YEAR%></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" ><%=i%></option>
							<%Next%>
						</select>
						<!-- <p><%=LNG_TEXT_YEAR%></p> -->
						<select name = "birthMM" class="input_select">
							<option value=""><%=LNG_TEXT_MONTH%></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" ><%=jsmm%></option>
							<%Next%>
						</select>
						<!-- <p><%=LNG_TEXT_MONTH%></p> -->
						<select name = "birthDD" class="input_select">
							<option value=""><%=LNG_TEXT_DAY%></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>" ><%=ksdd%></option>
							<%Next%>
						</select>
						<!-- <p><%=LNG_TEXT_DAY%></p> -->
					</td>
				</tr>
			</table>

			<a href="javascript:ajax_accountChk();" class="button small">본인인증</a>

			<div class="result_line tcenter tweight" id="result_text">
				<span class="lightBlue">은행 계좌정보 입력 후 본인인증 버튼을 눌러주세요</span>
				<input type="hidden" name="strBankCodeCHK" value="" readonly="readonly" />
				<input type="hidden" name="strBankNumCHK" value="" readonly="readonly" />
				<input type="hidden" name="strBankOwnerCHK" value="" readonly="readonly" />
				<input type="hidden" name="birthYYCHK" value="" readonly="readonly" />
				<input type="hidden" name="birthMMCHK" value="" readonly="readonly" />
				<input type="hidden" name="birthDDCHK" value="" readonly="readonly" />
				<input type="hidden" name="TempDataNum" value="" readonly="readonly" />
				<input type="hidden" name="ajaxTF" value="F" readonly="readonly" />
			</div>


			<div class="btnZone">
				<input type="button" class="cancel" data-ripplet onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
				<input type="submit" class="promise" onclick="" value="<%=LNG_TEXT_NEXT_STEP%>" />
			</div>
</form>

</div>
<!--#include virtual = "/m/_include/copyright.asp"-->
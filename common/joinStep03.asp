<!--#include virtual="/_lib/strFunc.asp" -->
<%
'*****************************************
If webproIP <> "T" Then
	'Call ALERTS("준비중입니다","BACK","")
End If
'****************************************

	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	view = 4
	sview = 9


	mnType = "3"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	If Not checkRef(houUrl &"/common/joinStep02.asp") Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

	'centerName			= pRequestTF("centerName",True)
	'centerCode			= pRequestTF("centerCode",True)
	'centerCodeChk		= pRequestTF("centerCodeChk",True)
	'centerNameChk		= pRequestTF("centerNameChk",True)
	'ajaxTF				= pRequestTF("ajaxTF",True)


	If Agree01 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

	'If ajaxTF <> "T" Then Call ALERTS("센터등록코드를 확인하셔야합니다.","back","")
	'If centerName <> centerNameChk Then Call ALERTS("센터선택이 잘못되었습니다.","back","")
	'If centerCode <> centerCodeChk Then Call ALERTS("센터코드 입력이 잘못되었습니다..","back","")


	'arrParams = Array(_
	'	Db.makeParam("@centerName",adVarChar,adParamInput,20,centerName) _
	')
	'Set DKRS = Db.execRs("DKP_CENTERCODE_CHECK",DB_PROC,arrParams,Nothing)
	'If Not DKRS.BOF And Not DKRS.BOF Then
	'	DKRS_ncode			= DKRS("ncode")
	'	DKRS_M_Reg_Code		= DKRS("M_Reg_Code")
	'Else
	'	Call ALERTS("센터선택이 잘못되었습니다.","back","")
	'End If
	'Call closeRs(DKRS)

	'If centerName <> DKRS_ncode Then Call ALERTS("센터선택이 잘못되었습니다.","back","")
	'If centerCode <> DKRS_M_Reg_Code Then Call ALERTS("센터코드 입력이 잘못되었습니다..","back","")

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
<!--#include virtual="/_include/document.asp" -->
<script type="text/javascript" src="joinStep.js?v5.1"></script>
<link rel="stylesheet" href="/css/common.css?v0" />
<%'Call selectBox()%>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<iframe src="/hiddens.asp" name="hidden" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="joinStep" class="common joinStep3">
	<form name="jfrm" method="post" action="joinStep04.asp" onsubmit="return chkAccountFrm(this);">
		<div class="wrap">
			<article>
				<p class="stit"><%=LNG_JOINSTEP02_U_STITLE04%></p>
				<input type="hidden" name="agree01" value="<%=Agree01%>" />
				<input type="hidden" name="agree02" value="<%=Agree02%>" />
				<input type="hidden" name="agree03" value="<%=Agree03%>" />
				<input type="hidden" name="centerName" value="<%=DKRS_ncode%>" />
				<input type="hidden" name="centerCode" value="<%=DKRS_M_Reg_Code%>" />
				<input type="hidden" name="NICE_BANK_WITH_MOBILE_USE" value="<%=NICE_BANK_WITH_MOBILE_USE%>" readonly="readonly" /><%'핸드폰인증용%>
				<input type="hidden" name="sRequestNO" value="<%=sRequestNO%>" readonly="readonly" /><%'핸드폰인증용%>

				<div id="loadings" style="width: 100%; height:350px;position:absolute; left: 0; background:url(/images_kr/join/loading_bg70.png) 0 0 repeat; z-index:999;visibility:hidden; justify-content: center;">
					<div style="position:relative; top:37%; text-align:center;">
						<img src="<%=IMG%>/159.gif" width="80" alt="" />
					</div>
				</div>
				<div class="dwrap">
					<div class="">
						<h5>은행선택<!-- <%=viewImg(IMG_JOIN&"/joinStep03_tit_01.gif",79,21,"")%> --></h5>
						<div class="con">
							<select name="strBankCode" class="input_select">
								<option value=""><%=LNG_JOINSTEP03_U_TEXT14%></option>
								<%
									'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE ([Na_Code] = 'KR') "
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
						</div>
					</div>
					<div class="">
						<h5><%=LNG_TEXT_BANKNUMBER%></h5>
						<div class="con">
							<input type="text" name="strBankNum" class="input_text"  maxlength="40" <%=onlyKeys%>>
							<p class="summary">* <%=LNG_JOINSTEP03_02%></p>
						</div>
					</div>
				</div>
					<div class="name">
						<h5><%=LNG_TEXT_BANKOWNER%></h5>
						<div class="con">
							<div class="inputs">
								<input type="hidden" name="strBankOwner" class="input_text imes_kr" style="" maxlength="40"  value="<%=DKRSM_sName%>"><%'핸드폰인증된 이름과 비교%>
								<input type="text" name="M_Name_Last" class="input_text imes_kr" onKeyUP="this.value = this.value.toUpperCase();" maxlength="15"  value="" placeholder="<%=LNG_TEXT_FAMILY_NAME%>">
								<input type="text" name="M_Name_First" class="input_text imes_kr" onKeyUP="this.value = this.value.toUpperCase();" maxlength="20" value="" placeholder="<%=LNG_TEXT_GIVEN_NAME%>">
							</div>
						</div>
					</div>
				<div class="box birth">
					<h5><%=LNG_TEXT_BIRTH%></h5>
					<div class="con">
						<div class="selects">
							<div>
								<select name = "birthYY" class="input_select">
									<option value="" disabled selected hidden><%=LNG_TEXT_YEAR%></option>
									<%For i = MIN_YEAR To MAX_YEAR%>
										<option value="<%=i%>" ><%=i%></option>
									<%Next%>
								</select>
								<!-- <p><%=LNG_TEXT_YEAR%></p> -->
							</div>
							<div>
								<select name = "birthMM" class="input_select">
									<option value="" disabled selected hidden><%=LNG_TEXT_MONTH%></option>
									<%For j = 1 To 12%>
										<%jsmm = Right("0"&j,2)%>
										<option value="<%=jsmm%>" ><%=jsmm%></option>
									<%Next%>
								</select>
							</div>
							<div>
								<select name = "birthDD" class="input_select">
									<option value="" disabled selected hidden><%=LNG_TEXT_DAY%></option>
									<%For k = 1 To 31%>
										<%ksdd = Right("0"&k,2)%>
										<option value="<%=ksdd%>" ><%=ksdd%></option>
									<%Next%>
								</select>
							</div>
						</div>
					</div>
				</div>
				<input type="button" class="button small" onclick="javascript: ajax_accountChk();" value="<%=LNG_JOINSTEP03_03%>" />
				<div class="result_line tcenter tweight" id="result_text">
					<span><%=LNG_JOINSTEP03_04%></span>
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
					<input type="button" class="cancel" onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_PREVIOUS_STEP%>"/>
					<input type="submit" class="promise" value="<%=LNG_TEXT_NEXT_STEP%>" />
				</div>

			</article>
		</div>
	</form>
</div>

<!--#include virtual="/_include/copyright.asp" -->

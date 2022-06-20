<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	IS_LANGUAGESELECT = "F"
	NO_MEMBER_REDIRECT = "F"

	view = 4
	sview = 3
	ThisJoinStep = "4"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	If Not checkRef(houUrl &"/common/joinStep03.asp") Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")

	CENTER_SELECT_TF = "T"		'센터선택 기본값
	IF CS_NOMIN_CENTER_0_TF = "T" Then CENTER_SELECT_TF = "F" '판매원센터따라가기


	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

'	centerName			= pRequestTF("centerName",True)
'	centerCode			= pRequestTF("centerCode",True)

	ajaxTF				= pRequestTF("ajaxTF",True)

	strBankCodeCHK		= pRequestTF("strBankCodeCHK",True)
	strBankNumCHK		= pRequestTF("strBankNumCHK",True)
	strBankOwnerCHK		= pRequestTF("strBankOwnerCHK",True)

	birthYYCHK			= pRequestTF("birthYYCHK",True)		'생년월일체크 YYYY
	birthMMCHK			= pRequestTF("birthMMCHK",True)		'생년월일체크 MM
	birthDDCHK			= pRequestTF("birthDDCHK",True)		'생년월일체크 DD
	TempDataNum			= pRequestTF("TempDataNum",True)

	strBankCode			= pRequestTF("strBankCode",True)
	strBankNum			= pRequestTF("strBankNum",True)
	strBankOwner		= pRequestTF("strBankOwner",True)

	birthYY				= pRequestTF("birthYY",True)		'생년월일 YYYY
	birthMM				= pRequestTF("birthMM",True)		'생년월일 MM
	birthDD				= pRequestTF("birthDD",True)		'생년월일 DD

	If Agree01 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS(""&LNG_ALERT_WRONG_ACCESS&"","go","joinStep01.asp")

	If ajaxTF <> "T" Then Call ALERTS("본인인증을 확인하셔야합니다.","back","")



	If strBankCodeCHK	<> strBankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep01.asp")
	If strBankNumCHK	<> strBankNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep01.asp")
	If strBankOwnerCHK	<> strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep01.asp")

	If birthYYCHK		<> birthYY			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If birthMMCHK		<> birthMM			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If birthDDCHK		<> birthDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")

	birthYYMMDD	= Right(birthYY,2)&birthMM&birthDD			'생년월일체크 YYMMDD

'	Call ResRW(birthYYMMDD,"birthYYMMDD")
'	Call ResRW(strSSH1,"strSSH1")
'	Call ResRW(strSSH2,"strSSH1")
'	Call ResRW(birthYY,"birthYY")
'	Call ResRW(birthMM,"birthMM")
'	Call ResRW(birthDD,"birthDD")
'	Call ResRW(strBankCodeCHK,"strBankCodeCHK")
'	Call ResRW(strBankNumCHK,"strBankNumCHK")
'	Call ResRW(strBankOwnerCHK,"strBankOwnerCHK")
'	Call ResRW(strSSH1CHK,"strSSH1CHK")
'	Call ResRW(strSSH2CHK,"strSSH2CHK")
'	Call ResRW(strBankCode,"strBankCode")
'	Call ResRW(strBankNum,"strBankNum")
'	Call ResRW(strBankOwner,"strBankOwner")


	'▣암호화후 템프테이블데이터와 비교
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strSSH1		<> "" Then Enc_strSSH1		= objEncrypter.Encrypt(strSSH1)
		If strSSH2		<> "" Then Enc_strSSH2		= objEncrypter.Encrypt(strSSH2)
		If birthYYMMDD	<> "" Then Enc_birthYYMMDD		= objEncrypter.Encrypt(birthYYMMDD)			'생년월일 암호화(YYMMDD)
	Set objEncrypter = Nothing


		'Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_strSSH1),_
		'Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_strSSH2)_
	arrParams = Array(_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
		Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_birthYYMMDD),_
		Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_birthYYMMDD)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW",DB_PROC,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_TempDataNum		= DKRS("TempDataNum")
		DKRS_strName			= DKRS("strName")
		DKRS_strSSH1			= DKRS("strSSH1")			'생년월일 YYMMDD
		DKRS_strSSH2			= DKRS("strSSH2")			'생년월일 YYMMDD
		DKRS_strCenterName		= DKRS("strCenterName")
		DKRS_strCenterCode		= DKRS("strCenterCode")
		DKRS_strBankCode		= DKRS("strBankCode")
		DKRS_strBankNum			= DKRS("strBankNum")
		DKRS_strBankOwner		= DKRS("strBankOwner")
		DKRS_strOrderNum		= DKRS("strOrderNum")
		DKRS_M_Name_First		= DKRS("M_Name_First")
		DKRS_M_Name_Last		= DKRS("M_Name_Last")
	Else
		Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
	End If
	Call closeRs(DKRS)


	'▣템프테이블 데이터 복호화후 비교
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If DKRS_strBankNum		<> "" Then DKRS_strBankNum	= objEncrypter.Decrypt(DKRS_strBankNum)
		If DKRS_strSSH1			<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
		If DKRS_strSSH2			<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
	Set objEncrypter = Nothing

	If DKRS_strBankCode		<>	strBankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If DKRS_strBankNum		<>	strBankNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","go","joinStep01.asp")
	If DKRS_strBankOwner	<>	strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","go","joinStep01.asp")
	If DKRS_TempDataNum		<>	TempDataNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","go","joinStep01.asp")
	If DKRS_strSSH1			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","go","joinStep01.asp")
	If DKRS_strSSH2			<>	birthYYMMDD			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.13","go","joinStep01.asp")

	If DK_MEMBER_VOTER <> "" Then
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_VOTER) _
		)
		VOTERCHK = Db.execRsData("DKP_JOIN_VOTER_CHK",DB_PROC,arrParams,Nothing)
		If VOTERCHK > 0 Then
			LINKVOTER = "T"
		End If
	End If


	If DK_MEMBER_VOTER_ID <> "" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			'DK_MEMBER_VOTER_ID	 = objEncrypter.Encrypt(DK_MEMBER_VOTER_ID)


		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WITH(NOLOCK) WHERE [webID] = ? "
		arrParamsVI = Array(_
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
		)
		Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
		If Not DKRSVI.BOF And Not DKRSVI.EOF Then
			DKRSVI_MBID1		= DKRSVI("MBID")
			DKRSVI_MBID2		= DKRSVI("MBID2")
			DKRSVI_MNAME		= DKRSVI("M_NAME")
			DKRSVI_CHECK		= "T"
			DKRSVI_WEBID		= DKRSVI("WebID")
			'DKRSVI_WEBID		= objEncrypter.DEcrypt(DKRSVI_WEBID)
		Else
			DKRSVI_MBID1		= ""
			DKRSVI_MBID2		= ""
			DKRSVI_MNAME		= ""
			DKRSVI_CHECK		= "F"
			DKRSVI_WEBID		= ""
		End If

		Set objEncrypter = Nothing
	End If

	Select Case Left(strSSH2,1)
		Case "1"
			birthYY = "19"
			isSex = "M"
		Case "2"
			birthYY = "19"
			isSex = "F"
		Case "3"
			birthYY = "20"
			isSex = "M"
		Case "4"
			birthYY = "20"
			isSex = "F"
	End Select

	'birthYYYY = birthYY & Left(strSSH1,2)
	'birthMM = Mid(strSSH1,3,2)
	'birthDD = Right(strSSH1,2)

	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD


	mnType = "4"

%>
<%
	If NICE_BANK_WITH_MOBILE_USE = "T" Then

		'#####################################
		'	NICE 본인인증(핸드폰)
		'#####################################

		sRequestNO = pRequestTF("sRequestNO",True)

		If session("REQ_SEQ") <> sRequestNO Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","go", MOB_PATH&"/common/joinStep01.asp")

		'▣ 인증 데이터 확인 S
			Set XTEncrypt = new XTclsEncrypt
			'RChar = XTEncrypt.MD5(RandomChar(10))
			RChar = makeMemTempNum&RandomChar(10)

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

				'NICE 휴대전화 리턴값 신청해야함!!!
				If DKRSM_sMobileNo = "" Then
					Call ALERTS("휴대폰정보가 없습니다..","GO", MOB_PATH&"/common/joinStep01.asp")
				End If

				'CS회원 중복체크
				SQL_CK = "SELECT MBID,MBID2,M_NAME,WebID FROM [tbl_memberInfo] (nolock) WHERE [hptel] = ? AND [hptel] <> '' "
				arrParams_CK = Array(_
					Db.makeParam("@mobileAuth",adVarChar,adParamInput,88,DKRSM_sMobileNo) _
				)
				Set DKRSM = Db.execRs(SQL_CK,DB_TEXT,arrParams_CK,DB3)
				If Not DKRSM.BOF And Not DKRSM.EOF Then
					Call ALERTS("이미 등록된 회원입니다.","GO", MOB_PATH&"/common/member_login.asp")
				Else

					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						On Error Resume Next
							If DKRSM_sMobileNo		<> "" Then DKRSM_sMobileNo		= objEncrypter.Decrypt(DKRSM_sMobileNo)
							If RChar				<> "" Then RChar				= objEncrypter.Encrypt(RChar)
						On Error GoTo 0
					Set objEncrypter = Nothing

					arrParams = Array(_
						Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar), _
						Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNO), _
						Db.makeParam("@sResponseNumber",adVarChar,adParamInput,24,sResponseNumber), _
						Db.makeParam("@sDupInfo",adVarChar,adParamInput,64,DKRSM_sDupInfo) _
					)
					Call Db.exec("DKSP_MEMBER_JOIN_TEMP_INSERT",DB_PROC,arrParams,Nothing)
					SESSION("dataNum") = RChar

				End If
			Else
				Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","GO", MOB_PATH&"/common/joinStep01.asp")
			End If
			Call closeRs(DKRSM)

			'print RChar
		'▣ 인증 데이터 확인 E

		'Call ResRW(SESSION("dataNum"),"SESSION(dataNum)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")
		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")

	End If
%>
<!--#include virtual="/_include/document.asp" -->
<!-- <link rel="stylesheet" href="/css/join.css" /> -->
<link rel="stylesheet" href="/css/common.css?v0" />
<script type="text/javascript" src="joinStep.js?v6"></script>
<script type="text/javascript">
	$(document).ready(function(){
		<%If DK_MEMBER_VOTER_ID = "" Then%>
			$("input[name=voter]").val("");
		<%End IF%>
		$("input[name=sponsor]").val("");
	});
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->

<div id="joinStep" class="common joinStep3 joinStep4">


	<form name="cfrm" method="post" action="joinStep04Handler.asp" onsubmit="return submitChk(this);">
		<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
		<input type="hidden" name="dataNum" value="<%=TempDataNum%>" />
		<input type="hidden" name="agree01" value="<%=Agree01%>" />
		<input type="hidden" name="agree02" value="<%=Agree02%>" />
		<input type="hidden" name="agree03" value="<%=Agree03%>" />

		<input type="hidden" name="strBankCode" value="<%=DKRS_strBankCode%>" />
		<input type="hidden" name="strBankNum" value="<%=DKRS_strBankNum%>" />
		<input type="hidden" name="strBankOwner" value="<%=DKRS_strBankOwner%>" />

		<%If DKRSVI_WEBID = "" Then%>
			<input type="hidden" name="NominID1" value="" readonly="readonly" />
			<input type="hidden" name="NominID2" value="" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="" readonly="readonly" />
			<input type="hidden" name="NominChk" value="" readonly="readonly" />
		<%Else%>
			<input type="hidden" name="NominID1" value="<%=DKRSVI_MBID1%>" readonly="readonly" />
			<input type="hidden" name="NominID2" value="<%=DKRSVI_MBID2%>" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="<%=DKRSVI_WEBID%>" readonly="readonly" />
			<input type="hidden" name="NominChk" value="<%=DKRSVI_CHECK%>" readonly="readonly" />
		<%End If%>
		<input type="hidden" name="SponID1" value="" readonly="readonly" />
		<input type="hidden" name="SponID2" value="" readonly="readonly" />
		<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
		<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
		<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />
		<input type="hidden" name="NominCom" value="F" readonly="readonly" />
		<input type="hidden" name="NICE_BANK_WITH_MOBILE_USE" value="<%=NICE_BANK_WITH_MOBILE_USE%>" readonly="readonly" /><%'핸드폰인증용%>
		<input type="hidden" name="CS_AUTO_WEBID_TF" value="<%=CS_AUTO_WEBID_TF%>" readonly="readonly" /><%'회원 자동 아이디 생성%>
		<input type="hidden" name="CENTER_SELECT_TF" value="<%=CENTER_SELECT_TF%>" readonly="readonly" /><%'추천센터선택%>

		<div class="wrap">
			<article>
				<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
				<div class="name">
					<h5><%=LNG_TEXT_NAME%></h5>
					<div class="con"><b><%=DKRS_strName%></b></div>
					<!-- <th>주민등록번호</th>
					<td><%=DKRS_strSSH1%>-*******</td> -->
				</div>
				<div class="bank dwrap">
					<div>
						<h5><%=LNG_TEXT_BANKNAME%> / <%=LNG_TEXT_BANKNUMBER%></h5>
						<div class="con">[<%=Fnc_bankname(DKRS_strBankCode)%>] / <%=DKRS_strBankNum%></div>
					</div>
					<div>
						<h5><%=LNG_TEXT_BANKOWNER%></h5>
						<div class="con"><%=DKRS_strBankOwner%></div>
					</div>
				</div>
				<div class="dwrap">
					<%If CS_AUTO_WEBID_TF = "T" Then%>
					<div class="name">
						<h5><%=LNG_TEXT_ID%>&nbsp;<%=starText%></h5>
						<div class="con"><b>아이디는 회원가입 후 발급됩니다.</b></div>
					</div>
					<%Else%>
					<div class="id">
						<h5><%=LNG_TEXT_ID%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="text" name="strID" class="input_text" maxlength="20" <%=toNoKorText%> placeholder="" />
							<input type="button" class="button" onclick="join_idcheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
							<p class="summary" id="idCheck"><%=LNG_JOINSTEP03_U_TEXT04%>
								<input type="hidden" name="idcheck" value="F" readonly="readonly" />
								<input type="hidden" name="chkID" value="" readonly="readonly" />
							</p>
						</div>
					</div>
					<%End If%>
				</div>
				<div class="password dwrap">
					<div>
						<h5><%=LNG_TEXT_PASSWORD%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="strPass" class="input_text" maxlength="20" size="24" placeholder="" />
							<p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p>
						</div>
					</div>
					<div>
						<h5><%=LNG_TEXT_PASSWORD_CONFIRM%>&nbsp;<%=starText%></h5>
						<div class="con">
							<input type="password" name="strPass2" class="input_text" maxlength="20" size="24" placeholder="" />
						</div>
					</div>
				</div>
				<%If CENTER_SELECT_TF = "T" Then%>
				<div class="center">
					<h5><%=LNG_TEXT_CENTER%>&nbsp;<%=starText%></h5>
					<div class="con">
						<select name="businessCode" class="input_select">
							<option value="" disabled selected hidden>::: <%=LNG_JOINSTEP03_U_TEXT09%> :::</option>
							<%
								SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = 'KR' AND [U_TF] = 0 ORDER BY [ncode] ASC"
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For i = 0 To listLen
										PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
									Next
								End If
							%>
						</select>
						<p class="summary">*&nbsp;<%=LNG_JOINSTEP03_U_TEXT11%></p>
					</div>
				</div>
				<%End If%>
				<%
					'※후원인선택 : 추천인의 후원산하로만(형제라인 지정불가) pop_VoterSFV.asp → pop_SponsorSFV.asp
				%>
				<div class="voter">
					<h5><%=CS_NOMIN%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="voter" class="input_text" value="<%=DKRSVI_MNAME%>" maxlength="12" size="24" readonly="readonly" onclick="" placeholder="<%=LNG_JOINSTEP04_01%>" />
						<!-- <input type="button" class="txtBtn j_medium" onclick="vote_idcheck();" value="검색"/> -->
						<%'#modal dialog%>
						<%If DKRSVI_CHECK <> "T" Then%>
						<a name="modal" class="button" id="popVoter" href="/common/pop_voter.asp" title="<%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						<%End If%>
					</div>
				</div>
				<%if 1=2 then%>
				<div class="sponsor">
					<h5><%=CS_SPON%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="sponsor" class="input_text" maxlength="12" size="24" readonly="readonly" onclick="" placeholder="<%=LNG_JOINSTEP04_02%>" />
						<!-- <input type="button" class="txtBtn j_medium" onclick="spon_idcheck();" value="검색" /> -->
						<%'#modal dialog%>
						<a name="modal" id="popSponsor" class="button" href="/common/pop_sponsor.asp" title="<%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%>" ><%=LNG_TEXT_SEARCH%></a>
						<input type="hidden" name="sponLine" value="" readonly="readonly" />
					</div>
				</div>
				<%End If%>
			</article>
		</div>

		<div class="wrap">
			<article>
				<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
				<div class="radio">
					<h5><%=LNG_TEXT_SEX%>&nbsp;<%=starText%></h5>
					<div class="con">
						<label><input type="radio" name="isSex" value="M" checked="checked" /><i class="icon-ok"></i><span><%=LNG_TEXT_MALE%></span></label>
						<label><input type="radio" name="isSex" value="F" /><i class="icon-ok"></i><span><%=LNG_TEXT_FEMALE%></span></label>
					</div>
				</div>
				<div class="address">
					<h5><%=LNG_TEXT_ADDRESS1%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle" maxlength="7" readonly="readonly" placeholder="" />
						<a name="modal" href="/m/common/pop_postcode.asp" id="pop_postcode" title="<%=LNG_JOINSTEP04_03%>"><input type="button" class="button" value="<%=LNG_JOINSTEP04_03%>"/></a>
						<!-- <input type="button" class="button" onclick="execDaumPostcode('oris');" value="우편번호검색" /> -->
						<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text readonly vmiddle" maxlength="500" readonly="readonly" placeholder="<%=LNG_JOINSTEP04_04%>" />
					</div>
				</div>
				<div class="address2">
					<h5><%=LNG_TEXT_ADDRESS2%>&nbsp;<%=starText%></h5>
					<div class="con"><input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" maxlength="500" placeholder="<%=LNG_JOINSTEP04_05%>" /></div>
				</div>
				<div class="mobile">
					<h5><%=LNG_JOINSTEP03_U_TEXT52%>&nbsp;<%=starText%></h5>
					<%If NICE_BANK_WITH_MOBILE_USE = "T" Then%>
					<div class="con tleft" style="font-size: 15px; line-height: 50px;"  >
						<input type="hidden" name="strMobile" value="<%=DKRSM_sMobileNo%>" readonly="readonly" />
						<%=FN_SPLIT_MOBILE(DKRSM_sMobileNo)%>
					</div>
					<%Else%>
					<div class="con" >
						<input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="" />
						<input type="button" class="button" onclick="join_MobileCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary tweight" id="mobileCheckTXT"></p>
						<input type="hidden" name="mobileCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkMobile" value="" readonly="readonly" />
						<p class="summary"><%=LNG_JOINSTEP03_U_TEXT24%></p>
					</div>
					<%End If%>
				</div>
				<div>
					<h5><%=LNG_TEXT_TEL%></h5>
					<div class="con"><input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>" /></div>
				</div>
				<div class="mobile">
					<h5><%=LNG_TEXT_EMAIL%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="text" name="strEmail" class="input_text" maxlength="512" />
						<input type="button" class="button" onclick="join_emailCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<p class="summary" id="emailCheckTXT"><%=LNG_JOINSTEP03_U_TEXT29%></p>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" />
					</div>
				</div>
				<div class="radio birth">
					<h5><%=LNG_TEXT_BIRTH%>&nbsp;<%=starText%></h5>
					<div class="con">
						<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
						<div><p><%=birthYYYY%>-<%=birthMM%>-<%=birthDD%></p></div>
						<label><input type="radio" name="isSolar" value="S" checked="checked"/><i class="icon-ok"></i><span><%=LNG_TEXT_SOLAR%></span></label>
						<label><input type="radio" name="isSolar" value="M" /><i class="icon-ok"></i><span><%=LNG_TEXT_LUNAR%></span></label>
					</div>
				</div>
			</article>
			<div class="btnZone">
				<input type="button" class="cancel" onclick="javascript:history.go(-1);" value="<%=LNG_TEXT_JOIN_CANCEL%>" data-ripplet>
				<input type="submit" class="promise" data-ripplet value="<%=LNG_TEXT_JOIN%>" />
			</div>
		</div>
	</form>


</div>

<%'▣ 추천/후원인 선택 modal▣%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual="/_include/copyright.asp" -->

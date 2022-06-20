<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "MEMBERSHIP"

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	TOP_WRAP_FIX = "F"		'상단메뉴고정X


	view = 1
	sview = 6

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/common/joinStep_n02c.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")
		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"back","")
	End Select



	strName		 = Trim(pRequestTF("name",True))
	M_Name_Last	 = Trim(pRequestTF("M_Name_Last",True))		'성
	M_Name_First = Trim(pRequestTF("M_Name_First",True))	'이름

	birthYY	= Trim(pRequestTF("birthYY",True))
	birthMM	= Trim(pRequestTF("birthMM",True))
	birthDD	= Trim(pRequestTF("birthDD",True))
	'strSSH1 = Trim(pRequestTF("ssh1",True))
	'strSSH2 = Trim(pRequestTF("ssh2",True))
	strSSH1  = Right(birthYY,2)&birthMM&birthDD
	strSSH2  = "0000000"

	If UCase(Lang) = "KR" Then
		strName		= Replace(strName," ","")			'KR 이름공백제거
	End If
	M_Name_First	= Replace(M_Name_First," ","")		'KR 이름
	M_Name_Last		= Replace(M_Name_Last," ","")		'KR 성

	agreement = pRequestTF("agreement",False)
	gather = pRequestTF("gather",False)
	company = pRequestTF("company",False)

	If agreement = "" Then agreement = "F"
	If gather = "" Then gather = "F"

	If agreement <> "T" Then Call ALERTS("이용약관에 동의하셔야합니다.","back","")
	If gather <> "T" Then Call ALERTS("개인정보 수집 및 이용에 동의하셔야합니다.","back","")
	If company <> "T" Then Call ALERTS("사업자회원 가입약관에 동의하셔야합니다.","back","")



	'주민번호 암호화입력

	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strSSH1		<> "" Then Enc_strSSH1		= objEncrypter.Encrypt(strSSH1)
		If strSSH2		<> "" Then Enc_strSSH2		= objEncrypter.Encrypt(strSSH2)
	Set objEncrypter = Nothing


	Set XTEncrypt = new XTclsEncrypt
	'RChar = XTEncrypt.MD5(RandomChar(10))
	RChar = makeMemTempNum&RandomChar(10)

	'▣DKP_MEMBER_JOIN_TEMP 확인!
	arrParams = Array(_
		Db.makeParam("@strName",adVarChar,adParamInput,20,strName),_
		Db.makeParam("@strSSH1",adVarChar,adParamInput,50,Enc_strSSH1),_
		Db.makeParam("@strSSH2",adVarChar,adParamInput,50,Enc_strSSH2),_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar),_
		Db.makeParam("@M_Name_First",adVarWChar,adParamInput,100,M_Name_First),_
		Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,100,M_Name_Last),_
		Db.makeParam("@Idnum",adInteger,adParamOutput,0,0) _
	)
	Call Db.exec("HJP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)
	'Call Db.exec("DKP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)

'	ThisIdentity = arrParams(3)(4)

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


		SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WHERE [webID] = ? "
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



'	ThisMd51 = Left(Rchar,16)
'	ThisMd52 = Right(Rchar,16)

'	ThisTempNum = ThisMd51 & ThisIdentity & ThisMd52


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

'	birthYYYY = birthYY & Left(strSSH1,2)
'	birthMM = Mid(strSSH1,3,2)
'	birthDD = Right(strSSH1,2)
	birthYYYY = birthYY
	birthMM = birthMM
	birthDD = birthDD


	'국가정보
	R_NationCode = Trim(pRequestTF("cnd",True))
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
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="join.css" />
<script type="text/javascript" src="joinStep_n03c.js"></script>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="joinStep" class="step03">
	<div class="title_area">
		<p class="c_b_title tweight" style="">판매회원정보 입력</p>
		<p class="c_s_title tweight" style="">회원가입을 위해서는 아래 회원가입폼에 정보를 입력하셔야합니다. <span class="red">*</span> 표시는 <span class="red">필수값</span>입니다.</p>
	</div>

	<!-- <form name="cfrm" method="post" action="joinStep_nFinish_c.asp" onsubmit="return chkSubmit(this);"> -->
	<form name="cfrm" method="post" action="joinFinish_c.asp" onsubmit="return chkSubmit(this);">
		<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
		<input type="hidden" name="agreement" value="<%=agreement%>" />
		<input type="hidden" name="gather" value="<%=gather%>" />
		<input type="hidden" name="company" value="<%=company%>" />

		<input type="hidden" name="SponID1" value="" readonly="readonly" />
		<input type="hidden" name="SponID2" value="" readonly="readonly" />
		<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
		<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
		<input type="hidden" name="dataNum" value="<%=RChar%>" readonly="readonly" />
		<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />

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
			<input type="hidden" name="voter" value="<%=DKRSVI_MNAME%>" readonly="readonly" />
		<%End If%>



		<div class="tableArea">
			<p class="s_title">회원기본정보</p>
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="*" />
				<!-- <tr class="line">
					<th>국가코드</th>
					<td colspan="3"><strong>[<%=DKRS_nationCode%>] <%=DKRS_className%></strong> <span class="alert">(The country code is based on ISO 3166-1 alpha-2 codes)</span></td>
				</tr> -->
				<tr class="line">
					<th>이름</th>
					<td><%=strName%></td>
				</tr><!-- <tr>
					<th>주민등록번호</th>
					<td><%=strSSH1%>-*******</td>
				</tr> --><tr>
					<th>아이디 <%=starText%></th>
					<td>
						<input type="text" name="strID" class="input_text imes vmiddle" maxlength="20" <%=toNoKorText%> placeholder="" />
						<input type="button" class="txtBtn j_medium" onclick="join_idcheck();" value="중복체크"/>
						<span class="summary" id="idCheck">띄어쓰기 없는 영문,숫자 4~20자
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</span>
					</td>
				</tr><!-- <tr>
					<th>별명 <%=starText%></th>
					<td colspan="3">
						<input type="text" name="NickName" class="input_text" maxlength="12" size="24" />
						<img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="닉네임 중복체크" class="cp vmiddle" onclick="join_NickCheck()" />
						<span class="summary" id="NickCheck">띄어쓰기 없이 적어주세요
							<input type="hidden" name="Nickcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkNick" value="" readonly="readonly" />
						</span>
					</td>
				</tr> --><tr>
					<th>비밀번호 <%=starText%></th>
					<td colspan="3"><input type="password" name="strPass" class="input_text imes" maxlength="20" size="24" onkeyup="noSpace('strPass');" placeholder="비밀번호를 입력해주세요" /><span class="summary">영문,숫자 혼합 6~20자</span></td>
				</tr><tr>
					<th>비밀번호 확인 <%=starText%></th>
					<td colspan="3"><input type="password" name="strPass2" class="input_text imes" maxlength="20" size="24" onkeyup="noSpace('strPass2');" placeholder="비밀번호를 다시 입력해주세요" /></td>
				</tr>
			</table>
		</div>

		<div class="tableArea">
			<p class="s_title">회원 부가정보</p>
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="*" />
				<!-- <tr class="line">
					<th class="req red2">판매원 구분 <%=starText%></th>
					<td>
						<label><input type="radio" name="Bus_FLAG" value="F" class="input_radio" checked="checked" /> 개인회원</span></label>
						<label style="margin-left:7px;"><input type="radio" name="Bus_FLAG" value="T" class="input_radio" /> 사업자회원</label>
					</td>
				</tr><tr id="Bus_FLAG_toggle" style="display:none;">
					<th></th>
					<td>
						<span class="tweight"> 사업자명 : </span><input type="text" name="Bus_Name" class="input_text" style="width:140px;" placeholder="사업자명 " />
						<span class="tweight" style="padding-left:10px;"> 사업자번호 : </span><input type="text" name="Bus_Number" class="input_text" style="width:180px;" maxlength="10" placeholder="사업자번호" <%=onlyKeys%>/>
					</td>
				</tr> -->

				<tr class="line">
					<th>센터 <%=starText%></th>
					<td>
						<select name="businessCode" style="width:220px;" class="input_select">
							<option value="">::: 센터 선택 :::</option>
							<!-- <option value="unknown">센터를 모릅니다.</option> -->
						<%
							'SQL = "SELECT * FROM [tbl_Business] ORDER BY [ncode] ASC"
							SQL = "SELECT * FROM [tbl_Business] WHERE [Na_Code] = '"&R_NationCode&"' AND [U_TF] = 0 ORDER BY [ncode] ASC"
							arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
							If IsArray(arrList) Then
								For i = 0 To listLen
									PRINT TABS(5)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
								Next
							Else
								PRINT TABS(5)& "	<option value="""">센터가 존재하지 않습니다.</option>"
							End If
						%>
						</select>
						<!-- <p style="margin-top:10px;"><span class="summary">* 센터를 모르시는 경우 추후에 본사로 연락하여 센터 변경을 할 수 있습니다.</span></p> -->
					</td>
				</tr>
				<tr>
					<th><%=CS_NOMIN%>&nbsp;<%=starText%></th>
					<%If DKRSVI_WEBID = "" Then%>
					<td>
						<input type="text" name="voter" class="input_text vmiddle readonly" maxlength="12" size="24" readonly="readonly" onclick="vote_idcheck()" placeholder="검색을 통해 추천인을 선택해주세요." />
						<input type="button" class="txtBtn j_medium" onclick="vote_idcheck();" value="검색"/>
					</td>
					<%Else%>
					<td><%=DKRSVI_MNAME%>(<%=DKRSVI_MBID1%>-<%=DKRSVI_MBID2%>)</td>
					<%End If%>
				</tr>
				<tr>
					<th><%=CS_SPON%>&nbsp;<%=starText%></th>
					<td>
						<input type="text" name="sponsor" class="input_text vmiddle readonly" maxlength="12" size="24" readonly="readonly" onclick="spon_idcheck()" placeholder="검색을 통해 후원인을 선택해주세요." />
						<input type="button" class="txtBtn j_medium" onclick="spon_idcheck();" value="검색" />
					</td>
				</tr>
				<tr>
					<th>은행 / 계좌번호</th>
					<td>
						<select name="bankCode" class="input_select">
							<option value="">은행을 선택해주세요</option>
							<%
								'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] ORDER BY [nCode] ASC"
								SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WHERE [Na_Code] = '"&R_NationCode&"' ORDER BY [nCode] ASC"
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
						<input type="text" name="BankNumber" class="input_text" />
					</td>
				</tr><tr>
					<th>예금주</th>
					<td><input type="text" name="bankOwner" class="input_text vmiddle" /></td>
				</tr>
			</table>
		</div>

		<div class="tableArea">
			<p class="s_title">회원부가정보</p>
			<table <%=tableatt%> class="width100">
				<col width="150" />
				<col width="*" />
				<tr class="line">
					<th>성별 <%=starText%></th>
					<td>
						<label><input type="radio" name="isSex" value="M" checked="checked" class="input_radio" /> 남성</label>
						<label style="margin-left:7px;"><input type="radio" name="isSex" value="F" class="input_radio" /> 여성</label>
					</td>
				</tr><!-- <tr>
					<th>이름노출 <%=starText%></th>
					<td>
						<label><input type="radio" name="isViewID" value="A" checked="checked" class="input_radio" /> 닉네임</label>
						<label style="margin-left:7px;"><input type="radio" name="isViewID" value="N" class="input_radio" /> 이름</label>
						<label style="margin-left:7px;"><input type="radio" name="isViewID" value="I" class="input_radio" /> 아이디</label>
					</td>
				</tr> --><tr>
					<th>주소 <%=starText%></th>
					<td>
						<input type="text" name="strZip" id="strZipDaum" class="input_text readonly vmiddle" style="width:60px;" readonly="readonly" placeholder="" />
						<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('oris');" value="우편번호검색" />
						<input type="text" name="strADDR1" id="strADDR1Daum" class="input_text readonly vmiddle" style="width:380px;" readonly="readonly" placeholder="우편번호검색을 통해 입력해주세요" />
					</td>
				</tr><tr>
					<th>상세주소 <%=starText%></th>
					<td><input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" style="width:500px; ime-mode:active;" placeholder="나머지 주소 입력." /></td>
				</tr><tr>
					<th>휴대폰번호 <%=starText%></th>
					<td>
						<!-- <input type="text" class="input_text" name="strMobile" <%=onLyKeys%> placeholder="휴대폰 번호 입력" /><span class="summary">하이픈(-)제외 숫자만 입력</span> -->
						<select name="mob_num1" class="input_select" style="width:70px;" >
							<option value="">선택</option>
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
							<option value="0130">0130</option>
							<option value="0502">0502</option>
							<option value="0505">0505</option>
							<option value="0506">0506</option>
							<option value="1541">1541</option>
							<option value="1595">1595</option>
							<option value="08217">08217</option>
						</select> -
						<input type="text" class="input_text" name="mob_num2" style="width:45px;" maxlength="4" <%=onLyKeys%> /> -
						<input type="text" class="input_text" name="mob_num3" style="width:45px;" maxlength="4" <%=onLyKeys%> />
						<span class="summary" style="">* 비상연락 시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
				</tr><tr>
					<th>전화번호</th>
					<td>
						<!-- <input type="text" class="input_text" name="strTel" <%=onLyKeys%> placeholder="전화번호 입력" /><span class="summary">하이픈(-)제외 숫자만 입력</span> -->
						<select name="tel_num1" class="input_select" style="width:70px;" >
							<option value="">선택</option>
							<option value="02">02</option>
							<option value="0303">0303</option>
							<option value="031">031</option>
							<option value="032">032</option>
							<option value="033">033</option>
							<option value="041">041</option>
							<option value="042">042</option>
							<option value="043">043</option>
							<option value="0502">0502</option>
							<option value="0504">0504</option>
							<option value="0505">0505</option>
							<option value="0506">0506</option>
							<option value="051">051</option>
							<option value="052">052</option>
							<option value="053">053</option>
							<option value="054">054</option>
							<option value="055">055</option>
							<option value="061">061</option>
							<option value="062">062</option>
							<option value="063">063</option>
							<option value="064">064</option>
							<option value="070">070</option>
							<option value="080">080</option>
							<option value="1544">1544</option>
							<option value="1566">1566</option>
							<option value="1577">1577</option>
							<option value="1588">1588</option>
							<option value="1599">1599</option>
							<option value="1600">1600</option>
							<option value="1644">1644</option>
							<option value="1661">1661</option>
							<option value="1688">1688</option>
						</select> -
						<input type="text" class="input_text" name="tel_num2" style="width:45px;" maxlength="4" <%=onLyKeys%> /> -
						<input type="text" class="input_text" name="tel_num3" style="width:45px;" maxlength="4" <%=onLyKeys%> />
					</td>
				</tr>
				<tr>
					<th>이메일 <%=starText%></th>
					<td>
						<input type="text" name="strEmail" class="input_text imes vmiddle" maxlength="512" />
						<p style="margin-top:10px;"><span class="summary">* ID/패스워드 분실시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span></p>
						<!-- <input type="button" class="txtBtn j_medium" onclick="join_emailCheck();" value="<%=LNG_TEXT_DOUBLE_CHECK%>"/>
						<span class="summary tweight" id="emailCheckTXT"></span>
						<input type="hidden" name="emailCheck" value="F" readonly="readonly" />
						<input type="hidden" name="chkEmail" value="" readonly="readonly" /> -->
					</td>
				</tr>
				<tr>
					<th>생일 <%=starText%></th>
					<td>
						<input type="hidden" name="birthYY" value="<%=birthYYYY%>" readonly="readonly" />
						<input type="hidden" name="birthMM" value="<%=birthMM%>" readonly="readonly" />
						<input type="hidden" name="birthDD" value="<%=birthDD%>" readonly="readonly" />
						<%=birthYYYY%>-<%=birthMM%>-<%=birthDD%>
						<!-- <select name="birthYY" class="vmiddle" style="width:70px;">
							<option value="">년도 선택</option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" <%=isSelect(i,birthYYYY)%>><%=i%></option>
							<%Next%>
						</select>
						<select name="birthMM" class="vmiddle" style="width:50px;">
							<option value="">월 선택</option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" <%=isSelect(jsmm,birthMM)%>><%=jsmm%></option>
							<%Next%>
						</select>
						<select name="birthDD" class="vmiddle" style="width:50px;">
							<option value="">일 선택</option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>"<%=isSelect(ksdd,birthDD)%>><%=ksdd%></option>
							<%Next%>
						</select><span class="summary">주민등록상 기재된 생년월일을 선택</span> -->
						<label style="margin-left:20px;"><input type="radio" name="isSolar" value="S" checked="checked" class="input_radio" /> 양력</label>
						<label><input type="radio" name="isSolar" value="M" class="input_radio" /> 음력</label>
					</td>
				</tr>

				<!-- <tr>
					<th>이메일 수신 여부 <%=starText%></th>
					<td>
						<p><%=DKCONF_SITE_TITLE%>은(는) 이메일을 통해 다양한 이벤트 및 정보를 제공하고 있습니다.</p>
						<p style="padding-bottom:3px;">이벤트와 정보를 이메일로 받아보시겠습니까?</p>
						<label><input type="radio" name="sendemail" value="T" class="input_radio" checked="checked" /> 예</label>
						<label><input type="radio" name="sendemail" value="F" class="input_radio" style="margin-left:10px;" /> 아니오</label>
						<span class="summary">* 이메일수신여부와는 별도로 회사주요정책변경등의 메시지등은 발송됩니다.</span>
					</td>
				</tr><tr>
					<th>SMS 수신여부 <%=starText%></th>
					<td>
						<p style="padding-bottom:3px;">이벤트와 쇼핑에 대한 정보를 SMS로 받아보시겠습니까?</p>
						<label><input type="radio" name="sendsms" value="T" class="input_radio" checked="checked" /> 예</label>
						<label><input type="radio" name="sendsms" value="F" class="input_radio" style="margin-left:10px;" /> 아니오</label>
						<span class="summary">* SMS수신여부와는 별도로 회사주요정책변경등의 메시지등은 발송됩니다.</span>
					</td>
				</tr> -->
			</table>
		</div>

		<div class="btnZone tcenter">
			<span><a href="joinStep01.asp" type="button" class="txtBtnC large radius10 gray" style="width:120px;">가입취소</a></span>
			<span class="pL10"><input type="submit" class="txtBtnC large radius10 blue h22" style="width:120px;" value="회원가입" /></span>
		</div>
	</form>

</div>
<!--#include virtual="/_include/copyright.asp" -->

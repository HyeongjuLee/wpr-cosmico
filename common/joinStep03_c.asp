<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
'print DK_MEMBER_VOTER_ID

	PAGE_SETTING = "MEMBERSHIP"

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1
	sview = 4

	If Not checkRef(houUrl &"/common/joinStep02_c.asp") Then Call alerts("잘못된 접근입니다.","go","/common/joinStep01.asp")

'	If UCase(LANG) <> "KR" Then
'		Response.Redirect "joinStep02_u.asp"
'	End If

	strName = Trim(pRequestTF("name",True))
	strSSH1 = Trim(pRequestTF("ssh1",True))
	strSSH2 = Trim(pRequestTF("ssh2",True))

	strName = Replace(strName," ","")			'KR 이름공백제거

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

	arrParams = Array(_
		Db.makeParam("@strName",adVarChar,adParamInput,20,strName),_
		Db.makeParam("@strSSH1",adVarChar,adParamInput,50,Enc_strSSH1),_
		Db.makeParam("@strSSH2",adVarChar,adParamInput,50,Enc_strSSH2),_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,RChar),_
		Db.makeParam("@Idnum",adInteger,adParamOutput,0,0) _
	)
	Call Db.exec("DKP_MEMBER_JOIN_TEMP",DB_PROC,arrParams,DB3)

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

	birthYYYY = birthYY & Left(strSSH1,2)
	birthMM = Mid(strSSH1,3,2)
	birthDD = Right(strSSH1,2)


	If DK_MEMBER_VOTER_ID <> "" Then

		DK_MEMBER_VOTER_ID_ORI	= DK_MEMBER_VOTER_ID

		'▣CS신버전 WebID/Password 암/복호화
		If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				'If DK_MEMBER_VOTER_ID	<> "" Then DK_MEMBER_VOTER_ID	 = objEncrypter.Encrypt(DK_MEMBER_VOTER_ID)

			Set objEncrypter = Nothing
		End If

		SQLVI = "SELECT [MBID],[MBID2],[M_NAME] FROM [tbl_MemberInfo] WHERE [webID] = ? "
		arrParamsVI = Array(_
			Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
		)
		Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
		If Not DKRSVI.BOF And Not DKRSVI.EOF Then
			DKRSVI_MBID1		= DKRSVI("MBID")
			DKRSVI_MBID2		= DKRSVI("MBID2")
			DKRSVI_MNAME		= DKRSVI("M_NAME")
			DKRSVI_CHECK		= "T"
		Else
			DKRSVI_MBID1		= ""
			DKRSVI_MBID2		= ""
			DKRSVI_MNAME		= ""
			DKRSVI_CHECK		= "F"
		End If

	End If

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
<link rel="stylesheet" href="/css/join.css" />
<style type="text/css">
	#joinStep {padding-bottom:30px;}
	#joinStep .title_area {margin-top:10px;}
	#joinStep .c_b_title {font-size:22px; padding:10px 0px; color:#333}
	#joinStep .c_s_title {font-size:12px; padding-bottom:10px; border-bottom:1px solid #555555;}
</style>
<script type="text/javascript" src="/jscript/joinStep03_c.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->
<div id="joinStep" class="" style="margin-top:130px;">
	<div class="title_area">
		<p class="c_b_title tweight" style="">회원정보 입력</p>
		<p class="c_s_title tweight" style="">회원가입을 위해서는 아래 회원가입폼에 정보를 입력하셔야합니다. <span class="red">* 표시는 필수값</span></p>
	</div>
</div>
<div id="join">
	<div class="joinInner">
		<form name="cfrm" method="post" action="joinFinish_c.asp" onsubmit="return chkSubmit(this);">
			<input type="hidden" name="cnd" value="<%=R_NationCode%>" readonly />
			<input type="hidden" name="agreement" value="<%=agreement%>" />
			<input type="hidden" name="gather" value="<%=gather%>" />
			<input type="hidden" name="company" value="<%=company%>" />
			<input type="hidden" name="NominID1" value="<%=DKRSVI_MBID1%>" readonly="readonly" />
			<input type="hidden" name="NominID2" value="<%=DKRSVI_MBID2%>" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="<%=DK_MEMBER_VOTER_ID%>" readonly="readonly" />
			<input type="hidden" name="NominChk" value="<%=DKRSVI_CHECK%>" readonly="readonly" />
			<input type="hidden" name="SponID1" value="" readonly="readonly" />
			<input type="hidden" name="SponID2" value="" readonly="readonly" />
			<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
			<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />
			<input type="hidden" name="dataNum" value="<%=RChar%>" readonly="readonly" />
			<input type="hidden" name="joinType" value="COMPANY" readonly="readonly" />
			<!-- <p class="sub_desc"><%=viewImg(IMG_JOIN&"/joinStep03_title.gif",490,70,"")%></p> -->
			<p style="margin-top:20px;"><%=viewImg("/images_"&R_NationCode&"/join/join_into_tit_01.gif",196,33,"")%></p>
			<table <%=tableatt%> class="infoTable">
				<col width="150" />
				<col width="185" />
				<col width="150" />
				<col width="185" />
				<!-- <tr class="line">
					<th>국가코드</th>
					<td colspan="3"><strong>[<%=DKRS_nationCode%>] <%=DKRS_nationNameEn%></strong></td>
				</tr> -->
				<tr class="line">
					<th>이름</th>
					<td><%=strName%></td>
					<th>주민등록번호</th>
					<td><%=strSSH1%>-*******</td>
				</tr><tr>
					<th>아이디 <%=starText%></th>
					<td colspan="3">
						<input type="text" name="strID" class="input_text imes vmiddle" maxlength="50" style="width:180px"/>
						<!-- <img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="join_idcheck()" /> -->
						<!-- <span class="button medium"><a onclick="join_idcheck()">중복체크</a></span> -->
						<input type="button" class="txtBtn small" onclick="join_idcheck();" value="중복체크"/>
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
					<td colspan="3"><input type="password" name="strPass" class="input_text imes" maxlength="20" size="24" /><span class="summary">영문,숫자 6~20자</span></td>
				</tr><tr>
					<th>비밀번호 확인 <%=starText%></th>
					<td colspan="3"><input type="password" name="strPass2" class="input_text imes" maxlength="20" size="24" /></td>
				</tr>
			</table>

			<p style="margin-top:20px;"><%=viewImg("/images_"&R_NationCode&"/join/join_into_tit_03.gif",196,33,"")%></p>
			<table <%=tableatt%> class="infoTable">
				<col width="150" />
				<col width="520" />
				<tr class="line">
					<th>센터 <%=starText%></th>
					<td>
						<select name="businessCode">
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
				</tr><tr>
					<th><%=CS_NOMIN%> <%=starText%></th>
					<td>
						<input type="text" name="voter" class="input_text" maxlength="12" size="24" value="<%=DKRSVI_MNAME%>" style="background-color:#f4f4f4;" readonly="readonly" onclick="vote_idcheck()" />
						<!-- <input type="text" name="NominWebID" class="input_text" maxlength="12" size="24" value="<%=DK_MEMBER_VOTER_ID_ORI%>" style="background-color:#f4f4f4;" readonly="readonly" onclick="vote_idcheck()" /> -->
						<input type="button" class="txtBtn small" onclick="vote_idcheck();" value="검색"/>
						<!-- <img src="<%=IMG_JOIN%>/voter_check2.gif" width="68" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="vote_idcheck()" /> -->
					</td>
				</tr><!-- <tr>
					<th><%=CS_SPON%> <%=starText%></th>
					<td>
						<input type="text" name="sponsor" class="input_text" maxlength="12" size="24" style="background-color:#f4f4f4;" readonly="readonly" onclick="spon_idcheck()" />
						<input type="button" class="txtBtn small" onclick="spon_idcheck();" value="검색"/>
					</td>
				</tr> -->
				<tr>
					<th>은행 / 계좌번호</th>
					<td>
						<select name="bankCode">
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
						<input type="text" name="BankNumber" class="input_text vmiddle" maxlength="100" style="width:180px;" />
					</td>
				</tr><tr>
					<th>예금주</th>
					<td><input type="text" name="bankOwner" class="input_text vmiddle" maxlength="100" style="width:120px;" /></td>
				</tr>
			</table>


			<p style="margin-top:20px;"><%=viewImg("/images_"&R_NationCode&"/join/join_into_tit_02.gif",196,33,"")%></p>
			<table <%=tableatt%> class="infoTable">
				<col width="150" />
				<col width="520" />
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
						<input type="text" class="input_text" name="strZip" id="strZipDaum" style="width:70px;background-color:#f4f4f4;" readonly="readonly" />
						<!-- <img src="<%=IMG_JOIN%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" /> -->
						<input type="button" class="txtBtn small" onclick="execDaumPostcode('oris');" value="우편번호"/>
						<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" style="width:350px;background-color:#f4f4f4;" readonly="readonly" />
					</td>
				</tr><tr>
					<th>상세주소 <%=starText%></th>
					<td><input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" style="width:512px;ime-mode:active;" /></td>
				</tr><tr>
					<th>휴대폰번호 <%=starText%></th>
					<td>
						<select name="mob_num1" style="width:55px;" class="vmiddle">
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
						<span class="summary">* 비상연락 시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
				</tr><tr>
					<th>전화번호</th>
					<td>
						<select name="tel_num1" style="width:55px;" class="vmiddle">
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
				</tr><tr>
					<th>이메일 <%=starText%></th>
					<td>
						<input type="text" name="mailh" value="" class="input_text imes" maxlength="512" style="width:102px;" /> @
						<input type="text" name="mailt" value="" class="input_text imes" maxlength="512" style="width:120px;" />
						<select name="mails" onchange="javascript:document.cfrm.mailt.value = document.cfrm.mails.value;" class="vmiddle">
							<option value="" selected>직접입력</option>
							<option value="chollian.net">chollian.net</option>
							<option value="daum.net">daum.net</option>
							<option value="dreamwiz.com">dreamwiz.com</option>
							<option value="freechal.com">freechal.com</option>
							<option value="empal.com">empal.com</option>
							<option value="hanafos.com">hanafos.com</option>
							<option value="hanmail.net">hanmail.net</option>
							<option value="hanmir.com">hanmir.com</option>
							<option value="hitel.net">hitel.net</option>
							<option value="hotmail.com">hotmail.com</option>
							<option value="korea.com">korea.com</option>
							<option value="kornet.net">kornet.net</option>
							<option value="lycos.co.kr">lycos.co.kr</option>
							<option value="nate.com">nate.com</option>
							<option value="naver.com">naver.com</option>
							<option value="netian.com">netian.com</option>
							<option value="nownuri.net">nownuri.net</option>
							<option value="paran.com">paran.com</option>
							<option value="unitel.co.kr">unitel.co.kr</option>
							<option value="yahoo.co.kr">yahoo.co.kr</option>
							<option value="gmail.com">gmail.com</option>
						</select>
						<p style="margin-top:10px;"><span class="summary">* ID/패스워드 분실시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span></p>
					</td>
				</tr><tr>
					<th>생일 <%=starText%></th>
					<td>
						<!-- <input type="text" name="birthYY" class="input_text" maxlength="4" style="width:55px;"  value="<%=birthYYYY%>" /> 년
						<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:40px;" value="<%=birthMM%>" /> 월
						<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:40px;" value="<%=birthDD%>" /> 일 -->
						<select name = "birthYY" class="vmiddle" style="width:60px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" <%=isSelect(i,birthYYYY)%>><%=i%></option>
							<%Next%>
						</select> 년
						<select name = "birthMM" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" <%=isSelect(jsmm,birthMM)%>><%=jsmm%></option>
							<%Next%>
						</select> 월
						<select name = "birthDD" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>"<%=isSelect(ksdd,birthDD)%>><%=ksdd%></option>
							<%Next%>
						</select> 일
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
			<div class="tcenter" style="margin-top:40px;height:80px;">
				<!-- <input type="image" src="<%=IMG_JOIN%>/btn_info_Submit.gif" />
				<a href="/common/joinStep01.asp"><%=viewImgOpt(IMG_JOIN&"/btn_info_Cancel.gif",139,40,"","style=""margin-left:6px;""")%></a> -->
				<span><input type="submit" class="txtBtnC large radius10 blue" style="width:100px;" value="회원가입"/></span>
				<span class="pL10"><input type="button" class="txtBtnC large radius10 gray" style="width:100px;" onclick="javascript:history.go(-1);" value="가입취소"/></span>
			</div>

		</form>



	</div>
</div>



<!--#include virtual="/_include/copyright.asp" -->

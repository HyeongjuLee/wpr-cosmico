<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/md5.asp" -->
<%
	PAGE_SETTING = "JOIN"



	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

	Select Case UCase(LANG)
		Case "KR"
			If Not checkRef(houUrl &"/m/common/joinStep02_c.asp") Then Call alerts("잘못된 접근입니다.","go","/m/common/joinStep01.asp")
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

	agreement = "T"
	gather	  = "T"
	company	  = "T"

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

	'바이럴 추천인 체크
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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="joinStep03_c.js?vs=2"></script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
<script>
<!--
	$(document).ready(function(){
		//판매원 구분
		$("input[name=Bus_FLAG]").ready(function(event){
			var value = $("input[name=Bus_FLAG]:checked").val();
			Bus_FLAGToggle(value);
		});
		$("input[name=Bus_FLAG]").click(function(event){
			var value = $("input[name=Bus_FLAG]:checked").val();
			Bus_FLAGToggle(value);
		});
	});
	function Bus_FLAGToggle(value) {
		if (value == 'T') {
			$("#Bus_FLAG_toggle").css({"display":"table-row"});
		} else {
			$("#Bus_FLAG_toggle").css({"display":"none"});
		}
	}
// -->
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >회원가입 : 회원정보입력</div>

<form name="cfrm" method="post" action="joinFinish_c.asp<%=ptshop%>" onsubmit="return chkSubmit(this);">
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


	<div id="joinStep03_Zone">
		<table <%=tableatt%> class="width100">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원기본정보</th>
			</tr><!-- <tr>
				<th>국가코드</th>
				<td><strong>[<%=DKRS_nationCode%>] <%=DKRS_nationNameEn%></strong><br /><!-- <span class="">(The country code is based on ISO 3166-1 alpha-2 codes)</span></td>
			</tr> --><tr>
				<th>이름</th>
				<td><%=strName%></td>
			</tr><!-- <tr>
				<th>주민번호</th>
				<td><%=strSSH1%> - *******</td>
			</tr> --><tr>
				<th>아이디 <%=starText%></th>
				<td>
					<div style="width:57%;"><input type="text" name="strID" class="imes input_text width100" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="join_idcheck();" class="input_btn width100" value="아이디체크" /></div>
					<div id="idCheck" class="summary" style="padding-top:4px;">띄어쓰기 없는 영문,숫자 4~20자
					<input type="hidden" name="idcheck" value="F" readonly="readonly" />
					<input type="hidden" name="chkID" value="" readonly="readonly" />
					</div>
				</td>
			</tr><tr>
				<th>비밀번호 <%=starText%></th>
				<td><input type="password" name="strPass" class="input_text width95a" /><br /><span class="summary" style="padding-top:4px;">영문,숫자 6~20자</span></td>
			</tr><tr>
				<th>비밀번호확인 <%=starText%></th>
				<td><input type="password" name="strPass2" class="input_text width95a"  /></td>
			</tr>
		</table>

		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원부가정보</th>
			</tr>
			<!-- <tr>
				<th style="height:30px;"><span class="red"> 판매원 구분</span><%=starText%></th>
				<td>
					<label><input type="radio" name="Bus_FLAG" value="F" class="input_radio" checked="checked" /> 개인회원</span></label>
					<label style="margin-left:7px;"><input type="radio" name="Bus_FLAG" value="T" class="input_radio" /> 사업자회원</label>
				</td>
			</tr><tr id="Bus_FLAG_toggle" style="display:none;">
				<th></th>
				<td>
					<span class="tweight"> 사업자 명 : &nbsp;&nbsp; </span><input type="text" name="Bus_Name" class="input_text" style="width:180px;" placeholder="사업자명 " /><br />
					<span class="tweight"> 사업자번호 : </span><input type="text" name="Bus_Number" class="input_text" style="width:180px;" placeholder="사업자번호" />
				</td>
			</tr> -->
			<tr>
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
				<%If DKRSVI_WEBID = "" Then%>
				<td>
					<div style="width:57%;"><input type="text" name="voter" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width95a" value="검색"  onclick="vote_idcheck();" /></div>
				</td>
				<%Else%>
				<td><%=DKRSVI_MNAME%>(<%=DKRSVI_MBID1%>-<%=DKRSVI_MBID2%>)</td>
				<%End If%>
			</tr>
			<tr>
				<th><%=CS_SPON%> <%=starText%></th>
				<td >
					<div style="width:57%;"><input type="text" name="sponsor" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;">
					<input type="button" name="" class="input_btn width95a" value="검색"  onclick="spon_idcheck();" /></div>
				</td>
			</tr>
			<tr>
				<th>은행</th>
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
				</td>
			</tr><tr>
				<th>계좌번호</th>
				<td><input type="text" name="BankNumber" class="input_text vmiddle" style="width:180px;" /></td>
			</tr><tr>
				<th>예금주</th>
				<td><input type="text" name="bankOwner" class="input_text vmiddle" style="width:120px;" /></td>
			</tr>
		</table>

		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="95" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원 부가정보</th>
			</tr><tr>
				<th>성별 <%=starText%></th>
				<td>
					<div class="skin-grey2"><input type="radio" name="isSex" value="M"  checked="checked"/><label>남성</label></div>
					<div class="skin-grey2"><input type="radio" name="isSex" value="F" /><label>여성</label></div>
				</td>
			</tr><tr>
				<th rowspan="3">주소 <%=starText%></th>
				<td style="border-bottom:0px none;"><div style="width:57%;"><input type="text" name="strZip" id="strZipDaum" class="input_text width95a" readonly="readonly" style="background-color:#efefef;" maxlength="7" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width95a" value="우편번호입력"  onclick="execDaumPostcode('oris');" /></div></td>
			</tr><tr>
				<td style="border-bottom:0px none; padding:0px;"><input type="text" name="strADDR1" id="strADDR1Daum" class="input_text width95a" style="background-color:#efefef;" readonly="readonly" /></td>
			</tr><tr>
				<td><input type="text" name="strADDR2" id="strADDR2Daum" class="input_text width95a" /></td>
			</tr><tr>
				<th>휴대전화 <%=starText%></th>
				<td>
					<input type="tel" name="mob_num1" maxlength="5" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="mob_num2" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="mob_num3" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> />
				</td>
			</tr><tr>
				<th>전화번호</th>
				<td>
					<input type="tel" name="tel_num1" maxlength="5" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="tel_num2" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> /> -
					<input type="tel" name="tel_num3" maxlength="4" class="input_text" style="width:25%;" <%=onlyKeys%> />
				</td>
			</tr>
			<tr>
				<th>이메일 <%=starText%></th>
				<td>
					<div style="width:100%;"><input type="email" name="strEmail" class="input_text imes width95a" value=""/></div>
					<!-- <div style="width:100%;"><input type="button" name="" onclick="join_emailCheck();" class="input_btn width95a" value="<%=LNG_TEXT_DOUBLE_CHECK%>" /></div>
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
					<!-- <select name = "birthYY" class="vmiddle" style="width:60px;">
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
					<br />
					<p style="margin-top:7px;"> -->
						<div class="skin-grey2"><input type="radio" name="isSolar" value="S"  checked="checked" /><label> 양력</label></div>
						<div class="skin-grey2"><input type="radio" name="isSolar" value="M" /><label> 음력</label></div>
					<!-- </p> -->
				</td>
			</tr>
		</table>

		<div id="" class="width100" style="margin-top:10px">
			<div class="porel clear" style=" margin:0px 10px 0px 10px; overflow:hidden;">
				<!-- <div><input type="button" class="joinBtn jBtn2 fleft" style="width:49%" onclick="javascript:history.go(-1);" value="회원가입취소"/></div> -->
				<div><input type="submit" class="joinBtn jBtn1 tcenter" style="width:49%" onclick="" value="회원가입"/></div>
			</div>
		</div>

	</div>

	<script>
		$(document).ready(function(){
			$('.skin-grey2 input').each(function(){
				var self = $(this),
				label = self.next(),
				label_text = label.text();

				label.remove();
				self.iCheck({
					checkboxClass: 'icheckbox_line-grey',
					radioClass: 'iradio_line-grey',
					insert: '<div class="icheck_line-icon" ></div>' + label_text
				});
			});

		});
	</script>
</form>
<!--#include virtual = "/m/_include/copyright.asp"-->
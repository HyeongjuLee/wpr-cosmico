<!--#include virtual="/_lib/strFunc.asp" -->
<%
	PAGE_SETTING = "MEMBERSHIP"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 2
	sview = 6


	If UCase(LANG) ="KR" Then
		If Not checkRef(houUrl &"/common/joinStep03_c.asp") Then Call alerts(LNG_JOINSTEP04C_TEXT01,"go","/common/joinStep01.asp")


	Else
		If Not checkRef(houUrl &"/common/joinStep02_c.asp") Then Call alerts(LNG_JOINSTEP04C_TEXT01,"go","/common/joinStep01.asp")
	End If


	Agree01				= pRequestTF("agree01",True)
	Agree02				= pRequestTF("agree02",True)
	Agree03				= pRequestTF("agree03",True)

	ajaxTF				= pRequestTF("ajaxTF",True)

	strBankCodeCHK		= pRequestTF("strBankCodeCHK",True)
	strBankNumCHK		= pRequestTF("strBankNumCHK",True)
	strBankOwnerCHK		= pRequestTF("strBankOwnerCHK",True)
	strSSH1CHK			= pRequestTF("strSSH1CHK",True)
	strSSH2CHK			= pRequestTF("strSSH2CHK",True)
	TempDataNum			= pRequestTF("TempDataNum",True)

	strBankCode			= pRequestTF("strBankCode",True)
	strBankNum			= pRequestTF("strBankNum",True)
	strBankOwner		= pRequestTF("strBankOwner",True)
	strSSH1				= pRequestTF("strSSH1",True)
	strSSH2				= pRequestTF("strSSH2",True)

	If Agree01 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree02 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")
	If Agree03 <> "T" Then Call ALERTS("잘못된 접근입니다.","go","joinStep01.asp")

	If ajaxTF <> "T" Then Call ALERTS("본인인증을 확인하셔야합니다.","back","")


	If strBankCodeCHK	<> strBankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep01.asp")
	If strBankNumCHK	<> strBankNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep01.asp")
	If strBankOwnerCHK	<> strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep01.asp")
	If strSSH1CHK		<> strSSH1			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.4","go","joinStep01.asp")
	If strSSH2CHK		<> strSSH2			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.5","go","joinStep01.asp")



	arrParams = Array(_
		Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
		Db.makeParam("@strSSH1",adChar,adParamInput,6,strSSH1),_
		Db.makeParam("@strSSH2",adChar,adParamInput,7,strSSH2)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW",DB_PROC,arrParams,DB3)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_TempDataNum		= DKRS("TempDataNum")
		DKRS_strName			= DKRS("strName")
		DKRS_strSSH1			= DKRS("strSSH1")
		DKRS_strSSH2			= DKRS("strSSH2")
		DKRS_strCenterName		= DKRS("strCenterName")
		DKRS_strCenterCode		= DKRS("strCenterCode")
		DKRS_strBankCode		= DKRS("strBankCode")
		DKRS_strBankNum			= DKRS("strBankNum")
		DKRS_strBankOwner		= DKRS("strBankOwner")
		DKRS_strOrderNum		= DKRS("strOrderNum")
	Else
		Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
	End If
	Call closeRs(DKRS)

	If strBankCodeCHK	<> strBankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep01.asp")
	If strBankNumCHK	<> strBankNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep01.asp")
	If strBankOwnerCHK	<> strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep01.asp")
	If strSSH1CHK		<> strSSH1			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.4","go","joinStep01.asp")
	If strSSH2CHK		<> strSSH2			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.5","go","joinStep01.asp")

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


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" href="join.css" />

<script type="text/javascript" src="joinStep04_c.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->

<div id="join">
	<div class="joinInner">
		<form name="cfrm" method="post" action="joinFinish_c.asp" onsubmit="return chkSubmit(this);">
			<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
			<input type="hidden" name="dataNum" value="<%=TempDataNum%>" />
			<input type="hidden" name="agree01" value="<%=Agree01%>" />
			<input type="hidden" name="agree02" value="<%=Agree02%>" />
			<input type="hidden" name="agree03" value="<%=Agree03%>" />
			<input type="hidden" name="centerName" value="<%=DKRS_ncode%>" />
			<input type="hidden" name="centerCode" value="<%=DKRS_M_Reg_Code%>" />

			<input type="hidden" name="strBankCode" value="<%=DKRS_strBankCode%>" />
			<input type="hidden" name="strBankNum" value="<%=DKRS_strBankNum%>" />
			<input type="hidden" name="strBankOwner" value="<%=DKRS_strBankOwner%>" />

			<input type="hidden" name="NominID1" value="" readonly="readonly" />
			<input type="hidden" name="NominID2" value="" readonly="readonly" />
			<input type="hidden" name="NominWebID" value="" readonly="readonly" />
			<input type="hidden" name="NominChk" value="F" readonly="readonly" />
			<input type="hidden" name="SponID1" value="" readonly="readonly" />
			<input type="hidden" name="SponID2" value="" readonly="readonly" />
			<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
			<input type="hidden" name="SponIDChk" value="F" readonly="readonly" />

			<p class="sub_desc"><%=viewImg(IMG_JOIN&"/joinStep03_title.gif",490,70,"")%></p>
			<p style="margin-top:20px;"><%=viewImg(IMG_JOIN&"/join_into_tit_01.gif",196,33,"")%></p>
			<table <%=tableatt%> class="infoTable">
				<col width="150" />
				<col width="*" />
				<tr class="line">
					<th>이름 <%=starText%></th>
					<td>
						<input type="text" name="strName" class="input_text" maxlength="12" size="24" />
						<span class="summary">띄어쓰기 없이 적어주세요</span>
					</td>
				</tr><tr>
					<th>아이디 <%=starText%></th>
					<td>
						<input type="text" name="strID" class="input_text imes vmiddle" maxlength="20" <%=toNoKorText%> placeholder="" />
						<img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="join_idcheck_CSID()" />
						<!-- <img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="join_idcheck()" /> -->
						<span class="summary" id="idCheck">띄어쓰기 없는 영문,숫자 4~20자
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</span>
					</td>
				</tr><!-- <tr>
					<th>닉네임 <%=starText%></th>
					<td>
						<input type="text" name="NickName" class="input_text" maxlength="12" size="24" />
						<img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="닉네임 중복체크" class="cp vmiddle" onclick="join_NickCheck()" />
						<span class="summary" id="NickCheck">띄어쓰기 없이 적어주세요
							<input type="hidden" name="Nickcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkNick" value="" readonly="readonly" />
						</span>
					</td>
				</tr> --><tr>
					<th>비밀번호 <%=starText%></th>
					<td><input type="password" name="strPass" class="input_text imes" maxlength="20" size="24" /><span class="summary">영문,숫자 혼합 4~20자</span></td>
				</tr><tr>
					<th>비밀번호 확인 <%=starText%></th>
					<td><input type="password" name="strPass2" class="input_text imes" maxlength="20" size="24" /></td>
				</tr>
			</table>

			<p style="margin-top:20px;"><%=viewImg(IMG_JOIN&"/join_into_tit_02.gif",196,33,"")%></p>
			<table <%=tableatt%> class="infoTable">
				<col width="150" />
				<col width="*" />
				<tr class="line">
					<th>성별 <%=starText%></th>
					<td>
						<label><input type="radio" name="isSex" value="M" <%=isChecked(isSex,"M")%> class="input_radio" /> 남성</label>
						<label style="margin-left:7px;"><input type="radio" name="isSex" value="F" <%=isChecked(isSex,"F")%> class="input_radio" /> 여성</label>
					</td>
				</tr><tr>
					<th>생일 <%=starText%></th>
					<td>
						<!-- <input type="text" name="birthYY" class="input_text" maxlength="4" style="width:55px;"  value="<%=birthYYYY%>" /> 년
						<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:40px;" value="<%=birthMM%>" /> 월
						<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:40px;" value="<%=birthDD%>" /> 일 -->
						<select name = "birthYY" class="vmiddle" style="width:60px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR2%>
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
						<input type="text" class="input_text" name="strzip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" />
						<img src="<%=IMG_JOIN%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" />
						<input type="text" class="input_text" name="straddr1" style="width:280px;background-color:#f4f4f4;" readonly="readonly" />
					</td>
				</tr><tr>
					<th>상세주소 <%=starText%></th>
					<td><input type="text" class="input_text" name="straddr2" style="width:480px;" /></td>
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
							<option value="yahoo.co.kr">yahoo.co.kr</option>
							<option value="gmail.com">gmail.com</option>
						</select>
						<p style="margin-top:10px;"><span class="summary">* ID/패스워드 분실시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span></p>
					</td>
				</tr><!-- <tr>
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
				<tr>
					<th>추천인 / 후원인 <%=starText%></th>
					<td>
						<input type="text" name="voter" class="input_text" maxlength="12"  style="background-color:#f4f4f4;width:110px;" readonly="readonly" />
						<input type="text" name="sponsor" class="input_text" maxlength="20"  style="background-color:#f4f4f4;width:130px;" readonly="readonly" />
						<img src="<%=IMG_JOIN%>/voter_sponsor_check.gif" width="102" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="vote_idcheck2()" />
						<span class="summary">* 추천인 선택후, 후원인 선택(라인선택)</span>
						<input type="hidden" size ="1" name="sponLine" value="" readonly="readonly" />
					</td>
				</tr>
				<!-- <tr>
					<th>추천인 <%=starText%></th>
					<td colspan="3">
						<input type="text" name="voter" class="input_text" maxlength="12" size="24" style="background-color:#f4f4f4;" readonly="readonly" onclick="vote_idcheck2()" />
						<img src="<%=IMG_JOIN%>/voter_check2.gif" width="68" height="20" alt="추천인 체크" class="cp vmiddle" onclick="vote_idcheck2()" />
						<span class="summary">추천인 회원번호, 이름 입력</span>
						<img src="<%=IMG_JOIN%>/voter_check2.gif" width="8" height="10" alt="추천인 체크" class="cp vmiddle" onclick="vote_idcheckN()" />
					</td>
				</tr><tr>
					<th>후원인 <%=starText%></th>
					<td colspan="3">
						<input type="text" name="sponsor" class="input_text" maxlength="12" size="24" style="background-color:#f4f4f4;" readonly="readonly" onclick="spon_idcheck3()" />
						<img src="<%=IMG_JOIN%>/sponsor_check.gif" width="68" height="20" alt="후원인 체크" class="cp vmiddle" onclick="spon_idcheck3()" />
						<span class="summary">후원인 회원번호, 이름 입력, 후원 라인선택 (좌,우)</span>
						<input type="hidden " size ="1" name="sponLine" value="" readonly="readonly" />
					</td>
				</tr> -->
				<tr>
					<th>은행정보</td>
					<td>[<%=Fnc_bankname(DKRS_strBankCode)%>] <%=DKRS_strBankNum%></td>
				</tr><tr>
					<th>예금주</td>
					<td><%=DKRS_strBankOwner%></td>
				</tr>
			</table>
			<div class="tcenter" style="margin-top:40px;"><input type="image" src="<%=IMG_JOIN%>/joinStep_btn_go.jpg" /><a href="javascript:history.back();"><img src="<%=IMG_JOIN%>/joinStep_btn_back.jpg" alt="" style="margin-left:6px;" /></div>
		</form>

	</div>
</div>
<!--#include virtual="/_include/copyright.asp" -->

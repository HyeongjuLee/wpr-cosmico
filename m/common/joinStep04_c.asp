<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"


'	If getUserIP() <> "112.154.152.238" Then Call ALERTS("회원가입 수정중입니다.","go","/index.asp")

	agreement			= pRequestTF("agreement",True)


	If agreement <> "T" Then Call ALERTS("가입약관에 동의하지 않으셨습니다.","BACK","")

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


	If ajaxTF <> "T" Then Call ALERTS("본인인증을 확인하셔야합니다.","back","")

	If strBankCodeCHK	<> strBankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.1","go","joinStep_01.asp")
	If strBankNumCHK	<> strBankNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.2","go","joinStep_01.asp")
	If strBankOwnerCHK	<> strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.3","go","joinStep_01.asp")
	If strSSH1CHK		<> strSSH1			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.4","go","joinStep_01.asp")
	If strSSH2CHK		<> strSSH2			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.5","go","joinStep_01.asp")

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
		DKRS_strCenterName		= DKRS("strCenterName")		'센터 ncode
		DKRS_strCenterCode		= DKRS("strCenterCode")
		DKRS_strBankCode		= DKRS("strBankCode")
		DKRS_strBankNum			= DKRS("strBankNum")
		DKRS_strBankOwner		= DKRS("strBankOwner")
		DKRS_strOrderNum		= DKRS("strOrderNum")
	Else
		Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요.","BACK","")
	End If
	Call closeRs(DKRS)

	If DKRS_strBankCode		<>	strBankCode			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","go","joinStep01.asp")
	If DKRS_strBankNum		<>	strBankNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","go","joinStep01.asp")
	If DKRS_strBankOwner	<>	strBankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","go","joinStep01.asp")
	If DKRS_strSSH1			<>	strSSH1				Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.9","go","joinStep01.asp")
	If DKRS_strSSH2			<>	strSSH2				Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.10","go","joinStep01.asp")
	If DKRS_TempDataNum		<>	TempDataNum			Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","go","joinStep01.asp")


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

	If isSex = "M" Then viewSex = "남성" Else viewSex = "여성" End If



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="joinStep04_c.js"></script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script type="text/javascript" src="/m/js/check.js"></script>
<script src="/m/js/icheck/icheck.min.js"></script>
<script>
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >회원가입 : 회원정보입력</div>

<form name="cfrm" method="post" action="joinFinish_c.asp">
	<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
	<input type="hidden" name="dataNum" value="<%=TempDataNum%>" />
	<input type="hidden" name="agreement" value="<%=agreement%>" />


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


	<input type="hidden" name="isSex" value="<%=isSex%>" />
	<input type="hidden" readonly="readonly" id="isSolar" name="isSolar" value="S" />

	<div id="joinStep03_Zone">

		<table <%=tableatt%> class="width100">
			<col width="85" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">사업자회원정보</th>
			</tr><tr>
				<th>이름</th>
				<td><%=DKRS_strName%> (<%=viewSex%>)</td>
			</tr><tr>
				<th>주민번호</th>
				<td><%=DKRS_strSSH1%> - *******</td>
			</tr><tr>
				<th>생년월일</th>
				<td>
					<input type="text" name="birthYY" class="input_text" maxlength="4" style="width:30%;" value="<%=birthYYYY%>" placeholder="<%=birthYYYY%>" />년
					<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:20%;" value="<%=birthMM%>" placeholder="<%=birthMM%>" />월
					<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:20%;" value="<%=birthDD%>" placeholder="<%=birthDD%>" />일
				</td>
			</tr><tr>
				<th>은행정보</td>
				<td>[<%=Fnc_bankname(DKRS_strBankCode)%>] <%=DKRS_strBankNum%></td>
			</tr><tr>
				<th>예금주</td>
				<td><%=DKRS_strBankOwner%></td>
			</tr>
		</table>


		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="85" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">회원필수정보</th>
			</tr><tr>
				<th>아이디</th>
				<td>
					<div style="width:57%;"><input type="text" name="strID" class="imes input_text width100" onkeyup="this.value=this.value.replace(/[^a-zA-Z0-9]/g,'');" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" onclick="join_idcheck_CSID();" class="input_btn width100" value="아이디체크" /></div>
					<div id="idCheck"class="summary" style="padding-top:4px;">띄어쓰기 없는 영문,숫자 4~20자
					<input type="hidden" name="idcheck" value="F" readonly="readonly" />
					<input type="hidden" name="chkID" value="" readonly="readonly" />
					</div>
				</td>
			</tr><tr>
				<th>비밀번호</th>
				<td><input type="password" name="strPass" class="input_text" style="width:100%" /></td>
			</tr><tr>
				<th>비밀번호확인</th>
				<td><input type="password" name="strPass2" class="input_text" style="width:100%" /></td>
			</tr><tr>
				<th>휴대전화</th>
				<td>
					<input type="tel" name="mob_num1" maxlength="5" class="input_text" style="width:25%;" /> -
					<input type="tel" name="mob_num2" maxlength="4" class="input_text" style="width:25%;" /> -
					<input type="tel" name="mob_num3" maxlength="4" class="input_text" style="width:25%;" />
				</td>
			</tr><tr>
				<th>전화번호</th>
				<td>
					<input type="tel" name="tel_num1" maxlength="5" class="input_text" style="width:25%;" /> -
					<input type="tel" name="tel_num2" maxlength="4" class="input_text" style="width:25%;" /> -
					<input type="tel" name="tel_num3" maxlength="4" class="input_text" style="width:25%;" />
				</td>
			</tr><tr>
				<th>이메일</th>
				<td><input type="email" name="strEmail" class="input_text width100" /></td>
			</tr><tr>
				<th rowspan="3">주소</th>
				<td style="border-bottom:0px none;"><div style="width:57%;"><input type="text" name="strZip" class="input_text width100" readonly="readonly" style="background-color:#efefef;" maxlength="7" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width100" value="우편번호입력"  onclick="openzip();" /></td>
			</tr><tr>
				<td style="border-bottom:0px none; padding:0px;"><input type="text" name="strADDR1" class="input_text width100" style="background-color:#efefef;" readonly="readonly" /></td>
			</tr><tr>
				<td><input type="text" name="strADDR2" class="input_text width100" /></td>
			</tr>
		</table>

		<table <%=tableatt%> class="width100" style="margin-top:25px;">
			<col width="85" />
			<col width="*" />
			<tr>
				<th colspan="2" style="background-color:#ececec;padding:7px 0px; text-indent:7px;">추천/후원정보</th>
			</tr>
			<tr>
				<th  rowspan="2">추천인<br />/후원인 <%=starText%></th>
				<td >
					<div style="width:57%;"><input type="text" name="voter" class="input_text width100" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width100" value="추천인/후원인 검색"  onclick="vote_idcheck2();" /></div>
				</td>
			</tr><tr>
				<!-- <th>후원인 <%=starText%></th> -->
				<td >
					<div style="width:100%;"><input type="text" name="sponsor" class="input_text width100" readonly="readonly" style="background-color:#efefef;" /></div>
					<input type="hidden" size ="1" name="sponLine" value="" readonly="readonly" />
					<div class="summary" style="padding-top:4px;">추천인 선택후, 후원인 선택(라인선택)</div>

				</td>
			</tr>
			<!-- <tr>
				<th>추천인 <%=starText%></th>
				<td >
					<div style="width:57%;"><input type="text" name="voter" class="input_text width100" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width100" value="추천인검색"  onclick="vote_idcheck2();" /></div>

					<div class="summary" style="padding-top:4px;">추천인 회원번호, 이름 입력</div>
				</td>
			</tr><tr>
				<th>후원인 <%=starText%></th>
				<td >
					<div style="width:57%;"><input type="text" name="sponsor" class="input_text width100" readonly="readonly" style="background-color:#efefef;" /></div><div class="tcenter" style="width:3%;"></div><div style="width:40%;"><input type="button" name="" class="input_btn width100" value="후원인검색"  onclick="spon_idcheck3();" /></div>
					<input type="hidden " size ="1" name="sponLine" value="" readonly="readonly" />
					<div class="summary" style="padding-top:4px;">후원인 회원번호, 이름 입력, 후원 라인선택 (좌,우)</div>

				</td>
			</tr> -->
		</table>






		<div class="joinBtn jBtn1 tcenter" style=""><a href="javascript:chkSubmit();">회원가입</a></div>
	</div>

</form>
<!--#include virtual = "/m/_include/copyright.asp"-->
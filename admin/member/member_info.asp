<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER1-1"
' ===================================================================
'
' ===================================================================
' ===================================================================
	strUserID = Request("mid")


	'SQL = "SELECT * FROM DK_MEMBER A,DK_MEMBER_FINANCIAL B WHERE a.STRUSERID = b.STRUSERID AND a.strUserID = ?"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
	)
	Set DKRS = Db.execRs("DKPA_MEMBER_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_intIDX		= DKRS("intIDX")

		RS_DOMAIN		= DKRS("MotherSite")
		RS_REGISTDATE	= DKRS("dateRegist")
		RS_ID			= DKRS("strUserID")
		RS_NAME			= DKRS("strName")
		RS_PASS			= DKRS("strPass")
		RS_ZIP			= DKRS("strZip")
		RS_ADDR1		= DKRS("strADDR1")
		RS_ADDR2		= DKRS("strADDR2")
		RS_TEL			= DKRS("strTel")
		RS_MOBILE		= DKRS("strMobile")

		RS_MAIL			= DKRS("strEmail")
		RS_SMS			= DKRS("isSMS")
		RS_MAILING		= DKRS("isMailing")
		RS_VISIT		= DKRS("INTVISIT")

		RS_BIRTH		= DKRS("strBirth")
		RS_SOLAR		= DKRS("strSolar")

		RS_STATE		= DKRS("STRSTATE")
		RS_LEVEL		= DKRS("intMemLevel")
		'RS_LEVEL_BEFORE	= DKRS("intMemLevel_Before")		'전레벨(직급)

		RS_MEMBER_TYPE	= DKRS("memberType")


		RS_LEAVECAUSE		= DKRS("leaveCause")
		RS_LEAVEDATE1		= DKRS("leaveDate1")
		RS_LEAVEDATE2		= DKRS("leaveDate2")


		RS_strNickName		= DKRS("strNickName")
		RS_SAdminSite		= DKRS("SAdminSite")
		RS_isIDImg			= DKRS("isIDImg")
		RS_strImg			= DKRS("imgPath")

	'	RS_strJob			= DKRS("strJob")
	'	RS_strIntroduce		= DKRS("strIntroduce")
	'	RS_N_Name			= DKRS("N_Name")
	'	RS_N_WebID			= DKRS("N_WebID")
	'	RS_N_Mobile			= DKRS("N_Mobile")
	'	RS_strCenterCode	= DKRS("strCenterCode")
	'	RS_strForumCode		= DKRS("strForumCode")

		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If RS_ADDR1			<> "" Then RS_ADDR1		= objEncrypter.Decrypt(RS_ADDR1)
					If RS_ADDR2			<> "" Then RS_ADDR2		= objEncrypter.Decrypt(RS_ADDR2)
					If RS_TEL			<> "" Then RS_TEL		= objEncrypter.Decrypt(RS_TEL)
					If RS_MOBILE		<> "" Then RS_MOBILE	= objEncrypter.Decrypt(RS_MOBILE)
					If RS_PASS			<> "" Then RS_PASS		= objEncrypter.Decrypt(RS_PASS)

					If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
						If RS_MAIL		<> "" Then RS_MAIL		= objEncrypter.Decrypt(RS_MAIL)
					End If
				On Error GoTo 0
			Set objEncrypter = Nothing
		End If

		'변경
'		If RS_TEL = "" Or IsNull(RS_TEL) Then RS_TEL = "--"
'			arrTEL = Split(RS_TEL,"-")
'		If RS_MOBILE = "" Or IsNull(RS_MOBILE) Then RS_MOBILE = "--"
'			arrMob = Split(RS_MOBILE,"-")

		If RS_TEL <> "" Then RS_TEL = Replace(RS_TEL,"-","")
		If RS_MOBILE <> "" Then RS_MOBILE = Replace(RS_MOBILE,"-","")

		If RS_MAIL = "" Or IsNull(RS_MAIL) Then RS_MAIL = "@"
			arrMAIL = Split(RS_MAIL,"@")
		If RS_BIRTH = "" Or IsNull(RS_BIRTH) Then RS_BIRTH = "--"
			arrBIRTH = Split(RS_BIRTH,"-")

		SQL = "SELECT COUNT(*) FROM DK_MEMBER_ADMIN_MEMO WHERE STRUSERID = ?"
		arrParam = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
		)
		ADMIN_MEMO = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

	Else
		Call ALERTS("회원정보가 로드되지 못했습니다.","back","")
	End If
	Call closeRS(DKRS)


	If RS_VOTERID = "" Or IsNull(RS_VOTERID) Then
		RS_VOTERID = "가입시 추천한 회원이 없습니다."
	Else
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,RS_VOTERID) _
		)
		Set DKRS = Db.execRs("DKPA_MEMBER_VOTER",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			RS_VOTER_STATE = DKRS("strState")

			RS_VOTER_RESULT = "님은 현재 "& CallMemState(RS_VOTER_STATE) &" 상태의 회원입니다."

		Else
			RS_VOTER_RESULT = "데이터가 없음. (가입시 추천인을 입력하였으니 해당 추천인이 탈퇴를 한 상태입니다.)"
		End If
	End If


	If RS_N_WebID <> "" Then NominChk = "T"

%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/member.js?v0"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_modify">
	<!-- <form name="cfrm" method="post" action="member_infoOk.asp" enctype="multipart/form-data">	 -->
	<form name="cfrm" method="post" action="">
		<input type="hidden" name="strUserID" value="<%=RS_ID%>" />
		<input type="hidden" name="mode" value="MODIFY" />

		<table <%=tableatt%> style="width:1000px;">
			<colgroup>
				<col width="130" />
				<col width="215" />
				<col width="130" />
				<col width="215" />
			</colgroup>
			<tbody>
				<tr class="line">
					<th colspan="4" class="th">회원 기본정보</th>
				</tr><tr class="line">
					<th>가입도메인</th>
					<td><%=RS_DOMAIN%></td>
					<th>가입일</th>
					<td><%=RS_REGISTDATE%></td>
				</tr><tr>
					<th>아이디</th>
					<td colspan="3"><%=RS_ID%></td>
					<!-- <th>별명</th>
					<td><%=RS_strNickName%></td> -->
				</tr><tr>
					<th>이름 <%=starText%></th>
					<td><input type="text" name="strName" class="input_text" style="width:160px;" value="<%=RS_NAME%>" /></td>
					<th>비밀번호 <%=starText%></td>
					<td><input type="password" name="strPass" class="input_text" maxlength="20" value="<%=RS_PASS%>" /></td>
				</tr><tr class="line">
					<th colspan="4" class="th">회원 일반정보</th>
				</tr><tr class="line">
					<th>주소 </th>
					<td colspan="3">
						<input type="text" class="input_text" name="strzip" id="strZipDaum"  style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_ZIP%>" />
						<input type="button" class="txtBtn j_medium" onclick="execDaumPostcode('oris');" value="<%=LNG_TEXT_ZIPCODE%>" />
						<input type="text" class="input_text" name="straddr1" id="strADDR1Daum" style="width:390px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_ADDR1%>" />
					</td>
				</tr><tr>
					<th>상세주소 </th>
					<td colspan="3"><input type="text" class="input_text" name="straddr2" id="strADDR2Daum" style="width:550px;" value="<%=RS_ADDR2%>" /></td>
				</tr><tr>
					<th>전화번호</th>
					<td colspan="3">
						<input type="text" class="input_text" name="strTel" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=RS_TEL%>" />
					</td>
				</tr><tr>
					<th>휴대폰번호 </th>
					<td colspan="3">
						<input type="text" class="input_text" name="strMobile" style="width:150px;" maxlength="15" <%=onLyKeys%> value="<%=RS_MOBILE%>" />
						<span class="summary">* 비상연락 시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
				</tr><!-- <tr>
					<th>SMS 수신여부 <%=starText%></th>
					<td colspan="3">
						<p style="padding-bottom:3px;">이벤트와 쇼핑에 대한 정보를 SMS로 받아보시겠습니까?</p>
						<label><input type="radio" name="sendsms" value="T" class="input_chk" <%=isChecked(RS_SMS,"T")%> /> 예</label>
						<label><input type="radio" name="sendsms" value="F" class="input_chk" <%=isChecked(RS_SMS,"F")%> style="margin-left:10px;" />아니오</label>
						<span class="summary">* SMS수신여부와는 별도로 회사주요정책변경등의 메시지등은 발송됩니다.</span>
					</td>
				</tr> --><tr>
					<th>이메일 </th>
					<td colspan="3">
						<input type="text" name="mailh" class="input_text imes" maxlength="512" style="width:102px;" value="<%=arrMAIL(0)%>" /> @
						<input type="text" name="mailt" class="input_text imes" maxlength="512" style="width:120px;" value="<%=arrMAIL(1)%>" />
						<select name="mails" onchange="javascript:document.cfrm.mailt.value = document.cfrm.mails.value;" class="vmiddle">
							<option value="" <%=isSelect(arrMAIL(1),"")%>>직접입력</option>
							<option value="chollian.net"		<%=isSelect(arrMAIL(1),"chollian.net")%>>chollian.net</option>
							<option value="daum.net"			<%=isSelect(arrMAIL(1),"daum.net")%>>daum.net</option>
							<option value="dreamwiz.com"		<%=isSelect(arrMAIL(1),"dreamwiz.com")%>>dreamwiz.com</option>
							<option value="freechal.com"		<%=isSelect(arrMAIL(1),"freechal.com")%>>freechal.com</option>
							<option value="empal.com"			<%=isSelect(arrMAIL(1),"empal.com")%>>empal.com</option>
							<option value="hanafos.com"			<%=isSelect(arrMAIL(1),"hanafos.com")%>>hanafos.com</option>
							<option value="hanmail.net"			<%=isSelect(arrMAIL(1),"hanmail.net")%>>hanmail.net</option>
							<option value="hanmir.com"			<%=isSelect(arrMAIL(1),"hanmir.com")%>>hanmir.com</option>
							<option value="hitel.net"			<%=isSelect(arrMAIL(1),"hitel.net")%>>hitel.net</option>
							<option value="hotmail.com"			<%=isSelect(arrMAIL(1),"hotmail.com")%>>hotmail.com</option>
							<option value="korea.com"			<%=isSelect(arrMAIL(1),"korea.com")%>>korea.com</option>
							<option value="kornet.net"			<%=isSelect(arrMAIL(1),"kornet.net")%>>kornet.net</option>
							<option value="lycos.co.kr"			<%=isSelect(arrMAIL(1),"lycos.co.kr")%>>lycos.co.kr</option>
							<option value="nate.com"			<%=isSelect(arrMAIL(1),"nate.com")%>>nate.com</option>
							<option value="naver.com"			<%=isSelect(arrMAIL(1),"naver.com")%>>naver.com</option>
							<option value="netian.com"			<%=isSelect(arrMAIL(1),"netian.com")%>>netian.com</option>
							<option value="nownuri.net"			<%=isSelect(arrMAIL(1),"nownuri.net")%>>nownuri.net</option>
							<option value="paran.com"			<%=isSelect(arrMAIL(1),"paran.com")%>>paran.com</option>
							<option value="unitel.co.kr"		<%=isSelect(arrMAIL(1),"unitel.co.kr")%>>unitel.co.kr</option>
							<option value="yahoo.co.kr"			<%=isSelect(arrMAIL(1),"yahoo.co.kr")%>>yahoo.co.kr</option>
							<option value="gmail.com"			<%=isSelect(arrMAIL(1),"gmail.com")%>>gmail.com</option>
						</select>
					</td>
				</tr><!-- <tr>
					<th>이메일 수신 여부 <%=starText%></th>
					<td colspan="3">
						<p><%=DKCONF_SITE_TITLE%>(은)는 이메일 특가상품 등 다양한 이벤트를 실시하고 있습니다.</p>
						<p style="padding-bottom:3px;">이벤트와 쇼핑에 대한 정보를 이메일로 받아보시겠습니까?</p>
						<label><input type="radio" name="sendemail" value="T" class="input_chk" <%=isChecked(RS_MAILING,"T")%> /> 예</label>
						<label><input type="radio" name="sendemail" value="F" class="input_chk" <%=isChecked(RS_MAILING,"F")%> style="margin-left:10px;" />아니오</label>
						<span class="summary">* SMS수신여부와는 별도로 회사주요정책변경등의 메시지등은 발송됩니다.</span>
					</td>
				</tr> --><tr>
					<th>생년월일 <%=starText%></th>
					<td colspan="3">
						<!-- <input type="text" name="birthYY" class="input_text" maxlength="4" style="width:55px;" value="<%=arrBIRTH(0)%>" <%=onlyKeys%> /> 년
						<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(1)%>" <%=onlyKeys%> /> 월
						<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(2)%>" <%=onlyKeys%> /> 일 -->
						<select name = "birthYY" class="vmiddle input_text" style="width:60px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" <%=isSelect(i,arrBIRTH(0))%>><%=i%></option>
							<%Next%>
						</select> 년
						<select name = "birthMM" class="vmiddle input_text" style="width:45px;">
							<option value=""></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" <%=isSelect(jsmm,arrBIRTH(1))%>><%=jsmm%></option>
							<%Next%>
						</select> 월
						<select name = "birthDD" class="vmiddle input_text" style="width:45px;">
							<option value=""></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>"<%=isSelect(ksdd,arrBIRTH(2))%>><%=ksdd%></option>
							<%Next%>
						</select> 일
						<label style="margin-left:20px;"><input type="radio" name="isSolar" value="S" class="input_chk" <%=isChecked(RS_SOLAR,"S")%> />양력</label>
						<label><input type="radio" name="isSolar" value="M" class="input_chk" <%=isChecked(RS_SOLAR,"M")%>  />음력</label>
					</td>
				</tr>



				<tr class="line">
					<th colspan="4" class="th">회원 상태정보</th>
				</tr><tr class="line">
					<th>회원상태</th>
					<td colspan="3"><%=CallMemState(RS_STATE)%></td>
				</tr><tr>
					<th>회원타입</th>
					<td>
						<select name="memberType" class="vmiddle" onchange="chgMemType(this.value)">
							<!-- <option value="MEMBER" <%=isSelect("MEMBER",RS_MEMBER_TYPE)%>>일반회원</option>
							<option value="SADMIN" <%=isSelect("SADMIN",RS_MEMBER_TYPE)%>>지점관리자</option>
							<option value="OPERATOR" <%=isSelect("OPERATOR",RS_MEMBER_TYPE)%>>오퍼레이터</option> -->
							<option value="ADMIN" <%=isSelect("ADMIN",RS_MEMBER_TYPE)%>>관리자</option>
						</select>
					</td>
					<th>회원레벨</th>
					<td>
						<select name="intMemLevel" class="vmiddle">
							<%
								'For z = 1 To 10
								For z = RS_LEVEL To RS_LEVEL
							%>
							<option value="<%=z%>" <%=isSelect(z,RS_LEVEL)%>><%=z%></option>
							<%
								Next
							%>
						</select>
						레벨 회원입니다.
					</td>
				</tr><!-- <tr>
					<th>관리자메모</th>
					<td><strong><%=ADMIN_MEMO%></strong> 건의 메모가 있습니다. <%=aImgSt("javascript:openMemo('"&RS_ID&"');",IMG_ICON&"/icon_memo.gif",16,16,"","","vmiddle")%></td>
					<th>로그인 횟수</th>
					<td><strong><%=RS_VISIT%></strong>번</td>
				</tr> -->

				<%If RS_STATE = "443" Or RS_STATE = "444" Or RS_STATE = "445" Then%>
					<tr class="line">
						<th colspan="4" class="th">탈퇴정보</th>
					</tr><tr class="line">
						<th>탈퇴요청일</th>
						<td><%=RS_LEAVEDATE1%></td>
						<th>탈퇴승인일</th>
						<td><%=RS_LEAVEDATE2%></td>
					</tr>
				<%End If%>
			</tbody>
		</table>
	</form>
</div>
<%
	LEAVE_BTN1 = ""
	LEAVE_BTN2 = ""
	BACK_LINKS = ""
	Select Case RS_STATE
		Case "101"
		''	LEAVE_BTN1 = viewImgStJS(IMG_BTN&"/btn_rect_member_leave.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""submitChkA();""")
			BACK_LINKS = "member_list.asp"
		Case "443"
			LEAVE_BTN1 = viewImgStJS(IMG_BTN&"/btn_rect_member_leaveC.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""submitChkB();""")
			LEAVE_BTN2 = viewImgStJS(IMG_BTN&"/btn_rect_member_leaveOk.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""submitChkL();""")
			BACK_LINKS = "member_list443.asp"
		Case "444"
			LEAVE_BTN1 = viewImgStJS(IMG_BTN&"/btn_rect_member_leaveC.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""submitChkB();""")
			BACK_LINKS = "member_list444.asp"
		Case "445"
			LEAVE_BTN1 = viewImgStJS(IMG_BTN&"/btn_rect_member_leaveC.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""submitChkB();""")
			BACK_LINKS = "member_list445.asp"
		Case Else
			LEAVE_BTN1 = ""
			BACK_LINKS = "member_list.asp"
	End Select

%>
<div class="btn_area p100">
	<input type="button" class="input_submit_b design1" value="수 정" onclick="submitChk();" />
	<input type="button" class="input_submit_b design2" value="목 록" onclick="location.href='<%=BACK_LINKS%>';" />
</div>
<!-- <div class="btn_area p100"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChk();""")%><%=aImgSt(BACK_LINKS,IMG_BTN&"/btn_rect_list.gif",99,45,"","margin:20px 0px 0px 10px;","")%><%=LEAVE_BTN1%><%=LEAVE_BTN2%></div> -->
<!--#include virtual = "/admin/_inc/copyright.asp"-->




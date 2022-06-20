<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER3-1"


	mbid  = Request("mid")
	mbid2 = Request("mid2")

	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,mbid2) _
	)
	Set DKRS = Db.execRs("DKPA_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_mbid				= DKRS("mbid")
		RS_mbid2			= DKRS("mbid2")
		RS_M_Name			= DKRS("M_Name")
		RS_E_name			= DKRS("E_name")
		RS_Email			= DKRS("Email")
		RS_cpno				= DKRS("cpno")
		RS_Addcode1			= DKRS("Addcode1")
		RS_Address1			= DKRS("Address1")
		RS_Address2			= DKRS("Address2")
		RS_Address3			= DKRS("Address3")
		RS_reqtel			= DKRS("reqtel")
		RS_officetel		= DKRS("officetel")
		RS_hometel			= DKRS("hometel")
		RS_hptel			= DKRS("hptel")
		RS_LineCnt			= DKRS("LineCnt")
		RS_N_LineCnt		= DKRS("N_LineCnt")
		RS_Recordid			= DKRS("Recordid")
		RS_Recordtime		= DKRS("Recordtime")
		RS_businesscode		= DKRS("businesscode")
		RS_bankcode			= DKRS("bankcode")
		RS_banklocal		= DKRS("banklocal")
		RS_bankaccnt		= DKRS("bankaccnt")
		RS_bankowner		= DKRS("bankowner")
		RS_Regtime			= DKRS("Regtime")
		RS_Saveid			= DKRS("Saveid")
		RS_Saveid2			= DKRS("Saveid2")
		RS_Nominid			= DKRS("Nominid")
		RS_Nominid2			= DKRS("Nominid2")
		RS_RegDocument		= DKRS("RegDocument")
		RS_CpnoDocument		= DKRS("CpnoDocument")
		RS_BankDocument		= DKRS("BankDocument")
		RS_Remarks			= DKRS("Remarks")
		RS_LeaveCheck		= DKRS("LeaveCheck")
		RS_LineUserCheck	= DKRS("LineUserCheck")
		RS_LeaveDate		= DKRS("LeaveDate")
		RS_LineUserDate		= DKRS("LineUserDate")
		RS_LeaveReason		= DKRS("LeaveReason")
		RS_LineDelReason	= DKRS("LineDelReason")
		RS_WebID			= DKRS("WebID")
		RS_WebPassWord		= DKRS("WebPassWord")
		RS_BirthDay			= DKRS("BirthDay")
		RS_BirthDayTF		= DKRS("BirthDayTF")
		RS_Ed_Date			= DKRS("Ed_Date")
		RS_Ed_TF			= DKRS("Ed_TF")
		RS_PayStop_Date		= DKRS("PayStop_Date")
		RS_PayStop_TF		= DKRS("PayStop_TF")
		RS_For_Kind_TF		= DKRS("For_Kind_TF")
		RS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		RS_CurGrade			= DKRS("CurGrade")
		RS_Max_CurGrade		= DKRS("Max_CurGrade")

		RS_Grade_Cnt		= DKRS(50)
		RS_Grade_Name		= DKRS(51)
		RS_Center_Name		= DKRS(52)


		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If RS_Address1	<> "" Then RS_Address1	= objEncrypter.Decrypt(RS_Address1)
				If RS_Address2	<> "" Then RS_Address2	= objEncrypter.Decrypt(RS_Address2)
				If RS_hometel	<> "" Then RS_hometel	= objEncrypter.Decrypt(RS_hometel)
				If RS_hptel		<> "" Then RS_hptel		= objEncrypter.Decrypt(RS_hptel)
				If RS_bankaccnt	<> "" Then RS_bankaccnt	= objEncrypter.Decrypt(RS_bankaccnt)
			Set objEncrypter = Nothing
		End If

		'변경
		If RS_hometel = "" Or IsNull(RS_hometel) Then RS_hometel = "--"
			arrTEL = Split(RS_hometel,"-")
		If RS_hptel = "" Or IsNull(RS_hptel) Then RS_hptel = "--"
			arrMob = Split(RS_hptel,"-")
		If RS_Email = "" Or IsNull(RS_Email) Then RS_Email = "@"
			arrMAIL = Split(RS_Email,"@")
		'If RS_BirthDay = "" Or IsNull(RS_BirthDay) Then RS_BirthDay = "--"
		'	arrBIRTH = Split(RS_BirthDay,"-")

		If RS_LeaveCheck = 1 Then
			LeaveStatus = "활동"
			LEAVE_TEXT = ""
		ElseIf RS_LeaveCheck = 0 Then
			LeaveStatus = "<span class=""red"">탈퇴</span>"
			LEAVE_TEXT = "<span class=""red""> (탈퇴)</span>"
		End If

		If RS_Sell_Mem_TF = 0 Then
			Sell_Mem_TF = "판매원"
		ElseIf RS_LeaveCheck = 1 Then
			Sell_Mem_TF = "소비자"
		End If

		If RS_WebID = "" Then RS_WebID = "--"

	Else
		Call ALERTS("회원정보가 로드되지 못했습니다.","back","")
	End If
	Call closeRS(DKRS)

%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/cs_member.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_modify">
	<!-- <form name="cfrm" method="post" action="member_infoOk.asp" enctype="multipart/form-data">	 -->
	<form name="cfrm" method="post" action="">
	<input type="hidden" name="mbid" value="<%=RS_mbid%>" readonly="readonly"/>
	<input type="hidden" name="mbid2" value="<%=RS_mbid2%>" readonly="readonly"/>
	<input type="hidden" name="strPass" value="<%=RS_WebPassWord%>" readonly="readonly"/>
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
				<th>회원 고유 번호</th>
				<td><%=RS_mbid%> - <%=Fn_MBID2(RS_mbid2)%></td>
				<th>가입일</th>
				<td><%=date8to10(RS_Regtime)%></td>
			</tr><tr>
				<th>이름</th>
				<td><%=RS_M_Name%><%=LEAVE_TEXT%></td>
				<th>주민등록번호</th>
				<td><%=cutSSH(RS_cpno,"del")%></td>
			</tr><tr>
				<th>웹아이디</th>
				<td><%=RS_WebID%></td>
				<th>센타명</td>
				<td><%=RS_Center_Name%></td>
				<!-- <th>비밀번호(수정)</td>
				<td><%=RS_WebPassWord%></td> -->
				<!-- <td><input type="password" name="strPass" class="input_text" maxlength="20" value="<%=RS_WebPassWord%>" /></td> -->
			</tr><tr>
				<th>계좌정보</th>
				<td colspan="3">
					<%
						SQL = "SELECT [bankName] FROM [tbl_Bank] WHERE [ncode] = ?"
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,10,RS_bankcode) _
						)
						RS_bankName = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
					%>
					[<%=RS_bankName%>] <%=RS_bankaccnt%> [예금주] : <%=RS_bankowner%>
				</td>
			</tr>
			<tr class="line">
				<th colspan="4" class="th">회원 일반정보</th>
			</tr><tr class="line">
				<th>주소 <%=starText%></th>
				<td colspan="3">
					<input type="text" class="input_text" name="strzip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=cutZip(RS_addcode1)%>" />
					<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" />
					<input type="text" class="input_text" name="straddr1" style="width:390px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_Address1%>" />
				</td>
			</tr><tr>
				<th>상세주소 <%=starText%></th>
				<td colspan="3"><input type="text" class="input_text" name="straddr2" style="width:550px;" value="<%=RS_Address2%>" /></td>
			</tr><tr>
				<th>전화번호</th>
				<td colspan="3">
					<select name="tel_num1" style="width:55px;" class="vmiddle">
						<option value=""		<%=isSelect(arrTEL(0),"")%>>선택</option>
						<option value="02"		<%=isSelect(arrTEL(0),"02")%>>02</option>
						<option value="0303"	<%=isSelect(arrTEL(0),"0303")%>>0303</option>
						<option value="031"		<%=isSelect(arrTEL(0),"031")%>>031</option>
						<option value="032"		<%=isSelect(arrTEL(0),"032")%>>032</option>
						<option value="033"		<%=isSelect(arrTEL(0),"033")%>>033</option>
						<option value="041"		<%=isSelect(arrTEL(0),"041")%>>041</option>
						<option value="042"		<%=isSelect(arrTEL(0),"042")%>>042</option>
						<option value="043"		<%=isSelect(arrTEL(0),"043")%>>043</option>
						<option value="0502"	<%=isSelect(arrTEL(0),"0502")%>>0502</option>
						<option value="0504"	<%=isSelect(arrTEL(0),"0504")%>>0504</option>
						<option value="0505"	<%=isSelect(arrTEL(0),"0505")%>>0505</option>
						<option value="0506"	<%=isSelect(arrTEL(0),"0506")%>>0506</option>
						<option value="051"		<%=isSelect(arrTEL(0),"051")%>>051</option>
						<option value="052"		<%=isSelect(arrTEL(0),"052")%>>052</option>
						<option value="053"		<%=isSelect(arrTEL(0),"053")%>>053</option>
						<option value="054"		<%=isSelect(arrTEL(0),"054")%>>054</option>
						<option value="055"		<%=isSelect(arrTEL(0),"055")%>>055</option>
						<option value="061"		<%=isSelect(arrTEL(0),"061")%>>061</option>
						<option value="062"		<%=isSelect(arrTEL(0),"062")%>>062</option>
						<option value="063"		<%=isSelect(arrTEL(0),"063")%>>063</option>
						<option value="064"		<%=isSelect(arrTEL(0),"064")%>>064</option>
						<option value="070"		<%=isSelect(arrTEL(0),"070")%>>070</option>
						<option value="080"		<%=isSelect(arrTEL(0),"080")%>>080</option>
						<option value="1544"	<%=isSelect(arrTEL(0),"1544")%>>1544</option>
						<option value="1566"	<%=isSelect(arrTEL(0),"1566")%>>1566</option>
						<option value="1577"	<%=isSelect(arrTEL(0),"1577")%>>1577</option>
						<option value="1588"	<%=isSelect(arrTEL(0),"1588")%>>1588</option>
						<option value="1599"	<%=isSelect(arrTEL(0),"1599")%>>1599</option>
						<option value="1600"	<%=isSelect(arrTEL(0),"1600")%>>1600</option>
						<option value="1644"	<%=isSelect(arrTEL(0),"1644")%>>1644</option>
						<option value="1661"	<%=isSelect(arrTEL(0),"1661")%>>1661</option>
						<option value="1688"	<%=isSelect(arrTEL(0),"1688")%>>1688</option>
					</select> -
					<input type="text" class="input_text" name="tel_num2" style="width:45px;" maxlength="4" <%=onLyKeys%> value="<%=arrTEL(1)%>"  /> -
					<input type="text" class="input_text" name="tel_num3" style="width:45px;" maxlength="4" <%=onLyKeys%> value="<%=arrTEL(2)%>"  />
				</td>
			</tr><tr>
				<th>휴대폰번호  <%=starText%></th>
				<td colspan="3">
					<select name="mob_num1" style="width:55px;" class="vmiddle">
						<option value=""		<%=isSelect(arrMob(0),"")%>>선택</option>
						<option value="010"		<%=isSelect(arrMob(0),"010")%>>010</option>
						<option value="011"		<%=isSelect(arrMob(0),"011")%>>011</option>
						<option value="016"		<%=isSelect(arrMob(0),"016")%>>016</option>
						<option value="017"		<%=isSelect(arrMob(0),"017")%>>017</option>
						<option value="018"		<%=isSelect(arrMob(0),"018")%>>018</option>
						<option value="019"		<%=isSelect(arrMob(0),"019")%>>019</option>
						<option value="0130"	<%=isSelect(arrMob(0),"0130")%>>0130</option>
						<option value="0502"	<%=isSelect(arrMob(0),"0502")%>>0502</option>
						<option value="0505"	<%=isSelect(arrMob(0),"0505")%>>0505</option>
						<option value="0506"	<%=isSelect(arrMob(0),"0506")%>>0506</option>
						<option value="1541"	<%=isSelect(arrMob(0),"1541")%>>1541</option>
						<option value="1595"	<%=isSelect(arrMob(0),"1595")%>>1595</option>
						<option value="08217"	<%=isSelect(arrMob(0),"08217")%>>08217</option>
					</select> -
					<input type="text" class="input_text" name="mob_num2" style="width:45px;" maxlength="4" <%=onLyKeys%> value="<%=arrMob(1)%>" /> -
					<input type="text" class="input_text" name="mob_num3" style="width:45px;" maxlength="4" <%=onLyKeys%> value="<%=arrMob(2)%>"  />
					<span class="summary">* 비상연락 시 반드시 필요한 정보입니다. 정확히 기재해주세요.</span>
				</td>
			</tr><tr>
				<th>이메일</th>
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
			</tr><tr>
				<th>생일 <%=starText%></th>
				<td colspan="3">
					<select name = "birthYY" class="vmiddle" style="width:60px;">
						<option value=""></option>
						<%For i = MIN_YEAR To MAX_YEAR%>
							<option value="<%=i%>" <%=isSelect(i,Left(RS_BirthDay,4))%>><%=i%></option>
						<%Next%>
					</select> 년
					<select name = "birthMM" class="vmiddle" style="width:45px;">
						<option value=""></option>
						<%For j = 1 To 12%>
							<%jsmm = Right("0"&j,2)%>
							<option value="<%=jsmm%>" <%=isSelect(jsmm,Mid(RS_BirthDay,5,2))%>><%=jsmm%></option>
						<%Next%>
					</select> 월
					<select name = "birthDD" class="vmiddle" style="width:45px;">
						<option value=""></option>
						<%For k = 1 To 31%>
							<%ksdd = Right("0"&k,2)%>
							<option value="<%=ksdd%>"<%=isSelect(ksdd,Right(RS_BirthDay,2))%>><%=ksdd%></option>
						<%Next%>
					</select> 일
					<label style="margin-left:20px;"><input type="radio" name="isSolar" value="1" class="input_chk" <%=isChecked(RS_BirthDayTF,"1")%> />양력</label>
					<label><input type="radio" name="isSolar" value="2" class="input_chk" <%=isChecked(RS_BirthDayTF,"2")%>  />음력</label>
				</td>
			</tr><tr class="line">
				<th colspan="4" class="th">회원 상태정보</th>
			</tr><tr class="line">
				<th>회원구분</th>
				<td colspan="3"><%=Sell_Mem_TF%></td>
			</tr><tr>
				<th>회원상태</th>
				<td colspan="3"><%=LeaveStatus%></td>
			</tr>
			<%If RS_LeaveCheck = 0 Then%>
				<tr>
					<th>탈퇴일</th>
					<td class="red"><%=date8to10(RS_LeaveDate)%></td>
					<th>탈퇴사유</th>
					<td><%=RS_LeaveReason%></td>
				</tr>
			<%End If%>
			<tr class="line">
				<th colspan="4" class="th">직 상위 회원</th>
			</tr><tr class="line">
				<%
					arrParams = Array(_
						Db.makeParam("@mbid",adVarChar,adParamInput,20,RS_Saveid), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,RS_Saveid2) _
					)
					SAVE_NAME = Db.execRsData("DKP_MEMBER_UP_NAME_SEARCH",DB_PROC,arrParams,DB3)
				%>
				<th>직상위후원인</th>
				<td><%=RS_Saveid%> - <%=Fn_MBID2(RS_Savei2)%> (<%=SAVE_NAME%>)</td>
				<%
					arrParams = Array(_
						Db.makeParam("@mbid",adVarChar,adParamInput,20,RS_Nominid), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,RS_Nominid2) _
					)
					NOMINID_NAME = Db.execRsData("DKP_MEMBER_UP_NAME_SEARCH",DB_PROC,arrParams,DB3)
				%>
				<th>직상위추천인</th>
				<td><%=RS_Nominid%> - <%=Fn_MBID2(RS_Nominid2)%> (<%=NOMINID_NAME%>)</td>
			</tr>

		</tbody>
	</table>
	</form>
</div>

<div class="btn_area p100"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChk();""")%><%=aImgSt("cs_member_list.asp",IMG_BTN&"/btn_rect_list.gif",99,45,"","margin:20px 0px 0px 10px;","")%></div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->




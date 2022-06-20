<%
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		DKRS_Ed_TF				= DKRS("Ed_TF")
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")



		If DKRS_WebID = "" Then DKRS_WebID = "웹아이디 미등록 계정"

		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If DKRS_Address1	<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
				If DKRS_Address2	<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
				If DKRS_Address3	<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
				If DKRS_hometel		<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
				If DKRS_hptel		<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
				If DKRS_bankaccnt	<> "" Then DKRS_bankaccnt	= objEncrypter.Decrypt(DKRS_bankaccnt)
			'	PRINT  objEncrypter.Decrypt("Z0SPQ6DkhLd4e")
			Set objEncrypter = Nothing
		End If


		If DKRS_hometel = "" Or IsNull(DKRS_hometel) Then DKRS_hometel = "--"
			arrTEL = Split(DKRS_hometel,"-")
		If DKRS_hptel = "" Or IsNull(DKRS_hptel) Then DKRS_hptel = "--"
			arrMob = Split(DKRS_hptel,"-")
		If DKRS_Email = "" Or IsNull(DKRS_Email) Then DKRS_Email = "@"
			arrMAIL = Split(DKRS_Email,"@")
		If DKRS_BirthDay = "" Or IsNull(DKRS_BirthDay) Then
			DKRS_BirthDay = "--"
		Else
			DKRS_BirthDay = date8to10(DKRS_BirthDay)
		End If
		arrBIRTH = Split(DKRS_BirthDay,"-")

	Else
		Call ALERTS("회원정보가 로드되지 못했습니다..","back","")
	End If
	Call closeRS(DKRS)
%>
<div id="mypage" class="member_modify" style="margin-left:20px;">
	<p><%=viewImg(IMG_JOIN&"/join_into_tit_01.gif",196,33,"")%></p>
	<form name="cfrm" method="post" action="member_info_company_handler.asp" onsubmit="return memInfoChk(this);">
		<table <%=tableatt%> width="100%">
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
			<tbody>
				<tr class="line">
					<th>이름</th>
					<td><%=DKRS_M_Name%></td>
					<th>회원번호</th>
					<td><%=DKRS_mbid%>-<%=Fn_MBID2(DKRS_mbid2)%></td>
				</tr><tr>
					<th>마이오피스 웹아이디</th>
					<td><%=DKRS_WebID%></td>
					<th>가입일</th>
					<td><%=date8to10(DKRS_Regtime)%></td>
				</tr><tr>
					<th>비밀번호 <%=starText%></td>
					<td colspan="3">
						<input type="password" name="strPass" class="input_text" maxlength="20" />
						<label style="margin-left:10px; vetical-align:middle;"><input type="checkbox" name="isChgPass" value="T" class="vmiddle" onClick="checkChgPass(this)" /> 비밀번호 변경</label>
					</td>
				</tr><tr>
				<th>계좌정보</th>
				<td colspan="3">
					<%
						SQL = "SELECT [bankName] FROM [tbl_Bank] WHERE [ncode] = ?"
						arrParams = Array(_
							Db.makeParam("@ncode",adVarChar,adParamInput,10,DKRS_bankcode) _
						)
						DKRS_bankName = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
					%>
					[<%=DKRS_bankName%>] <%=DKRS_bankaccnt%>  [예금주] : <%=DKRS_bankowner%></td>
				</tr>
			</tbody>
			<tbody id="bodyPass" style="display:none;">
				<tr>
					<th>새 비밀번호 <%=starText%></td>
					<td colspan="3"><input type="password" name="newPass" class="input_text" maxlength="20" /> <span class="summary">영문,숫자,특수문자 6~20자</span></td>
				</tr><tr>
					<th>새 비밀번호확인 <%=starText%></td>
					<td colspan="3"><input type="password" name="newPass2" class="input_text" maxlength="20" /> <span class="summary">영문,숫자,특수문자 6~20자</span></td>
				</tr>
			</tbody>
		</table>


		<p><%=viewImg(IMG_JOIN&"/join_into_tit_02.gif",196,33,"")%></p>
		<table <%=tableatt%> width="100%">
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
			<tbody>
				<tr class="line">
					<th>주소 <%=starText%></th>
					<td colspan="3">
						<input type="text" class="input_text vmiddle" name="strzip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=DKRS_Addcode1%>" />
						<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" />
						<input type="text" class="input_text vmiddle" name="straddr1" style="width:270px;background-color:#f4f4f4;" readonly="readonly" value="<%=DKRS_Address1%>" />
					</td>
				</tr><tr>
					<th>상세주소 <%=starText%></th>
					<td colspan="3"><input type="text" class="input_text" name="straddr2" style="width:430px;" value="<%=DKRS_Address2%>" /></td>
				</tr><tr>
					<th>휴대폰번호 <%=starText%></th>
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
						<span class="summary">* 비상연락 시 필요한 정보입니다. 정확히 기재해주세요.</span>
					</td>
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
						<!-- <input type="text" name="birthYY" class="input_text" maxlength="4" style="width:55px;" value="<%=arrBIRTH(0)%>" /> 년
						<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(1)%>" /> 월
						<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(2)%>" /> 일 -->
						<select name = "birthYY" class="vmiddle" style="width:60px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" <%=isSelect(i,arrBIRTH(0))%>><%=i%></option>
							<%Next%>
						</select> 년
						<select name = "birthMM" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" <%=isSelect(jsmm,arrBIRTH(1))%>><%=jsmm%></option>
							<%Next%>
						</select> 월
						<select name = "birthDD" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>"<%=isSelect(ksdd,arrBIRTH(2))%>><%=ksdd%></option>
							<%Next%>
						</select> 일
						<label style="margin-left:20px;"><input type="radio" name="isSolar" value="1" class="input_radio" <%=isChecked(DKRS_BirthDayTF,"1")%> /> 양력</label>
						<label><input type="radio" name="isSolar" value="2" class="input_radio" <%=isChecked(DKRS_BirthDayTF,"2")%>  /> 음력</label>
					</td>
				</tr>
				<tr class="line">
					<%
						arrParams = Array(_
							Db.makeParam("@mbid",adVarChar,adParamInput,20,DKRS_Saveid), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,DKRS_Saveid2) _
						)
						SAVE_NAME = Db.execRsData("DKP_MEMBER_UP_NAME_SEARCH",DB_PROC,arrParams,DB3)
					%>
					<th>직상위후원인</th>
					<td><%=DKRS_Saveid%> - <%=Fn_MBID2(DKRS_Savei2)%> (<%=SAVE_NAME%>)</td>
					<%
						arrParams = Array(_
							Db.makeParam("@mbid",adVarChar,adParamInput,20,DKRS_Nominid), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,DKRS_Nominid2) _
						)
						NOMINID_NAME = Db.execRsData("DKP_MEMBER_UP_NAME_SEARCH",DB_PROC,arrParams,DB3)
					%>
					<th>직상위추천인</th>
					<td><%=DKRS_Nominid%> - <%=Fn_MBID2(DKRS_Nominid2)%> (<%=NOMINID_NAME%>)</td>
				</tr>
			</tbody>
		</table>
		<div class="btn_area p100 tcenter">
			<input type="image" src="<%=IMG_MYPAGE%>/infoOk.gif" />
		</div>
	</form>
</div>
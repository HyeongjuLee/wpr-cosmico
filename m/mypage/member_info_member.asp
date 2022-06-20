<%
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then

		DKRS_MotherSite		= DKRS("MotherSite")
		DKRS_strUserID		= DKRS("strUserID")
		DKRS_strPass		= DKRS("strPass")
		DKRS_strName		= DKRS("strName")
		DKRS_strNickName	= DKRS("strNickName")
		DKRS_strMobile		= DKRS("strMobile")
		DKRS_strEmail		= DKRS("strEmail")
		DKRS_strZip			= DKRS("strZip")
		DKRS_strADDR1		= DKRS("strADDR1")
		DKRS_strADDR2		= DKRS("strADDR2")
		DKRS_strState		= DKRS("strState")
		DKRS_isViewID		= DKRS("isViewID")
		DKRS_intMemLevel	= DKRS("intMemLevel")
		DKRS_intVisit		= DKRS("intVisit")
		DKRS_memberType		= DKRS("memberType")
		DKRS_dateRegist		= DKRS("dateRegist")
		DKRS_strTel			= DKRS("strTel")
		DKRS_isSMS			= DKRS("isSMS")
		DKRS_isMailing		= DKRS("isMailing")
		DKRS_strBirth		= DKRS("strBirth")
		DKRS_strSolar		= DKRS("strSolar")
		DKRS_isSex			= DKRS("isSex")
		DKRS_isIDImg		= DKRS("isIDImg")
		DKRS_imgPath		= DKRS("imgPath")

		If DKRS_strTel = "--" Then DKRS_strTel = ""
		If DKRS_strMobile = "--" Then DKRS_strMobile = ""

		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If DKRS_strADDR1	<> "" Then DKRS_strADDR1	= objEncrypter.Decrypt(DKRS_strADDR1)
				If DKRS_strADDR2	<> "" Then DKRS_strADDR2	= objEncrypter.Decrypt(DKRS_strADDR2)
				If DKRS_strTel		<> "" Then DKRS_strTel		= objEncrypter.Decrypt(DKRS_strTel)
				If DKRS_strMobile	<> "" Then DKRS_strMobile	= objEncrypter.Decrypt(DKRS_strMobile)
				'If RS_strEmail		<> "" Then RS_strEmail		= objEncrypter.Decrypt(RS_strEmail)
				Set objEncrypter = Nothing
				'PRINT  objEncrypter.Decrypt("tdjoz+7h7t0JgOCgu6TlEA==")
			Set objEncrypter = Nothing
		End If


		'변경
		If DKRS_strTel = "" Or IsNull(DKRS_strTel) Then DKRS_strTel = "--"
			arrTEL = Split(DKRS_strTel,"-")
		If DKRS_strMobile = "" Or IsNull(DKRS_strMobile) Then DKRS_strMobile = "--"
			arrMob = Split(DKRS_strMobile,"-")
		If DKRS_strEmail = "" Or IsNull(DKRS_strEmail) Then DKRS_strEmail = "@"
			arrMAIL = Split(DKRS_strEmail,"@")
		If DKRS_strBirth = "" Or IsNull(DKRS_strBirth) Then DKRS_strBirth = "--"
			arrBIRTH = Split(DKRS_strBirth,"-")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"go","/common/member_logout.asp")
	End If
%>

<div id="mypage" class="member_modify">
	<p><%=viewImg(IMG_JOIN&"/join_into_tit_01.gif",196,33,"")%></p>
	<form name="cfrm" method="post" action="member_info_member_handler.asp" onsubmit="return memInfoChk(this);">

		<table <%=tableatt%> width="100%">
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
			<tbody>
				<tr class="line">
					<th><%=LNG_TEXT_NAME%></th>
					<td><%=DKRS_strName%></td>
					<th><%=LNG_MYPAGE_INFO_MEMBER_TEXT08%></th>
					<td><%=DKRS_MotherSite%></td>
				</tr><tr>
					<th><%=LNG_TEXT_ID%></th>
					<td><%=DKRS_strUserID%></td>
					<th><%=LNG_TEXT_NICKNAME%></th>
					<td><%=DKRS_strNickName%></td>
				</tr><tr>
					<th><%=LNG_TEXT_PASSWORD%> <%=starText%></td>
					<td colspan="3">
						<input type="password" name="strPass" class="input_text" maxlength="20" />
						<label style="margin-left:10px;font-size:9pt;"><input type="checkbox" name="isChgPass" value="T" onClick="checkChgPass(this)"  class="vmiddle" /><%=LNG_TEXT_PASSWORD_CHANGE%></label>
					</td>
				</tr>
			</tbody>
			<tbody id="bodyPass" style="display:none;">
				<tr>
					<th><%=LNG_TEXT_NEWPASSWORD%> <%=starText%></td>
					<td colspan="3"><input type="password" name="newPass" class="input_text" maxlength="20" /> <span class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></span></td>
				</tr><tr>
					<th><%=LNG_TEXT_NEWPASSWORD_CONFIRM%> <%=starText%></td>
					<td colspan="3"><input type="password" name="newPass2" class="input_text" maxlength="20" /> <span class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></span></td>
				</tr>
			</tbody>
		</table>


		<p><%=viewImg(IMG_JOIN&"/join_into_tit_02.gif",196,33,"")%></p>
		<table <%=tableatt%> width="100%">
			<col width="20%" />
			<col width="80%" />
			<tbody>
				<tr class="line">
					<th><%=LNG_TEXT_SEX%></th>
					<td><%=CallMemSex(DKRS_isSex)%></td>
				</tr><tr>
					<th><%=LNG_TEXT_NAME_EXPOSURE%> <%=starText%></th>
					<td>
						<label><input type="radio" name="isViewID" value="A" class="input_radio" <%=isChecked("A",DKRS_isViewID)%> /> <%=LNG_TEXT_NICKNAME%></label>
						<label style="margin-left:7px;"><input type="radio" name="isViewID" value="N" class="input_radio" <%=isChecked("N",DKRS_isViewID)%> /> <%=LNG_TEXT_NAME%></label>
						<label style="margin-left:7px;"><input type="radio" name="isViewID" value="I" class="input_radio" <%=isChecked("I",DKRS_isViewID)%> /> <%=LNG_TEXT_ID%></label>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_ADDRESS1%> <%=starText%></th>
					<td colspan="3">
						<input type="text" class="input_text vmiddle" name="strzip" id="strZipDaum" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=DKRS_strZIP%>" />
						<img src="<%=IMG_MYPAGE%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="execDaumPostcode('oris')" />
						<input type="text" class="input_text vmiddle" name="straddr1" id="strADDR1Daum" style="width:270px;background-color:#f4f4f4;" readonly="readonly" value="<%=DKRS_strADDR1%>" />
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_ADDRESS2%> <%=starText%></th>
					<td colspan="3"><input type="text" class="input_text" name="straddr2" id="strADDR2Daum" style="width:430px;" value="<%=DKRS_strADDR2%>" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_MOBILE%> <%=starText%></th>
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
						<span class="summary">* <%=LNG_MYPAGE_INFO_MEMBER_TEXT24%></span>
					</td>
				</tr><tr>
					<th><%=LNG_TEXT_TEL%></th>
					<td>
						<select name="tel_num1" style="width:55px;" class="vmiddle">
							<option value=""		<%=isSelect(arrTEL(0),"")%>><%=LNG_TEXT_SELECT%></option>
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
					<th><%=LNG_TEXT_EMAIL%> <%=starText%></th>
					<td colspan="3">
						<input type="text" name="mailh" class="input_text imes" maxlength="512" style="width:102px;" value="<%=arrMAIL(0)%>" /> @
						<input type="text" name="mailt" class="input_text imes" maxlength="512" style="width:120px;" value="<%=arrMAIL(1)%>" />
						<select name="mails" onchange="javascript:document.cfrm.mailt.value = document.cfrm.mails.value;" class="vmiddle">
							<option value="" <%=isSelect(arrMAIL(1),"")%>><%=LNG_TEXT_DIRECT_INPUT%></option>
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
					<th><%=LNG_TEXT_BIRTH%> <%=starText%></th>
					<td>
						<!-- <input type="text" name="birthYY" class="input_text" maxlength="4" style="width:55px;" value="<%=arrBIRTH(0)%>" /> 년
						<input type="text" name="birthMM" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(1)%>" /> 월
						<input type="text" name="birthDD" class="input_text" maxlength="2" style="width:40px;" value="<%=arrBIRTH(2)%>" /> 일 -->
						<select name = "birthYY" class="vmiddle" style="width:60px;">
							<option value=""></option>
							<%For i = MIN_YEAR To MAX_YEAR%>
								<option value="<%=i%>" <%=isSelect(i,arrBIRTH(0))%>><%=i%></option>
							<%Next%>
						</select>
						<select name = "birthMM" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For j = 1 To 12%>
								<%jsmm = Right("0"&j,2)%>
								<option value="<%=jsmm%>" <%=isSelect(jsmm,arrBIRTH(1))%>><%=jsmm%></option>
							<%Next%>
						</select>
						<select name = "birthDD" class="vmiddle" style="width:45px;">
							<option value=""></option>
							<%For k = 1 To 31%>
								<%ksdd = Right("0"&k,2)%>
								<option value="<%=ksdd%>"<%=isSelect(ksdd,arrBIRTH(2))%>><%=ksdd%></option>
							<%Next%>
						</select> (<%=LNG_TEXT_YEAR%><%=LNG_TEXT_MONTH%><%=LNG_TEXT_DAY%>)
						<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
							<label style="margin-left:20px;"><input type="radio" name="isSolar" value="S" class="input_radio" <%=isChecked(DKRS_strSolar,"S")%> /> <%=LNG_TEXT_SOLAR%></label>
							<label><input type="radio" name="isSolar" value="M" class="input_radio" <%=isChecked(DKRS_strSolar,"M")%>  /> <%=LNG_TEXT_LUNAR%></label>
						<%Else%>
							<input type="hidden" name="isSolar" value="<%=DKRS_strSolar%>" />
						<%End If%>
					</td>
				</tr>
				<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
				<tr>
					<th><%=LNG_MYPAGE_INFO_MEMBER_TEXT32%> <%=starText%></th>
					<td>
						<p style="padding-bottom:3px;"><%=LNG_MYPAGE_INFO_MEMBER_TEXT33%></p>
						<label><input type="radio" name="sendsms" value="T" class="input_radio" <%=isChecked(DKRS_isSMS,"T")%> /> <%=LNG_MYPAGE_INFO_MEMBER_TEXT38%></label>
						<label><input type="radio" name="sendsms" value="F" class="input_radio" <%=isChecked(DKRS_isSMS,"F")%> style="margin-left:10px;" /> <%=LNG_MYPAGE_INFO_MEMBER_TEXT39%></label>
						<span class="summary">* <%=LNG_MYPAGE_INFO_MEMBER_TEXT34%></span>
					</td>
				</tr><tr>
					<th><%=LNG_MYPAGE_INFO_MEMBER_TEXT35%> <%=starText%></th>
					<td>
						<p><%=DKCONF_SITE_TITLE%><%=LNG_MYPAGE_INFO_MEMBER_TEXT36%></p>
						<p style="padding-bottom:3px;"><%=LNG_MYPAGE_INFO_MEMBER_TEXT37%></p>
						<label><input type="radio" name="sendemail" class="input_radio" value="T" <%=isChecked(DKRS_isMAILING,"T")%> /> <%=LNG_MYPAGE_INFO_MEMBER_TEXT38%></label>
						<label><input type="radio" name="sendemail" class="input_radio" value="F" <%=isChecked(DKRS_isMAILING,"F")%> style="margin-left:10px;" /> <%=LNG_MYPAGE_INFO_MEMBER_TEXT39%></label>
					</td>
				</tr>
				<%End If%>
			</tbody>
		</table>
		<div class="btn_area p100 tcenter">
			<input type="submit" class="txtBtn large b_blue" onclick="memInfoChk();" value="<%=LNG_TEXT_CONFIRM%>" />
			<!-- <input type="image" src="<%=IMG_MYPAGE%>/infoOk.gif" /> -->
		</div>
	</form>
</div>
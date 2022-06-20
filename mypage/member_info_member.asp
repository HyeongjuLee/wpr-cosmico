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

		'If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If DKRS_strADDR1		<> "" Then DKRS_strADDR1	= objEncrypter.Decrypt(DKRS_strADDR1)
					If DKRS_strADDR2		<> "" Then DKRS_strADDR2	= objEncrypter.Decrypt(DKRS_strADDR2)
					If DKRS_strTel			<> "" Then DKRS_strTel		= objEncrypter.Decrypt(DKRS_strTel)
					If DKRS_strMobile		<> "" Then DKRS_strMobile	= objEncrypter.Decrypt(DKRS_strMobile)
					If DKRS_strPass			<> "" Then DKRS_strPass		= objEncrypter.Decrypt(DKRS_strPass)

		'			If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
						If DKRS_strEmail	<> "" Then DKRS_strEmail	= objEncrypter.Decrypt(DKRS_strEmail)
		'			End If
				On Error GoTo 0
				'PRINT  objEncrypter.Decrypt("tdjoz+7h7t0JgOCgu6TlEA==")
			Set objEncrypter = Nothing
		'End If


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

<!-- <div id="mypage" class="member_modify userCWidth2"> -->
<div id="mypage" class="common">
	<!-- <p><img src="<%=IMG_JOIN%>/join_into_tit_01.gif" alt="" /></p> -->
	<form name="cfrm" method="post" action="member_info_member_handler.asp" onsubmit="return memInfoChk(this);">
	
		<article>
			<h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_NAME%></h5>
					<div class="con"><%=DKRS_strName%></div>
				</div>
				<div>
					<h5><%=LNG_MYPAGE_INFO_MEMBER_TEXT08%></h5>
					<div class="con"><%=DKRS_MotherSite%></div>
				</div>
			</div>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_ID%></h5>
					<div class="con"><%=DKRS_strUserID%></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_NICKNAME%></h5>
					<div class="con"><%=DKRS_strNickName%></div>
				</div>
			</div>
			<div class="password">
				<h5><%=LNG_TEXT_PASSWORD%> <%=starText%></h5>
				<div class="con">
					<!--<input type="hidden" name="isWebIDUse" value="T">-->
					<input type="password" name="strPass" class="input_text" maxlength="20" />
					<label><input type="checkbox" name="isChgPass" value="T" class="vmiddle" onClick="checkChgPass(this)" /><%=LNG_TEXT_PASSWORD_CHANGE%></label>
				</div>
			</div>
			<div id="bodyPass" style="display:none;" class="drow">
				<div>
					<h5><%=LNG_TEXT_NEWPASSWORD%> <%=starText%></h5>
					<div class="con"><input type="password" name="newPass" class="input_text" maxlength="20" /> <p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_NEWPASSWORD_CONFIRM%> <%=starText%></h5>
					<div class="con"><input type="password" name="newPass2" class="input_text" maxlength="20" /> <p class="summary"><%=LNG_TEXT_PASSWORD_TYPE%></p></div>
				</div>
			</div>
		</article>
		<article>
			<h6><%=LNG_TEXT_MEMBER_ADDITIONAL_INFO%></h6>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_SEX%></h5>
					<div class="con"><%=CallMemSex(DKRS_isSex)%></div>
				</div>
				<div class="radio">
					<h5><%=LNG_TEXT_NAME_EXPOSURE%> <%=starText%></h5>
					<div class="con">
						<label><input type="radio" name="isViewID" value="A" class="input_radio" <%=isChecked("A",DKRS_isViewID)%> /><i class="icon-ok"></i><span><%=LNG_TEXT_NICKNAME%></span></label>
						<label><input type="radio" name="isViewID" value="N" class="input_radio" <%=isChecked("N",DKRS_isViewID)%> /><i class="icon-ok"></i><span><%=LNG_TEXT_NAME%></span></label>
						<label><input type="radio" name="isViewID" value="I" class="input_radio" <%=isChecked("I",DKRS_isViewID)%> /><i class="icon-ok"></i><span><%=LNG_TEXT_ID%></span></label>
					</div>
				</div>
			</div>
			<div class="address dwrap">
				<div>
					<h5><%=LNG_TEXT_ADDRESS1%> <%=starText%></h5>
					<div class="con">
						<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
							<%Case "KR"%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7" value="<%=DKRS_Addcode1%>" readonly="readonly" />
								<input type="button" class="button" onclick="execDaumPostcode('oris');" value="<%=LNG_TEXT_ZIPCODE%>" />
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" readonly="readonly" />
							<%Case "JP"%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7"  <%=onLyKeys%> value="<%=DKRS_Addcode1%>" readonly="readonly"/>
								<input type="button" class="button" onclick="openzip_jp2EN();" value="<%=LNG_TEXT_ZIPCODE%>" />
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" readonly="readonly"/>
							<%Case Else%>
								<input type="text" class="input_text" name="strZip" id="strZipDaum" maxlength="7"  <%=onLyKeys%> value="<%=DKRS_Addcode1%>" />
								<input type="text" class="input_text" name="strADDR1" id="strADDR1Daum" maxlength="500" value="<%=DKRS_Address1%>" />
						<%End Select%>
					</div>
				</div>
				<div>
					<h5><%=LNG_TEXT_ADDRESS2%> <%=starText%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strADDR2" id="strADDR2Daum" maxlength="500" value="<%=DKRS_Address2%>" />
					</div>
				</div>
			</div>
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_MOBILE%> <%=starText%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strMobile" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>" />
						<p class="summary">* <%=LNG_MYPAGE_INFO_COMPANY_TEXT23%></p>
					</div>
				</div>
				<div>
					<h5><%=LNG_TEXT_TEL%></h5>
					<div class="con">
						<input type="text" class="input_text" name="strTel" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hometel%>" />
					</div>
				</div>
			</div>
			<div class="drow">
				<div class="email">
					<h5><%=LNG_TEXT_EMAIL%> <%=startext%></h5>
					<div class="con">
						<input type="text" name="strEmail" class="input_text" maxlength="512" value="<%=DKRS_Email%>" />
					</div>
				</div>
				<!-- <div class="birth radio">
					<h5><%=LNG_TEXT_BIRTH%> <%=starText%></h5>
					<div class="con">
						<div class="selects">
							<select name = "birthYY" class="input_select">
								<option value=""></option>
								<%For i = MIN_YEAR To MAX_YEAR%>
									<option value="<%=i%>" <%=isSelect(i,arrBIRTH(0))%>><%=i%></option>
								<%Next%>
							</select>
							<select name = "birthMM" class="input_select">
								<option value=""></option>
								<%For j = 1 To 12%>
									<%jsmm = Right("0"&j,2)%>
									<option value="<%=jsmm%>" <%=isSelect(jsmm,arrBIRTH(1))%>><%=jsmm%></option>
								<%Next%>
							</select>
							<select name = "birthDD" class="input_select">
								<option value=""></option>
								<%For k = 1 To 31%>
									<%ksdd = Right("0"&k,2)%>
									<option value="<%=ksdd%>"<%=isSelect(ksdd,arrBIRTH(2))%>><%=ksdd%></option>
								<%Next%>
							</select>
							<span style="display: none;">(<%=LNG_TEXT_YEAR%><%=LNG_TEXT_MONTH%><%=LNG_TEXT_DAY%>)</span>
						</div>
						<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
							<div>
								<label><input type="radio" name="isSolar" value="S" class="input_radio" <%=isChecked(DKRS_strSolar,"S")%> /><i class="icon-ok"></i><span><%=LNG_TEXT_SOLAR%></span></label>
								<label><input type="radio" name="isSolar" value="M" class="input_radio" <%=isChecked(DKRS_strSolar,"M")%> /><i class="icon-ok"></i><span><%=LNG_TEXT_LUNAR%></span></label>
							</div>
						<%Else%>
							<input type="hidden" name="isSolar" value="<%=DKRS_strSolar%>" />
						<%End If%>
					</div>
				</div> -->
			</div>
		</article>
				
				<!-- <%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
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
		</table> -->
		</article>
		<div class="btnZone">
			<input type="submit" class="button" onclick="memInfoChk();" value="<%=LNG_TEXT_CONFIRM%>" />
		</div>
	</form>
</div>
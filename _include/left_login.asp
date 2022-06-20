<div id="left_login">
<%
	If DK_MEMBER_LEVEL > 0 Then
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
		)
		Set DKRS = Db.execRs("DKP_LAST_CONNECTION",DB_PROC,arrParams,Nothing)

		If Not DKRS.BOF And Not DKRS.EOF Then
			LAST_LOGIN				= DKRS("LAST_LOGIN")
			TOTAL_ORDER_CNT			= DKRS("TOTAL_ORDER_CNT")
			TOTAL_ORDER_PRICE		= DKRS("TOTAL_ORDER_PRICE")
		Else

		End If

		Call closeRS(DKRS)



%>
		<div class="loginContent">
			<div class="clear"><%=viewImg(IMG_LEFT&"/logined_top.gif",187,40,"")%></div>
			<table <%=tableatt%> style="width:187px;">
				<col width="80" />
				<col width="7" />
				<col width="100" />
				<tr>
					<td class="td1">회원명</td>
					<td class="td2">:</td>
					<td class="td3"><%=DK_MEMBER_NAME%> <span style="color:#888;">님</span></td>
				</tr><tr>
					<td class="td1">구매횟수</td>
					<td class="td2">:</td>
					<td class="td3"><%=TOTAL_ORDER_CNT%> <span style="color:#888;">건</span></td>
				</tr><tr>
					<td class="td1">구매금액</td>
					<td class="td2">:</td>
					<td class="td3"><%=NUM2CUR(TOTAL_ORDER_PRICE)%> <span style="color:#888;">원</span></td>
				</tr><tr>
					<td class="td2" colspan="3"><span style="color:#888;font-size:8pt;">최근접속 : <%=LAST_LOGIN%></span><%%></td>
				</tr>
			</table>
			<div class="clear"><%=viewImg(IMG_LEFT&"/login_line.gif",187,21,"")%></div>
			<div class="clear btnLine">
					<%=aImgOpt("","S",IMG_LEFT&"/left_login_info.gif",70,22,"","style=""margin-left:20px;""")%>
					<%=aImgOpt("/common/member_logout.asp","S",IMG_LEFT&"/left_login_logout.gif",70,22,"","style=""margin-left:10px;""")%>
			</div>
		</div>
	<%Else%>
	<div class="loginContent">
		<form name="mLogin" action="/common/member_loginOk.asp" method="post"  onsubmit="return chkmlLogin(this)">
			<input type="hidden" name="loginMode" value="page" />
			<input type="hidden" name="backURLs" value="<%=ThisPageURL%>" />
			<div class="clear"><%=viewImg(IMG_LEFT&"/login_top.gif",187,40,"")%></div>
			<div class="login_input"><input type="text" name="mem_id" class="input_none" tabindex="1" /></div>
			<div class="fright"><input type="image" src="<%=IMG_LEFT%>/btn_login.gif" tabindex="3" /></div>
			<div class="login_input pwd"><input type="password" name="mem_pwd" class="input_none" tabindex="2" /></div>
			<div class="clear"><%=viewImg(IMG_LEFT&"/login_line.gif",187,21,"")%></div>
		</form>
		<div class="clear txtline">
			<ul>
				<li>아이디/비밀번호 찾기</li>
				<li style="margin-left:10px;"><a href="/common/member_join.asp">회원가입</a></li>
			</ul>
		</div>
	</div>

	<!-- <form name="llchkFrm" method="post" action="/common/member_loginOk.asp" onsubmit="return chkmlLogin(this)">
		<input type="hidden" name="loginMode" value="page" />
		<input type="hidden" name="backURLs" value="<%=ThisPageURL%>" />
		<table <%=tableatt%> class="inTable">
			<colgroup>
				<col width="121" />
				<col width="54" />
			</colgroup>
			<tr>
				<td colspan="2" style="height:26px;"><input type="text" name="mem_id" class="input_text_login" style="width:173px; background:#fff url(<%=CIMG_SHARE%>/left_mem_id_bg.gif) 0 0px no-repeat;" onfocus="bgDel(this);" onblur="bgChg(this);"/></td>
			</tr><tr>
				<td style="height:26px;"><input type="password" name="mem_pwd" class="input_text_login" style="width:117px; background:#fff url(<%=CIMG_SHARE%>/left_mem_pwd_bg.gif) 0 0px no-repeat;" onfocus="bgDel(this);" onblur="bgChgs(this);"/></td>
				<td class="tright"><input type="image" src="<%=CIMG_SHARE%>/left_login_submit.gif" /></td>
			</tr>

		</table>
	</form> -->
	<%End If%>
</div>

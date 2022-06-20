<!--#include virtual = "/_lib/strFunc.asp"-->
<%	'번역x
	popWidth = 530
	popHeight = 420

	strName = pRequestTF("mem_name",True)
	mailh = pRequestTF("mailh",True)
	mailt = pRequestTF("mailt",True)
	strEmail = mailh &"@"& mailt


	SQL = "SELECT [strUserID],[memberType] FROM [DK_MEMBER] WHERE [strName] = ? AND [strEmail] = ? "
	arrParams = Array(_
		Db.makeParam("@strName",adVarChar,adParamInput,30,strName), _
		Db.makeParam("@strSSH1",adVarChar,adParamInput,512,strEmail) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		MESSAGE = "님의 아이디는 <strong>"&DKRS(0) & "</strong> 입니다."
		DB_memberType = DKRS(1)
	Else
		MESSAGE = "이 없습니다."
	End If
	Call closeRS(DKRS)

	If DB_memberType = "COMPANY" Then
		MESSAGE = "님은 사업자회원입니다.<br />사업자회원 아이디는 고객센터로 문의해주세요"
	End If



%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	function joins(){
		opener.document.location.href = '/common/joinStep01.asp';
		self.close();
	}


//-->
</script>
<style type="text/css">
	#pop_login {margin:15px;}
	#popup {width:452px;padding:21px 24px 0px 24px;}
	#popup .tops {clear:both;border-bottom:1px solid #eaeaea;}

	#popup .login_info {clear:both;float:left; margin:35px 0px 35px 26px; width:400px; text-align:center;}
	#popup .etc_btn {clear:both; float:left; width:452px; border-top:1px solid #eaeaea; padding:10px 0px;}

	#popup .id, #popup .pwd {clear:both;float:left; width:342px; height:22px;overflow:hidden;}
	#popup .pwd {margin-top:5px; }

	#popup .login_bottom {clear:both;height:30px;text-align:center;border-top:1px solid #eaeaea;}
	#popup .input_text {border:1px solid #dadada; background:#e6e6e6; ;height:18px;}
	#popup .submit {float:left; margin-top:25px;height:45px; width:50px; margin-left:8px;}

	#popup table {margin:0 auto; width:400px;}
	#popup td {padding:2px 0px; color:#999;}
	#popup p {line-height:130%;}

</style>
</head>
<body>
<div id="pop_login">
	<div id="popup">
		<div class="tops"><%=viewImg(IMG_JOIN&"/idsearch_top.gif",227,50,"")%></div>
		<div class="login_info lheight160">
			입력하신 정보와 일치하는 회원<%=MESSAGE%>
		</div>
		<div class="etc_btn">
			<table <%=tableatt%>>
				<tr>
					<td>- <%=DKCONF_SITE_TITLE%> <%=DK_CONF_SITE_TYPE_NAME%>의 <span class="text_black">회원</span>이 아니신가요?</td>
					<td class="tright"><%=viewImgStJs(IMG_JOIN&"/btn_join.gif",85,20,"","","cp","onclick=""joins();""")%></td>
				</tr><tr>
					<td>- <span class="text_black">아이디</span>가 기억이 안나시나요?</td>
					<td class="tright"><%=aImg("member_idsearch.asp",IMG_JOIN&"/btn_idsearch.gif",85,20,"")%></td>
				</tr><tr>
					<td>- <span class="text_black">비밀번호</span>가 기억이 안나시나요? (일반회원용)</td>
					<td class="tright"><%=aImg("pop_pwdSearch.asp?m=nor",IMG_JOIN&"/btn_pwdsearch.gif",85,20,"")%></td>
				</tr><tr>
					<td>- <span class="text_black">비밀번호</span>가 기억이 안나시나요? (사업자회원용)</td>
					<td class="tright"><%=aImg("pop_pwdSearch.asp?m=com",IMG_JOIN&"/btn_pwdsearch.gif",85,20,"")%></td>
				</tr><tr>
					<td>- 지금 <span class="text_black">로그인</span> 하시겠습니까?</td>
					<td class="tright"><%=aImg("bak_member_login.asp",IMG_JOIN&"/btn_login.gif",85,20,"")%></td>
				</tr>
			</table>
		</div>
		<div class="login_bottom"><img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/></div>

	</div>
</div>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>

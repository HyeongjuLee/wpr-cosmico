<!--#include virtual = "/_lib/strFunc.asp"-->
<%	 '번역X
	popWidth = 530
	popHeight = 420

	mode = pRequestTF("mode",True)

	RND_PWD = RandomChar(8)
'	PRINT strName
'	PRINT strUserID
'	PRINT strSSH1
'	PRINT strSSH2
	strName = pRequestTF("mem_name",True)
	strUserID = pRequestTF("mem_id",True)


	If mode = "com" Then
		strSSH1 = pRequestTF("mem_ssh1",True)
		strSSH2 = pRequestTF("mem_ssh2",True)


		arrParams = Array(_
			Db.makeParam("@strName",adVarChar,adParamInput,30,strName), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,strUSerID), _
			Db.makeParam("@strSSH1",adChar,adParamInput,6,strSSH1), _
			Db.makeParam("@strSSH2",adChar,adParamInput,7,strSSH2), _
			Db.makeParam("@RND_PWD",adVarChar,adParamInput,8,RND_PWD), _
			Db.makeParam("@MOD",adVarChar,adParamOutput,5,"") _
		)
		Call Db.exec("DKP_PWD_CHG_FOR_CS",DB_PROC,arrParams,Nothing)
		CHGMOD = arrParams(UBound(arrParams))(4)

	ElseIf mode = "nor" Then
		strEmail1 = pRequestTF("mailh",True)
		strEmail2 = pRequestTF("mailt",True)
		strEmail = strEmail1 &"@"&strEmail2
		arrParams = Array(_
			Db.makeParam("@strName",adVarChar,adParamInput,30,strName), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,30,strUSerID), _
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail), _
			Db.makeParam("@RND_PWD",adVarChar,adParamInput,8,RND_PWD), _
			Db.makeParam("@MOD",adVarChar,adParamOutput,5,"") _
		)
		Call Db.exec("DKP_PWD_CHG",DB_PROC,arrParams,Nothing)

		CHGMOD = arrParams(UBound(arrParams))(4)
	End If


	If CHGMOD = "NOMEM" Then
		If mode = "nor" Then
			MESSAGE = "<p>입력하신 정보와 일치하는 회원이 없습니다</p><p>사업자회원인경우 사업자회원용 비번찾기를 이용해주세요</p>"
		Else
			MESSAGE = "입력하신 정보와 일치하는 회원이 없습니다"
  	End If

	ElseIf CHGMOD = "COMMEM" Then
		MESSAGE = "사업자회원 암호찾기를 이용해주세요"

	ElseIf CHGMOD = "CHMEM" Then
		MESSAGE = "<p>회원님의 암호가 <strong>"&RND_PWD&"</strong> 로 변경되었습니다.</p><p>새로고침하시면 암호가 재변경 되니 주의해주세요</p>"
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
	#popup p {line-height:180%;}

</style>
</head>
<body>
<div id="pop_login">
	<form name="frms" method="post" action="member_idsearchOk.asp" onsubmit="return frmChk(this)">
	<div id="popup">
		<div class="tops"><%=viewImg(IMG_JOIN&"/pwdsearch_top.gif",356,50,"")%></div>
		<div class="login_info">
			<%=MESSAGE%>
		</div>
		<div class="etc_btn">
			<table <%=tableatt%>
				<tr>
					<td>- <%=DKCONF_SITE_TITLE%> <%=DK_CONF_SITE_TYPE_NAME%>의 <span class="text_black">회원</span>이 아니신가요?</td>
					<td class="tright"><%=viewImgStJs(IMG_JOIN&"/btn_join.gif",85,20,"","","cp","onclick=""joins();""")%></td>
				</tr>
				<%' If mode = "com" Then%>
				<tr>
					<td>- <span class="text_black">비밀번호</span>가 기억이 안나시나요? (일반회원용)</td>
					<td class="tright"><%=aImg("pop_pwdSearch.asp?m=nor",IMG_JOIN&"/btn_pwdsearch.gif",85,20,"")%></td>
				</tr>
				<%' ElseIf mode = "nor" Then%>
				<tr>
					<td>- <span class="text_black">비밀번호</span>가 기억이 안나시나요? (사업자회원용)</td>
					<td class="tright"><%=aImg("pop_pwdSearch.asp?m=com",IMG_JOIN&"/btn_pwdsearch.gif",85,20,"")%></td>
				</tr>
				<%'End If%>


				<tr>
					<td>- 지금 <span class="text_black">로그인</span> 하시겠습니까?</td>
					<td class="tright"><%=aImg("bak_member_login.asp",IMG_JOIN&"/btn_login.gif",85,20,"")%></td>
				</tr>
			</table>
		</div>
		<div class="login_bottom"><img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:30px; cursor:pointer;" onclick="self.close();"/></div>

	</div>
	</form>
</div>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>

<!--#include virtual = "/_lib/strFunc.asp"-->
<%  '번역x
	popWidth = 530
	popHeight = 420
%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	function frmChk(f){
		if(!chkNull(f.mem_name, "\'회원명\'을 입력해 주세요")) return false;

		var objItem;
		for (var i=1; i<=2; i++) {
			objItem = eval('f.mem_ssh'+i);
			if (chkEmpty(objItem)) {
				alert("주민등록번호를 입력해 주세요.");
				objItem.focus();
				return false;
			}
		}

		if (!checkSSH(f.mem_ssh1, f.mem_ssh2)) return false;


		f.submit();
	}
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

	#popup .login_info {clear:both;float:left; margin-top:25px; margin-left:26px; width:342px; height:66px;}
	#popup .etc_btn {clear:both; float:left; width:452px;margin-top:20px; border-top:1px solid #eaeaea; padding:10px 0px;}

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
	<form name="frms" method="post" action="member_idsearchHandler.asp" onsubmit="return frmChk(this)">
	<div id="popup">
		<div class="tops"><%=viewImg(IMG_JOIN&"/idsearch_top.gif",227,50,"")%></div>
		<div class="login_info">
			<div class="id"><%=viewImgSt(IMG_JOIN&"/login_name.gif",70,20,"","","vmiddle")%><input type="text" name="mem_name" maxlength="30" class="input_text vmiddle" style="width:260px;" /></div>
			<div class="pwd"><%=viewImgSt(IMG_JOIN&"/login_mail.gif",70,20,"","","vmiddle")%><input type="text" name="mailh" class="input_text vmiddle imes" style="width:114px;" /> @ <input type="text" name="mailt" class="input_text vmiddle imes" style="width:125px;" /></div>
		</div>
		<div class="submit"><input type="image" src="<%=IMG_JOIN%>/idsearch_submit.gif" style="width:50px; height:47px;" /></div>
		<div class="clear" style="margin-left:90px;"><!-- 사업자회원의 경우 아이디는 고객센터로 문의해주세요. --></div>
		<div class="etc_btn">
			<table <%=tableatt%>>
				<tr>
					<td>- <%=DKCONF_SITE_TITLE%> <%=DK_CONF_SITE_TYPE_NAME%>의 <span class="text_black">회원</span>이 아니신가요?</td>
					<td class="tright"><%=viewImgStJs(IMG_JOIN&"/btn_join.gif",85,20,"","","cp","onclick=""joins();""")%></td>
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

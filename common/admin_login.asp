<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"

	PAGE_MODE = "HOME"
	PAGE_SETTING = "COMMON"
	PAGE_SETTING2 = "ADMIN"
	ISSUBPADDING = "F"
	ISLEFT = "F"
	ISFULLPAGE = "F"
	ISSUBTOP = "T"

	backURL = gRequestTF("backURL",False)
	If backURL = "" Then
		backURL = request.ServerVariables("HTTP_REFERER")
	Else
		backURL = Replace(backURL,"§","&")
	End If

'	print backURL

	'If DK_MEMBER_ID <> "GUEST" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/index.asp")

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	function nextFocus() {
		var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

		if (keyCode == 13){
			document.frms.mem_pwd.focus();
			return false;
		}

	}
	function frmChk(f){
		if(!chkNull(f.mem_id, "<%=LNG_JS_ID%>")) return false;
		var v = $("input[name=memberType]:checked").val();

		if (v == 'company')
		{
			//alert(v);
			var regExp = /^([\w]+)[-]([\d]+)$/gi;
			if (!regExp.test(f.mem_id.value)) {
				alert("<%=LNG_MEMBER_LOGIN_JS02%>");
				f.mem_id.focus();
				return false;
			}
		}

		if(!chkNull(f.mem_pwd, "<%=LNG_JS_PASSWORD%>")) return false;

		f.submit();
	}

	$(document).ready(function(){
		$("input[name=memberType]").ready(function(event){
			var v = $("input[name=memberType]:checked").val();
			if (v == "company")
			{
				$("#login_alert").css({"display":"block"});
			} else {
				$("#login_alert").css({"display":"none"});
			}
		});
		$("input[name=memberType]").click(function(event){
			var v = $("input[name=memberType]:checked").val();
			if (v == "company")
			{
				$("#login_alert").css({"display":"block"});
			} else {
				$("#login_alert").css({"display":"none"});
			}
		});
	});

//-->
</script>
</head>
<body onload="document.frms.mem_id.focus();">
<!--#include virtual = "/_include/header.asp"-->
<%
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		'PRINT objEncrypter.Encrypt("a12345")
			If backURL	<> "" Then backURL	 = objEncrypter.Encrypt(backURL)
	Set objEncrypter = Nothing
%>
<div id="login" class="common admin">
	<div class="wrap">
		<form name="frms" method="post" action="member_loginOk.asp" onsubmit="return frmChk(this)">
			<input type="hidden" name="backURLs" value="<%=backURL%>" />
			<input type="hidden" name="loginMode" value="page" />
			<%If UCase(Lang) = "KR" Then%>
			<%End If%>
			<input type="hidden" name="memberType" value="member">
			<div class="input-wrap">
				<label>
					<input type="text" name="mem_id" class="imes" maxlength="30" value="" <%=toNoKorText%> placeholder="<%=LNG_TEXT_ID%>" />
				</label>
				<label>
					<input type="password" name="mem_pwd" class="imes" maxlength="32" value placeholder="<%=LNG_TEXT_PASSWORD%>" />
				</label>

			</div>
			<!-- <div class="find"><a href="/common/member_idpw.asp"><%=LNG_TEXT_FIND_IDPASSWORD%></a></div> -->

			<input class="button" type="submit" value="<%=LNG_TEXT_LOGIN%>" tabindex="3" data-ripplet />
			<!-- <a class="button" href="/common/joinStep01.asp" data-ripplet><%=LNG_TEXT_JOIN%></a> -->
		</form>
	</div>
</div>
<script type="text/javascript">
	function kakaoLogin() {
		openPopup('/sns/snsLogin.asp?m=p&ptn=<%=Request.ServerVariables("SERVER_PORT")%>&backURL=<%=server.urlencode(backURL)%>', 'pop_Login', 'top=100px,left=200px,width=600,height=500,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}

</script>
<!--#include virtual = "/_include/copyright.asp"-->
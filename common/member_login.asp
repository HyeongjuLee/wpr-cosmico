<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"

	PAGE_MODE = "HOME"
	PAGE_SETTING = "COMMON"
	ISSUBPADDING = "F"
	ISLEFT = "F"
	ISFULLPAGE = "F"
	ISSUBTOP = "T"
	view = 1

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
	<div id="login" class="common">
		<div class="wrap">
			<form name="frms" method="post" action="member_loginOk.asp" onsubmit="return frmChk(this)">
				<input type="hidden" name="backURLs" value="<%=backURL%>" />
				<input type="hidden" name="loginMode" value="page" />
				<input type="hidden" name="memberType" value="company2" />
				<div class="input-wrap">
					<label>
						<i class="icon-id"></i>
						<!-- <span><%=LNG_TEXT_ID%></span> -->
						<input type="text" name="mem_id" maxlength="30" value="" <%=toNoKorText%> placeholder="<%=LNG_TEXT_ID%>" />
					</label>
					<label>
						<i class="icon-pw"></i>
						<!-- <span><%=LNG_TEXT_PASSWORD%></span> -->
						<input type="password" name="mem_pwd" maxlength="32" value="" placeholder="<%=LNG_TEXT_PASSWORD%>" />
					</label>
				</div>
				<div class="find"><a href="/common/member_idpw.asp"><%=LNG_TEXT_FIND_IDPASSWORD%></a></div>

				<input class="button" type="submit" value="<%=LNG_TEXT_LOGIN%>" tabindex="3" data-ripplet />
				<a class="button" href="/common/joinStep01.asp" data-ripplet><%=LNG_TEXT_JOIN%></a>

					<div class="sns-login">
						<%If SNS_LOGIN_TF = "T" Then%>
						<h6><span>SNS 간편 로그인</span></h6>
						<%End If%>
						<%If NAVER_LOGIN_TF = "T" Then%>
							<%'(1) 버튼 event 처리를 위하여 id를 지정%>
							<!-- <div id="naverIdLogin"><a id="naverIdLogin_loginButton" href="#"><img src="https://static.nid.naver.com/oauth/big_g.PNG?version=js-2.0.1" height="60"></a></div> -->
							<div id="naverIdLogin" style="display: none;"></div> <%'아래 커스텀 버튼 동작을 위해%>
							<div class="naver"><a id="naverIdLogin_customButton" href="#" data-ripplet><i class="icon-naver"></i><span>네이버 아이디로 로그인</span></a></div>
							<span id="gnbLoginArea" style="display: none;" ><a id="gnbLogin" href="" ></a></span>
							<!--#include virtual = "/SNS/naver/naverLogin.asp"-->
						<%End If%>
						<%If KAKAO_LOGIN_TF = "T" Then%>
							<div class="kakao"><a href="#" class="kakaoLogin" data-ripplet><i class="icon-kakao"></i><span>카카오 아이디로 로그인</span></a></div>
							<!--#include virtual = "/SNS/kakao/kakaoLogin.asp"-->
							<%If webproIP = "T" and 1=2 Then%>
							<span class="kakaoLogout" style="color:#cdcdcd;">카카오 로그아웃</span>
							<%End if%>
						<%End If%>
						<%If FACEBOOK_LOGIN_TF = "T" Then%>
							<div class="facebook"><a href="#;" data-ripplet><i class="icon-facebook-1"></i><span>페이스북 아이디로 로그인</span></a></div>
						<%End If%>
						<%If GOOGLE_LOGIN_TF = "T" Then%>
							<div class="google"><a href="#;" data-ripplet><i></i><span>구글 아이디로 로그인</span></a></div>
						<%End If%>
					</div>

			</form>

			<div class="cleft login_alert" id="login_alert" style="display: none;">
				<ul>
					<li class="red"><%=LNG_MEMBER_LOGIN_TEXT05%></li>
					<li><%=LNG_MEMBER_LOGIN_TEXT06%></li>
					<li><%=LNG_MEMBER_LOGIN_TEXT07%></li>
					<li><%=LNG_MEMBER_LOGIN_TEXT08%></li>
					<li><%=LNG_MEMBER_LOGIN_TEXT09%></li>
				</ul>
			</div>
		</div>
	</div>

<!--#include virtual = "/_include/copyright.asp"-->

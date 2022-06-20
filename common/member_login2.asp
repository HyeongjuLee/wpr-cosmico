<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	NO_MEMBER_REDIRECT = "F"

	PAGE_MODE = "HOME"
	PAGE_SETTING = "COMMON"
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

	DK_SAVE_ID = Request.Cookies("DKMEMBERIDSAVE")

	DEC_DK_SAVE_ID = ""
	If DK_SAVE_ID <> "" Then
		'쿠키에 아이디 저장값이 있으면 노출
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			DEC_DK_SAVE_ID = objEncrypter.Decrypt(DK_SAVE_ID)

		Set objEncrypter = Nothing
	End If

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
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

		if ($("input:checkbox[name=mem_id_save]").prop("checked")) {
			$("input:checkbox[name=mem_id_save]").val('T');
		} else {
			$("input:checkbox[name=mem_id_save]").val('');
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

		<% If DEC_DK_SAVE_ID <> "" Then %>
		$("input[name=mem_pwd]").focus();
		<% Else %>
		$("input[name=mem_id]").focus();
		<% End If %>
	});

//-->
</script>
<link rel="stylesheet" type="text/css" href="membership.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<% If False Then %>
<!--#include virtual = "/SNS/kakaoLogin.asp"-->
<!--#include virtual = "/SNS/googleLogin.asp"-->
<% End If %>
<!--#include virtual = "/SNS/naverLogin.asp"-->
<%
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		'PRINT objEncrypter.Encrypt("a12345")
			If backURL	<> "" Then backURL	 = objEncrypter.Encrypt(backURL)
	Set objEncrypter = Nothing
%>
<div id="login" class="memberWrap">
	<div class="in_area">

		<div class="login_left">
			<form name="frms" method="post" action="member_loginOk.asp" onsubmit="return frmChk(this)">
				<input type="hidden" name="backURLs" value="<%=backURL%>" />
				<input type="hidden" name="loginMode" value="page" />
				<input type="hidden" name="memberType" value="company2" />
				<%If UCase(Lang) = "KR" Then%>
				<%End If%>
				<div class="inputWrap width100">
					<div class="input">
						<input type="text" name="mem_id" class="imes" maxlength="30" placeholder="<%=LNG_TEXT_ID%>" value="<%=DEC_DK_SAVE_ID%>" />
					</div>
					<div class="input">
						<input type="password" name="mem_pwd" class="imes" maxlength="32" placeholder="<%=LNG_TEXT_PASSWORD%>" />
					</div>

					<div class="id_save">
						<label>
							<input type="checkbox" name="mem_id_save" value="" <% If DEC_DK_SAVE_ID <> "" Then PRINT "checked" End If %> />
							<span>
								<i class="off"></i>
								<i class="on">
									<img src="/images/icon/009-check.svg" alt="">
								</i>
							</span>
							<p>아이디 저장</p>
						</label>
					</div>

					<div class="mem_search">
						<div class="inner">
							<div class="join mem"><a href="/common/joinStep01.asp"><%=LNG_TEXT_JOIN%></a></div>
							<i></i>
							<div class="idpw mem"><a href="/common/member_idpw.asp"><%=LNG_TEXT_FIND_IDPASSWORD%></a></div>
						</div>
					</div>

					<div class="mem_btn">
						<input type="submit" value="<%=LNG_TEXT_LOGIN%>" tabindex="3" />
					</div>

					<% If False Then %>
					<div class="sns_login_tit"><i></i><span>SNS 간편 로그인</span></div>
					<div class="sns_login">
						<div class="kakao"><a href="javascript:void(0);" class="kakaoLogin"><i></i><span>카카오 아이디로 로그인</span></a></div>
						<div class="google"><a href="javascript:void(0);" class="googleLogin"><i></i><span>구글 아이디로 로그인</span></a></div>
						<% If 1=2 Then %>
						<div class="naver"><a href="#"><i></i><span>네이버 아이디로 로그인</span></a></div>
						<div class="facebook"><a href="#"><i></i><span>페이스북 아이디로 로그인</span></a></div>
						<% End If %>
					</div>
					<% End If %>

					<% If webproIP="T" Then %>
					<div class="mem_btn">
						<img src="//mud-kage.kakao.com/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="300" class="kakaoLogin" />
					</div>
					<div id=""><a class="naverIdLogin" href="#"><img src="https://static.nid.naver.com/oauth/big_g.PNG?version=js-2.0.1" height="60" /></a></div>
					<div class="mem_btn">
						<div><span class="googleLogin">구글 로그인</span></div>
						<diV><span class="googleLogout">구글 로그아웃</span></div>
					</div>
					<diV><span class="kakaoLogout">카카오 로그아웃</span></div>
					<div class="fb-login-button" data-width="" data-size="large" data-button-type="continue_with" data-layout="default" data-auto-logout-link="false" data-use-continue-as="false"></div>
					<% End If %>
				</div>
			</form>
		</div>


		<div class="cleft login_alert" id="login_alert" style="display:none;">
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

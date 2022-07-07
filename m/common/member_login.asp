<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMMON"
	view = 1
	ISSUBTOP = "T"

	NO_MEMBER_REDIRECT = "F"
	link_mod = gRequestTF("mod",False)

	backURL = gRequestTF("backURL",false)

	If backURL = "" Then
		backURL = Request.ServerVariables("HTTP_REFERER")
	Else
		backURL = Replace(backURL,"§","&")
	End If


'	If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
'		Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/m/index.asp")
'	End If

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	If DK_MEMBER_ID <> "GUEST" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/m/index.asp")

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script src="/m/js/icheck/zepto.js"></script>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<!-- <script src="member_login.js"></script> -->
<script type="text/javascript">
<!--
function loginChk(f){

	var values = $("input[name=memberType]:checked").val();

	// if ($("input[name=memberType]:checked").length == 0)
	// {
	// 	alert("로그인 타입을 선택해주세요");
	// 	return false;
	// }

	if (f.memberIDS.value == '')
	{
		alert("<%=LNG_JS_ID%>");
		f.memberIDS.focus();
		return false;
	}
	if (values == 'N')
	{
		//alert(values);
		var regExp = /^([\w]+)[-]([\d]+)$/gi;
		if (!regExp.test(f.memberIDS.value)) {
			alert("<%=LNG_MEMBER_LOGIN_JS02%>");
			f.memberIDS.focus();
			return false;
		}
	}

	if (f.memberPWD.value == '')
	{
		alert("<%=LNG_JS_PASSWORD%>");
		f.memberPWD.focus();
		return false;
	}

}


function checkMemType(){
	var values = $("input[name=memberType]:checked").val();
	if (values == 'N')
	{
		$("#login_alert").css({"display":"block"});
	} else {
		$("#login_alert").css({"display":"none"});
	}
}

$(document).ready(function() {
	$("form").on("propertychange change keyup paste input","input", function() {
		$(this).val(function(index, value) {
			return value.replace(/ /gi, '');
		});
	});
});

// -->
</script>
<link rel="stylesheet" href="/m/css/common.css" />
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
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
		<form name="loginFrm" action="/m/common/member_loginOk.asp" method="post" onsubmit="return loginChk(this);" >
			<input type="hidden" name="backURL" value="<%=backURL%>" />
			<input type="hidden" name="memberType" value="I" checked="checked" />

			<div class="input-wrap">
				<label>
					<input type="text" name="memberIDS" value placeholder="<%=LNG_TEXT_ID%>" />
				</label>
				<label>
					<input type="password" name="memberPWD" value placeholder="<%=LNG_TEXT_PASSWORD%>" />
				</label>
			</div>
			<div class="find"><a href="/m/common/member_idpw.asp"><%=LNG_TEXT_FIND_IDPASSWORD%></a></div>

			<input class="button" type="submit" value="<%=LNG_TEXT_LOGIN%>" />
			<a class="button" href="/m/common/joinStep01.asp"><%=LNG_TEXT_JOIN%></a>

			<%If webproIP="T" Then%>
				<%If SNS_LOGIN_TF = "T" Then%>
				<div class="sns_login_tit"><span>SNS 간편 로그인</span></div>
				<%End If%>
				<div class="sns_login">
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
			<%End If%>

		</form>
	</div>
</div>


<!--#include virtual = "/m/_include/copyright.asp"-->




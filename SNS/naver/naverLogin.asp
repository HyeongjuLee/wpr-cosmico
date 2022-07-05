<%
	'네아로 Login With NaverID Javascript SDK 2.0.2
	'https://static.nid.naver.com/oauth/sample/javascript_sample.html 기준

	'Callback URL
	'http(s)://domain.com/SNS/naver/naverCallback.asp

	'* PC : 팝업방식
	'* Mob : 페이지이동
%>
<%'네아로 (1) 버튼 event 처리를 위하여 id를 지정%>

<%' (2) LoginWithNaverId Javscript SDK %>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>

<%' (3) LoginWithNaverId Javscript 설정 정보 및 초기화 %>
<script>
	window.name='opener';
	var naverLogin = new naver.LoginWithNaverId({
		clientId: "<%=NAVER_CLIENT_ID%>",
		//callbackUrl: "<%=HTTPS%>://" + window.location.hostname + ((location.port==""||location.port==undefined)?"":":" + location.port) + "/SNS/naverCallback.asp",
		callbackUrl: "<%=NAVER_CALLBACK_URL%>",
		isPopup: <%=LCase(NAVER_isPopup)%>,
		loginButton: {color: "green", type: 3, height: 60}
	});

	//커스텀 버튼 동작
	$("#naverIdLogin_customButton").click( function() {
		var naverLogin = document.getElementById("naverIdLogin").firstChild;
		naverLogin.click();
	});

	//<%' (4) 네아로 로그인 정보를 초기화하기 위하여 init을 호출 %>
	naverLogin.init();

	//<%' (4-1) 임의의 링크를 설정해줄 필요가 있는 경우  %>
	$("#gnbLogin").attr("href", naverLogin.generateAuthorizeUrl());

	//<%' (5) 현재 로그인 상태를 확인  %>
	window.addEventListener('load', function () {
		naverLogin.getLoginStatus(function (status) {
			if (status) {
				//<%' (6) 로그인 상태가 "true" 인 경우 로그인 버튼을 없애고 사용자 정보를 출력합니다.  %>
				setLoginStatus();
			}
		});
	});

	//<%' (6) 로그인 상태가 "true" 인 경우 로그인 버튼을 없애고 사용자 정보를 출력합니다.  %>
	function setLoginStatus() {
		//const getName = naverLogin.user.getName();
		//$("#naverIdLogin_loginButton").html(getName + '님 반갑습니다.</p>');
		$("#gnbLogin").html("Logout").css("color","#e5e5e5");
		$("#gnbLogin").attr("href", "#");
		$("#gnbLoginArea").show();

		//<%' (7) 로그아웃 버튼을 설정하고 동작을 정의합니다. %>
		$("#gnbLogin").click(function (e) {
			e.preventDefault();
			naverLogin.logout();

			var currentUrl = window.location.href;
			if (currentUrl.toLowerCase().indexOf("/m/") > -1){
				location.replace('/m/common/member_login.asp');
				//location.replace('<%=HTTPS%>://" + window.location.hostname + ((location.port==""||location.port==undefined)?"":":" + location.port) + "/m/common/member_login.asp');
			} else {
				location.replace('/common/member_login.asp');
				//location.replace('<%=HTTPS%>://" + window.location.hostname + ((location.port==""||location.port==undefined)?"":":" + location.port) + "/common/member_login.asp');
			}

		});
	}

</script>

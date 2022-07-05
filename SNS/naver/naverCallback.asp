<!--#include virtual="/_lib/strFunc.asp" -->
<%
	'########################################################################################
	'네아로 Login With NaverID Javascript SDK 2.0.2
	'https://static.nid.naver.com/oauth/sample/javascript_sample.html 기준

	'Callback URL
	'http(s)://domain.com/SNS/naver/naverCallback.asp
	'########################################################################################

	'########################################################################################
	'snsToken 기본 설정 (이용자 식별자)

	'https://developers.naver.com/docs/login/devguide/devguide.md
	'3.3.2 로그인한 회원의 네이버 로그인 사용 여부
	'네이버 로그인을 이용하여 로그인 연동을 수행한 사용자는 각각의 사용자를 구별하기 위한 사용자 유니크ID를 가지고 있습니다.
	'이용자 식별자 (Unique Identifier)
	'64자 이내로 구성된 BASE64 형식의 문자열
	'(2021년 5월 1일 이후 생성된 애플리케이션부터 적용. 기존 애플리케이션은 INT64 규격의 숫자로 구성)
	'네이버 아이디 별로 고유하게 부여된 값
	'애플리케이션간에는 이용자 식별자가 공유되지 않습니다.
	'네이버 아이디값은 제공하지 않으며, 대신 'id'라는 애플리케이션당 유니크한 일련번호값을 이용해서 자체적으로 회원정보를 구성하셔야 합니다.


	'각회원당 다중 SNS 로그인 불가!!!
	'https://developers.naver.com/forum/posts/28835
	'naver user.getEmail() 사용 불가 = naver 연락처 이메일, 네이버ID@naver.com 형식의 이메일은 현재 정책 상 제공하지 않습니다.

	'Javascript SDK 2.0.2
	'snsToken = user.getId() 사용!!!
	'########################################################################################
	NAVER_isMobile = request("m")

	If NAVER_isMobile = "t" Then		'mob
		isOpener = ""
		NAVER_isPopup = false	'네아로 페이지 전환형태
	Else			'PC
		isOpener = "opener."
		NAVER_isPopup = true
	End If
%>
</head>
<body>

	<!-- callback 처리중입니다. 이 페이지에서는 callback을 처리하고 바로 main으로 redirect하기때문에 이 메시지가 보이면 안됩니다. -->
	<script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
	<%' (1) LoginWithNaverId Javscript SDK %>
  <script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>

	<%' (2) LoginWithNaverId Javscript 설정 정보 및 초기화 %>
	<script>

		var naverLogin = new naver.LoginWithNaverId({
			clientId: "<%=NAVER_CLIENT_ID%>",
			//callbackUrl: "http://" + window.location.hostname + ((location.port==""||location.port==undefined)?"":":" + location.port) + "/SNS/naverCallback.asp",
			callbackUrl: "<%=NAVER_CALLBACK_URL%>",

			//isPopup: false,
			isPopup: <%=LCase(NAVER_isPopup)%>,
			callbackHandle: true
			/* callback 페이지가 분리되었을 경우에 callback 페이지에서는 callback처리를 해줄수 있도록 설정합니다. */
		});

		//<%' (3) 네아로 로그인 정보를 초기화하기 위하여 init을 호출 %>
		naverLogin.init();

		//<%' (4) Callback의 처리. 정상적으로 Callback 처리가 완료될 경우 main page로 redirect(또는 Popup close) %>
		window.addEventListener('load', function () {

			//let aaa = opener.$('.naverIdLogin_customButton').data('smtf'); // 23

			naverLogin.getLoginStatus(function (status) {
				if (status) {
					//<%' (5) 로그인 상태가 "true" 인 경우  %>
					//<%' (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 %>
					setLoginStatus();
				} else {
					console.log("callback 처리에 실패하였습니다.");
				}
			});
		});

		//<%' (5) 필수적으로 받아야하는 프로필 정보가 있다면 callback처리 시점에 체크 %>
		function setLoginStatus() {
			const getNickName = naverLogin.user.getNickName();
			const getId = naverLogin.user.getId();
			const getName = naverLogin.user.getName();
			const getEmail = naverLogin.user.getEmail();					//'<%' naver 연락처 이메일  아이디@naver.com 아닐 수 있음 %>
			const getBirthday = naverLogin.user.getBirthday();
			const getBirthyear = naverLogin.user.getBirthyear();
			const getGender = naverLogin.user.getGender();
			const getMobile = naverLogin.user.getMobile();

			//<%' (5-1) 사용자 정보 재동의를 위하여 다시 네아로 동의페이지로 이동함 %>
			if( getEmail === undefined || getEmail === null) {
				alert("이메일이 필요합니다. 정보제공을 동의해주세요.");
				naverLogin.reprompt();
				return;
			}
			if( getBirthday === undefined || getBirthday === null) {
				alert("생일정보가 필요합니다. 정보제공을 동의해주세요.");
				naverLogin.reprompt();
				return;
			}
			if( getBirthyear === undefined || getBirthyear === null) {
				alert("출생연도가 필요합니다. 정보제공을 동의해주세요.");
				naverLogin.reprompt();
				return;
			}
			if( getMobile === undefined || getMobile === null) {
				alert("휴대전화정보 필요합니다. 정보제공을 동의해주세요.");
				naverLogin.reprompt();
				return;
			}

			// 회원정보 조회
			$.ajax({
				type: "post",
				async : false,
				url: "/SNS/authCheck.asp",
				data: {"snsType" : "naver", "token" : getId, "email" : getEmail},
				dataType: 'json',
				success: function(rData){
					if (rData.result == "success"){
						alert("네이버 회원으로 로그인 처리되었습니다.");
						fnGotoUrl('/index.asp');
						return false;
					} else {

						if (rData.resultMsg == 'join') {
							var askYn = confirm("회원정보가 없습니다. 회원가입을 진행하시겠습니까?");
							if (askYn){
								//fnNaverJoin(getId, getName, getName, getEmail);
								//fnNaverJoin(getId, getName, getEmail, getBirthday, getBirthyear, getGender, getMobile);
								const getId = rData.getId;
								fnNaverJoin(getId, getName, getEmail, getBirthday, getBirthyear, getGender, getMobile);
							}else{
								fnGotoUrl('/common/member_login.asp');
								return false;
							}
							return false;
						}else{
							alert(rData.resultMsg);
							fnGotoUrl('/common/member_login.asp');
							return false;
						}

					}
				},
				error: function(rData){
					alert("로그인 중 오류가 발생했습니다.");
					return false;
				},
				// complete: function(){
				// 	signOut();
				// }
			});

		}

		function fnNaverJoin(getId, getName, getEmail, getBirthday, getBirthyear, getGender, getMobile) {
			<%=isOpener%>naverLogin.logout();	//naver logout
			<%If NAVER_isPopup Then%>
				window.opener.name = "parentPage";
				document.joinForm.target = "parentPage"
			<%End If%>
			//var currentUrl = window.<%=isOpener%>location.href;
			//if (currentUrl.toLowerCase().indexOf("/m/") > -1){
			if(navigator.userAgent.match(/Mobile|iP(hone|od)|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/)){
				document.joinForm.action = "/m/common/<%=SNS_JOINSTEP_URL%>"
			} else {
				document.joinForm.action = "/common/<%=SNS_JOINSTEP_URL%>"
			}

			document.joinForm.S_SellMemTF.value = <%=SNS_JOINSTEP_SMTF%>;
			document.joinForm.snsType.value = 'naver';
			document.joinForm.snsToken.value = getId;

			document.joinForm.snsName.value = getName;
			document.joinForm.snsEmail.value = getEmail;
			document.joinForm.snsBirthday.value = getBirthday;
			document.joinForm.snsBirthyear.value = getBirthyear;
			document.joinForm.snsGender.value = getGender;
			document.joinForm.snsMobile.value = getMobile;
			document.joinForm.submit();
			<%If NAVER_isPopup Then%>
			self.close();
			<%End If%>
		}

		function fnGotoUrl(url) {
			<%=isOpener%>naverLogin.logout();
			if(navigator.userAgent.match(/Mobile|iP(hone|od)|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/)){
				<%=isOpener%>location.href='/m' +url;
			} else {
				<%=isOpener%>location.reload();
				self.close();
			}
		}

	</script>

	<form action="" name="joinForm" method="post">
		<input type="hidden" name="S_SellMemTF" value="" >
		<input type="hidden" name="snsType" value="" >
		<input type="hidden" name="snsToken" value="" >
		<input type="hidden" name="snsName" value="" >
		<input type="hidden" name="snsEmail" value="" >
		<input type="hidden" name="snsBirthday" value="" >
		<input type="hidden" name="snsBirthyear" value="" >
		<input type="hidden" name="snsGender" value="" >
		<input type="hidden" name="snsMobile" value="" >
	</form>

</body>
</html>

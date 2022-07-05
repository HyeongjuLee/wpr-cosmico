<%
	'########################################################################################
	'카카오아이디 로그인 with JavaScript 키
	'https://developers.kakao.com/docs/latest/ko/kakaologin/js

	'팝업방식
	'https://developers.kakao.com/tool/demo/login/login?method=dynamic

	'Redirect URI 등록 XXX
	'REST API로 개발하는 경우 필수로 설정해야 합니다.


	'########################################################################################
	'사업자 정보를 등록하여 비즈 앱으로 전환할 수 있습니다.
	'비즈 앱 전환 시 이메일을 필수 동의항목으로 설정할 수 있고, 비즈니스 채널 연결이 가능합니다.

	'https://devtalk.kakao.com/t/topic/78741/3
	'이메일 : 선택값 기본, 비즈 앱 전환 시 이메일을 필수 동의항목으로 설정할 수 있음.
	'출생년도 정보 birthyear = ""; //카카오싱크가입 only, 검수필요
	'연락처 정보 mobile = ""; //카카오싱크가입 only, 검수필요
%>
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
	<script type="text/javascript">

		//'Kakao Javascript 사용을 위한 초기 설정
		//Kakao.init('d7a163efef9dc42a4ac26ac749e1c6c9');
		Kakao.init('<%=KAKAO_JAVASCRIPT_KEY%>');
		Kakao.isInitialized();
		//console.log(Kakao.isInitialized());

		$(function(){
			// $(".kakaoLogin").on("click", fnKakaoMakeToken);
			$(".kakaoLogin").on("click", kakaoLogin);
			$(".kakaoLogout").on("click", unlinkApp);

			if (!Kakao.Auth.getAccessToken()) {
				//console.log('Not logged in.');
				return;
			}else{
				//console.log('logged in.');
				return;
			}
		});


		function kakaoLogin(){
			fnKakaoCheckLoginInfo();
		}

		//사용자 로그인,Token정보 (로그인시 정보제공동의 중복체크 방지)
		function fnKakaoCheckLoginInfo(){
			Kakao.API.request({
				url:'/v2/user/me',
				success: function(response){
					//alert(Kakao.Auth.getAccessToken());
					fnKakaoLogin();		//있으면 로그인
					return false;
				},
				fail: function(error){
					fnKakaoMakeToken();		//없으면 토큰만들고 로그인
					return false;
				}
			});
		}

		//Kakao API 사용을 위한 토큰 생성
		/* 	Kakao.Auth.login()		(팝업 방식으로 로그인)
				함수 호출 시 팝업으로 카카오 로그인 동의 화면이 표시됩니다.
				로그인 요청 결과 토큰이 발급
		*/
		function fnKakaoMakeToken(){
			//$(".kakaoLogin").off("click");
			Kakao.Auth.login({
				//scope:'profile_nickname, account_email, gender',
				success: function(response){
					//console.log(response);
					fnKakaoLogin();
				},
				fail: function(error){
					alert("카카오 로그인 처리 중 오류가 발생했습니다.");
					return false;
				},
				always: function(){
					$(".kakaoLogin").on("click", fnKakaoLogin);
				}
			});
		}

		//'Kakao.Auth.login 에서 토큰 생성 후 회원 카카오로그인 정보 가져오기
		function fnKakaoLogin(){
			//unlinkApp();
			Kakao.API.request({
				url:'/v2/user/me',
				success: function(response){
					//console.log(response);
					const id = response.id;
					const kakao_account = response.kakao_account;
					const email   = kakao_account.email;								//account_email => email 비즈 앱 전환 시 이메일을 필수 동의할 수 있음.

					const nickname = kakao_account.profile.nickname;	//profile_nickname => profile.nickname
					const name = nickname;							//name = 닉네임
					//const name = kakao_account.name;		//name = 카카오비즈니스 신청시 S

					const mobile = kakao_account.phone_number;
					//console.log(email,name,phone_number);
					//카카오비즈니스 신청시 E

					const birthday = kakao_account.birthday; //mmdd
					const gender = kakao_account.gender;		//male / femail
					const birthyear = kakao_account.birthyear; //카카오싱크 only, 검수필요

					//console.log(id,email);
					//console.log(kakao_account, name);

					if( email === undefined || email === null) {
						alert("이메일이 필요합니다. 정보제공을 동의해주세요.");
						unlinkApp();
						return false;
					}
					/*
					if( name === undefined || name === null) {
						alert("이름이 필요합니다. 정보제공을 동의해주세요.");
						unlinkApp();
						return false;
					}
					*/
					$.ajax({
						type: "post",
						async : false,
						url: "/SNS/authCheck.asp",
						data: {"snsType" : "kakao", "token" : id, "email" : email},
						dataType: 'json',
						success: function(rData){
							if (rData.result == "success"){     <%' 카카오 회원가입을 한 회원인 경우 로그인 처리 후 메인화면으로 이동시킴 %>
								alert("카카오 회원으로 로그인 처리되었습니다.");
								//location.href="/index.asp";
								fnGoIndex();
								return false;
							} else {

								if (rData.resultMsg == 'join') {
									var askYn = confirm("회원정보가 없습니다. 회원가입을 진행하시겠습니까?");
									if (askYn){
										const id = rData.getId;
										//alert(id);
										fnKakaoJoin(id, name, email, birthday, birthyear, gender, mobile);
									}
									return false;
								}else{
									alert(rData.resultMsg);
									self.close();
									unlinkApp();
									location.reload();
									return false;
								}

							}
						},
						error: function(rData){
							alert("로그인 중 오류가 발생했습니다.");
							return false;
						}
					});

				},
				fail: function(error){
					console.log(error);
				}
			});
		}

		function fnKakaoJoin(id, name, email, birthday, birthyear, gender, mobile){
				var currentUrl = window.location.href;
				var joinForm = $('<form></form>');

				joinForm.attr("name", "joinForm");
				joinForm.attr("method", "post");

				if (currentUrl.toLowerCase().indexOf("/m/") > -1){
					joinForm.attr("action", "/m/common/<%=SNS_JOINSTEP_URL%>");
				} else {
					joinForm.attr("action", "/common/<%=SNS_JOINSTEP_URL%>");
				}

				joinForm.append($('<input />', {type: 'hidden', name: 'S_SellMemTF', value:'<%=SNS_JOINSTEP_SMTF%>'}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsType', value:'kakao'}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsToken', value: id}));

				joinForm.append($('<input />', {type: 'hidden', name: 'snsName', value: name}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsEmail', value: email}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsBirthday', value: birthday}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsBirthyear', value: birthyear}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsGender', value: gender}));
				joinForm.append($('<input />', {type: 'hidden', name: 'snsMobile', value: mobile}));

				// if (name.length > 2) {
				// 		joinForm.append($('<input />', {type: 'hidden', name: 'snsFamilyName', value:name.substring(0, 1)}));
				// 		joinForm.append($('<input />', {type: 'hidden', name: 'snsGivenName', value:name.substring(1)}));
				// } else {
				// 		joinForm.append($('<input />', {type: 'hidden', name: 'snsFamilyName', value:""}));
				// 		joinForm.append($('<input />', {type: 'hidden', name: 'snsGivenName', value:name}));
				// }

				joinForm.appendTo('body');

				joinForm.submit();
		}


		function unlinkApp() {
			Kakao.API.request({
				url: '/v1/user/unlink',
				success: function(res) {
					console.log('success: ' + JSON.stringify(res))
				},
				fail: function(err) {
					console.log('fail: ' + JSON.stringify(err))
				}
			})
		}

		function fnGoIndex() {
			var currentUrl = window.location.href;
			if (currentUrl.toLowerCase().indexOf("/m/") > -1){
				location.href='/m/index.asp';
			} else {
				location.href='/index.asp';
			}
			self.close();
		}

	</script>
